import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sw1final_official/config/blocs/permissions/local-notificacions.dart';
import 'package:sw1final_official/config/constant/data.const.dart';
import 'package:sw1final_official/firebase_options.dart';

part 'permissions_event.dart';
part 'permissions_state.dart';

Future<void> firebaseMessaingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Manejando un mensaje en segundo plano: ${message.messageId}");
}

class PermissionsBloc extends Bloc<PermissionsEvent, PermissionsState> {
  StreamSubscription? gpsServiceSubscription;
  // READ : NOTIFICACIONES FIREBASE
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  PermissionsBloc() : super(const PermissionsState()) {
    // READ : EVENTOS BLOC SOBRE EL GPS
    on<GpsAndPermissionEvent>((event, emit) {
      emit(state.copyWith(
        isGpsEnabled: event.isGpsEnabled,
        isGpsPermissionGranted: event.isPermissionGranted,
      ));
    });

    // READ : EVENTOS BLOC SOBRE LAS NOTIFICACIONES
    on<OnChangePermissionNotifi>((event, emit) {
      emit(state.copyWith(
        statusNotification: event.status,
      ));
      _getFCMToken();
    });
    on<OnNotificationReceived>((event, emit) {
      emit(state.copyWith(
        notificaciones: [...state.notificaciones, event.notifi],
      ));
    });

    // LOGIC : VERIFICAR GPS ESTADO Y PERMISO USO DE GPS
    _init();

    // LOGIC : VERIFICAR ESTADO DE PERMISO DE NOTIFICACIONES
    _initialStatusCheck();

    // LOGIC : LISTENER(ESCUCHAR) PARA MENSAJES EN PRIMER PLANO (FOREGROUND)
    _onForegroundMessage();
  }

  // READ : METODOS DE USO A TODO LO REFENTE A LAS NOTIFICACIONES
  static Future<void> initializeFCM() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  }

  void _initialStatusCheck() async {
    final settings = await messaging.getNotificationSettings();
    add(OnChangePermissionNotifi(settings.authorizationStatus));
  }

  void _getFCMToken() async {
    final settings = await messaging.getNotificationSettings();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      final token = await messaging.getToken();
      print('Token: $token');
    }
  }

  Future<String> getFCMTokenProvisional() async {
    final settings = await messaging.getNotificationSettings();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      final token = await messaging.getToken();
      print('Token: $token');
      return token!;
    } else {
      print('Notificaciones no autorizadas');
      return "Presiona el boton"; // O lanza una excepción si prefieres manejarlo de otra manera
    }
  }

  void handleRemoteMessage(RemoteMessage message) {
    if (message.notification == null) return;
    final notification = PushMessage(
      messageId:
          message.messageId?.replaceAll(':', '').replaceAll('%', '') ?? '',
      title: message.notification!.title ?? '',
      body: message.notification!.body ?? '',
      sentDate: message.sentTime ?? DateTime.now(),
      data: message.data,
      imageURL: Platform.isAndroid
          ? message.notification!.android?.imageUrl
          : message.notification!.apple?.imageUrl,
    );
    // print(pushMessage.toString());
    LocalNotifications.showLocalNotification(
      id: 1,
      body: notification.body,
      data: notification.data.toString(),
      title: notification.title,
    );
    add(OnNotificationReceived(notification));
  }

  void _onForegroundMessage() {
    FirebaseMessaging.onMessage.listen(handleRemoteMessage);
  }

  Future<void> requestPermissions() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );
    // TODO: SOLICITAR PERMISOS DE NOTIFICACIONES LOCALES
    await LocalNotifications.requestPermissionLocalNotifications();
    add(OnChangePermissionNotifi(settings.authorizationStatus));
  }

  PushMessage? getMessageById(String messageId) {
    final exist =
        state.notificaciones.any((element) => element.messageId == messageId);
    if (exist) {
      return state.notificaciones
          .firstWhere((element) => element.messageId == messageId);
    }
    return null;
  }

  // READ : METODOS DE USO A TODO LO REFENTE AL GPS
  Future<void> _init() async {
    final gpsInitStatus = await Future.wait([
      _chechGpsStatus(),
      _isPermissionGranted(),
    ]);

    add(GpsAndPermissionEvent(
      isGpsEnabled: gpsInitStatus[0],
      isPermissionGranted: gpsInitStatus[1],
    ));
  }

  Future<bool> _chechGpsStatus() async {
    final isGpsEnabled = await Permission.location.serviceStatus.isEnabled;
    gpsServiceSubscription =
        Geolocator.getServiceStatusStream().listen((event) {
      final isGpsEnabled = (event.index == 1) ? true : false;
      add(GpsAndPermissionEvent(
        isGpsEnabled: isGpsEnabled,
        isPermissionGranted: state.isGpsPermissionGranted,
      ));
    });

    return isGpsEnabled;
  }

  Future<bool> _isPermissionGranted() async {
    final isGranted = await Permission.location.isGranted;
    return isGranted;
  }

  Future<void> askGpsAccess() async {
    final status = await Permission.location.request();

    switch (status) {
      case PermissionStatus.granted:
        add(GpsAndPermissionEvent(
          isGpsEnabled: state.isGpsEnabled,
          isPermissionGranted: true,
        ));
        break;
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.limited:
      case PermissionStatus.permanentlyDenied:
      case PermissionStatus.provisional:
        add(GpsAndPermissionEvent(
          isGpsEnabled: state.isGpsEnabled,
          isPermissionGranted: false,
        ));
        openAppSettings();
        break;
    }
  }

  Future<Position> getActualLocation() async {
    final position = await Geolocator.getCurrentPosition();
    return position;
  }

  @override
  Future<void> close() {
    gpsServiceSubscription!.cancel();
    return super.close();
  }
}
