import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mega_plus/app_root.dart';
import 'package:mega_plus/core/helpers/cache/cache_helper.dart';
import 'package:mega_plus/core/helpers/network/dio_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Future.wait([
    CacheHelper.init(),
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
  ]);

  DioHelper.init();
  runApp(const AppRoot());
}
