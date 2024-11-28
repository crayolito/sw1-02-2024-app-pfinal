part of 'auth_bloc.dart';

class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class OnChangedViewInfo extends AuthEvent {
  const OnChangedViewInfo();
}

class OnChangedServicioPublico extends AuthEvent {
  final ServicioPublico servicioPublico;

  const OnChangedServicioPublico(this.servicioPublico);
}

class OnCleanBlocAuth extends AuthEvent {
  const OnCleanBlocAuth();
}

class OnChangeStatusServicio extends AuthEvent {
  final StatusServicio statusServicio;
  const OnChangeStatusServicio(this.statusServicio);
}

class OnChangePerfil extends AuthEvent {
  final Perfil perfil;
  const OnChangePerfil(this.perfil);
}

class OnChangendServicioParking extends AuthEvent {
  final ServiciosSeleccionadosInfo servicioParking;
  const OnChangendServicioParking(this.servicioParking);
}
