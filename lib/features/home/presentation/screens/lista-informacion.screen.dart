import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sw1final_official/config/blocs/auth/auth_bloc.dart';
import 'package:sw1final_official/config/constant/const.dart';

class ListaInformacionScreen extends StatefulWidget {
  const ListaInformacionScreen({super.key});

  @override
  State<ListaInformacionScreen> createState() => _ListaInformacionScreenState();
}

class _ListaInformacionScreenState extends State<ListaInformacionScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Perfil> _perfilesFiltrados = [];

  @override
  void initState() {
    super.initState();
    _perfilesFiltrados = perfiles;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filtrarPerfiles(String query) {
    setState(() {
      if (query.isEmpty) {
        _perfilesFiltrados = perfiles;
      } else {
        _perfilesFiltrados = perfiles
            .where((perfil) =>
                perfil.nombreParking
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                perfil.direccion.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: _perfilesFiltrados.isEmpty
                ? _buildEmptyState()
                : _buildParkingList(),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: Text(
        'Estacionamientos',
        style: GoogleFonts.poppins(
          color: kSecondaryColor,
          fontSize: size.width * 0.05,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.04,
        vertical: size.height * 0.02,
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _filtrarPerfiles,
        decoration: ParkingStyles.searchDecoration('Buscar estacionamiento...'),
        style: GoogleFonts.poppins(
          color: kSecondaryColor,
          fontSize: size.width * 0.035,
        ),
      ),
    );
  }

  Widget _buildParkingList() {
    return ListView.builder(
      padding: EdgeInsets.only(
        top: size.height * 0.01,
        bottom: size.height * 0.02,
      ),
      itemCount: _perfilesFiltrados.length,
      itemBuilder: (context, index) {
        final Perfil perfil = _perfilesFiltrados[index];
        return ParkingCard(
          perfil: _perfilesFiltrados[index],
          onTap: () {
            final AuthBloc authBloc = BlocProvider.of<AuthBloc>(context);
            authBloc.add(OnChangePerfil(perfil));
            // Implementar navegación al detalle
            context.push("/informacion-detallada");
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: size.width * 0.15,
            color: kTerciaryColor,
          ),
          SizedBox(height: size.height * 0.02),
          Text(
            'No se encontraron resultados',
            style: ParkingStyles.subtitleStyle,
          ),
        ],
      ),
    );
  }
}

class ParkingCard extends StatelessWidget {
  final Perfil perfil;
  final VoidCallback onTap;

  const ParkingCard({
    required this.perfil,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.04,
        vertical: size.height * 0.01,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(size.width * 0.04),
          child: Container(
            decoration: ParkingStyles.cardDecoration,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImage(),
                _buildContent(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Container(
      height: size.height * 0.2,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(size.width * 0.04),
          topRight: Radius.circular(size.width * 0.04),
        ),
        child: perfil.imagenURL.isNotEmpty
            ? Image.network(
                perfil.imagenURL,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return _buildPlaceholder();
                },
                errorBuilder: (context, error, stackTrace) =>
                    _buildErrorWidget(),
              )
            : _buildErrorWidget(),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: kTerciaryColor.withOpacity(0.1),
      child: Center(
        child: CircularProgressIndicator(
          color: kCuartoColor,
          strokeWidth: 2,
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      color: kTerciaryColor.withOpacity(0.1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported_outlined,
            color: kTerciaryColor,
            size: size.width * 0.08,
          ),
          SizedBox(height: size.height * 0.01),
          Text(
            'Imagen no disponible',
            style: TextStyle(
              color: kTerciaryColor,
              fontSize: size.width * 0.03,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: EdgeInsets.all(size.width * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            perfil.nombreParking,
            style: ParkingStyles.titleStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: size.height * 0.01),
          _buildInfoRow(
            FontAwesomeIcons.locationDot,
            perfil.direccion,
          ),
          SizedBox(height: size.height * 0.005),
          _buildInfoRow(
            FontAwesomeIcons.clock,
            perfil.horarioAtencion,
          ),
          SizedBox(height: size.height * 0.005),
          _buildInfoRow(
            FontAwesomeIcons.car,
            '${perfil.cantEspacios} espacios',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          color: kCuartoColor,
          size: size.width * 0.04,
        ),
        SizedBox(width: size.width * 0.02),
        Expanded(
          child: Text(
            text,
            style: ParkingStyles.bodyStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class ParkingStyles {
  static TextStyle get titleStyle => GoogleFonts.poppins(
        color: kSecondaryColor,
        fontSize: size.width * 0.05,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get subtitleStyle => GoogleFonts.poppins(
        color: kTerciaryColor,
        fontSize: size.width * 0.035,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get bodyStyle => GoogleFonts.poppins(
        color: kSecondaryColor,
        fontSize: size.width * 0.032,
      );

  static BoxDecoration get cardDecoration => BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.circular(size.width * 0.04),
        boxShadow: [
          BoxShadow(
            color: kSecondaryColor.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      );

  static InputDecoration searchDecoration(String hint) => InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(
          color: kTerciaryColor,
          fontSize: size.width * 0.035,
        ),
        filled: true,
        fillColor: kPrimaryColor,
        prefixIcon: Icon(
          Icons.search,
          color: kTerciaryColor,
          size: size.width * 0.06,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(size.width * 0.03),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(size.width * 0.03),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(size.width * 0.03),
          borderSide: BorderSide(color: kCuartoColor, width: 2),
        ),
      );
}
