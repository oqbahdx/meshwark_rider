import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../resources/fonts_manager.dart';
import '../../resources/style_manager.dart';

class LogOutsButtonDialog extends StatelessWidget {
  final String text;
  final Color color;
  final Function()? onPressed;
  const LogOutsButtonDialog({
    super.key,
    required this.text,
    required this.color,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: getBoldStyle(color: color, fontSize: FontSize.s12.sp),
        ));
  }
}
