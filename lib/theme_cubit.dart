import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<MaterialColor> {
  ThemeCubit() : super(defaultColor);

  static const MaterialColor defaultColor = Colors.blue;

  void updateTheme(MaterialColor materialColor) {
    emit(materialColor);
  }
}
