import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mega_plus/presentation/auth/signup/cubit/sign_up_cubit.dart';
import 'package:mega_plus/presentation/map/cubit/map_cubit.dart';
import 'core/style/app_themes.dart';
import 'presentation/start/splash_screen.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => MapCubit()),
        BlocProvider(create: (context) => SignUpCubit()),
      ],
      child: MaterialApp(
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: const TextScaler.linear(1.0)),
            child: child!,
          );
        },
        debugShowCheckedModeBanner: false,
        theme: AppThemes.lightTheme,
        themeMode: ThemeMode.light,
        locale: const Locale('en', ''),
        supportedLocales: const [Locale('en', '')],
        home: kDebugMode ? SplashScreen() : SplashScreen(),
      ),
    );
  }
}
