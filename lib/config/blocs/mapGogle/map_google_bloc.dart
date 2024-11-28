import 'dart:async';
import 'dart:ui' as ui;

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sw1final_official/config/blocs/auth/auth_bloc.dart';
import 'package:sw1final_official/config/blocs/permissions/permissions_bloc.dart';
import 'package:sw1final_official/config/constant/const.dart';

part 'map_google_event.dart';
part 'map_google_state.dart';

class MapGoogleBloc extends Bloc<MapGoogleEvent, MapGoogleState> {
  final AuthBloc authBloc;
  final PermissionsBloc permissionsBloc;
  GoogleMapController? mapController;

  MapGoogleBloc({
    required this.authBloc,
    required this.permissionsBloc,
  }) : super(MapGoogleState()) {
    on<OnMapInitContent>((event, emit) async {
      emit(state.copyWith(
        markers: {},
        polylines: {},
        polygons: {},
      ));
      Map<String, Marker> markers = {};

      // Código del marcador actualizado
      for (var i = 0; i < perfiles.length; i++) {
        final perfil = perfiles[i];
        final markerId = "PARK$i";

        // Obtener LatLng de las coordenadas
        final position = obtenerCoordenadas(perfil.coordenadas);

        final marker = Marker(
          markerId: MarkerId(markerId),
          position: position,
          icon: await getAssetImageMarker("assets/logo-parkings.png"),
          onTap: () {
            authBloc.add(OnChangePerfil(perfil)); // Pasamos el perfil completo
            add(const OnGoNavigationMarcador());
          },
        );

        markers[markerId] = marker;
      }

      emit(state.copyWith(markers: markers));
    });

    on<OnChangeDetailMapGoogle>((event, emit) {
      emit(state.copyWith(detailMapGoogle: event.detail));
    });

    on<OnChangeDetailSantaCruz>((event, emit) async {});

    on<OnChangedMarkersDenuncia>((event, emit) async {});

    on<OnChangedWorkMapType>((event, emit) {
      emit(state.copyWith(workMapType: event.workMapType));
      add(const OnMapInitContent());
    });

    on<OnChangedTypeServicio>((event, emit) async {});

    on<OnGenerarRuta>((event, emit) async {
      emit(state.copyWith(
        polylines: {},
        polygons: {},
        markers: {},
      ));

      String coordenadas = authBloc.state.perfil!.coordenadas;
      LatLng puntoDestino = obtenerCoordenadas(coordenadas);

      Position posicionUsuario = await permissionsBloc.getActualLocation();
      LatLng loca = LatLng(posicionUsuario.latitude, posicionUsuario.longitude);

      String polylineEncode = await getRoutePuntosCorte(
        posicionInicial: loca,
        posicionDestino: puntoDestino,
      );

      List<PointLatLng> result =
          PolylinePoints().decodePolyline(polylineEncode);
      List<LatLng> polylineCoordinates = result
          .map((PointLatLng point) => LatLng(point.latitude, point.longitude))
          .toList();

      // Crear polyline con borde (sombra)
      final polylineSombra = Polyline(
        polylineId: const PolylineId('rutaSombra'),
        points: polylineCoordinates,
        color: Colors.black54,
        width: 8,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
      );

      // Crear polyline principal
      final polylinePrincipal = Polyline(
        polylineId: const PolylineId('rutaPrincipal'),
        points: polylineCoordinates,
        color: kPrimaryColor,
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        patterns: [PatternItem.dash(20), PatternItem.gap(10)],
      );

      final marcadorDestino = Marker(
        markerId: const MarkerId('destino'),
        position: puntoDestino,
        icon: await getAssetImageMarker("assets/logo-parkings.png"),
        onTap: () {
          authBloc.add(OnChangePerfil(authBloc.state.perfil!));
          add(const OnGoNavigationMarcador());
        },
      );

      authBloc.add(OnChangeStatusServicio(StatusServicio.gps));

      // Convertir PolylineId a String en el Map
      final currentPolylines = {
        'rutaSombra': polylineSombra,
        'rutaPrincipal': polylinePrincipal,
      };

      emit(state.copyWith(polylines: currentPolylines, markers: {
        'destino': marcadorDestino,
      }));
    });
    on<OnGoogleMapController>((event, emit) {
      mapController = event.controller;
    });

    on<OnGoNavigationMarcador>((event, emit) {
      emit(state.copyWith(urlAppMarcador: '/informacion-detallada'));
    });

    on<OnResetNavigationMarcador>((event, emit) {
      emit(state.copyWith(urlAppMarcador: ''));
    });

    on<OnCleanBlocMapGoogle>((event, emit) {
      emit(state.copyWith(
        detailMapGoogle: DetailMapGoogle.normal,
        detailSanCruz: DetailSanCruz.todos,
        statusMarkersDenuncia: StatucMarkersDenuncia.todos,
        workMapType: WorkMapType.denuncias,
        typeServicio: TypeServicio.serviciosPublicos,
        markers: {},
        polylines: {},
        polygons: {},
      ));
    });
  }

