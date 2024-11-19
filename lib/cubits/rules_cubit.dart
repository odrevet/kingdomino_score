import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/rules.dart';

class RulesCubit extends Cubit<Rules> {
  RulesCubit() : super(Rules());

  void reset() => emit(Rules());
}
