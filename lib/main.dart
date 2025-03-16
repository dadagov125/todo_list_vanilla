import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/app/app.dart';
import 'package:todo_list/app/app_runner.dart';

void main() async {
  await runZonedGuarded(() async {
    runApp(
      const AppRunner(
        child: App(),
      ),
    );
  }, (error, stackTrace) {
    if (kDebugMode) {
      print('Error: $error');
      print('Stacktrace: $stackTrace');
    }
  });
}
