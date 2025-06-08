import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../resources/Strings_manager.dart';
import '../resources/color_manager.dart';
import '../resources/fonts_manager.dart';
import '../resources/language_manager.dart';
import '../resources/style_manager.dart';
import '../resources/value_manager.dart';
import '../../app/app_pref.dart';
import '../../app/di.dart';

class LanguageView extends StatefulWidget {
  const LanguageView({Key? key}) : super(key: key);

  @override
  State<LanguageView> createState() => _LanguageViewState();
}

class _LanguageViewState extends State<LanguageView> with SingleTickerProviderStateMixin {
  final AppPreferences _appPreferences = instance<AppPreferences>();
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: ColorManager.white,
          statusBarIconBrightness: Brightness.dark,
        ),
        backgroundColor: ColorManager.white,
        elevation: 0,
        title: Text(
          AppStrings.changeLanguage.tr(),
          style: getBoldStyle(
            color: ColorManager.primary,
            fontSize: FontSize.s22.sp,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSize.s20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 40.h),
              Text(
                AppStrings.changeLanguage.tr(),
                style: getSemiBoldStyle(
                  color: ColorManager.grey,
                  fontSize: FontSize.s18.sp,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 60.h),
              FadeTransition(
                opacity: _animation,
                child: Column(
                  children: [
                    _buildLanguageCard(
                      language: AppStrings.arabic.tr(),
                      isSelected: isRTL(),
                      onTap: !isRTL() ? _changeToArabic : null,
                      icon: Icons.language,
                      flagEmoji: '🇸🇦',
                    ),
                    SizedBox(height: AppSize.s20.h),
                    _buildLanguageCard(
                      language: AppStrings.english.tr(),
                      isSelected: !isRTL(),
                      onTap: isRTL() ? _changeToEnglish : null,
                      icon: Icons.language,
                      flagEmoji: '🇺🇸',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageCard({
    required String language,
    required bool isSelected,
    required VoidCallback? onTap,
    required IconData icon,
    required String flagEmoji,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: AppSize.s80.h,
        decoration: BoxDecoration(
          color: isSelected ? ColorManager.primary : ColorManager.white,
          borderRadius: BorderRadius.circular(AppSize.s15.r),
          boxShadow: [
            BoxShadow(
              color: ColorManager.lightGrey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSize.s20.w),
              child: Text(
                flagEmoji,
                style: TextStyle(fontSize: 30.sp),
              ),
            ),
            Expanded(
              child: Text(
                language,
                style: getSemiBoldStyle(
                  color: isSelected ? ColorManager.white : ColorManager.primary,
                  fontSize: FontSize.s18.sp,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            if (isSelected)
              Padding(
                padding: EdgeInsets.only(right: AppSize.s20.w),
                child: Icon(
                  Icons.check_circle,
                  color: ColorManager.white,
                  size: AppSize.s22.sp,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _changeToArabic() {
    _appPreferences.changeAppLanguage();
    Phoenix.rebirth(context);
  }

  void _changeToEnglish() {
    _appPreferences.changeAppLanguage();
    Phoenix.rebirth(context);
  }

  bool isRTL() {
    return context.locale == ARABIC_LOCALE;
  }
}