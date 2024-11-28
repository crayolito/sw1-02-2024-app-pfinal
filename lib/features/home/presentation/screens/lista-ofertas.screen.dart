import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sw1final_official/config/blocs/auth/auth_bloc.dart';
import 'package:sw1final_official/config/constant/const.dart';

class ListaOfertasScreen extends StatefulWidget {
  const ListaOfertasScreen({super.key});

  @override
  State<ListaOfertasScreen> createState() => _ListaOfertasScreenState();
}

class _ListaOfertasScreenState extends State<ListaOfertasScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<MapEntry<Perfil, Servicio>> _ofertasFiltradas = [];
  List<MapEntry<Perfil, Servicio>> _todasLasOfertas = [];

  @override
  void initState() {
    super.initState();
    _inicializarOfertas();
  }

  void _inicializarOfertas() {
    _todasLasOfertas = perfiles.expand((perfil) {
      return perfil.servicios.map((servicio) {
        // if (servicio.descuento > 0) {
        //   return MapEntry(perfil, servicio);
        // }
        // return null;
        return MapEntry(perfil, servicio);
      }).whereType<MapEntry<Perfil, Servicio>>();
    }).toList();

    _ofertasFiltradas = List.from(_todasLasOfertas);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filtrarOfertas(String query) {
    setState(() {
      if (query.isEmpty) {
        _ofertasFiltradas = _todasLasOfertas;
      } else {
        _ofertasFiltradas = _todasLasOfertas.where((entry) {
          final perfil = entry.key;
          final servicio = entry.value;
          return perfil.nombreParking
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              servicio.nombre.toLowerCase().contains(query.toLowerCase()) ||
              servicio.categoria.toLowerCase().contains(query.toLowerCase());
        }).toList();
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
            child: _ofertasFiltradas.isEmpty
                ? _buildEmptyState()
                : _buildOfertasList(),
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
        'Ofertas Disponibles',
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
        onChanged: _filtrarOfertas,
        decoration: OfertasStyles.searchDecoration('Buscar ofertas...'),
        style: GoogleFonts.poppins(
          color: kSecondaryColor,
          fontSize: size.width * 0.035,
        ),
      ),
    );
  }

  Widget _buildOfertasList() {
    return ListView.builder(
      padding: EdgeInsets.only(
        top: size.height * 0.01,
        bottom: size.height * 0.02,
      ),
      itemCount: _ofertasFiltradas.length,
      itemBuilder: (context, index) {
        final oferta = _ofertasFiltradas[index];
        // Buscar el perfil actual de la oferta
        final perfilActual = _ofertasFiltradas.elementAt(index).key;

        return OfertaCard(
          perfil: oferta.key,
          servicio: oferta.value,
          onTap: () {
            final AuthBloc authBloc = BlocProvider.of<AuthBloc>(context);
            authBloc
                .add(OnChangePerfil(perfilActual)); // Usar el perfil encontrado
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
            Icons.local_offer_outlined,
            size: size.width * 0.15,
            color: kTerciaryColor,
          ),
          SizedBox(height: size.height * 0.02),
          Text(
            'No se encontraron ofertas',
            style: OfertasStyles.subtitleStyle,
          ),
          SizedBox(height: size.height * 0.01),
          Text(
            'Intenta con otros términos de búsqueda',
            style: OfertasStyles.bodyStyle.copyWith(
              color: kTerciaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

class OfertaCard extends StatelessWidget {
  final Perfil perfil;
  final Servicio servicio;
  final VoidCallback onTap;

  const OfertaCard({
    required this.perfil,
    required this.servicio,
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
            decoration: OfertasStyles.cardDecoration,
            child: Row(
              children: [
                _buildImage(),
                Expanded(child: _buildContent()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Container(
      width: size.width * 0.3,
      height: size.width * 0.3,
      margin: EdgeInsets.all(size.width * 0.02),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size.width * 0.03),
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
            Icons.error_outline,
            color: kTerciaryColor,
            size: size.width * 0.06,
          ),
          SizedBox(height: size.height * 0.005),
          Text(
            'Sin imagen',
            style: TextStyle(
              color: kTerciaryColor,
              fontSize: size.width * 0.025,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: EdgeInsets.all(size.width * 0.03),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            servicio.nombre,
            style: OfertasStyles.titleStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: size.height * 0.005),
          Text(
            perfil.nombreParking,
            style: OfertasStyles.subtitleStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: size.height * 0.01),
          _buildPriceInfo(),
          SizedBox(height: size.height * 0.005),
          _buildCategoryChip(),
        ],
      ),
    );
  }

  Widget _buildPriceInfo() {
    final hasDiscount = servicio.descuento > 0;
    final discountedPrice = servicio.precio * (1 - servicio.descuento / 100);

    return Row(
      children: [
        if (hasDiscount) ...[
          Text(
            'Bs. ${discountedPrice.toStringAsFixed(2)}',
            style: OfertasStyles.priceStyle,
          ),
          SizedBox(width: size.width * 0.02),
          Text(
            'Bs. ${servicio.precio.toStringAsFixed(2)}',
            style: OfertasStyles.bodyStyle.copyWith(
              decoration: TextDecoration.lineThrough,
              color: kTerciaryColor,
            ),
          ),
        ] else
          Text(
            'Bs. ${servicio.precio.toStringAsFixed(2)}',
            style: OfertasStyles.priceStyle,
          ),
      ],
    );
  }

  Widget _buildCategoryChip() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.02,
        vertical: size.height * 0.005,
      ),
      decoration: BoxDecoration(
        color: kCuartoColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(size.width * 0.02),
      ),
      child: Text(
        servicio.categoria,
        style: OfertasStyles.bodyStyle.copyWith(
          color: kCuartoColor,
          fontSize: size.width * 0.03,
        ),
      ),
    );
  }
}

class OfertasStyles {
  static TextStyle get titleStyle => GoogleFonts.poppins(
        color: kSecondaryColor,
        fontSize: size.width * 0.045,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get subtitleStyle => GoogleFonts.poppins(
        color: kTerciaryColor,
        fontSize: size.width * 0.035,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get priceStyle => GoogleFonts.poppins(
        color: kCuartoColor,
        fontSize: size.width * 0.04,
        fontWeight: FontWeight.w700,
      );

  static TextStyle get discountStyle => GoogleFonts.poppins(
        color: kQuintaColor,
        fontSize: size.width * 0.035,
        fontWeight: FontWeight.w600,
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
