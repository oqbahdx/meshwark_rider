import 'package:flutter/material.dart';

import '../../resources/color_manager.dart';
import '../../resources/style_manager.dart';

class BuildFormField extends StatelessWidget {
  const BuildFormField(
      {super.key,
      required this.isSecure,
      required this.controller,
      required this.text,
      required this.icon,
      required this.inputType,
      required this.validator,
      required this.fontSize,
      this.maxLength,
      this.counter = ''});

  final TextEditingController controller;
  final bool isSecure;

  final String text;
  final Widget icon;
  final TextInputType inputType;
  final String? Function(String? value) validator;
  final double fontSize;
  final int? maxLength;
  final String? counter;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isSecure,
      style: getSemiBoldStyle(color: ColorManager.primary, fontSize: fontSize),
      keyboardType: inputType,
      textAlign: TextAlign.end,
      decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.never,
          filled: true,
          fillColor: ColorManager.textFormLightGrey,
          labelText: text,
          suffixIcon: icon,
          suffixIconColor: ColorManager.primary,
          iconColor: ColorManager.darkPrimary,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: ColorManager.textFormLightGrey)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: ColorManager.textFormLightGrey)),
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: ColorManager.textFormLightGrey)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: ColorManager.textFormLightGrey)),
          counterText: counter),
      maxLength: maxLength,
      validator: validator,
    );
  }
}
