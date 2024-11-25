import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kingdomino_score_count/cubits/game_cubit.dart';
import 'package:kingdomino_score_count/cubits/kingdom_cubit.dart';
import 'package:pie_chart/pie_chart.dart';

import '../../models/land.dart' show LandType, getColorForLandType;

class ScorePie extends StatelessWidget {
  const ScorePie({super.key});

  @override
  Widget build(BuildContext context) {
    var properties = getKingdomCubit(context, context.read<GameCubit>().state.kingColor!).state.getProperties();
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
      chartRadius: MediaQuery.of(context).size.width / 3.2,
      animationDuration: const Duration(milliseconds: 200),
      colorList: landScore.isEmpty
          ? [Colors.transparent.withOpacity(0.5)]
          : landScore.keys
              .map((landType) => getColorForLandType(landType))
              .toList(),
      dataMap: dataMap.isEmpty ? {'': 0} : dataMap,
      emptyColor: Colors.transparent.withOpacity(0.5),
      baseChartColor: Colors.transparent.withOpacity(0.5),
      centerWidget: Container(
        color: Colors.white.withOpacity(0.5),
        child: Text(
          context.read<GameCubit>().state.score.total.toString(),
          style: const TextStyle(color: Colors.black),
        ),
      ),
      legendOptions: const LegendOptions(showLegends: false),
      chartValuesOptions: const ChartValuesOptions(
        decimalPlaces: 0,
        showChartValueBackground: true,
        showChartValues: true,
        showChartValuesInPercentage: false,
        showChartValuesOutside: false,
      ),
    );
  }
}
