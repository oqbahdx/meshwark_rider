import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../resources/color_manager.dart';
import '../../resources/fonts_manager.dart';
import '../../resources/style_manager.dart';
import '../../resources/value_manager.dart';






class BuildContainerWithImage extends StatelessWidget {
  const BuildContainerWithImage({super.key, required this.text,required this.tag, required this.image, required this.colors, required this.alignment});
 final String text;
 final String image;
 final String tag;
 final List<Color> colors;
 final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return  Card(
      elevation: AppSize.s1_5,
      color: ColorManager.white,
      child: Container(
        alignment: Alignment.center,
        height: height * 0.24,
        width: double.infinity,
        decoration: BoxDecoration(
            color: ColorManager.white,
            borderRadius: BorderRadius.circular(AppSize.s20)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: AppSize.s14, left: AppSize.s14,right:AppSize.s14 ),
              child: Align(
                alignment: alignment,
                child: Text(
                  text,
                  style: getBoldStyle(
                      color: ColorManager.primary,
                      fontSize: FontSize.s18.sp),
                ),
              ),
            ),
            Hero(
              tag: tag,
              child: Image.asset(
                image,
                fit: BoxFit.contain,
                height: 120.h,
                color: ColorManager.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

}
