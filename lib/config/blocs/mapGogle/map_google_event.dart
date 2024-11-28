part of 'map_google_bloc.dart';

class MapGoogleEvent extends Equatable {
  const MapGoogleEvent();

  @override
  List<Object> get props => [];
}

class OnMapInitContent extends MapGoogleEvent {
  const OnMapInitContent();
}

class OnGoogleMapController extends MapGoogleEvent {
  final GoogleMapController controller;
  const OnGoogleMapController(this.controller);
}

class OnCameraPosition extends MapGoogleEvent {
  final CameraPosition cameraPosition;
  const OnCameraPosition(this.cameraPosition);
}

class OnChangeDetailMapGoogle extends MapGoogleEvent {
  final DetailMapGoogle detail;

  const OnChangeDetailMapGoogle(this.detail);
}

class OnChangeDetailSantaCruz extends MapGoogleEvent {
  final DetailSanCruz detail;

  const OnChangeDetailSantaCruz(this.detail);
}

class OnChangedMarkersDenuncia extends MapGoogleEvent {
  final StatucMarkersDenuncia status;

  const OnChangedMarkersDenuncia(this.status);
}

class OnChangedWorkMapType extends MapGoogleEvent {
  final WorkMapType workMapType;

  const OnChangedWorkMapType(this.workMapType);
}

class OnChangedTypeServicio extends MapGoogleEvent {
  final TypeServicio typeServicio;

  const OnChangedTypeServicio(this.typeServicio);
}

class OnGenerarRuta extends MapGoogleEvent {
  const OnGenerarRuta();
}

class OnCleanBlocMapGoogle extends MapGoogleEvent {
  const OnCleanBlocMapGoogle();
}

class OnGoNavigationMarcador extends MapGoogleEvent {
  const OnGoNavigationMarcador();
}

class OnResetNavigationMarcador extends MapGoogleEvent {
  const OnResetNavigationMarcador();
}
