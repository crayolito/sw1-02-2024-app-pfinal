// screens/qr_estacionamiento_screen.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sw1final_official/config/blocs/auth/auth_bloc.dart';
import 'package:sw1final_official/config/constant/const.dart';
import 'package:sw1final_official/features/home/presentation/screens/detalels-parking.screen.dart';

class QREstacionamientoScreen extends StatelessWidget {
  const QREstacionamientoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context, listen: true);
    final perfil = authBloc.state.perfil!;
    final serviciosSeleccionados = authBloc.state.servicioParking!;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [kPrimaryColor, Color(0xFFF5F5F5)],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                delegate: CabeceraQRDelegate(
                  perfil: perfil,
                  minHeight: size.height * 0.15,
                  maxHeight: size.height * 0.25,
                ),
                pinned: true,
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      InformacionServicioCard(
                        perfil: perfil,
                        serviciosSeleccionados: serviciosSeleccionados,
                      ),
                      SizedBox(height: 24),
                      QRContainer(
                        perfil: perfil,
                        serviciosSeleccionados: serviciosSeleccionados,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CabeceraQRDelegate extends SliverPersistentHeaderDelegate {
  final Perfil perfil;
  final double minHeight;
  final double maxHeight;

  CabeceraQRDelegate({
    required this.perfil,
    required this.minHeight,
    required this.maxHeight,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final progress = shrinkOffset / maxHeight;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            kSecondaryColor,
            kSecondaryColor.withOpacity(0.8),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: kSecondaryColor.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedOpacity(
            duration: Duration(milliseconds: 150),
            opacity: 1 - progress,
            child: Image.network(
              perfil.imagenURL,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 150),
              opacity: 1 - progress,
              child: Text(
                perfil.nombreParking,
                style: GoogleFonts.montserrat(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 10,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Título minimizado para cuando se hace scroll
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 150),
              opacity: progress,
              child: Text(
                'QR de Acceso',
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}

class InformacionServicioCard extends StatelessWidget {
  final Perfil perfil;
  final ServiciosSeleccionadosInfo serviciosSeleccionados;

  const InformacionServicioCard({
    Key? key,
    required this.perfil,
    required this.serviciosSeleccionados,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: kTerciaryColor.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detalles del Servicio',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.montserrat(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: kSecondaryColor,
              ),
            ),
            Divider(color: kTerciaryColor),
            _buildDetalleItem(
              'Tipo de Vehículo',
              serviciosSeleccionados.tipoVehiculo == TipoVehiculo.auto
                  ? 'Auto'
                  : 'Moto',
              Icons.directions_car,
            ),
            _buildServiciosLista('Estacionamiento',
                serviciosSeleccionados.serviciosEstacionamiento),
            if (serviciosSeleccionados.serviciosLimpieza.isNotEmpty)
              _buildServiciosLista(
                  'Limpieza', serviciosSeleccionados.serviciosLimpieza),
            if (serviciosSeleccionados.serviciosAdicionales.isNotEmpty)
              _buildServiciosLista(
                  'Adicionales', serviciosSeleccionados.serviciosAdicionales),
            Divider(color: kTerciaryColor),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total a Pagar:',
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: kSecondaryColor,
                  ),
                ),
                Text(
                  'Bs. ${serviciosSeleccionados.totalPagar.toStringAsFixed(2)}',
                  style: GoogleFonts.montserrat(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: kCuartoColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetalleItem(String titulo, String valor, IconData icono) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icono, color: kCuartoColor, size: 24),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titulo,
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  color: kTerciaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                valor,
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  color: kSecondaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServiciosLista(
      String titulo, List<ServicioSeleccionado> servicios) {
    return Container(
      height: size.height * 0.12,
      // Eliminar width fijo
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Text(
              titulo,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: kSecondaryColor,
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: servicios
                    .map((servicio) => Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                servicio.nombre,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.montserrat(
                                  fontSize: 14,
                                  color: kSecondaryColor,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Bs. ${servicio.precio.toStringAsFixed(2)}',
                                style: GoogleFonts.montserrat(
                                  fontSize: 14,
                                  color: kTerciaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class QRContainer extends StatelessWidget {
  final Perfil perfil;
  final ServiciosSeleccionadosInfo serviciosSeleccionados;

  const QRContainer({
    Key? key,
    required this.perfil,
    required this.serviciosSeleccionados,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final qrData = {
    //   'perfilId': perfil.id,
    //   'tipoVehiculo': serviciosSeleccionados.tipoVehiculo.toString(),
    //   'servicios': serviciosSeleccionados.serviciosEstacionamiento
    //       .map((s) => s.id)
    //       .toList(),
    //   'total': serviciosSeleccionados.totalPagar,
    //   'timestamp': DateTime.now().toIso8601String(),
    // };

    final qrData = {
      'codigoEntrada': 1,
    };

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              kPrimaryColor,
            ],
          ),
        ),
        child: Column(
          children: [
            Text(
              'Escanea para Ingresar',
              style: GoogleFonts.montserrat(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: kSecondaryColor,
              ),
            ),
            SizedBox(height: 24),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: kSecondaryColor.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: QrImageView(
                data: jsonEncode(
                    qrData), // Usa los datos del qrData que ya tienes definido
                version: QrVersions
                    .auto, // Vuelve a auto para asegurar la compatibilidad
                size: 200,
                backgroundColor: Colors.white,
                eyeStyle: QrEyeStyle(
                  eyeShape: QrEyeShape.square,
                  color: kCuartoColor,
                ),
                dataModuleStyle: QrDataModuleStyle(
                  dataModuleShape: QrDataModuleShape.square,
                  color: kSecondaryColor,
                ),
                embeddedImage: AssetImage('assets/logo.jpeg'),
                embeddedImageStyle: QrEmbeddedImageStyle(
                  size: Size(40, 40),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Válido por ${_obtenerValidez()}',
              style: GoogleFonts.montserrat(
                fontSize: 16,
                color: kTerciaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 24),
            Row(children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kTerciaryColor,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Cancelar',
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Aquí puedes agregar la lógica para empezar
                    context.push("/control-estacionamiento");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kCuartoColor,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Empezar',
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ])
          ],
        ),
      ),
    );
  }

  String _obtenerValidez() {
    final servicio = serviciosSeleccionados.serviciosEstacionamiento.first;
    if (servicio.nombre.contains('Mensual')) return '30 días';
    if (servicio.nombre.contains('Día completo')) return '24 horas';
    if (servicio.nombre.contains('12 horas')) return '12 horas';
    if (servicio.nombre.contains('4 horas')) return '4 horas';
    if (servicio.nombre.contains('1 hora')) return '1 hora';
    if (servicio.nombre.contains('30 min')) return '30 minutos';
    return '15 minutos';
  }
}
