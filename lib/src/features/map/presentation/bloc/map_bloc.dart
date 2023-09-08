import 'package:bloc/bloc.dart';
import 'package:travel_point/src/features/map/domain/usecase/get_user_current_location.dart';
import 'package:travel_point/src/features/map/presentation/bloc/map_event.dart';
import 'package:travel_point/src/features/map/presentation/bloc/map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final GetUserCurrentLocationUsecase _getUserCurrentLocationUsecase;

  MapBloc(this._getUserCurrentLocationUsecase)
      : super(const InitialMapState()) {
    on<GetCurrentLocationEvent>(_getUserCurrentLocationHandler);
  }

  Future<void> _getUserCurrentLocationHandler(
      GetCurrentLocationEvent event, Emitter<MapState> emitter) async {
    emit(const LoadingMapState());

    final result = await _getUserCurrentLocationUsecase();

    result.fold(
      (failure) => emit(ErrorMapState(failure.errorMessage, failure.errorCode)),
      (position) => emit(ResultMapState(position)),
    );
  }
}
