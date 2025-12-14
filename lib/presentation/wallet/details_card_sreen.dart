import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mega_plus/core/helpers/addons_functions.dart';
import 'package:mega_plus/core/style/app_colors.dart';
import 'package:mega_plus/presentation/wallet/cubit/wallet_cubit.dart';
import 'package:mega_plus/presentation/wallet/models/saved_card_response_model.dart';

class CardDetailsScreen extends StatelessWidget {
  final SavedCardResponseModel card; // 👈 بدل كل الـ parameters

  const CardDetailsScreen({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    final Color green = AppColors.primary;

    // استخرج آخر 4 أرقام من الـ maskedPan
    String lastDigits = '';
    if (card.maskedPan != null && card.maskedPan!.length >= 4) {
      lastDigits = card.maskedPan!.replaceAll('*', '').replaceAll(' ', '');
      if (lastDigits.length >= 4) {
        lastDigits = lastDigits.substring(lastDigits.length - 4);
      }
    }

    return Scaffold(
      backgroundColor: Color(0xFFF7F7F7),
      body: BlocConsumer<WalletCubit, WalletState>(
        listener: (context, state) {
          if (state is SuccessGetSavedCardsState) {
            Navigator.pop(context);
          } else if (state is ErrorDeleteSavedCardsState) {
            context.showErrorMessage("Can't delete this card,please try again");
          } else if (state is ErrorDeactivateSavedCardsState) {
            context.showErrorMessage(
              "Can't Deactivate this card,please try again",
            );
          } else if (state is ErrorSetDefaultSavedCardsState) {
            context.showErrorMessage(
              "Can't set default for this card,please try again",
            );
          }
        },
        builder: (context, state) {
          if (state is LoadingGetSavedCardsState) {
            return Center(child: CircularProgressIndicator());
          }
          return SafeArea(
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
                          "Card Details",
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

                SizedBox(height: 24),

                // Card Display
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF2D2D2D), Color(0xFF1A1A1A)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Decorative circles
                      Positioned(
                        right: -50,
                        top: -50,
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.05),
                          ),
                        ),
                      ),
                      Positioned(
                        left: -30,
                        bottom: -30,
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.03),
                          ),
                        ),
                      ),

                      // Card content
                      Padding(
                        padding: EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Credit Card',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  (card.cardType ?? 'VISA').toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Text(
                                //   (card.holderName ?? 'CARD HOLDER')
                                //       .toUpperCase(),
                                //   style: TextStyle(
                                //     color: Colors.white,
                                //     fontSize: 16,
                                //     fontWeight: FontWeight.w500,
                                //     letterSpacing: 1.2,
                                //   ),
                                // ),
                                SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      card.maskedPan ??
                                          '**** - **** - **** - ****',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                    // Text(
                                    //   card.expiryDate ?? 'MM/YY',
                                    //   style: TextStyle(
                                    //     color: Colors.white.withOpacity(0.7),
                                    //     fontSize: 12,
                                    //     fontWeight: FontWeight.w500,
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24),

                // Buttons
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      // Set as Default Button (يظهر فقط لو مش default)
                      if (card.isDefault != 1)
                        Container(
                          width: double.infinity,
                          height: 56,
                          margin: EdgeInsets.only(bottom: 12),
                          child: ElevatedButton(
                            onPressed: () {
                              WalletCubit.get(
                                context,
                              ).setDefaultCard(card.id ?? 0);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFD1FADF),
                              foregroundColor: green,
                              elevation: 0,
                              disabledBackgroundColor: Colors.grey[300],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              'Set as Default Card',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: green,
                              ),
                            ),
                          ),
                        ),

                      // Deactivate Button (يظهر فقط لو هو default)
                      if (card.status == "active")
                        Container(
                          width: double.infinity,
                          height: 56,
                          margin: EdgeInsets.only(bottom: 12),
                          child: OutlinedButton(
                            onPressed: () {
                              WalletCubit.get(
                                context,
                              ).deactivateCard(card.id ?? 0);
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: green,
                              side: BorderSide(color: green, width: 2),
                              elevation: 0,
                              disabledForegroundColor: Colors.grey,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              'Deactivate',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: green,
                              ),
                            ),
                          ),
                        ),

                      // Delete Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            bool? result = await showDialog<bool?>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Delete Card'),
                                content: Text(
                                  'Are you sure you want to delete this card?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, true);
                                    },
                                    child: Text(
                                      'Delete',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            );

                            if (result == true) {
                              WalletCubit.get(context).deleteCard(card.id ?? 0);
                            }
                          },
                          icon: Icon(
                            Icons.delete_outline,
                            color: Color(0xFFB71C1C),
                            size: 22,
                          ),
                          label: Text(
                            'Delete',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFB71C1C),
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Color(0xFFB71C1C),
                            side: BorderSide(
                              color: Color(0xFFB71C1C),
                              width: 2,
                            ),
                            elevation: 0,
                            disabledForegroundColor: Colors.grey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
