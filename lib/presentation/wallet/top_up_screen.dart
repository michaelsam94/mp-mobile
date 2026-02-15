import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mega_plus/core/helpers/addons_functions.dart';
import 'package:mega_plus/core/style/app_colors.dart';
import 'package:mega_plus/presentation/wallet/cubit/wallet_cubit.dart';
import 'package:mega_plus/presentation/wallet/pay_url_screen.dart';
// import 'package:mega_plus/core/style/app_colors.dart'; // Replace with your color system

class TopUpScreen extends StatefulWidget {
  const TopUpScreen({super.key});

  @override
  State<TopUpScreen> createState() => _TopUpScreenState();
}

class _TopUpScreenState extends State<TopUpScreen> {
  final Color green = Color(0xFF07C355);
  final Color bgGreen = Color(0xFFE6F9EE);
  int selectedAmount = 50;
  List<int> amounts = [50, 100, 150, 200];
  final TextEditingController _customAmount = TextEditingController();
  String? selectedCardToken; // null means "New Card"

  @override
  void initState() {
    super.initState();
    // Load saved cards when screen opens
    WalletCubit.get(context).getSavedCards();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 8),
          children: [
            // AppBar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              width: double.infinity,
              height: 57,
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xffF2F4F8))),
                color: Colors.white,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: SvgPicture.asset("assets/icons/back.svg"),
                    ),
                  ),
                  Center(
                    child: Text(
                      "Top-up Balance",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Color(0xff212121),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),

            // Amount selection
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 2,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Color(0xFFE9E9E9)),
                ),
                padding: EdgeInsets.symmetric(vertical: 22, horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Select Amount",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 18),
                    Wrap(
                      spacing: 13,
                      runSpacing: 13,
                      children: amounts.map((amount) {
                        bool isSelected = amount == selectedAmount;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedAmount = amount;
                              _customAmount.clear();
                            });
                          },
                          child: Container(
                            width: context.width() * .4,
                            height: 62,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSelected ? bgGreen : Colors.white,
                              border: Border.all(
                                color: isSelected ? green : Color(0xFFE9E9E9),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Text(
                              '$amount EGP',
                              style: TextStyle(
                                color: isSelected ? green : Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 17),

            // Custom Amount
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 2,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Color(0xFFE9E9E9)),
                ),
                padding: EdgeInsets.symmetric(vertical: 18, horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Custom Amount",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 13),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFFE9E9E9)),
                        borderRadius: BorderRadius.circular(13),
                        color: Color(0xffFAFAFA),
                      ),
                      child: TextField(
                        controller: _customAmount,
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        onChanged: (val) {
                          setState(() {
                            if (val.isNotEmpty) {
                              selectedAmount =
                                  int.tryParse(val) ?? selectedAmount;
                            }
                          });
                        },
                        decoration: InputDecoration(
                          hintText: "Enter amount",
                          border: InputBorder.none,
                          // suffixIcon: Container(
                          //   margin: EdgeInsets.only(right: 8),
                          //   child: SvgPicture.asset(
                          //     "assets/icons/arrow_down.svg",
                          //     height: 24,
                          //     width: 24,
                          //   ),
                          // ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        ),
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // SizedBox(height: 17),

            // // Payment card select
            // Padding(
            //   padding: const EdgeInsets.symmetric(
            //     horizontal: 12.0,
            //     vertical: 2,
            //   ),
            //   child: Container(
            //     decoration: BoxDecoration(
            //       color: Colors.white,
            //       borderRadius: BorderRadius.circular(18),
            //       border: Border.all(color: Color(0xFFE9E9E9)),
            //     ),
            //     padding: EdgeInsets.symmetric(vertical: 18, horizontal: 15),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Text(
            //           "Select Payment Card",
            //           style: TextStyle(
            //             fontWeight: FontWeight.bold,
            //             fontSize: 22,
            //             color: Colors.black,
            //           ),
            //         ),
            //         SizedBox(height: 16),
            //         Container(
            //           decoration: BoxDecoration(
            //             color: bgGreen,
            //             border: Border.all(color: green, width: 2),
            //             borderRadius: BorderRadius.circular(24),
            //           ),
            //           padding: EdgeInsets.symmetric(
            //             vertical: 18,
            //             horizontal: 20,
            //           ),
            //           child: Row(
            //             children: [
            //               Column(
            //                 crossAxisAlignment: CrossAxisAlignment.start,
            //                 children: [
            //                   Text(
            //                     'Visa',
            //                     style: TextStyle(
            //                       color: AppColors.primary,
            //                       fontSize: 16,
            //                       fontWeight: FontWeight.w700,
            //                     ),
            //                   ),
            //                   SizedBox(height: 6),
            //                   Text(
            //                     '****  8831   ****   2367',
            //                     style: TextStyle(
            //                       color: AppColors.primary,
            //                       fontSize: 14,
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //               Spacer(),
            //               Column(
            //                 mainAxisAlignment: MainAxisAlignment.center,
            //                 children: [
            //                   Image.asset("assets/icons/card_type_icon.png"),
            //                   SizedBox(height: 5),
            //                   Text(
            //                     '08/26',
            //                     style: TextStyle(
            //                       color: AppColors.primary,
            //                       fontWeight: FontWeight.bold,
            //                       fontSize: 14,
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //             ],
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            SizedBox(height: 17),

            // Payment card select
            BlocBuilder<WalletCubit, WalletState>(
              builder: (context, state) {
                final savedCards = WalletCubit.get(context).savedCards;

                // Only show if there are saved cards
                if (savedCards.isEmpty) {
                  return SizedBox.shrink();
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 2,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Color(0xFFE9E9E9)),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 18, horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Select Payment Method",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 16),

                        // New Card option
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedCardToken = null;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: selectedCardToken == null
                                  ? bgGreen
                                  : Colors.white,
                              border: Border.all(
                                color: selectedCardToken == null
                                    ? green
                                    : Color(0xFFE9E9E9),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: 18,
                              horizontal: 20,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.add_card,
                                  color: selectedCardToken == null
                                      ? green
                                      : Colors.grey,
                                ),
                                SizedBox(width: 12),
                                Text(
                                  'New Card',
                                  style: TextStyle(
                                    color: selectedCardToken == null
                                        ? green
                                        : Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 12),

                        // Saved cards
                        ...savedCards.map((card) {
                          bool isSelected = selectedCardToken == card.token;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedCardToken = card.token;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isSelected ? bgGreen : Colors.white,
                                  border: Border.all(
                                    color: isSelected
                                        ? green
                                        : Color(0xFFE9E9E9),
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                padding: EdgeInsets.symmetric(
                                  vertical: 18,
                                  horizontal: 20,
                                ),
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          card.cardType ?? 'Card',
                                          style: TextStyle(
                                            color: isSelected
                                                ? green
                                                : Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        SizedBox(height: 6),
                                        Text(
                                          card.maskedPan ?? '****',
                                          style: TextStyle(
                                            color: isSelected
                                                ? green
                                                : Colors.grey[700],
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    if (card.isDefault == 1)
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: green.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          'Default',
                                          style: TextStyle(
                                            color: green,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                );
              },
            ),

            SizedBox(height: 40),
            // Submit button
            BlocConsumer<WalletCubit, WalletState>(
              listener: (context, state) async {
                if (state is SuccessPayWalletState) {
                  await context.goTo(
                    PayWithUrlScreen(
                      checkoutUrl: WalletCubit.get(context).payUrl ?? "",
                    ),
                  );
                  // Refresh balance and go back to wallet screen
                  WalletCubit.get(context).getWallet();
                  Navigator.pop(context);
                } else if (state is SuccessPayWithSavedCardRedirectState) {
                  // Payment requires 3DS - open redirection URL
                  await context.goTo(
                    PayWithUrlScreen(
                      checkoutUrl: WalletCubit.get(context).redirectionUrl ?? "",
                    ),
                  );
                  // Refresh balance and go back to wallet screen
                  WalletCubit.get(context).getWallet();
                  Navigator.pop(context);
                } else if (state is SuccessPayWithSavedCardState) {
                  // Payment with saved card successful (no redirect needed)
                  context.showSuccessMessage("Payment successful!");
                  // Refresh balance and go back to wallet screen
                  WalletCubit.get(context).getWallet();
                  Navigator.pop(context);
                } else if (state is ErrorPayWithSavedCardState) {
                  // Payment with saved card failed
                  context.showErrorMessage(state.message);
                }
              },
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: ElevatedButton(
                      onPressed: () {
                        // If a saved card is selected, use it
                        if (selectedCardToken != null) {
                          WalletCubit.get(context).payWithSavedCard(
                            selectedAmount,
                            selectedCardToken!,
                          );
                        } else {
                          // Otherwise, use new card (iframe)
                          WalletCubit.get(context).getPayUrl(selectedAmount);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child:
                          state is LoadingPayWalletState ||
                              state is LoadingPayWithSavedCardState
                          ? Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              selectedCardToken != null
                                  ? 'Pay $selectedAmount EGP'
                                  : 'Top-Up $selectedAmount EGP',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 21,
                              ),
                            ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 22),
          ],
        ),
      ),
    );
  }
}
