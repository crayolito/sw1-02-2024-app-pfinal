import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:dio/dio.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HelpersMap {
  static Future<BitmapDescriptor> getAssetImageMarker(String assetPath) async {
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

  static Future<BitmapDescriptor> getNetworkImageMarker(
      String urlMarker) async {
    final resp = await Dio().get(
      urlMarker,
      options: Options(responseType: ResponseType.bytes),
    );

    final imageCodec = await ui.instantiateImageCodec(resp.data,
        targetHeight: 140, targetWidth: 140);
    final frame = await imageCodec.getNextFrame();
    final data = await frame.image.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }
}
