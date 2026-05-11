import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../core/storage/local_cache.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color(0x00000000),
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFFFFFFFF),
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  await Hive.initFlutter();

  await Future.wait([
    Hive.openBox<String>(CacheBoxNames.positions),
    Hive.openBox<String>(CacheBoxNames.orders),
    Hive.openBox<String>(CacheBoxNames.notifications),
    Hive.openBox<String>(CacheBoxNames.misc),
  ]);
}
