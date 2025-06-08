import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'select_truck_state.dart';

class SelectTruckCubit extends Cubit<SelectTruckState> {
  SelectTruckCubit() : super(SelectTruckInitial());
}
