// models/servicio_seleccionado.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sw1final_official/config/blocs/auth/auth_bloc.dart';
import 'package:sw1final_official/config/blocs/mapGogle/map_google_bloc.dart';
import 'package:sw1final_official/config/constant/const.dart';

class ServiciosSeleccionadosInfo {
  final TipoVehiculo tipoVehiculo;
  final List<ServicioSeleccionado> serviciosEstacionamiento;
  final List<ServicioSeleccionado> serviciosLimpieza;
  final List<ServicioSeleccionado> serviciosAdicionales;
  final double totalPagar;

  ServiciosSeleccionadosInfo({
    required this.tipoVehiculo,
    required this.serviciosEstacionamiento,
    required this.serviciosLimpieza,
    required this.serviciosAdicionales,
    required this.totalPagar,
  });
}

class ServicioSeleccionado {
  final String id;
  final String nombre;
  final double precio;
  bool seleccionado;

  ServicioSeleccionado({
    required this.id,
    required this.nombre,
    required this.precio,
    this.seleccionado = false,
  });
}

enum TipoVehiculo { ninguno, auto, moto }

class GrupoServicio {
  final String categoria;
  final List<ServicioSeleccionado> servicios;

  GrupoServicio({
    required this.categoria,
    required this.servicios,
  });
}

class DetallesParkingScreen extends StatefulWidget {
  const DetallesParkingScreen({
    Key? key,
  }) : super(key: key);

  @override
  _DetallesParkingScreenState createState() => _DetallesParkingScreenState();
}

class _DetallesParkingScreenState extends State<DetallesParkingScreen> {
  List<ServicioSeleccionado> serviciosSeleccionados = [];
  TipoVehiculo tipoVehiculoSeleccionado = TipoVehiculo.ninguno;
  List<GrupoServicio> serviciosAgrupados = [];
  double totalServicios = 0.0;
  Perfil? perfil;

  @override
  void initState() {
    super.initState();
    final authBloc = BlocProvider.of<AuthBloc>(context);
    perfil = authBloc.state.perfil;
    _inicializarServicios();
  }

  void _inicializarServicios() {
    // Agrupar servicios por categoría
    Map<String, List<ServicioSeleccionado>> grupos = {};

    for (var servicio in perfil!.servicios) {
      String categoria = _obtenerCategoria(servicio.nombre);
      if (!grupos.containsKey(categoria)) {
        grupos[categoria] = [];
      }
      grupos[categoria]!.add(ServicioSeleccionado(
        id: servicio.id,
        nombre: servicio.nombre,
        precio: servicio.precio - (servicio.precio * servicio.descuento / 100),
      ));
    }

    serviciosAgrupados = grupos.entries
        .map((e) => GrupoServicio(categoria: e.key, servicios: e.value))
        .toList();
  }

  String _obtenerCategoria(String nombreServicio) {
    if (nombreServicio.contains('Estacionamiento Auto'))
      return 'Estacionamiento Auto';
    if (nombreServicio.contains('Estacionamiento Moto'))
      return 'Estacionamiento Moto';
    if (nombreServicio.contains('Lavado')) return 'Servicios de Limpieza';
    return 'Servicios Adicionales';
  }

