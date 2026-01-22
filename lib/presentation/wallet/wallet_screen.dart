import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mega_plus/core/helpers/addons_functions.dart';
import 'package:mega_plus/core/style/app_colors.dart';
import 'package:mega_plus/core/widgets/shimmer_widget.dart';
import 'package:mega_plus/presentation/wallet/cubit/wallet_cubit.dart';
import 'package:mega_plus/presentation/wallet/manage_cards_screen.dart';
import 'package:mega_plus/presentation/wallet/top_up_screen.dart';

import '../../core/helpers/cache/cache_helper.dart';

class WalletScreen extends StatelessWidget {
  WalletScreen({super.key});

  final Color green = Color(0xFF19C37D);
  final Color bgGreen = Color(0xFFECFDF3);

  @override
  Widget build(BuildContext context) {

    WalletCubit.get(context).getWallet();

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            WalletCubit.get(context).getWallet();
            // Wait a bit to allow the API call to complete
            await Future.delayed(Duration(milliseconds: 500));
          },
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 16),
            physics: AlwaysScrollableScrollPhysics(),
            children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              width: double.infinity,
              height: 57,
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xffF2F4F8))),
                color: Colors.white,
              ),
              child: Center(
                child: Text(
                  "Wallet",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff212121),
                  ),
                ),
              ),
            ),
            // Wallet card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/credit_card_bg.png"),
                        fit: BoxFit.fill,
                      ),
                      borderRadius: BorderRadius.circular(26),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: BlocBuilder<WalletCubit, WalletState>(
                      builder: (context, state) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text(
                          "Hello, ${CacheHelper.getUserData()?.user?.fullName ?? ''}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 21,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "Available Balance""",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.0,
                          ),
                        ),
                        SizedBox(height: 7),
                        Text(
                          "${WalletCubit.get(context).currency ?? ""} ${WalletCubit.get(context).balance ?? ""}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 34,
                            color: Colors.black,
                            letterSpacing: 1,
                          ),
                        ),
                        SizedBox(height: 6),
                        // Top Up button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 22,
                            ),
                            label: Text(
                              'Add Credit',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              minimumSize: Size(0, 46),
                              padding: EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(11),
                              ),
                            ),
                            onPressed: () {
                              context.goTo(TopUpScreen());
                            },
                          ),
                        ),
                        SizedBox(height: 7),
                        // Add Card button
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white.withOpacity(0.8),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(11),
                            color: Colors.white.withOpacity(0.12),
                            
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(11),
                              onTap: () {
                                context.goTo(ManageCardsScreen());
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icons/add_card.svg",
                                      width: 22,
                                      height: 22,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      "Manage Cards",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        

                        // Manage Cards button
                        // Container(
                        //   width: double.infinity,
                        //   decoration: BoxDecoration(
                        //     border: Border.all(
                        //       color: Colors.white.withOpacity(0.8),
                        //       width: 2,
                        //     ),
                        //     borderRadius: BorderRadius.circular(11),
                        //     color: Colors.white.withOpacity(0.12),
                        //   ),
                        //   child: Material(
                        //     color: Colors.transparent,
                        //     child: InkWell(
                        //       borderRadius: BorderRadius.circular(11),
                        //       onTap: () {
                        //         context.goTo(ManageCardsScreen());
                        //       },
                        //       child: Padding(
                        //         padding: EdgeInsets.symmetric(vertical: 15),
                        //         child: Center(
                        //           child: Text(
                        //             "Manage Cards",
                        //             style: TextStyle(
                        //               fontSize: 18,
                        //               fontWeight: FontWeight.w600,
                        //               color: Colors.black,
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                          ],
                        );
                      },
                    ),
                  ),
                  // Logo in top-right corner
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Opacity(
                        opacity: 0.4,
                        child: ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            const Color(0xFF07C355),
                            BlendMode.srcIn,
                          ),
                          child: Image.asset(
                            "assets/icons/ic_charge.png",
                            width: 50,
                            height: 50,            
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 21.0),
              child: Text(
                "Transactions",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 12),

            // Transactions list
            BlocBuilder<WalletCubit, WalletState>(
              builder: (context, state) {
                if (state is LoadingGetTransactionsWalletState) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 11,
                          vertical: 7,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Color(0xFFE6E7EF),
                              width: 1,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 17,
                            vertical: 19,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ShimmerWidget(
                                width: 40,
                                height: 40,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ShimmerWidget(
                                      width: double.infinity,
                                      height: 18,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    SizedBox(height: 8),
                                    ShimmerWidget(
                                      width: 120,
                                      height: 14,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 8),
                              ShimmerWidget(
                                width: 80,
                                height: 20,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final item = WalletCubit.get(context).transactions[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 7,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Color(0xFFE6E7EF),
                            width: 1,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 17,
                          vertical: 19,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset("assets/icons/charger.svg"),
                            SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Credit Added",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    "${item.createdAt}",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 10),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "${item.amount} ${item.currency}",
                                style: TextStyle(
                                  color: Color(0xFF52996D),
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: WalletCubit.get(context).transactions.length,
                );
              },
            ),
          ],
          ),
        ),
      ),
    );
  }
}
