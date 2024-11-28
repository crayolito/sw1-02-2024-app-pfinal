import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRWithLogoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('QR con Logo')),
      body: Center(
        child: QrImageView(
          data: '1', // Datos del QR
          size: 250.0, // Tamaño del QR
          backgroundColor: Colors.white, // Fondo del QR
          embeddedImage: AssetImage('assets/logo.jpeg'), // Ruta del logo
          embeddedImageStyle: QrEmbeddedImageStyle(
            size: Size(50, 50), // Tamaño del logo en el centro
          ),
        ),
      ),
    );
  }
}
