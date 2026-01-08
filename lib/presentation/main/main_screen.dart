import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mega_plus/core/helpers/addons_functions.dart';
import 'package:mega_plus/core/helpers/cache/cache_helper.dart';
import 'package:mega_plus/core/style/app_colors.dart';
import 'package:mega_plus/presentation/auth/guest_bottom_sheet.dart';
import 'package:mega_plus/presentation/history/history_screen.dart';
import 'package:mega_plus/presentation/profile/cubit/profile_cubit.dart';
import 'package:mega_plus/presentation/profile/profile_screen.dart';
import 'package:mega_plus/presentation/wallet/wallet_screen.dart';

import '../../core/services/websocket_cubit/websocket_cubit.dart';
import '../map/map_screen.dart';
import '../vehicles/cubit/vehicles_cubit.dart';
import '../vehicles/current_vehicle_charging_screen.dart';
import '../vehicles/my_vehicles_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    MapScreen(),
    WalletScreen(),
    const SizedBox(), // Placeholder for center button
    HistoryScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    context.read<WebSocketCubit>().connect();
    context.read<ProfileCubit>().getRFID();
    // Load vehicles to check if user has any
    context.read<VehiclesCubit>().getVehicles();
  }

  void _handleChargeButtonTap(BuildContext context) {
    // Check if user is logged in
    if (CacheHelper.checkLogin() != 3) {
      GuestBottomSheet.show(context);
      return;
    }

    // Check if user has vehicles
    final vehiclesCubit = VehiclesCubit.get(context);

    // Check vehicles list - if empty, show message and navigate to vehicles screen
    if (vehiclesCubit.vehicles.isEmpty) {
      context.showErrorMessage("Please add vehicle");
      context.goTo(MyVehiclesScreen());
      return;
    }

    // User has vehicles, proceed to current vehicle charging screen
    context.goTo(CurrentVehicleChargingScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: _currentIndex == 2 ? 0 : _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.none,
          children: [
            Container(
              height: 70,
              alignment: AlignmentDirectional.bottomCenter,
              padding: const EdgeInsets.only(bottom: 10),
              child: ClipRect(
                child: BottomNavigationBar(
                currentIndex: _currentIndex,
                onTap: (index) {
                  if (index == 2) {
                    _handleChargeButtonTap(context);
                    return;
                  }

                  // Check if user is logged in for other tabs (except map which is index 0)
                  if (index != 0 && CacheHelper.checkLogin() != 3) {
                    GuestBottomSheet.show(context);
                    return;
                  }

                  setState(() {
                    _currentIndex = index;
                  });
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
            ),

            Positioned(
              top: -30,
              child: GestureDetector(
                onTap: () {
                  _handleChargeButtonTap(context);
                },
                child: Image.asset(
                  "assets/icons/ic_charge_middle.png",
                  width: 80,
                  height: 80,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ],
        ),
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
