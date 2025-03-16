import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/app/app.dart';
import 'package:todo_list/app/app_runner.dart';
import 'package:todo_list/app/di.dart';

void main() async {
  await runZonedGuarded(() async {
    final appContainers = AppDependencyContainers();
    await appContainers.initialize();
    runApp(
      AppRunner(
        containers: appContainers,
        child: const App(),
      ),
    );
  }, (error, stackTrace) {
    if (kDebugMode) {
      print('Error: $error');
      print('Stacktrace: $stackTrace');
    }
  });
}
