part of 'map_google_bloc.dart';

enum DetailMapGoogle { hybrid, none, normal, satellite, terrain }

enum DetailSanCruz { marcadores, distritos, todos }

enum StatucMarkersDenuncia { todos, otros }

enum WorkMapType { denuncias, informativo }

enum TypeServicio { micros, serviciosPublicos }

// ignore: must_be_immutable
class MapGoogleState extends Equatable {
  // LOGIC : Control del zoom
  final double statusZoom;

  final bool processMap;
  final bool isMapInitialized;
  final bool followUser;

  Map<String, Marker> markers;
  Map<String, Polyline> polylines;
  Map<String, Polygon> polygons;

  // LOGIC : CONTROL DE MAPA
  final DetailMapGoogle detailMapGoogle;
  final DetailSanCruz detailSanCruz;
  final StatucMarkersDenuncia statusMarkersDenuncia;

  // LOGIC : PARA PODER NAVEGAR DESDE EL CLICK DE LOS MARCADORES
  final String urlAppMarcador;

  // LOGIC : CONTROL TIPO MAPA TRABAJO
  final WorkMapType workMapType;
  final TypeServicio typeServicio;

  MapGoogleState(
      {this.statusZoom = 17,
      this.processMap = true,
      this.isMapInitialized = false,
      this.followUser = false,
      Map<String, Marker>? markers,
      Map<String, Polyline>? polylines,
      Map<String, Polygon>? polygons,
      this.urlAppMarcador = "",
      this.detailMapGoogle = DetailMapGoogle.normal,
      this.detailSanCruz = DetailSanCruz.todos,
      this.statusMarkersDenuncia = StatucMarkersDenuncia.todos,
      this.workMapType = WorkMapType.denuncias,
      this.typeServicio = TypeServicio.serviciosPublicos})
      : markers = markers ?? const {},
        polylines = polylines ?? const {},
        polygons = polygons ?? const {};

  MapGoogleState copyWith({
    String? urlAppMarcador,
    double? statusZoom,
    bool? processMap,
    bool? isMapInitialized,
    bool? followUser,
    Map<String, Marker>? markers,
    Map<String, Polyline>? polylines,
    Map<String, Polygon>? polygons,
    DetailMapGoogle? detailMapGoogle,
    DetailSanCruz? detailSanCruz,
    StatucMarkersDenuncia? statusMarkersDenuncia,
    WorkMapType? workMapType,
    TypeServicio? typeServicio,
  }) {
    return MapGoogleState(
      urlAppMarcador: urlAppMarcador ?? this.urlAppMarcador,
      statusZoom: statusZoom ?? this.statusZoom,
      processMap: processMap ?? this.processMap,
      isMapInitialized: isMapInitialized ?? this.isMapInitialized,
      followUser: followUser ?? this.followUser,
      markers: markers ?? this.markers,
      polylines: polylines ?? this.polylines,
      polygons: polygons ?? this.polygons,
      detailMapGoogle: detailMapGoogle ?? this.detailMapGoogle,
      detailSanCruz: detailSanCruz ?? this.detailSanCruz,
      statusMarkersDenuncia:
          statusMarkersDenuncia ?? this.statusMarkersDenuncia,
      workMapType: workMapType ?? this.workMapType,
      typeServicio: typeServicio ?? this.typeServicio,
    );
  }

  @override
  List<Object?> get props => [
        urlAppMarcador,
        statusZoom,
        processMap,
        isMapInitialized,
        followUser,
        markers,
        polylines,
        polygons,
        detailMapGoogle,
        detailSanCruz,
        statusMarkersDenuncia,
        workMapType,
        typeServicio,
      ];
}
