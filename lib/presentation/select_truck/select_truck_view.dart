import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meshwark_rider/presentation/resources/Strings_manager.dart';
import 'package:meshwark_rider/presentation/resources/assets_manager.dart';
import 'package:meshwark_rider/presentation/resources/color_manager.dart';
import 'package:meshwark_rider/presentation/resources/value_manager.dart';

import '../map/map_view.dart';
import '../resources/fonts_manager.dart';
import '../resources/language_manager.dart';
import '../resources/style_manager.dart';
import '../select_service/widgets/select_service_wigets.dart';

class SelectTruckView extends StatefulWidget {
  const SelectTruckView({
    super.key,
  });

  @override
  State<SelectTruckView> createState() => _SelectTruckViewState();
}

class _SelectTruckViewState extends State<SelectTruckView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        title: Text(
          AppStrings.selectTruck.tr(),
          style: getBoldStyle(
              color: ColorManager.primary,
              fontSize: isRTL() ? FontSize.s22.sp : FontSize.s20.sp),
        ),
        backgroundColor: ColorManager.transparent,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: ColorManager.white,
            statusBarIconBrightness: Brightness.dark),
        elevation: AppSize.s0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppPadding.p18),
            child: Column(
              children: [
                const SizedBox(
                  height: AppSize.s60,
                ),
                InkWell(
                  splashColor: Colors.transparent,
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const MapPageView(
                              tag: AppStrings.truck,
                              image: ImageAssets.truck2Select,
                              gender: '',
                              typeOfTrip: 'truck',
                            )));
                  },
                  child: BuildContainerWithImage(
                    text: AppStrings.truck.tr(),
                    tag: AppStrings.truck,
                    image: ImageAssets.truck2Select,
                    alignment: Alignment.center,
                    colors: [
                      ColorManager.primary,
                      ColorManager.white,
                    ],
                  ),
                ),
                SizedBox(
                  height: AppSize.s60.h,
                ),
                InkWell(
                  splashColor: Colors.transparent,
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const MapPageView(
                              tag: AppStrings.bigTruck,
                              image: ImageAssets.truckSelect,
                              gender: '',
                              typeOfTrip: 'bigTruck',
                            )));
                  },
                  child: BuildContainerWithImage(
                    text: AppStrings.bigTruck.tr(),
                    tag: AppStrings.bigTruck,
                    image: ImageAssets.truckSelect,
                    alignment: Alignment.center,
                    colors: [
                      ColorManager.white,
                      ColorManager.primary,
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool isRTL() {
    return context.locale == ARABIC_LOCALE;
  }
}