  Future<String> getRoutePuntosCorte({
    required LatLng posicionInicial,
    required LatLng posicionDestino,
  }) async {
    final dio = Dio();

    // Crear el cuerpo de la solicitud usando un Map
    final requestBody = {
      "origin": {
        "location": {
          "latLng": {
            "latitude": posicionInicial.latitude,
            "longitude": posicionInicial.longitude
          }
        }
      },
      "destination": {
        "location": {
          "latLng": {
            "latitude": posicionDestino.latitude,
            "longitude": posicionDestino.longitude
          }
        }
      },
      "travelMode": "DRIVE",
      "polylineQuality": "HIGH_QUALITY",
      "routingPreference": "TRAFFIC_UNAWARE",
      "computeAlternativeRoutes": false,
      "routeModifiers": {
        "avoidTolls": false,
        "avoidHighways": false,
        "avoidFerries": false,
        "avoidIndoor": false
      }
    };

    final options = Options(
      headers: {
        'Content-Type': 'application/json',
        'X-Goog-Api-Key': 'AIzaSyDYq6w1N7meIbXFGd56FrrfoGN4c7U-r2g',
        'X-Goog-FieldMask':
            'routes.duration,routes.distanceMeters,routes.polyline.encodedPolyline'
      },
    );

    try {
      final response = await dio.post(
        'https://routes.googleapis.com/directions/v2:computeRoutes',
        data: requestBody, // Dio convertirá automáticamente el Map a JSON
        options: options,
      );

      if (response.statusCode == 200) {
        return response.data['routes'][0]['polyline']['encodedPolyline'];
      }

      throw Exception('Failed to load route: Status ${response.statusCode}');
    } catch (e) {
      throw Exception('Error fetching route: ${e.toString()}');
    }
  }

  Future<BitmapDescriptor> getAssetImageMarker(String assetPath) async {
    final ByteData data = await rootBundle.load(assetPath);

    // Decodificar la imagen primero para obtener sus dimensiones originales
    final ui.Codec codec =
        await ui.instantiateImageCodec(data.buffer.asUint8List());
    final ui.FrameInfo fi = await codec.getNextFrame();

    // Calcular las dimensiones manteniendo la proporción
    final double aspectRatio = fi.image.width / fi.image.height;
    int targetWidth = 140;
    int targetHeight = (targetWidth / aspectRatio).round();

    // Crear la imagen redimensionada
    final imageCodec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetHeight: targetHeight,
      targetWidth: targetWidth,
      allowUpscaling: false,
    );

    final frame = await imageCodec.getNextFrame();
    final imageData = await frame.image.toByteData(
      format: ui.ImageByteFormat.png, // PNG para mejor calidad sin pérdida
    );

    return BitmapDescriptor.fromBytes(imageData!.buffer.asUint8List());
  }

  LatLng obtenerCoordenadas(String coordenadas) {
    final coords = coordenadas.split(',');
    return LatLng(
        double.parse(coords[0].trim()), double.parse(coords[1].trim()));
  }
}
