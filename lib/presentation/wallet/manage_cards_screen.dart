import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mega_plus/core/style/app_colors.dart';
import 'package:mega_plus/presentation/wallet/cubit/wallet_cubit.dart';
import 'package:mega_plus/presentation/wallet/models/saved_card_response_model.dart';

import 'details_card_sreen.dart';

class ManageCardsScreen extends StatelessWidget {
  ManageCardsScreen({super.key});

  final Color green = AppColors.primary;
  final Color bgGreen = Color(0xFFD1FADF);
  final Color borderGreen = Color(0xFFABEFC6);
  Widget cardItem({
    required SavedCardResponseModel card, // 👈 بدل كل الـ parameters
    required BuildContext context,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CardDetailsScreen(
              card: card, // 👈 بنبعت الـ object كله
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: (card.isDefault == 1) ? borderGreen : Color(0xFFE8E8E8),
            width: 2,
          ),
          boxShadow: (card.isDefault == 1)
              ? [
                  BoxShadow(
                    color: borderGreen.withOpacity(0.15),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            // Card Icon
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: green,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.credit_card, color: Colors.white, size: 28),
            ),
            SizedBox(width: 16),

            // Card Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        card.cardType ?? "Visa",
                        style: TextStyle(
                          color: Color(0xFF212121),
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      if (card.isDefault == 1) ...[
                        SizedBox(width: 8),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFF2563EB),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Default',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],

                      if (card.status == "inactive") ...[
                        SizedBox(width: 8),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Deactivated',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 6),
                  Text(
                    card.maskedPan ?? "**** **** **** ****",
                    style: TextStyle(
                      color: Color(0xFF212121),
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      letterSpacing: 1.2,
                    ),
                  ),
                  // if (card.expiryDate != null && card.expiryDate!.isNotEmpty)
                  //   Padding(
                  //     padding: EdgeInsets.only(top: 4),
                  //     child: Text(
                  //       'Expires ${card.expiryDate}',
                  //       style: TextStyle(
                  //         fontSize: 13,
                  //         color: Color(0xFF039855),
                  //         fontWeight: FontWeight.w500,
                  //       ),
                  //     ),
                  //   ),
                ],
              ),
            ),

            // Arrow Icon
            Icon(Icons.arrow_forward_ios, color: Color(0xFFBDBDBD), size: 18),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    WalletCubit.get(context).getSavedCards();

    return Scaffold(
      backgroundColor: Color(0xFFF7F7F7),
      body: SafeArea(
        child: Column(
          children: [
            // AppBar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              width: double.infinity,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(color: Color(0xFFE8E8E8), width: 1),
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: Color(0xFF212121),
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      "Payment Methods",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff212121),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Cards List
            Expanded(
              child: BlocBuilder<WalletCubit, WalletState>(
                builder: (context, state) {
                  if (state is LoadingGetSavedCardsState) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final cubit = WalletCubit.get(context);

                  return ListView.builder(
                    padding: EdgeInsets.only(top: 16, bottom: 100),
                    itemCount: cubit.savedCards.length,
                    itemBuilder: (context, index) {
                      final card = cubit.savedCards[index];
                      return cardItem(
                        card: card, // 👈 بنبعت الـ object مباشرة
                        context: context,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // Add New Card Button (Fixed at bottom)
      // floatingActionButton: Container(
      //   width: double.infinity,
      //   padding: EdgeInsets.all(16),
      //   decoration: BoxDecoration(
      //     color: Colors.white,
      //     boxShadow: [
      //       BoxShadow(
      //         color: Colors.black.withOpacity(0.05),
      //         blurRadius: 10,
      //         offset: Offset(0, -2),
      //       ),
      //     ],
      //   ),
      //   child: SafeArea(
      //     child: SizedBox(
      //       width: double.infinity,
      //       height: 56,
      //       child: ElevatedButton.icon(
      //         onPressed: () {
      //           // context.goTo(AddCardScreen());
      //         },
      //         icon: Icon(Icons.add, size: 24, color: Colors.white),
      //         label: Text(
      //           'Add New Card',
      //           style: TextStyle(
      //             color: Colors.white,
      //             fontWeight: FontWeight.w600,
      //             fontSize: 16,
      //           ),
      //         ),
      //         style: ElevatedButton.styleFrom(
      //           backgroundColor: green,
      //           shape: RoundedRectangleBorder(
      //             borderRadius: BorderRadius.circular(16),
      //           ),
      //           elevation: 0,
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
