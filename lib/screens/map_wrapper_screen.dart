import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trash_collector/blocs/authentication/authentication_bloc.dart';
import 'package:trash_collector/models/user_model.dart';
import 'package:trash_collector/screens/bins/bins_map_screen.dart';
import 'package:trash_collector/screens/colllectors/collector_map_screen.dart';

class MapScreenWrapper extends StatelessWidget {
  const MapScreenWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return switch (context.read<AuthenticationBloc>().userModel!.accountType!) {
      AccountType.collector => const CollectorMapScreen(),
      AccountType.user => const BinMapScreen(),
      AccountType.admin => const BinMapScreen(),
    };
  }
}
