part of 'permissions_bloc.dart';

class PermissionsEvent extends Equatable {
  const PermissionsEvent();

  @override
  List<Object> get props => [];
}

class GpsAndPermissionEvent extends PermissionsEvent {
  final bool isGpsEnabled;
  final bool isPermissionGranted;

  const GpsAndPermissionEvent(
      {required this.isGpsEnabled, required this.isPermissionGranted});
}

// READ : EVENTOS NOTIFICACIONE

class OnChangePermissionNotifi extends PermissionsEvent {
  final AuthorizationStatus status;

  const OnChangePermissionNotifi(this.status);
}

class OnAddNotifi extends PermissionsEvent {
  final PushMessage notifi;

  const OnAddNotifi(this.notifi);
}

class OnNotificationReceived extends PermissionsEvent {
  final PushMessage notifi;

  const OnNotificationReceived(this.notifi);
}
