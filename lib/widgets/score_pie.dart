import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kingdomino_score_count/cubits/kingdom_cubit.dart';
import 'package:kingdomino_score_count/cubits/score_cubit.dart';
import 'package:kingdomino_score_count/cubits/theme_cubit.dart';
import 'package:kingdomino_score_count/models/extensions/lacour/lacour.dart';
import 'package:kingdomino_score_count/widgets/kingdomino_app_bar.dart';
import 'package:kingdomino_score_count/widgets/warning_widget.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

import '../models/land.dart' show getColorForLandType;

class ScorePie extends StatelessWidget {
  const ScorePie({super.key});

  @override
  Widget build(BuildContext context) {
    var properties = context.read<KingdomCubit>().state.getProperties();


    var data = <String, double>{};
    var colors = <Color>[];

    for (int index = 0; index < properties.length; index++) {
      data[index.toString()] =
          (properties[index].crownCount * properties[index].landCount)
              .toDouble();
      colors.add(getColorForLandType(properties[index].landType));
    }

    return PieChart(
      chartRadius: MediaQuery.of(context).size.width / 5.5,
      colorList: colors.isEmpty ? [Colors.transparent] : colors.toList(),
      dataMap: data.isEmpty ? {'': 0} : data,
      emptyColor: Colors.transparent,
      baseChartColor: Colors.transparent,
      legendOptions: const LegendOptions(showLegends: false),
    );
  }
}
