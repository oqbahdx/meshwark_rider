import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

// Assuming you have these imports
import 'package:meshwark_rider/presentation/bloc/select_service_bloc/select_service_cubit.dart';
import 'package:meshwark_rider/presentation/resources/Strings_manager.dart';
import 'package:meshwark_rider/presentation/resources/color_manager.dart';
import 'package:meshwark_rider/presentation/resources/assets_manager.dart';
import 'package:meshwark_rider/presentation/resources/fonts_manager.dart';
import 'package:meshwark_rider/presentation/resources/routes_manager.dart';

import '../map/widgets/map_widgets.dart';
import '../resources/style_manager.dart';

class SelectServiceView extends StatefulWidget {
  const SelectServiceView({super.key});

  @override
  State<SelectServiceView> createState() => _SelectServiceViewState();
}

class _SelectServiceViewState extends State<SelectServiceView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
      ));
    });
    context.read<SelectServiceCubit>().fToast.init(context);
    context.read<SelectServiceCubit>().getUserData();
  }

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<SelectServiceCubit>();
    return Scaffold(
      backgroundColor: ColorManager.white,
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: Text(AppStrings.selectService.tr(),
            style: getSemiBoldStyle(
                color: ColorManager.primary, fontSize: FontSize.s20.sp)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: ColorManager.primary),
      ),
      body: BlocConsumer<SelectServiceCubit, SelectServiceState>(
        listener: (context, state) {
          if (cubit.userModel?.data?.hasProfile == false) {
            Navigator.of(context)
                .pushReplacementNamed(Routes.addRiderProfileRoute);
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 30.h),
                  _buildServiceCard(
                    context: context,
                    title: AppStrings.car.tr(),
                    image: ImageAssets.carSelect,
                    onTap: () => Navigator.of(context)
                        .pushNamed(Routes.selectGenderRoute),
                  ),
                  SizedBox(height: 20.h),
                  _buildServiceCard(
                    context: context,
                    title: AppStrings.van.tr(),
                    image: ImageAssets.vanSelect,
                    onTap: () {
                      cubit.showWarringMessage(message: AppStrings.soon.tr(), context: context);
                      // Navigate to MapPageView for van
                    },
                  ),
                  SizedBox(height: 20.h),
                  _buildServiceCard(
                    context: context,
                    title: AppStrings.truck.tr(),
                    image: ImageAssets.truckSelect,
                    onTap: () {
                      cubit.showWarringMessage(message: AppStrings.soon.tr(), context: context);
                      // Navigate to SelectTruckView
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildServiceCard({
    required BuildContext context,
    required String title,
    required String image,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [ColorManager.primary.withOpacity(0.1), ColorManager.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: ColorManager.primary,
                  ),
                ),
              ),
            ),
            Image.asset(
              image,
              height: 100.h,
              width: 120.w,
              fit: BoxFit.contain,
            ),
            SizedBox(width: 20.w),
          ],
        ),
      ),
    );
  }
}
