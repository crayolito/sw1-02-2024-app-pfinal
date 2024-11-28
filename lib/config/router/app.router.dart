import 'package:go_router/go_router.dart';
import 'package:sw1final_official/features/home/presentation/screens/detalels-parking.screen.dart';
import 'package:sw1final_official/features/home/presentation/screens/estacionamiento-contro.screen.dart';
import 'package:sw1final_official/features/home/presentation/screens/home.screen.dart';
import 'package:sw1final_official/features/home/presentation/screens/lista-informacion.screen.dart';
import 'package:sw1final_official/features/home/presentation/screens/lista-ofertas.screen.dart';
import 'package:sw1final_official/features/home/presentation/screens/map.screen.dart';
import 'package:sw1final_official/features/home/presentation/screens/preservicio-ingreso.screen.dart';

final appRouter = GoRouter(initialLocation: '/', routes: [
  GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
  GoRoute(path: '/map', builder: (context, state) => const MapGoogleScreen()),
  GoRoute(
      path: '/informacion-parkings',
      builder: (context, state) => const ListaInformacionScreen()),
  GoRoute(
      path: '/ofertas-parkings',
      builder: (context, state) => const ListaOfertasScreen()),
  GoRoute(
      path: '/informacion-detallada',
      builder: (context, state) => const DetallesParkingScreen()),
  GoRoute(
      path: '/qr-servicio',
      builder: (context, state) => const QREstacionamientoScreen()),
  GoRoute(
      path: '/control-estacionamiento',
      builder: (context, state) => const EstacionamientoActivoScreen()),
]);
