import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sw1final_official/config/constant/data.const.dart';
import 'package:sw1final_official/features/home/presentation/screens/detalels-parking.screen.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthState()) {
    on<OnChangedViewInfo>((event, emit) {
      emit(state.copyWith(viewWindowInfo: !state.viewWindowInfo));
    });

    on<OnChangedServicioPublico>((event, emit) {
      emit(state.copyWith(servicioPublico: event.servicioPublico));
    });

    on<OnCleanBlocAuth>((event, emit) {
      emit(state.copyWith(
        viewWindowInfo: false,
      ));
    });

    on<OnChangeStatusServicio>((event, emit) {
      emit(state.copyWith(statusServicio: event.statusServicio));
    });

    on<OnChangePerfil>((event, emit) {
      emit(state.copyWith(perfil: event.perfil));
    });

    on<OnChangendServicioParking>((event, emit) {
      emit(state.copyWith(servicioParking: event.servicioParking));
    });
  }
}
