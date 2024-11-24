import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kingdomino_score_count/cubits/kingdom_cubit.dart';
import 'package:kingdomino_score_count/widgets/kingdomino_app_bar.dart';
import 'package:kingdomino_score_count/widgets/score/score_widget.dart';
import 'package:kingdomino_score_count/widgets/warning_widget.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../cubits/game_cubit.dart';
import '../models/extensions/extension.dart';
import '../models/game.dart';
import '../models/kingdom.dart';
import 'kingdom_widget.dart';
import 'tile/tile_bar.dart';

const String crown = '\u{1F451}';
const String castle = '\u{1F3F0}';
const String square = '\u{25A0}';

class KingdominoWidget extends StatefulWidget {
  const KingdominoWidget({
    super.key,
  });

  @override
  State<KingdominoWidget> createState() => _KingdominoWidgetState();
}

class _KingdominoWidgetState extends State<KingdominoWidget> {
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
  );

  _KingdominoWidgetState();

  @override
  initState() {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      _packageInfo = packageInfo;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
        listeners: [
          BlocListener<KingdomCubit, Kingdom>(listener: (context, kingdom) {
            context.read<GameCubit>().calculateScore(kingdom);
          })
        ],
        child: BlocBuilder<GameCubit, Game>(builder: (context, game) {
          return BlocBuilder<KingdomCubit, Kingdom>(
              builder: (context, kingdom) {
            return Scaffold(
                appBar: KingdominoAppBar(packageInfo: _packageInfo),
                floatingActionButton: game.warnings.isEmpty
                    ? null
                    : FloatingActionButton(
                        child: Badge(
                            label: Text(game.warnings.length.toString()),
                            child: const Icon(Icons.warning)),
                        onPressed: () {
                          showDialog<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: WarningsWidget(),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Icon(
                                      Icons.done,
                                      color: Colors.black87,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }),
                body: OrientationBuilder(
                    builder: (orientationBuilderContext, orientation) {
                  if (orientation == Orientation.portrait) {
                    return Column(children: <Widget>[
                      // ignore: prefer_const_constructors
                      Expanded(
                        flex: 4,
                        // ignore: prefer_const_constructors
                        child: ScoreWidget(),
                      ),
                      Expanded(
                        flex: 5,
                        child: KingdomWidget(
                          kingdom: kingdom,
                        ),
                      ),
                      TileBar(
                        extension: game.extension,
                        verticalAlign: false,
                      ),
                    ]);
                  } else {
                    return Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          // ignore: prefer_const_constructors
                          Expanded(
                            child: ScoreWidget(),
                          ),
                          KingdomWidget(
                            kingdom: kingdom,
                          ),
                          TileBar(
                            extension: game.extension ?? Extension.vanilla,
                            verticalAlign: true,
                          )
                        ]);
                  }
                }));
          });
        }));
  }
}
