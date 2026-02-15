import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mega_plus/core/helpers/addons_functions.dart';
import 'package:mega_plus/core/style/app_colors.dart';
import 'package:mega_plus/core/widgets/shimmer_widget.dart';
import 'package:mega_plus/presentation/profile/cubit/profile_cubit.dart';
import 'package:mega_plus/presentation/profile/models/rfid_response_model.dart';
import 'package:mega_plus/presentation/profile/rfid_qr_scanner_screen.dart';

class RFIDCardsScreen extends StatelessWidget {
  RFIDCardsScreen({super.key});

  final Color green = AppColors.primary;
  final Color bgGreen = Color(0xFFECFDF3);
  final Color borderGreen = Color(0xFF19C37D);
  final Color red = Color(0xFFD03534);
  final Color bgRed = Color(0xFFB71C1C);
  final Color blue = Color(0xFF256FEF);

  Widget cardItem(BuildContext context, RFIDResponseModel item) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 9),
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage("assets/images/bg_rfid_cards.png"),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SvgPicture.asset("assets/icons/rfid_iconsvg.svg"),
              SizedBox(width: 10),
            ],
          ),
          SizedBox(height: 26),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                item.code ?? "",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    border: Border.all(color: green.withOpacity(0.7), width: 2),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.transparent,
                  ),
                  child: TextButton(
                    onPressed: () {
                      ProfileCubit.get(
                        context,
                      ).deactivateRFID(item.id!, item.status == 1 ? "0" : "1");
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: green,
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      item.status == 1 ? "Deactivate" : "Activate",
                      style: TextStyle(
                        color: green,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextButton.icon(
                    onPressed: () {
                      ProfileCubit.get(context).deleteRFID(item.id!);
                    },
                    icon: Icon(
                      Icons.delete_outline,
                      color: Colors.white,
                      size: 24,
                    ),
                    label: Text(
                      "Delete",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Color(0xffB71C1C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ProfileCubit.get(context).getRFID();
    return Scaffold(
      backgroundColor: Color(0xFFF7F7F7),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final rfid = await showAddRfidBottomSheet(context);
          if (rfid != null) {
            ProfileCubit.get(context).addRFID(rfid);
          }
        },
        backgroundColor: Colors.green,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ErrorGetRFIDState) {
            context.showErrorMessage(state.message);
          } else if (state is SuccessAddRFIDState) {
            context.showSuccessMessage('RFID card added successfully');
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: ListView(
              children: [
                // AppBar
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  width: double.infinity,
                  height: 57,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Color(0xffF2F4F8)),
                    ),
                    color: Colors.white,
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
                          child: SvgPicture.asset("assets/icons/back.svg"),
                        ),
                      ),
                      Center(
                        child: Text(
                          "RFID Cards",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff212121),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                state is LoadingGetRFIDState
                    ? Center(
                        child: ShimmerWidget(
                          width: 50,
                          height: 50,
                          borderRadius: BorderRadius.circular(25),
                        ),
                      )
                    : ProfileCubit.get(context).rfidCards.isEmpty
                    ? Center(child: Text("No RFID Cards Added Please Add One"))
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: ProfileCubit.get(context).rfidCards.length,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final item = ProfileCubit.get(
                            context,
                          ).rfidCards[index];
                          return cardItem(context, item);
                        },
                      ),

                SizedBox(height: 27),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<String?> showAddRfidBottomSheet(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final rfidController = TextEditingController();

    return showModalBottomSheet<String?>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (bottomSheetContext) {
        final mediaQuery = MediaQuery.of(bottomSheetContext);
        final bottomInset = mediaQuery.viewInsets.bottom;

        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: bottomInset + 50, // عشان الكيبورد + 50px margin
                top: 12,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Indicator bar فوق
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xffE0E0E0),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Add RFID Card',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff121212),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // زر Scan QR Code
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () async {
                          // Open QR scanner and get result
                          final scannedCode = await Navigator.push<String>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RFIDQrScannerScreen(),
                            ),
                          );
                          
                          // If QR code was scanned, populate the text field
                          if (scannedCode != null && scannedCode.isNotEmpty) {
                            setState(() {
                              rfidController.text = scannedCode;
                            });
                          }
                        },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.qr_code_scanner, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'Scan QR Code',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Text تحت زر الـ Scan
                const Text(
                  'Scan the QR code on your RFID card for instant registration',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Color(0xff9E9E9E)),
                ),

                const SizedBox(height: 16),

                // Or line
                Row(
                  children: const [
                    Expanded(child: Divider(color: Color(0xffE7E7E7))),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        'Or',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xff606060),
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: Color(0xffE7E7E7))),
                  ],
                ),

                const SizedBox(height: 16),

                // Label
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Enter your RFID Cards',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff121212),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // TextField بنفس ستايل الديزاين
                Container(
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Center(
                    child: TextFormField(
                      controller: rfidController,
                      maxLength: 16,
                      decoration: const InputDecoration(
                        counterText: '',
                        border: InputBorder.none,
                        hintText: 'XXXXXXXXXXXXXX',
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: Color(0xffDCDCDC),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      validator: (value) {
                        final text = value?.trim() ?? '';
                        if (text.isEmpty) {
                          return 'Please enter your RFID card number';
                        }

                        return null;
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ADD Card button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState?.validate() ?? false) {
                        Navigator.pop(bottomSheetContext, rfidController.text.trim());
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'ADD Card',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
