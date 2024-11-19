import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/user_selection.dart';

class UserSelectionCubit extends Cubit<UserSelection> {
  UserSelectionCubit() : super(UserSelection());

  void reset() => emit(UserSelection());
}
