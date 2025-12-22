import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mega_plus/app_root.dart';
import 'package:mega_plus/core/helpers/cache/cache_helper.dart';
import 'package:mega_plus/core/helpers/network/dio_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Future.wait([
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
    CacheHelper.init(),
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
  ]);

  DioHelper.init();
  runApp(const AppRoot());
}
