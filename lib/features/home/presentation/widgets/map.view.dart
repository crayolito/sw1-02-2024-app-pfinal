import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sw1final_official/config/blocs/mapGogle/map_google_bloc.dart';

class MapViewGoogleMap extends StatefulWidget {
  const MapViewGoogleMap(
      {super.key,
      required this.initialLocation,
      required this.polygons,
      required this.polylines,
      required this.markers});

  final LatLng initialLocation;
  final Set<Polygon> polygons;
  final Set<Polyline> polylines;
  final Set<Marker> markers;

  @override
  State<MapViewGoogleMap> createState() => _MapViewGoogleMapState();
}

class _MapViewGoogleMapState extends State<MapViewGoogleMap> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // final mapBloc = BlocProvider.of<MapBloc>(context);
    // mapBloc.add(OnMapInitContent(context));
  }

  @override
  Widget build(BuildContext context) {
    final mapGoogleBloc = BlocProvider.of<MapGoogleBloc>(context);
    final size = MediaQuery.of(context).size;
    final CameraPosition initialCameraPosition =
        CameraPosition(target: widget.initialLocation, zoom: 17);

    return SizedBox(
      height: size.height,
      width: size.width,
      child: GoogleMap(
        initialCameraPosition: initialCameraPosition,
        trafficEnabled: true,
        buildingsEnabled: true,
        indoorViewEnabled: true,
        zoomGesturesEnabled: true,
        //
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        compassEnabled: false,
        zoomControlsEnabled: false,
        mapToolbarEnabled: false,
        onMapCreated: (GoogleMapController controller) {
          mapGoogleBloc.add(OnGoogleMapController(controller));
        },
        onCameraMove: (CameraPosition position) {},
        markers: widget.markers,
        polylines: widget.polylines,
        polygons: widget.polygons,
        // style: mapStyleCustom,
        mapType: getMapTypeFromDetail(mapGoogleBloc.state.detailMapGoogle),
      ),
    );
  }

  MapType getMapTypeFromDetail(DetailMapGoogle detailMap) {
    switch (detailMap) {
      case DetailMapGoogle.normal:
        return MapType.normal;
      case DetailMapGoogle.satellite:
        return MapType.satellite;
      case DetailMapGoogle.hybrid:
        return MapType.hybrid;
      case DetailMapGoogle.terrain:
        return MapType.terrain;
      case DetailMapGoogle.none:
        return MapType.normal;
    }
  }
}
