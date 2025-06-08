import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';


import '../resources/Strings_manager.dart';
import '../resources/assets_manager.dart';
import '../resources/color_manager.dart';
import '../resources/fonts_manager.dart';
import '../resources/routes_manager.dart';
import '../resources/style_manager.dart';
import '../resources/value_manager.dart';

class MainAccountView extends StatefulWidget {
  const MainAccountView({super.key});

  @override
  State<MainAccountView> createState() => _MainAccountViewState();
}

class _MainAccountViewState extends State<MainAccountView> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: ColorManager.primary,
      body: Stack(
        children: [
          Image.asset(
            opacity: const AlwaysStoppedAnimation<double>(150),
            ImageAssets.background,
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.fill,
          ),
          Center(
            child: Column(
              children: [
                SizedBox(
                  height:height * 0.1,
                ),
                Container(
                    height: width * 0.4,
                    width: width * 0.4,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppSize.s100),
                        ),
                    child: Center(
                      child: Image.asset(
                        ImageAssets.appLogoNew,
                        height: width * 0.4,
                        width: width * 0.4,
                        fit: BoxFit.fill,
                      ),
                    )),
                 SizedBox(
                  height: height * 0.2,
                ),
                InkWell(
                  onTap: (){
                    Navigator.of(context).pushReplacementNamed(Routes.registerRoute);

                  },
                  child: Container(
                    height: height * 0.06,
                    width: width * 0.5,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppSize.s10),
                        color: ColorManager.transparent,
                        border: Border(
                          bottom: BorderSide(color: ColorManager.white, width: AppPadding.p3),
                          left: BorderSide(color: ColorManager.white, width: AppPadding.p3),
                          right: BorderSide(color: ColorManager.white, width:  AppPadding.p3),
                          top: BorderSide(color: ColorManager.white, width:  AppPadding.p3),
                        )),
                    child: Center(
                      child: Text(
                        AppStrings.signUp.tr(),
                        style: getBoldStyle(
                            color: ColorManager.white, fontSize: FontSize.s22),
                      ),
                    ),
                  ),
                ),
                 SizedBox(
                  height:height * 0.05,
                ),
                SizedBox(
                    height: height * 0.06,
                    width: width * 0.5,
                    child: ElevatedButton(
                        onPressed: (){
                          Navigator.pushReplacementNamed(context, Routes.loginRoute);

                        },
                        child: Text(
                          AppStrings.login.tr(),
                          style: getBoldStyle(
                              color: ColorManager.white,
                              fontSize: FontSize.s22),
                        ))),
              ],
            ),
          )
        ],
      ),
    );
  }
}
