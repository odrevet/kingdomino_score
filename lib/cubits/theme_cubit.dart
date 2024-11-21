import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'game_cubit.dart';

class ThemeCubit extends Cubit<MaterialColor> {
  final GameCubit _gameCubit;

  ThemeCubit(this._gameCubit) : super(defaultColor) {
    // Listen to game state changes
    _gameCubit.stream.listen((gameState) {

      if (gameState.player != null) {
        emit(gameState.player!.color);
      }
    });
  }

  static const MaterialColor defaultColor = Colors.blue;

  void updateTheme(MaterialColor materialColor) {
    emit(materialColor);
  }

}