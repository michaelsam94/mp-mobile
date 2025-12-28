import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mega_plus/core/helpers/addons_functions.dart';
import 'package:mega_plus/core/style/app_colors.dart';
import 'package:mega_plus/presentation/history/history_screen.dart';
import 'package:mega_plus/presentation/profile/cubit/profile_cubit.dart';
import 'package:mega_plus/presentation/profile/profile_screen.dart';
import 'package:mega_plus/presentation/wallet/wallet_screen.dart';

import '../../core/helpers/cache/cache_helper.dart';
import '../../core/services/websocket_cubit/websocket_cubit.dart';
import '../map/map_screen.dart';
import '../map/qr_code_scanner_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (CacheHelper.checkLogin() != 1) {
      context.read<WebSocketCubit>().connect();
      context.read<ProfileCubit>().getRFID();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: MapScreen(),
      bottomNavigationBar: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: 120,
            alignment: AlignmentDirectional.bottomCenter,
            padding: const EdgeInsets.only(bottom: 20),
            child: BottomNavigationBar(
              currentIndex: 0,
              onTap: (index) {
                if (CacheHelper.checkLogin() != 1) {
                  switch (index) {
                    case 1:
                      context.goTo(WalletScreen());
                    case 3:
                      context.goTo(HistoryScreen());
                    case 4:
                      context.goTo(ProfileScreen());
                  }
                  if (index == 2) {
                    return;
                  }
                } else {
                  context.showErrorMessage("Please login first");
                }
              },
              type: BottomNavigationBarType.fixed,
              elevation: 0,
              backgroundColor: Colors.white,
              selectedItemColor: AppColors.primary,
              unselectedItemColor: const Color(0xffB6B6B6),
              showSelectedLabels: true,
              showUnselectedLabels: true,
              items: [
                BottomNavigationBarItem(
                  icon: SvgPicture.asset("assets/icons/map_nav.svg"),
                  label: "Map",
                  activeIcon: SvgPicture.asset(
                    "assets/icons/map_nav.svg",
                    colorFilter: ColorFilter.mode(
                      AppColors.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset("assets/icons/wallet_nav.svg"),
                  label: "Wallet",
                  activeIcon: SvgPicture.asset(
                    "assets/icons/wallet_nav.svg",
                    colorFilter: ColorFilter.mode(
                      AppColors.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: SizedBox(width: 48), // for spacing (main FAB overlaps)
                  label: "",
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset("assets/icons/history_nav.svg"),
                  label: "History",
                  activeIcon: SvgPicture.asset(
                    "assets/icons/history_nav.svg",
                    colorFilter: ColorFilter.mode(
                      AppColors.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset("assets/icons/profile_nav.svg"),
                  label: "Profile",
                  activeIcon: SvgPicture.asset(
                    "assets/icons/profile_nav.svg",
                    colorFilter: ColorFilter.mode(
                      AppColors.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            top: 5,
            child: GestureDetector(
              onTap: () {
                if (CacheHelper.checkLogin() != 1) {
                  context.goTo(QrCodeScannerScreen());
                } else {
                  context.showErrorMessage("Please login first");
                }
              },
              child: Container(
                height: 62,
                width: 62,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 16,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.flash_on,
                  color: Colors.white,
                  size: 36,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:mega_plus/core/services/charging_cubit/charging_cubit.dart';
// import 'package:mega_plus/core/services/websocket_cubit/websocket_cubit.dart';

// class MainScreen extends StatelessWidget {
//   const MainScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     context.read<WebSocketCubit>().connect();

//     int? transactionId;

//     return Scaffold(
//       body: BlocConsumer<ChargingCubit, ChargingState>(
//         listener: (context, state) {
          // if (state is ChargingSuccess) {
          //   print(state.data);
          // } else if (state is ChargingError) {
          //   print(state.message);
          // }
//         },
//         builder: (context, state) {
//           return BlocConsumer<WebSocketCubit, WebSocketState>(
//             listener: (context, state) {
//               print(state);
              // if (state is SessionUpdate) {
              //   if (state.data.event != "session_stopped") {
              //     transactionId = state.data.transactionId;
              //   }
              // }
//             },
//             builder: (context, state) {
//               return Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     ElevatedButton(
//                       onPressed: () async {
//                         ChargingCubit.get(
//                           context,
//                         ).startCharging("minus", 60, "CF60186600");
//                       },
//                       child: Text("Start"),
//                     ),
//                     ElevatedButton(
//                       onPressed: () {
//                         ChargingCubit.get(
//                           context,
//                         ).stopCharging("minus", transactionId!);
//                       },
//                       child: Text("Stop"),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
