import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'select_gender_state.dart';

class SelectGenderCubit extends Cubit<SelectGenderState> {
  SelectGenderCubit() : super(SelectGenderInitial());
  bool manIsActive = false;
  bool womanIsActive = false;
  bool buttonIsActive = false;
  var image = "";
  var tag = "";
  String gender = '';
  setManActive() {
    manIsActive = true;
    womanIsActive = false;
    buttonIsActive = true;
    gender = 'man';
    emit(UpdateGenderState());
  }

  setWomanActive() {
    manIsActive = false;
    womanIsActive = true;
    buttonIsActive = true;
    gender = 'woman';
    emit(UpdateGenderState());
  }
}
