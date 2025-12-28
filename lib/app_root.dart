import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mega_plus/core/services/charging_cubit/charging_cubit.dart';
import 'package:mega_plus/core/services/websocket_cubit/websocket_cubit.dart';
import 'package:mega_plus/core/services/websocket_service.dart';
import 'package:mega_plus/presentation/auth/signup/cubit/sign_up_cubit.dart';
import 'package:mega_plus/presentation/map/map_cubit/map_cubit.dart';
import 'package:mega_plus/presentation/map/search_cubit/search_cubit.dart';
import 'package:mega_plus/presentation/map/station_details_cubit/station_details_cubit.dart';
import 'package:mega_plus/presentation/profile/cubit/profile_cubit.dart';
import 'package:mega_plus/presentation/vehicles/cubit/vehicles_cubit.dart';
import 'package:mega_plus/presentation/wallet/cubit/wallet_cubit.dart';
import 'core/style/app_themes.dart';
import 'presentation/start/splash_screen.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SearchCubit()),
        BlocProvider(create: (context) => MapCubit()),
        BlocProvider(create: (context) => SignUpCubit()),
        BlocProvider(create: (context) => ProfileCubit()),
        BlocProvider(create: (context) => VehiclesCubit()),
        BlocProvider(create: (context) => WalletCubit()),
        BlocProvider(create: (context) => ChargingCubit()),
        BlocProvider(create: (context) => StationDetailsCubit()),
        BlocProvider(create: (context) => WebSocketCubit(WebSocketService())),
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
