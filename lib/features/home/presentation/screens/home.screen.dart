import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sw1final_official/config/constant/const.dart';
import 'package:sw1final_official/features/home/presentation/widgets/formulario-auth.widget.dart';
import 'package:sw1final_official/features/home/presentation/widgets/formulario-registro.widget.dart'; // Asegúrate de crear este archivo

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _mostrarLogin = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          body: SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  height: size.height * 0.75,
                  width: size.width,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/fondo1.jpg"),
                        fit: BoxFit.cover),
                  ),
                  child: DecoratedBox(
                      decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                  )),
                ),
                const ContainerCustom(),
                Positioned(
                    top: size.height * 0.07,
                    child: Container(
                      alignment: Alignment.center,
                      width: size.width,
                      height: size.height * 0.1,
                      child: Text("EASYPARK", style: letterStyle.tituloHome),
                    )),
                Positioned(
                  top: size.height * 0.175,
                  child: Container(
                    alignment: Alignment.center,
                    width: size.width,
                    height: size.height * 0.1,
                    child: Text(
                      "Cuidamos tu Vehículo\nTu Tranquilidad es Nuestra Prioridad",
                      style: letterStyle.titulo2Home,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Positioned(
                  top: size.height * 0.31,
                  left: size.width * 0.1,
                  right: size.width * 0.1,
                  child: Column(
                    children: [
                      _mostrarLogin
                          ? const FormularioAuth()
                          : const FormularioRegistro(),
                      SizedBox(height: size.height * 0.02),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _mostrarLogin = !_mostrarLogin;
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _mostrarLogin
                                  ? "¿No estás registrado? "
                                  : "¿Ya tienes una cuenta? ",
                              style: GoogleFonts.montserrat(
                                color: kSecondaryColor,
                                fontSize: size.width * 0.035,
                              ),
                            ),
                            Text(
                              _mostrarLogin
                                  ? "Regístrate aquí"
                                  : "Inicia sesión",
                              style: GoogleFonts.montserrat(
                                color: kCuartoColor,
                                fontSize: size.width * 0.035,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

class ContainerCustom extends StatelessWidget {
  const ContainerCustom({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
        width: size.width,
        height: size.height,
        child: CustomPaint(
          painter: _CurvoContainer(),
        ));
  }
}

class _CurvoContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final lapiz = Paint();

    lapiz.color = Colors.white;
    lapiz.style = PaintingStyle.fill;
    lapiz.strokeWidth = 20;

    final path = Path();

    path.moveTo(0, size.height);
    path.lineTo(0, size.height * 0.65);
    path.quadraticBezierTo(
        size.width * 0.5, size.height * 0.82, size.width, size.height * 0.65);
    path.lineTo(size.width, size.height);

    canvas.drawPath(path, lapiz);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
