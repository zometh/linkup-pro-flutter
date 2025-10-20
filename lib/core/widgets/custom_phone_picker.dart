import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';
import 'package:linkup_pro/main.dart';

class CustomPhonePicker extends StatefulWidget {
  final void Function(PhoneNumber) onPhoneNumberChanged;
  final PhoneNumber? initialValue;
  final TextEditingController? textEditingController;

  const CustomPhonePicker({
    super.key,
    required this.onPhoneNumberChanged,
    this.initialValue,
    this.textEditingController,
  });

  @override
  State<CustomPhonePicker> createState() => _CustomPhonePickerState();
}

class _CustomPhonePickerState extends State<CustomPhonePicker> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.textEditingController ?? TextEditingController();
  }

  @override
  void dispose() {
    // Ne disposer que si on a créé le contrôleur nous-mêmes
    if (widget.textEditingController == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InternationalPhoneNumberInput(
      spaceBetweenSelectorAndTextField: 0,
      textFieldController: _controller,

      //maxLength: 15,
      /*keyboardType: const TextInputType.numberWithOptions(
        signed: true,
        decimal: true,
      ),*/
      // Use an empty phoneNumber here to avoid passing non-numeric placeholders
      // to the underlying parser which would throw ErrorType.notANumber.
      initialValue:
          widget.initialValue ?? PhoneNumber(dialCode: "+221", isoCode: "SN"),

      selectorConfig: const SelectorConfig(
        leadingPadding: 0,
        selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
      ),

      autoValidateMode: AutovalidateMode.onUserInteraction,
      //onInputChanged: widget.onPhoneNumberChanged,
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
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: context.isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: context.isDarkMode
                ? Colors.grey[700]!.withValues(alpha: .3)
                : Colors.grey[300]!,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red[400]!, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red[400]!, width: 2),
        ),
      ),
      textStyle: GoogleFonts.poppins(
        //color: AppColors.textPrimary,
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
      ),
      onInputChanged: widget.onPhoneNumberChanged,

      // onInputChanged: (PhoneNumber number) {
      //   _phoneController.text = number.phoneNumber!;
      // },
    );
  }
}
