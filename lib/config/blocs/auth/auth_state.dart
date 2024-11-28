part of 'auth_bloc.dart';

enum StatusServicio { gps, informacion, ofertas }

class AuthState extends Equatable {
  final bool viewWindowInfo;
  final ServicioPublico? servicioPublico;
  final StatusServicio statusServicio;
  Perfil? perfil;
  ServiciosSeleccionadosInfo? servicioParking;

  AuthState({
    this.viewWindowInfo = false,
    this.statusServicio = StatusServicio.informacion,
    this.servicioPublico,
    this.servicioParking,
    this.perfil,
  });

  AuthState copyWith({
    bool? viewWindowInfo,
    ServicioPublico? servicioPublico,
    StatusServicio? statusServicio,
    ServiciosSeleccionadosInfo? servicioParking,
    Perfil? perfil,
  }) {
    return AuthState(
      perfil: perfil ?? this.perfil,
      servicioParking: servicioParking ?? this.servicioParking,
      statusServicio: statusServicio ?? this.statusServicio,
      viewWindowInfo: viewWindowInfo ?? this.viewWindowInfo,
      servicioPublico: servicioPublico ?? this.servicioPublico,
    );
  }

  @override
  List<Object?> get props => [
        statusServicio,
        perfil,
        viewWindowInfo,
        servicioParking,
        servicioPublico,
      ];
}
