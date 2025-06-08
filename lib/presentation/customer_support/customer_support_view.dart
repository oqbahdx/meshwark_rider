import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meshwark_rider/presentation/customer_support/widgets/customer_support_widgets.dart';
import '../resources/Strings_manager.dart';
import '../resources/color_manager.dart';
import '../resources/language_manager.dart';
import '../resources/style_manager.dart';

class CustomerSupportView extends StatelessWidget {
  const CustomerSupportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          AppStrings.customerSupport.tr(),
          style: getBoldStyle(
            color: ColorManager.primary,
            fontSize: isRTL(context) ? 22.sp : 20.sp,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30.h),
              Text(
                AppStrings.howCanWeHelp.tr(),
                style: getBoldStyle(
                  color: ColorManager.darkGrey,
                  fontSize: 24.sp,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                AppStrings.chooseContactMethod.tr(),
                style: getRegularStyle(
                  color: ColorManager.grey,
                  fontSize: 16.sp,
                ),
              ),
              SizedBox(height: 40.h),
              _buildContactOption(
                context: context,
                icon: FontAwesomeIcons.whatsapp,
                title: AppStrings.whatsapp.tr(),
                subtitle: AppStrings.quickResponse.tr(),
                color: Color(0xFF25D366),
                onTap: () => SendMessageToApp.launchWhatsapp(context),
              ),
              SizedBox(height: 20.h),
              _buildContactOption(
                context: context,
                icon: Icons.email_outlined,
                title: AppStrings.email.tr(),
                subtitle: AppStrings.detailedInquiries.tr(),
                color: ColorManager.primary,
                onTap: () =>
                    SendMessageToApp.launchEmail("mailto:support@example.com"),
              ),
              SizedBox(height: 20.h),
              _buildContactOption(
                context: context,
                icon: Icons.phone_outlined,
                title: AppStrings.phoneCall.tr(),
                subtitle: AppStrings.talkToSupport.tr(),
                color: Colors.blue,
                onTap: () => SendMessageToApp.launchPhone("tel:+1234567890"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Ink(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.r),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(icon, color: color, size: 24.sp),
              ),
              SizedBox(width: 20.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: getBoldStyle(
                          color: ColorManager.darkGrey, fontSize: 18.sp),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      subtitle,
                      style: getRegularStyle(
                          color: ColorManager.grey, fontSize: 14.sp),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios,
                  color: ColorManager.grey, size: 16.sp),
            ],
          ),
        ),
      ),
    );
  }

  bool isRTL(BuildContext context) {
    return context.locale == ARABIC_LOCALE;
  }
}
