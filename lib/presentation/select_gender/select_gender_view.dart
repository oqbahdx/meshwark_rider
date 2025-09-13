import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meshwark_rider/presentation/bloc/select_gender_bloc/select_gender_cubit.dart';
import 'package:meshwark_rider/presentation/map/map_view.dart';
import 'package:meshwark_rider/presentation/resources/Strings_manager.dart';
import 'package:meshwark_rider/presentation/resources/assets_manager.dart';
import 'package:meshwark_rider/presentation/resources/color_manager.dart';
import 'package:meshwark_rider/presentation/resources/fonts_manager.dart';
import 'package:meshwark_rider/presentation/resources/style_manager.dart';
import 'package:permission_handler/permission_handler.dart';

class SelectGenderView extends StatefulWidget {
  final String tag;
  final String image;

  const SelectGenderView({super.key, required this.tag, required this.image});

  @override
  State<SelectGenderView> createState() => _SelectGenderViewState();
}

class _SelectGenderViewState extends State<SelectGenderView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SelectGenderCubit, SelectGenderState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = context.read<SelectGenderCubit>();
        return Scaffold(
          backgroundColor: ColorManager.white,
          appBar: AppBar(
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarBrightness: Brightness.light,
              statusBarIconBrightness: Brightness.dark,
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              AppStrings.selectGender.tr(),
              style: getBoldStyle(color: ColorManager.primary, fontSize: 22.sp),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 40.h),
                  Row(
                    children: [
                      Expanded(
                        child: _buildGenderCard(
                          cubit,
                          AppStrings.woman,
                          ImageAssets.woman,
                          ColorManager.pink,
                        ),
                      ),
                      SizedBox(width: 20.w),
                      Expanded(
                        child: _buildGenderCard(
                          cubit,
                          AppStrings.man,
                          ImageAssets.man,
                          ColorManager.primary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40.h),
                  FadeTransition(
                    opacity: _animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.5),
                        end: Offset.zero,
                      ).animate(_animation),
                      child: Image.asset(
                        ImageAssets.carSelect,
                        height: 120.h,
                        color: ColorManager.primary,
                      ),
                    ),
                  ),
                  const Spacer(),
                  _buildNextButton(cubit),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGenderCard(
      SelectGenderCubit cubit, String gender, String imagePath, Color color) {
    bool isActive =
        gender == AppStrings.woman ? cubit.womanIsActive : cubit.manIsActive;
    return GestureDetector(
      onTap: () {
        gender == AppStrings.woman
            ? cubit.setWomanActive()
            : cubit.setManActive();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: isActive ? color : Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                gender.tr(),
                style: getBoldStyle(
                  color: isActive ? Colors.white : color,
                  fontSize: 20.sp,
                ),
              ),
              SizedBox(height: 16.h),
              Hero(
                tag: gender.tr(),
                child: Image.asset(
                  imagePath,
                  height: 120.h,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton(SelectGenderCubit cubit) {
    return AnimatedOpacity(
      opacity: cubit.buttonIsActive ? 1.0 : 0.5,
      duration: const Duration(milliseconds: 300),
      child: ElevatedButton(
        onPressed: cubit.buttonIsActive ? () => _onNextPressed(cubit) : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorManager.primary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
          padding: EdgeInsets.symmetric(vertical: 16.h),
        ),
        child: Text(
          AppStrings.next.tr(),
          style: getBoldStyle(
              color: ColorManager.white, fontSize: FontSize.s16.sp),
        ),
      ),
    );
  }

  Future<void> _onNextPressed(SelectGenderCubit cubit) async {
    final status = await Permission.locationWhenInUse.request();

    if (status.isGranted && mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => MapPageView(
            image: cubit.image,
            tag: cubit.tag,
            gender: cubit.gender,
            typeOfTrip: 'cityToCity',
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Location permission is required.")),
      );
    }
  }
}
