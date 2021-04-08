import 'kingdom.dart' show LandType;

class Warning {
  int leftOperand;
  LandType landType;
  int crown;
  String operator;
  int rightOperand;

  Warning(this.leftOperand, this.landType, this.crown, this.operator,
      this.rightOperand);
}
