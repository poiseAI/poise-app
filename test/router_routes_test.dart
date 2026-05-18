import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('route constants are registered by app router', () {
    final routesSource = File('lib/core/router/routes.dart').readAsStringSync();
    final routerSource =
        File('lib/core/router/app_router.dart').readAsStringSync();

    final constants = <String, String>{
      for (final match in RegExp(
        r"static const (\w+) = '([^']+)';",
      ).allMatches(routesSource))
        match.group(1)!: match.group(2)!,
    };
    final registeredRouteNames = RegExp(
      r'path:\s*Routes\.(\w+)',
    ).allMatches(routerSource).map((match) => match.group(1)!).toSet();
    final registeredPaths = {
      for (final name in registeredRouteNames) constants[name],
    };

    for (final name in registeredRouteNames) {
      expect(
        constants,
        contains(name),
        reason: 'GoRouter references Routes.$name but it is not defined.',
      );
    }

    for (final entry in constants.entries) {
      final name = entry.key;
      final path = entry.value;
      final queryIndex = path.indexOf('?');
      final basePath = queryIndex == -1 ? path : path.substring(0, queryIndex);

      expect(
        registeredRouteNames.contains(name) ||
            (queryIndex != -1 && registeredPaths.contains(basePath)),
        isTrue,
        reason: 'Routes.$name ($path) is not registered by GoRouter.',
      );
    }
  });
}
