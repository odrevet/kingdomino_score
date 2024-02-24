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

import '../models/land.dart' show LandType, getColorForLandType;

class ScorePie extends StatelessWidget {
  const ScorePie({super.key});

  @override
  Widget build(BuildContext context) {
    var properties = context.read<KingdomCubit>().state.getProperties();
    var landScore = <LandType, double>{};

    // Summing up scores by land type
    for (var property in properties) {
      double propertyScore =
          (property.landCount * property.crownCount).toDouble();
      if (propertyScore > 0) {
        if (landScore.containsKey(property.landType)) {
          // If land type already exists in the map, add the score to its existing value
          landScore[property.landType!] =
              (landScore[property.landType!]! + propertyScore);
        } else {
          // If land type doesn't exist in the map, initialize it with the score
          landScore[property.landType!] = propertyScore;
        }
      }
    }

    Map<String, double> dataMap = {};

    landScore.forEach((key, value) {
      dataMap[key.toString()] = value;
    });

    return PieChart(
      chartRadius: MediaQuery.of(context).size.width / 5.5,
      colorList: landScore.isEmpty
          ? [Colors.transparent]
          : landScore.keys
              .map((landType) => getColorForLandType(landType))
              .toList(),
      dataMap: dataMap.isEmpty ? {'': 0} : dataMap,
      emptyColor: Colors.transparent,
      baseChartColor: Colors.transparent,
      legendOptions: const LegendOptions(showLegends: false),
        chartValuesOptions: const ChartValuesOptions(
        )
    );
  }
}
