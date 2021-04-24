import 'land.dart' show LandType;

class Property {
  LandType? landType;
  int crownCount = 0;
  int landCount = 0;
  int giantCount = 0; //AoG

  Property(this.landType);
}