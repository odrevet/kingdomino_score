import '../kingdom.dart';
import '../land.dart' show LandType;
import 'quest.dart';

class FourCorners extends Quest {
  static final FourCorners _singleton = FourCorners._internal();

  factory FourCorners(LandType landType) {
    _singleton.landType = landType;
    return _singleton;
  }

  FourCorners._internal() : super(reward: 5);

  LandType? landType;

  @override
  List<(int, int)> getPlaces(Kingdom kingdom) {
    final last = kingdom.kingdomSize.size - 1;
    return [
      for (final corner in [(0, 0), (last, 0), (0, last), (last, last)])
        if (kingdom.getLand(corner.$1, corner.$2)?.landType == landType) corner,
    ];
  }
}
