import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sw1final_official/config/blocs/auth/auth_bloc.dart';
import 'package:sw1final_official/config/blocs/location/location_bloc.dart';
import 'package:sw1final_official/config/blocs/mapGogle/map_google_bloc.dart';
import 'package:sw1final_official/config/constant/const.dart';
import 'package:sw1final_official/features/home/presentation/screens/map-loading.screen.dart';
import 'package:sw1final_official/features/home/presentation/widgets/map.view.dart';

// Definición de estilos globales
class MapStyles {
  static final cardDecoration = BoxDecoration(
    color: kPrimaryColor,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: kSecondaryColor.withOpacity(0.1),
        blurRadius: 10,
        offset: const Offset(0, 5),
      ),
    ],
  );

  static final buttonStyle = TextStyle(
    fontFamily: GoogleFonts.poppins().fontFamily,
    color: kSecondaryColor,
    fontWeight: FontWeight.w600,
  );

  static final gradientBackground = LinearGradient(
    colors: [kCuartoColor, kTerciaryColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class MapGoogleScreen extends StatefulWidget {
  const MapGoogleScreen({super.key});

  @override
  State<MapGoogleScreen> createState() => _MapGoogleScreenState();
}

class _MapGoogleScreenState extends State<MapGoogleScreen>
    with SingleTickerProviderStateMixin {
  late MapGoogleBloc _mapGoogleBloc;
  late AuthBloc _authBloc;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _initLocation();
  }

  void _initAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _animationController.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _mapGoogleBloc = BlocProvider.of<MapGoogleBloc>(context);
    _authBloc = BlocProvider.of<AuthBloc>(context);
  }

  Future<void> _initLocation() async {
    final locationBloc = BlocProvider.of<LocationBloc>(context);
    final mapGoogleBloc = BlocProvider.of<MapGoogleBloc>(context);
    mapGoogleBloc.add(const OnMapInitContent());
    await locationBloc.getActualPosition();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _mapGoogleBloc.add(const OnCleanBlocMapGoogle());
    _authBloc.add(const OnCleanBlocAuth());
    super.dispose();
  }

  void _handleMapMarkerNavigation(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.push('/informacion-detallada');
      BlocProvider.of<MapGoogleBloc>(context)
          .add(const OnResetNavigationMarcador());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationBloc, LocationState>(
      builder: (context, locationState) {
        return BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            if (locationState.lastKnownLocation == null) {
              return const MapLoading();
            }

            return FadeTransition(
              opacity: _fadeAnimation,
              child: Stack(
                children: [
                  _contruccionSeccionMapa(context),
                  if (authState.statusServicio == StatusServicio.gps)
                    _buildActionPanel(context),
                  authState.statusServicio == StatusServicio.gps
                      ? const SizedBox()
                      : const CustomSearchButton(),
                  authState.statusServicio == StatusServicio.gps
                      ? const SizedBox()
                      : _buildBottomNavigationPanel(context),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _contruccionSeccionMapa(BuildContext context) {
    return BlocListener<MapGoogleBloc, MapGoogleState>(
      listener: (context, state) {
        if (state.urlAppMarcador.isNotEmpty) {
          _handleMapMarkerNavigation(context);
        }
      },
      child: BlocBuilder<MapGoogleBloc, MapGoogleState>(
        builder: (context, mapState) {
          return MapViewGoogleMap(
            initialLocation: const LatLng(-17.78314482714944, -63.182108160618),
            polygons: mapState.polygons.values.toSet(),
            polylines: mapState.polylines.values.toSet(),
            markers: mapState.markers.values.toSet(),
          );
        },
      ),
    );
  }

  Widget _buildActionPanel(BuildContext context) {
    return Positioned(
      top: size.height * 0.65,
      right: size.width * 0.02,
      // bottom: size.height * 0.15,
      child: Container(
        decoration: MapStyles.cardDecoration.copyWith(
          color: kPrimaryColor.withOpacity(0.9),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: _buildMapActions(context),
        ),
      ),
    );
  }

  List<Widget> _buildMapActions(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    final mapGoogleBloc = BlocProvider.of<MapGoogleBloc>(context);
    final actions = [
      MapAction(
        icon: FontAwesomeIcons.locationCrosshairs,
        onPressed: () {},
        tooltip: 'Mi ubicación',
      ),
      MapAction(
        icon: FontAwesomeIcons.route,
        onPressed: () {},
        tooltip: 'Seguimiento',
      ),
      MapAction(
        icon: FontAwesomeIcons.compass,
        onPressed: () {},
        tooltip: 'Brújula',
      ),
      MapAction(
        icon: FontAwesomeIcons.squareParking,
        onPressed: () {
          authBloc
              .add(const OnChangeStatusServicio(StatusServicio.informacion));
          mapGoogleBloc.add(const OnMapInitContent());
        },
        tooltip: 'Navegación',
      ),
      MapAction(
        icon: FontAwesomeIcons.upRightAndDownLeftFromCenter,
        onPressed: () {},
        tooltip: 'Cambiar vista',
      ),
    ];

    return actions.map((action) => _buildActionButton(action)).toList();
  }

  Widget _buildActionButton(MapAction action) {
    return Padding(
      padding: EdgeInsets.all(size.width * 0.01),
      child: Tooltip(
        message: action.tooltip,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: action.onPressed,
            customBorder: const CircleBorder(),
            child: Container(
              width: size.width * 0.12,
              height: size.width * 0.12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kPrimaryColor,
                boxShadow: [
                  BoxShadow(
                    color: kSecondaryColor.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                action.icon,
                color: kSecondaryColor,
                size: size.width * 0.06,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationPanel(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context, listen: true);
    final mapGoogleBloc = BlocProvider.of<MapGoogleBloc>(context, listen: true);
    return Positioned(
      bottom: size.height * 0.02,
      left: size.width * 0.1,
      right: size.width * 0.1,
      child: Container(
        height: size.height * 0.08,
        decoration: MapStyles.cardDecoration,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildBottomNavButton(
              icon: FontAwesomeIcons.map, // Cambiado de locationDot a map
              label: 'GPS',
              onTap: () => authBloc
                  .add(const OnChangeStatusServicio(StatusServicio.gps)),
            ),
            _buildBottomNavButton(
              icon: FontAwesomeIcons
                  .clipboardList, // Cambiado de bell a clipboardList
              label: 'Información',
              onTap: () {
                authBloc.add(
                  const OnChangeStatusServicio(StatusServicio.informacion),
                );

                mapGoogleBloc.add(const OnMapInitContent());
              },
            ),
            _buildBottomNavButton(
                icon: FontAwesomeIcons.tags, // Cambiado de gear a tags
                label: 'Ofertas',
                onTap: () {
                  authBloc.add(
                    const OnChangeStatusServicio(StatusServicio.ofertas),
                  );
                  mapGoogleBloc.add(const OnMapInitContent());
                }),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavButton(
      {required IconData icon,
      required String label,
      required GestureTapCallback onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.03,
            vertical: size.height * 0.01,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: kSecondaryColor,
                size: size.width * 0.06,
              ),
              SizedBox(height: size.height * 0.005),
              Text(
                label,
                style: MapStyles.buttonStyle.copyWith(
                  fontSize: size.width * 0.03,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomSearchButton extends StatelessWidget {
  const CustomSearchButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: size.height * 0.05,
      left: size.width * 0.04,
      child: Hero(
        tag: 'searchButton',
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(size.width * 0.08),
          child: Container(
            width: size.width * 0.14,
            height: size.width * 0.14,
            decoration: BoxDecoration(
              gradient: MapStyles.gradientBackground,
              borderRadius: BorderRadius.circular(size.width * 0.08),
            ),
            child: _buildSearchButtonContent(context),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchButtonContent(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context, listen: true);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(size.width * 0.08),
        onTap: () {
          if (authBloc.state.statusServicio == StatusServicio.gps) {
            authBloc
                .add(const OnChangeStatusServicio(StatusServicio.informacion));
            return;
          }

          if (authBloc.state.statusServicio == StatusServicio.informacion) {
            context.push('/informacion-parkings');
            return;
          }

          if (authBloc.state.statusServicio == StatusServicio.ofertas) {
            context.push('/ofertas-parkings');
            return;
          }
        },
        child: Icon(
          authBloc.state.statusServicio == StatusServicio.informacion
              ? FontAwesomeIcons.info
              : authBloc.state.statusServicio == StatusServicio.gps
                  ? FontAwesomeIcons.arrowLeft // Icono de volver atrás para GPS
                  : FontAwesomeIcons
                      .bullhorn, // Mantiene el icono original para otros casos
          color: kPrimaryColor,
          size: size.width * 0.07,
        ),
      ),
    );
  }
}

class MapAction {
  final IconData icon;
  final VoidCallback onPressed;
  final String tooltip;

  const MapAction({
    required this.icon,
    required this.onPressed,
    required this.tooltip,
  });
}
