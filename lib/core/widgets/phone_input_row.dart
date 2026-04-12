import 'package:flutter/material.dart';

class PhoneInputRow extends StatelessWidget {
  final TextEditingController controller;
  final String countryCode;
  final VoidCallback onCountryTap;
  final ValueChanged<String> onChanged;

  const PhoneInputRow({
    super.key,
    required this.controller,
    required this.countryCode,
    required this.onCountryTap,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Country code selector
        GestureDetector(
          onTap: onCountryTap,
          child: Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: const Color(0xffFAFAFA),
              border: Border.all(color: const Color(0xffE0E0E0)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  countryCode,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xff212427),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 2),
                const Icon(
                  Icons.keyboard_arrow_down,
                  size: 20,
                  color: Color(0xff606060),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Phone number field
        Expanded(
          child: Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xffE0E0E0)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Image.asset(
                  "assets/images/eg_flag.png",
                  width: 26,
                  height: 26,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: controller,
                    keyboardType: TextInputType.phone,
                    onChanged: onChanged,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      errorBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      hintText: 'XXXXXXXXXX',
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Color(0xffC8C8C8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
