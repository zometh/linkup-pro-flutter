import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';
import 'package:linkup_pro/main.dart';

class CustomPhonePicker extends StatefulWidget {
  final Function onPhoneNumberChanged;
  const CustomPhonePicker({super.key, required this.onPhoneNumberChanged});

  @override
  State<CustomPhonePicker> createState() => _CustomPhonePickerState();
}

class _CustomPhonePickerState extends State<CustomPhonePicker> {
  @override
  Widget build(BuildContext context) {
    return InternationalPhoneNumberInput(
      spaceBetweenSelectorAndTextField: 0,

      //maxLength: 15,
      /*keyboardType: const TextInputType.numberWithOptions(
        signed: true,
        decimal: true,
      ),*/
      initialValue: PhoneNumber(
        dialCode: "+221",
        isoCode: "SN",
        phoneNumber: "7X XXX XX XX",
      ),

      selectorConfig: const SelectorConfig(
        leadingPadding: 0,
        selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
      ),
      autoValidateMode: AutovalidateMode.onUserInteraction,
      onInputChanged: widget.onPhoneNumberChanged as void Function(PhoneNumber),
      cursorColor: AppColors.primary,
      errorMessage: "invalid_field_name".tr(
        namedArgs: {"field": "phone_number".tr()},
      ),

      hintText: "phone_number".tr(),
      inputDecoration: InputDecoration(
        fillColor: context.isDarkMode
            ? Color(0xFF1E293B).withValues(
                alpha: .5,
              ) // Gris foncé semi-transparent en mode sombre
            : AppColors.primary.withValues(alpha: .03),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: AppColors.primary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: AppColors.primary),
        ),
      ),
      textStyle: GoogleFonts.poppins(
        //color: AppColors.textPrimary,
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
      ),

      // onInputChanged: (PhoneNumber number) {
      //   _phoneController.text = number.phoneNumber!;
      // },
    );
  }
}
