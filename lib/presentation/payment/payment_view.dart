import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meshwark_rider/presentation/resources/language_manager.dart';
import '../resources/Strings_manager.dart';
import '../resources/color_manager.dart';
import '../resources/fonts_manager.dart';
import '../resources/style_manager.dart';
import '../resources/value_manager.dart';
class PaymentView extends StatefulWidget {
  const PaymentView({super.key});

  @override
  State<PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: ColorManager.white,
            statusBarIconBrightness: Brightness.dark),
        backgroundColor: ColorManager.white,
        elevation: AppSize.s0,
        title: Text(
          AppStrings.payment.tr(),
          style: getBoldStyle(
              color: ColorManager.primary,
              fontSize: isRTL() ? FontSize.s22 : FontSize.s20),
        ),
      ),
    );

  }
  bool isRTL() {
    return context.locale == ARABIC_LOCALE;
  }
}

