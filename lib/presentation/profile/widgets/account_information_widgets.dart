import 'package:flutter/material.dart';

import '../../resources/color_manager.dart';
import '../../resources/fonts_manager.dart';
import '../../resources/style_manager.dart';
import '../../resources/value_manager.dart';

class BuildTextField extends StatelessWidget {
  BuildTextField(
      {super.key,
      required this.textEditingController,
      required this.text,
      required this.icon});
  TextEditingController textEditingController = TextEditingController();
  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      style: getSemiBoldStyle(color: ColorManager.grey, fontSize: FontSize.s20),
      keyboardType: TextInputType.text,
      textAlign: TextAlign.end,
      decoration: InputDecoration(
        labelText: text,
        hintText: text,
        suffixIcon: Icon(icon),
        iconColor: ColorManager.darkPrimary,
      ),
    );
  }
}

class BuildTextFormFieldNoBorder extends StatelessWidget {
  const BuildTextFormFieldNoBorder(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.labelText,
      required this.icon,
      this.maxLength,
      required this.inputType, this.validator});
  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final IconData icon;
  final int? maxLength;
  final TextInputType inputType;
  final String? Function(String?)? validator;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      style: getSemiBoldStyle(color: ColorManager.grey, fontSize: FontSize.s20),
      keyboardType: inputType,
      textAlign: TextAlign.end,
      maxLength: maxLength,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSize.s8),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorManager.transparent, width: 0.0),
          borderRadius: BorderRadius.circular(AppSize.s8),
        ),
        counterText: '',
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorManager.transparent, width: 0.0),
          borderRadius: BorderRadius.circular(AppSize.s8),
        ),
        fillColor: ColorManager.textFormLightGrey,
        filled: true,
        focusedBorder: InputBorder.none,
        labelText: hintText,
        hintText: labelText,
        suffixIcon: Icon(icon),
        iconColor: ColorManager.darkPrimary,
      ),
    );
  }
}
