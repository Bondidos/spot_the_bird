import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';

part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit() : super(const LocationInitial());

  Future<void> getLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        emit(const LocationError());
      }
      if (permission == LocationPermission.deniedForever) {
        emit(const LocationError());
      }
    }
      emit(const LocationLoading());

      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        emit(LocationLoaded(position.latitude, position.longitude));
      } catch (error) {
        print(error);
        emit(const LocationError());
      }
    }
    // get latlng

}
