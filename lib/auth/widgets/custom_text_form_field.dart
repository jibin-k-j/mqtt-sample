import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mqtt_test/config/app_colors.dart';

class CustomTextFormField extends StatelessWidget {
  final String textFieldKey;
  final bool isObscure;
  final Icon? icon;
  final String hintText;
  final TextInputAction inputAction;
  final String? Function(String?)? validator;
  final Function(String?)? onSaved;
  final Widget? suffixIcon;
  final TextInputType? inputType;
  final TextCapitalization textCapitalization;

  const CustomTextFormField(
      {Key? key,
      required this.isObscure,
      this.icon,
      required this.hintText,
      required this.inputAction,
      required this.textCapitalization,
      this.inputType,
      this.validator,
      this.onSaved,
      this.suffixIcon,
      required this.textFieldKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: ValueKey(key),
      obscureText: isObscure,
      textInputAction: inputAction,
      keyboardType: inputType,
      textCapitalization: textCapitalization,
      style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: Colors.white),
      validator: validator,
      onSaved: onSaved,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
        prefixIcon: icon,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: AppColors.surfaceColor,
        focusedBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(15)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
      ),
    );
  }
}
