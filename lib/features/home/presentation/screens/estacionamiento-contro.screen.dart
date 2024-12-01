// screens/estacionamiento_activo_screen.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sw1final_official/config/blocs/auth/auth_bloc.dart';
import 'package:sw1final_official/config/constant/const.dart';
import 'package:sw1final_official/features/home/presentation/screens/detalels-parking.screen.dart';

class EstacionamientoActivoScreen extends StatelessWidget {
  const EstacionamientoActivoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context, listen: true);
    final servicio = authBloc.state.servicioParking!;

    return BlocProvider(
      create: (context) => ParkingTimerBloc(servicio),
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [kSecondaryColor, kSecondaryColor.withOpacity(0.95)],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.05,
                      vertical: size.height * 0.02,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        AutoWidget(),
                        CronometroWidget(),
                        BotonesControlWidget(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kSecondaryColor,
        boxShadow: [
          BoxShadow(
            color: kSecondaryColor.withOpacity(0.2),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Control de parking',
            style: GoogleFonts.montserrat(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          IconButton(
            icon: Icon(Icons.menu, color: kQuintaColor),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

// widgets/cronometro_widget.dart
class CronometroWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ParkingTimerBloc, ParkingTimerState>(
      builder: (context, state) {
        return Column(
          children: [
            Text(
              'Tiempo del Parqueo',
              style: GoogleFonts.montserrat(
                fontSize: 18,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: size.height * 0.02),
            Text(
              state.tiempoFormateado,
              style: GoogleFonts.montserrat(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: size.height * 0.02),
            Text(
              '${state.precioActual.toStringAsFixed(2)} Bs.',
              style: GoogleFonts.montserrat(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: kQuintaColor,
              ),
            ),
          ],
        );
      },
    );
  }
}

class AutoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ParkingTimerBloc, ParkingTimerState>(
      builder: (context, state) {
        final progress =
            state.tiempoTranscurrido.inSeconds / state.tiempoLimite.inSeconds;
        final adjustedProgress = progress > 1 ? progress % 1 : progress;

        return Container(
          width: size.width * 0.8, // Aumentamos el tamaño del contenedor
          height: size.width * 0.8,
          child: Stack(
            children: [
              // Círculo base (gris)
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: kTerciaryColor.withOpacity(0.3),
                    width: 12,
                  ),
                ),
              ),
              // Círculo de progreso animado
              Transform.rotate(
                angle: -3.14159 / 2,
                child: CustomPaint(
                  size: Size(size.width * 0.8, size.width * 0.8),
                  painter: CircleProgressPainter(
                    progress: adjustedProgress,
                    progressColor: state.tiempoTranscurrido > state.tiempoLimite
                        ? Colors.red
                        : kQuintaColor,
                    strokeWidth: 12,
                  ),
                ),
              ),
              // Auto centrado con efectos
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: size.width * 0.5, // Auto más grande
                      height: size.width * 0.35,
                      // padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: kSecondaryColor.withOpacity(0.3),
                        boxShadow: [
                          BoxShadow(
                            color: kSecondaryColor.withOpacity(0.2),
                            blurRadius: 15,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'assets/auto.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    Text(
                      _getTiempoRestante(state),
                      style: GoogleFonts.montserrat(
                        fontSize: 18, // Texto más grande
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              // Indicador de tiempo excedido
              if (progress > 1)
                AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.red.withOpacity(0.4),
                      width: 4,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.2),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  String _getTiempoRestante(ParkingTimerState state) {
    if (state.tiempoTranscurrido > state.tiempoLimite) {
      return 'Tiempo excedido';
    }

    final tiempoRestante = state.tiempoLimite - state.tiempoTranscurrido;
    final minutos = tiempoRestante.inMinutes;
    final segundos = tiempoRestante.inSeconds % 60;

    return '$minutos:${segundos.toString().padLeft(2, '0')} restantes';
  }
}

// Painter personalizado para el círculo de progreso
class CircleProgressPainter extends CustomPainter {
  final double progress;
  final Color progressColor;
  final double strokeWidth;

  CircleProgressPainter({
    required this.progress,
    required this.progressColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Círculo de progreso
    final paint = Paint()
      ..color = progressColor
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    final arcAngle = 2 * 3.14159 * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      0,
      arcAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

// widgets/botones_control_widget.dart
class BotonesControlWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ParkingTimerBloc, ParkingTimerState>(
      builder: (context, state) {
        return Column(
          children: [
            ElevatedButton.icon(
              onPressed: () {
                context.read<ParkingTimerBloc>().add(
                      FinalizarEstacionamiento(),
                    );
                context.push("/qr-salir");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white24,
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.1,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              icon: Icon(Icons.stop_circle_outlined, color: Colors.white),
              label: Text(
                'Terminar, procesar pago',
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancelar',
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class ParkingTimerState {
  final Duration tiempoTranscurrido;
  final double precioBase;
  final double precioActual;
  final bool estaActivo;
  final Duration tiempoLimite;

  String get tiempoFormateado {
    final horas = tiempoTranscurrido.inHours.toString().padLeft(2, '0');
    final minutos =
        (tiempoTranscurrido.inMinutes % 60).toString().padLeft(2, '0');
    final segundos =
        (tiempoTranscurrido.inSeconds % 60).toString().padLeft(2, '0');
    return '$horas:$minutos:$segundos';
  }

  ParkingTimerState({
    required this.tiempoTranscurrido,
    required this.precioBase,
    required this.precioActual,
    required this.estaActivo,
    required this.tiempoLimite,
  });

  ParkingTimerState copyWith({
    Duration? tiempoTranscurrido,
    double? precioBase,
    double? precioActual,
    bool? estaActivo,
    Duration? tiempoLimite,
  }) {
    return ParkingTimerState(
      tiempoTranscurrido: tiempoTranscurrido ?? this.tiempoTranscurrido,
      precioBase: precioBase ?? this.precioBase,
      precioActual: precioActual ?? this.precioActual,
      estaActivo: estaActivo ?? this.estaActivo,
      tiempoLimite: tiempoLimite ?? this.tiempoLimite,
    );
  }
}

abstract class ParkingTimerEvent {}

class IniciarEstacionamiento extends ParkingTimerEvent {}

class ActualizarTiempo extends ParkingTimerEvent {}

class FinalizarEstacionamiento extends ParkingTimerEvent {}

class ParkingTimerBloc extends Bloc<ParkingTimerEvent, ParkingTimerState> {
  Timer? _timer;
  final ServiciosSeleccionadosInfo servicio;

  ParkingTimerBloc(this.servicio)
      : super(ParkingTimerState(
          tiempoTranscurrido: Duration.zero,
          precioBase: servicio.totalPagar,
          precioActual: servicio.totalPagar,
          estaActivo: false,
          tiempoLimite: _obtenerTiempoLimite(servicio),
        )) {
    on<IniciarEstacionamiento>(_onIniciarEstacionamiento);
    on<ActualizarTiempo>(_onActualizarTiempo);
    on<FinalizarEstacionamiento>(_onFinalizarEstacionamiento);

    // Auto-iniciar el timer
    add(IniciarEstacionamiento());
  }

  static Duration _obtenerTiempoLimite(ServiciosSeleccionadosInfo servicio) {
    final primerServicio = servicio.serviciosEstacionamiento.first;

    // Asegurarse de que estamos detectando correctamente el tiempo seleccionado
    if (primerServicio.nombre.toLowerCase().contains('30 min')) {
      return Duration(minutes: 30);
    }
    if (primerServicio.nombre.toLowerCase().contains('15 min')) {
      return Duration(minutes: 15);
    }
    if (primerServicio.nombre.toLowerCase().contains('1 hora')) {
      return Duration(hours: 1);
    }
    if (primerServicio.nombre.toLowerCase().contains('4 hora')) {
      return Duration(hours: 4);
    }
    if (primerServicio.nombre.toLowerCase().contains('12 hora')) {
      return Duration(hours: 12);
    }
    if (primerServicio.nombre.toLowerCase().contains('dia')) {
      return Duration(hours: 24);
    }

    // Por defecto 30 minutos
    return Duration(minutes: 30);
  }

  void _onIniciarEstacionamiento(
    IniciarEstacionamiento event,
    Emitter<ParkingTimerState> emit,
  ) {
    _timer?.cancel();
    _timer = Timer.periodic(
      Duration(seconds: 1),
      (_) => add(ActualizarTiempo()),
    );
    emit(state.copyWith(estaActivo: true));
  }

  void _onActualizarTiempo(
    ActualizarTiempo event,
    Emitter<ParkingTimerState> emit,
  ) {
    final nuevoTiempo = state.tiempoTranscurrido + Duration(seconds: 1);
    double nuevoPrecio = state.precioBase;

    if (nuevoTiempo > state.tiempoLimite) {
      // Calcular precio adicional
      final tiempoExtra = nuevoTiempo - state.tiempoLimite;
      final horasExtra = (tiempoExtra.inMinutes / 30).ceil();
      nuevoPrecio =
          state.precioBase + (horasExtra * 10); // 10 Bs por cada 30 min extra
    }

    emit(state.copyWith(
      tiempoTranscurrido: nuevoTiempo,
      precioActual: nuevoPrecio,
    ));
  }

  void _onFinalizarEstacionamiento(
    FinalizarEstacionamiento event,
    Emitter<ParkingTimerState> emit,
  ) {
    _timer?.cancel();
    emit(ParkingTimerState(
      tiempoTranscurrido: Duration.zero,
      precioBase: state.precioBase,
      precioActual: state.precioBase,
      estaActivo: false,
      tiempoLimite: state.tiempoLimite,
    ));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
