import 'package:flutter_bloc/flutter_bloc.dart';

class DomainsModeCubit extends Cubit<bool> {
  DomainsModeCubit() : super(false);

  void toggle() => emit(!state);
}

final domainsModeCubit = DomainsModeCubit();