  void actualizarTotal() {
    setState(() {
      totalServicios = 0;
      for (var grupo in serviciosAgrupados) {
        for (var servicio in grupo.servicios) {
          if (servicio.seleccionado) {
            totalServicios += servicio.precio;
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [kPrimaryColor, Color(0xFFF5F5F5)],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            _buildSliverAppBar(),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInformacionBasica(),
                    SizedBox(height: 24),
                    _buildReglas(),
                    SizedBox(height: 24),
                    _buildServicios(),
                    SizedBox(height: 24),
                    _buildBotonComunicados(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 300,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          perfil!.nombreParking,
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                offset: Offset(0, 2),
                blurRadius: 4,
                color: Colors.black.withOpacity(0.5),
              ),
            ],
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              perfil!.imagenURL,
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInformacionBasica() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Información General',
              style: GoogleFonts.montserrat(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: kSecondaryColor,
              ),
            ),
            Divider(color: kTerciaryColor),
            _buildInfoRow(
                Icons.access_time, 'Horario', perfil!.horarioAtencion),
            _buildInfoRow(
                Icons.local_parking, 'Espacios', '${perfil!.cantEspacios}'),
            _buildInfoRow(Icons.phone, 'Teléfono', perfil!.telefono),
            _buildInfoRow(Icons.location_on, 'Dirección', perfil!.direccion),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String titulo, String valor) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: kCuartoColor, size: 24),
          SizedBox(width: 12),
          Expanded(
            child: Column(
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
          ),
        ],
      ),
    );
  }

  Widget _buildReglas() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reglas del Estacionamiento',
              style: GoogleFonts.montserrat(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: kSecondaryColor,
              ),
            ),
            Divider(color: kTerciaryColor),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: perfil!.reglas.length,
              itemBuilder: (context, index) {
                final regla = perfil!.reglas[index];
                return ListTile(
                  leading: Icon(Icons.check_circle, color: kCuartoColor),
                  title: Text(
                    regla.descripcion,
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      color: kSecondaryColor,
                    ),
                  ),
                  subtitle: Text(
                    regla.categoria,
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      color: kTerciaryColor,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServicios() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Servicios Disponibles',
              style: GoogleFonts.montserrat(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: kSecondaryColor,
              ),
            ),
            Divider(color: kTerciaryColor),
            // Selección de tipo de vehículo
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () =>
                        _seleccionarTipoVehiculo(TipoVehiculo.auto),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          tipoVehiculoSeleccionado == TipoVehiculo.auto
                              ? kCuartoColor
                              : Colors.grey[300],
                    ),
                    child: Text('Auto'),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () =>
                        _seleccionarTipoVehiculo(TipoVehiculo.moto),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          tipoVehiculoSeleccionado == TipoVehiculo.moto
                              ? kCuartoColor
                              : Colors.grey[300],
                    ),
                    child: Text('Moto'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            // Lista de servicios filtrados
            ...serviciosAgrupados
                .where((grupo) => _mostrarGrupo(grupo.categoria))
                .map((grupo) => _buildGrupoServicios(grupo)),
          ],
        ),
      ),
    );
  }

  bool _mostrarGrupo(String categoria) {
    if (tipoVehiculoSeleccionado == TipoVehiculo.ninguno) return false;

    if (tipoVehiculoSeleccionado == TipoVehiculo.auto) {
      if (categoria == 'Estacionamiento Moto') return false;
      if (categoria == 'Servicios de Limpieza') {
        return true; // Solo mostrar servicios de auto
      }
    } else {
      if (categoria == 'Estacionamiento Auto') return false;
      if (categoria == 'Servicios de Limpieza') {
        return true; // Solo mostrar servicios de moto
      }
    }

    return categoria == 'Servicios Adicionales' ||
        (categoria.contains('Estacionamiento') &&
            categoria.contains(tipoVehiculoSeleccionado == TipoVehiculo.auto
                ? 'Auto'
                : 'Moto'));
  }

  Widget _buildGrupoServicios(GrupoServicio grupo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            grupo.categoria,
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: kSecondaryColor,
            ),
          ),
        ),
        ...grupo.servicios
            .where((servicio) => _mostrarServicio(servicio.nombre))
            .map((servicio) => CheckboxListTile(
                  title: Text(servicio.nombre),
                  subtitle: Text('Bs. ${servicio.precio.toStringAsFixed(2)}'),
                  value: servicio.seleccionado,
                  onChanged: (bool? value) {
                    _seleccionarServicio(servicio, value ?? false);
                  },
                )),
        SizedBox(height: 16),
      ],
    );
  }

  bool _mostrarServicio(String nombreServicio) {
    if (tipoVehiculoSeleccionado == TipoVehiculo.auto) {
      return !nombreServicio.contains('Moto');
    } else {
      return !nombreServicio.contains('Auto');
    }
  }

  void _seleccionarServicio(ServicioSeleccionado servicio, bool seleccionado) {
    setState(() {
      // Deseleccionar otros servicios de estacionamiento si es necesario
      if (seleccionado && servicio.nombre.contains('Estacionamiento')) {
        for (var grupo in serviciosAgrupados) {
          for (var s in grupo.servicios) {
            if (s.nombre.contains('Estacionamiento')) {
              s.seleccionado = false;
            }
          }
        }
      }
      servicio.seleccionado = seleccionado;
      actualizarTotal();
    });
  }

  void _seleccionarTipoVehiculo(TipoVehiculo tipo) {
    setState(() {
      if (tipoVehiculoSeleccionado != tipo) {
        // Deseleccionar todos los servicios al cambiar de tipo
        for (var grupo in serviciosAgrupados) {
          for (var servicio in grupo.servicios) {
            servicio.seleccionado = false;
          }
        }
        tipoVehiculoSeleccionado = tipo;
        actualizarTotal();
      }
    });
  }

  Widget _buildBotonComunicados() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              _mostrarComunicados(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: kCuartoColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.symmetric(vertical: 16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.announcement, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Ver Comunicados',
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 12),
        ElevatedButton(
          onPressed: () {
            // Lógica para marcar/desmarcar como favorito
            // Aquí puedes alternar el estado y actualizar el ícono
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: kSecondaryColor,
            padding: EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Icon(
            Icons
                .favorite_border, // O Icons.favorite si está marcado como favorito
            color: kQuintaColor,
            size: 24,
          ),
        ),
        SizedBox(width: 12),
        ElevatedButton(
          onPressed: () {
            // context.push("/maps-parking");
            final mapGoogleBloc = BlocProvider.of<MapGoogleBloc>(context);
            mapGoogleBloc.add(OnGenerarRuta());
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: kSecondaryColor,
            padding: EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Icon(
            Icons.map_outlined,
            color: kQuintaColor,
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    // Verificar si hay un servicio de estacionamiento seleccionado
    bool hayEstacionamientoSeleccionado = serviciosAgrupados
        .where((grupo) => grupo.categoria.contains('Estacionamiento'))
        .any((grupo) =>
            grupo.servicios.any((servicio) => servicio.seleccionado));

    // Verificar el resto de servicios seleccionados
    bool hayOtrosServicios = serviciosAgrupados.any(
      (grupo) =>
          !grupo.categoria.contains('Estacionamiento') &&
          grupo.servicios.any((servicio) => servicio.seleccionado),
    );
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Servicios',
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    color: kTerciaryColor,
                  ),
                ),
                Text(
                  'Bs. ${totalServicios.toStringAsFixed(2)}',
                  style: GoogleFonts.montserrat(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: kSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: hayEstacionamientoSeleccionado
                ? () {
                    List<ServicioSeleccionado> estacionamiento = [];
                    List<ServicioSeleccionado> limpieza = [];
                    List<ServicioSeleccionado> adicionales = [];

                    for (var grupo in serviciosAgrupados) {
                      for (var servicio in grupo.servicios) {
                        if (servicio.seleccionado) {
                          if (grupo.categoria.contains('Estacionamiento')) {
                            estacionamiento.add(servicio);
                          } else if (grupo.categoria ==
                              'Servicios de Limpieza') {
                            limpieza.add(servicio);
                          } else if (grupo.categoria ==
                              'Servicios Adicionales') {
                            adicionales.add(servicio);
                          }
                        }
                      }
                    }

                    final serviciosInfo = ServiciosSeleccionadosInfo(
                      tipoVehiculo: tipoVehiculoSeleccionado,
                      serviciosEstacionamiento: estacionamiento,
                      serviciosLimpieza: limpieza,
                      serviciosAdicionales: adicionales,
                      totalPagar: totalServicios,
                    );

                    authBloc.add(OnChangendServicioParking(serviciosInfo));
                    context.push("/qr-servicio");
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: kCuartoColor,
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Comenzar Servicios',
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarComunicados(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Comunicados',
                style: GoogleFonts.montserrat(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: kSecondaryColor,
                ),
              ),
              Divider(color: kTerciaryColor),
              Container(
                constraints: BoxConstraints(maxHeight: 400),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: perfil!.comunicados.length,
                  itemBuilder: (context, index) {
                    final comunicado = perfil!.comunicados[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: Icon(
                          comunicado.tipo == 'Aviso'
                              ? Icons.warning
                              : Icons.info,
                          color: comunicado.tipo == 'Aviso'
                              ? kQuintaColor
                              : kCuartoColor,
                        ),
                        title: Text(
                          comunicado.contenido,
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            color: kSecondaryColor,
                          ),
                        ),
                        subtitle: Text(
                          comunicado.tipo,
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            color: kTerciaryColor,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kCuartoColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Cerrar',
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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

class CustomCard extends StatelessWidget {
  final Widget child;
  final double elevation;
  final EdgeInsetsGeometry padding;
  final BorderRadius? borderRadius;

  const CustomCard({
    Key? key,
    required this.child,
    this.elevation = 4,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: kSecondaryColor.withOpacity(0.1),
            blurRadius: elevation * 2,
            offset: Offset(0, elevation),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}

class ServicioCard extends StatelessWidget {
  final ServicioSeleccionado servicio;
  final Function(bool?) onChanged;

  const ServicioCard({
    Key? key,
    required this.servicio,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: servicio.seleccionado
            ? kCuartoColor.withOpacity(0.1)
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: servicio.seleccionado
              ? kCuartoColor
              : kTerciaryColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: CheckboxListTile(
        title: Text(
          servicio.nombre,
          style: GoogleFonts.montserrat(
            fontSize: 16,
            color: kSecondaryColor,
            fontWeight:
                servicio.seleccionado ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        subtitle: Text(
          'Bs. ${servicio.precio.toStringAsFixed(2)}',
          style: GoogleFonts.montserrat(
            fontSize: 14,
            color: kTerciaryColor,
          ),
        ),
        value: servicio.seleccionado,
        activeColor: kCuartoColor,
        onChanged: onChanged,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

class AnimatedTotalCounter extends StatelessWidget {
  final double total;

  const AnimatedTotalCounter({
    Key? key,
    required this.total,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: total),
      duration: Duration(milliseconds: 500),
      builder: (context, value, child) {
        return Text(
          'Bs. ${value.toStringAsFixed(2)}',
          style: GoogleFonts.montserrat(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: kSecondaryColor,
          ),
        );
      },
    );
  }
}

class AppTheme {
  static ThemeData get theme => ThemeData(
        colorScheme: ColorScheme.light(
          primary: kCuartoColor,
          secondary: kQuintaColor,
          surface: kPrimaryColor,
          background: kPrimaryColor,
          error: Colors.red,
          onPrimary: Colors.white,
          onSecondary: kSecondaryColor,
          onSurface: kSecondaryColor,
          onBackground: kSecondaryColor,
          onError: Colors.white,
        ),
        scaffoldBackgroundColor: kPrimaryColor,
        appBarTheme: AppBarTheme(
          backgroundColor: kSecondaryColor,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: GoogleFonts.montserrat(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.disabled)) {
                  return kCuartoColor.withOpacity(0.3);
                }
                return kCuartoColor;
              },
            ),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            textStyle: MaterialStateProperty.all<TextStyle>(
              GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        textTheme: TextTheme(
          displayLarge: GoogleFonts.montserrat(
            // antes headline1
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: kSecondaryColor,
          ),
          displayMedium: GoogleFonts.montserrat(
            // antes headline2
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: kSecondaryColor,
          ),
          displaySmall: GoogleFonts.montserrat(
            // antes headline3
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: kSecondaryColor,
          ),
          bodyLarge: GoogleFonts.montserrat(
            // antes bodyText1
            fontSize: 16,
            color: kSecondaryColor,
          ),
          bodyMedium: GoogleFonts.montserrat(
            // antes bodyText2
            fontSize: 14,
            color: kTerciaryColor,
          ),
        ),
        useMaterial3: true, // Habilitar Material 3
      );
}
