part of 'map_cubit.dart';

@immutable
abstract class MapState {}

class MapInitial extends MapState {}

class GetDriversLoadingState extends MapState {}

class GetDriversSuccessState extends MapState {}

class GetDriversErrorState extends MapState {
  final String error;
  GetDriversErrorState(this.error);
}

class UpdateMapMarkersState extends MapState {
  final List<Marker> markers;

  UpdateMapMarkersState(this.markers);
}


class CancelTripLoadingState extends MapState {}
class CancelTripSuccessState extends MapState {}
class CancelTripErrorState extends MapState {
  final String error;
  CancelTripErrorState(this.error);
}

class LocationPermissionDeniedState extends MapState {}