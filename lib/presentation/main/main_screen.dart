import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mega_plus/core/style/app_colors.dart';
import 'package:mega_plus/presentation/main/cubit/main_cubit.dart';

import '../history/history_screen.dart';
import '../map/map_screen.dart';
import '../profile/profile_screen.dart';
import '../wallet/wallet_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainCubit(),
      child: MainScreenUI(),
    );
  }
}

class MainScreenUI extends StatelessWidget {
  MainScreenUI({super.key});

  final List<Widget> screens = [
    const MapScreen(),
    const WalletScreen(),
    const Center(child: Text("Placeholder")),
    const HistoryScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<MainCubit, MainState>(
        builder: (context, state) {
          return screens[MainCubit.get(context).selectedIndex];
        },
      ),
      bottomNavigationBar: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          BlocBuilder<MainCubit, MainState>(
            builder: (context, state) {
              return Container(
                height: 120,
                alignment: AlignmentDirectional.bottomCenter,
                padding: const EdgeInsets.only(bottom: 20),
                child: BottomNavigationBar(
                  currentIndex: MainCubit.get(context).selectedIndex,
                  onTap: (index) {
                    if (index == 2) {
                      return;
                    }
                    MainCubit.get(context).changeIndex(index);
                  },
                  type: BottomNavigationBarType.fixed,
                  elevation: 0,
                  backgroundColor: Colors.white,
                  selectedItemColor: Colors.green,
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
                      icon: SizedBox(
                        width: 48,
                      ), // for spacing (main FAB overlaps)
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
              );
            },
          ),
          // Floating Center Button
          Positioned(
            top: 5,
            child: GestureDetector(
              onTap: () {},
              child: Container(
                height: 62,
                width: 62,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.3),
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
