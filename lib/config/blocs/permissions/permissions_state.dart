part of 'permissions_bloc.dart';

class PermissionsState extends Equatable {
  // LOGIC : GPS ESTADO
  final bool isGpsEnabled;
  // LOGIC : PERMISOS DEL GPS
  final bool isGpsPermissionGranted;
  // LOGIC : PERMISOS NOTIFICACIONES
  final bool isNotifiPermission;

  // READ : BLOC NOTIFICACIONES
  final AuthorizationStatus statusNotification;
  final List<PushMessage> notificaciones;

  const PermissionsState({
    this.isGpsEnabled = false,
    this.isGpsPermissionGranted = false,
    this.isNotifiPermission = false,
    this.statusNotification = AuthorizationStatus.notDetermined,
    this.notificaciones = const [],
  });

  PermissionsState copyWith({
    bool? isGpsEnabled,
    bool? isGpsPermissionGranted,
    bool? isNotifiPermission,
    AuthorizationStatus? statusNotification,
    List<PushMessage>? notificaciones,
  }) {
    return PermissionsState(
      isGpsEnabled: isGpsEnabled ?? this.isGpsEnabled,
      isGpsPermissionGranted:
          isGpsPermissionGranted ?? this.isGpsPermissionGranted,
      isNotifiPermission: isNotifiPermission ?? this.isNotifiPermission,
      statusNotification: statusNotification ?? this.statusNotification,
      notificaciones: notificaciones ?? this.notificaciones,
    );
  }

  @override
  List<Object> get props => [
        isGpsEnabled,
        isGpsPermissionGranted,
        isNotifiPermission,
        statusNotification,
        notificaciones,
      ];
}
