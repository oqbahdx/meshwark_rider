import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../resources/color_manager.dart';
import '../resources/style_manager.dart';
import '../resources/assets_manager.dart';
import '../resources/Strings_manager.dart';
import '../resources/language_manager.dart';

class AboutAppView extends StatefulWidget {
  const AboutAppView({super.key});

  @override
  State<AboutAppView> createState() => _AboutAppViewState();
}

class _AboutAppViewState extends State<AboutAppView> {
  String? version;

  @override
  void initState() {
    super.initState();
    _getAppVersion();
  }

  Future<void> _getAppVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: SafeArea(

        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarBrightness: Brightness.light,
                statusBarIconBrightness: Brightness.dark,

              ),
              iconTheme: IconThemeData(
                color: ColorManager.white, // Change this to the desired color
              ),
              expandedHeight: 200.h,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  AppStrings.aboutApp.tr(),
                  style: getBoldStyle(
                    color: ColorManager.white,
                    fontSize: isRTL() ? 22.sp : 20.sp,
                  ),
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [ColorManager.primary, ColorManager.lightPrimary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 60.r,
                      backgroundColor: ColorManager.lightPrimary,
                      child: Image.asset(
                        ImageAssets.appLogoNew,
                        width: 80.w,
                        height: 80.w,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      AppStrings.meshwarkApp.tr(),
                      style: getBoldStyle(
                        color: ColorManager.primary,
                        fontSize: 28.sp,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      "${AppStrings.version.tr()}: $version",
                      style: getRegularStyle(
                        color: ColorManager.black,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 32.h),
                    _buildInfoCard(
                      icon: Icons.info_outline,
                      title: AppStrings.appDescription.tr(),
                      content: AppStrings.appDescriptionContent.tr()
                    ),
                    SizedBox(height: 16.h),
                    _buildInfoCard(
                      icon: Icons.star_outline,
                      title: AppStrings.features.tr(),
                      content: AppStrings.featuresContent.tr()
                    ),
                    SizedBox(height: 16.h),
                    _buildInfoCard(
                      icon: Icons.contact_support_outlined,
                      title: AppStrings.support.tr(),
                      content: AppStrings.supportContent.tr(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Card(
      elevation: 0,
      color: ColorManager.textFormLightGrey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: ColorManager.primary, size: 24.sp),
                SizedBox(width: 8.w),
                Text(
                  title,
                  style: getSemiBoldStyle(
                    color: ColorManager.primary,
                    fontSize: 18.sp,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              content,
              style: getRegularStyle(
                color: ColorManager.black,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isRTL() {
    return context.locale == ARABIC_LOCALE;
  }
}
