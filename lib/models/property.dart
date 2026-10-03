import 'land.dart';

class Property {
  LandType? landType;
  int crownCount = 0;
  int landCount = 0;
  int giantCount = 0;
  final List<(int, int)> cells = [];

  Property(this.landType);
}
