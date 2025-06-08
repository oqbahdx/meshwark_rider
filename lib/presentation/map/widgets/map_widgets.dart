import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:meshwark_rider/app/app_pref.dart';
import 'package:meshwark_rider/app/di.dart';
import 'package:meshwark_rider/presentation/bloc/cubit.dart';
import 'package:meshwark_rider/presentation/bloc/select_service_bloc/select_service_cubit.dart';
import 'package:meshwark_rider/presentation/resources/Strings_manager.dart';
import 'package:meshwark_rider/presentation/resources/assets_manager.dart';
import 'package:meshwark_rider/presentation/resources/color_manager.dart';
import 'package:meshwark_rider/presentation/resources/fonts_manager.dart';
import 'package:meshwark_rider/presentation/resources/language_manager.dart';
import 'package:meshwark_rider/presentation/resources/style_manager.dart';

import 'dart:math' as math;

import '../../../domain/all_drivers_model.dart'; // Contains GetAllDriversModel & Data
import '../../resources/routes_manager.dart';
import '../../resources/value_manager.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final AppPreferences _appPreferences = instance<AppPreferences>();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    // Assume the user model stored in SelectServiceCubit is now a GetAllDriversModel wrapper
    // where the actual profile details are in its inner Data object (i.e.: userModel.data).
    final userData = context.read<SelectServiceCubit>().userModel?.data;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20.h),
            CircleAvatar(
              radius: 50.r,
              backgroundImage: userData?.personalImagePath != null
                  ? CachedNetworkImageProvider("${userData!.personalImagePath}")
                  : null,
              backgroundColor: ColorManager.primary.withOpacity(0.1),
              child: userData?.personalImagePath == null
                  ? Icon(Icons.person, size: 50.r, color: ColorManager.primary)
                  : null,
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                children: [
                  _buildDrawerItem(
                    icon: Icons.account_circle_outlined,
                    title: AppStrings.accountInformation.tr(),
                    onTap: () =>
                        Navigator.of(context).pushNamed(Routes.accountInformationRoute),
                  ),
                  _buildDrawerItem(
                    icon: Icons.language,
                    title: AppStrings.language.tr(),
                    onTap: () =>
                        Navigator.of(context).pushNamed(Routes.changeLanguageRoute),
                  ),
                  _buildDrawerItem(
                    icon: Icons.notifications_none,
                    title: AppStrings.notifications.tr(),
                    onTap: () =>
                        Navigator.of(context).pushNamed(Routes.notificationRoute),
                  ),
                  _buildDrawerItem(
                    icon: Icons.history,
                    title: AppStrings.tripHistory.tr(),
                    onTap: () =>
                        Navigator.of(context).pushNamed(Routes.historyRoute),
                  ),
                  _buildDrawerItem(
                    icon: Icons.account_balance_wallet_outlined,
                    title: AppStrings.wallet.tr(),
                    onTap: () =>
                        Navigator.of(context).pushNamed(Routes.walletRoute),
                  ),
                  _buildDrawerItem(
                    icon: Icons.support_agent,
                    title: AppStrings.customerSupport.tr(),
                    onTap: () =>
                        Navigator.of(context).pushNamed(Routes.customerSupportRoute),
                  ),
                  _buildDrawerItem(
                    icon: Icons.info_outline,
                    title: AppStrings.aboutApp.tr(),
                    onTap: () =>
                        Navigator.of(context).pushNamed(Routes.aboutAppRoute),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: ElevatedButton.icon(
                onPressed: () =>
                    context.read<SelectServiceCubit>().showImprovedDialog(context),
                icon: Icon(Icons.logout, color: ColorManager.white),
                label: Text(AppStrings.logout.tr(),
                    style: TextStyle(color: ColorManager.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorManager.error,
                  minimumSize: Size(double.infinity, 50.h),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r)),
                ),
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

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: ColorManager.primary),
      title: Text(title,
          style: TextStyle(fontSize: 16.sp, color: ColorManager.primary)),
      trailing: Icon(Icons.chevron_right, color: ColorManager.primary),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(vertical: 4.h),
    );
  }
}

class BuildListTile extends StatelessWidget {
  const BuildListTile(
      {super.key,
      required this.leading,
      required this.fontSize,
      required this.title,
      required this.trailing,
      required this.transform,
      required this.fontColor,
      required this.iconColor});
  final Widget leading;
  final String title;
  final String trailing;
  final Matrix4 transform;
  final double fontSize;
  final Color fontColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      title: Center(
          child: Text(
        title,
        style: getSemiBoldStyle(color: fontColor, fontSize: fontSize),
      )),
      trailing: Transform(
        alignment: Alignment.center,
        transform: transform,
        child: SvgPicture.asset(
          trailing,
          color: iconColor,
        ),
      ),
    );
  }
}

class BuildInfoWindowRow extends StatelessWidget {
  final String keyText;
  final String valueText;

  const BuildInfoWindowRow(
      {super.key, required this.keyText, required this.valueText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            "$keyText  ",
            style: getMediumStyle(
                color: ColorManager.black, fontSize: FontSize.s14.sp),
          ),
          const Spacer(),
          Text(
            valueText,
            style: getMediumStyle(
                color: ColorManager.black, fontSize: FontSize.s16.sp),
          ),
        ],
      ),
    );
  }
}

class DriverDetailsCard extends StatelessWidget {
  // Change parameter type from GetAllDriversModel to Data for driver details.
  const DriverDetailsCard({
    super.key,
    required this.driver,
    required this.context,
  });

  final Data driver;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: ColorManager.textFormLightGrey,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          const SizedBox(
            height: 5,
          ),
          BuildInfoWindowRow(
            keyText: AppStrings.name.tr(),
            valueText: '${driver.firstName} ${driver.lastName}',
          ),
          const SizedBox(height: 5),
          BuildInfoWindowRow(
            keyText: AppStrings.carColor.tr(),
            valueText: '${driver.carColor}',
          ),
          const SizedBox(
            height: 5,
          ),
          BuildInfoWindowRow(
            keyText: AppStrings.carModel.tr(),
            valueText: '${driver.carModel}',
          ),
          const SizedBox(
            height: 5,
          ),
          const SizedBox(
            height: 5,
          ),
          const SizedBox(
            height: 5,
          ),
          BuildInfoWindowRow(
            keyText: AppStrings.nextDestination.tr(),
            valueText: '${driver.nextDestination}',
          ),
          const SizedBox(
            height: 5,
          ),
          // TODO: fix tripPrice later; using a placeholder string for now.
          BuildInfoWindowRow(
            keyText: AppStrings.tripPrice.tr(),
            valueText: "price", 
          ),
          SizedBox(
            width: double.infinity,
            height: double.infinity * 0.1,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: ColorManager.primary),
                onPressed: () async {
                  context.read<AppCubit>().showNotification(
                      id: driver.id!,
                      title: "booking request",
                      body:
                          "The request has been sent to ${driver.firstName} ${driver.lastName}");
                },
                child: Text(
                  AppStrings.book.tr(),
                  style: getBoldStyle(
                      color: ColorManager.white, fontSize: FontSize.s16),
                )),
          )
        ],
      ),
    );
  }
}

class ShowModelSheet extends StatelessWidget {
  // Change parameter type from GetAllDriversModel to Data.
  const ShowModelSheet({
    super.key,
    required this.driver,
    required this.context,
  });

  final Data driver;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          height: 5,
        ),
        BuildInfoWindowRow(
          keyText: AppStrings.name.tr(),
          valueText: '${driver.firstName} ${driver.lastName}',
        ),
        const SizedBox(
          height: 5,
        ),
        const Divider(
          thickness: 1.5,
        ),
        const SizedBox(
          height: 5,
        ),
        BuildInfoWindowRow(
          keyText: AppStrings.carColor.tr(),
          valueText: '${driver.carColor}',
        ),
        const SizedBox(
          height: 5,
        ),
        const Divider(
          thickness: 1.5,
        ),
        const SizedBox(
          height: 5,
        ),
        BuildInfoWindowRow(
          keyText: AppStrings.carModel.tr(),
          valueText: '${driver.carModel}',
        ),
        const SizedBox(
          height: 5,
        ),
        const Divider(
          thickness: 1.5,
        ),
        const SizedBox(
          height: 5,
        ),
        BuildInfoWindowRow(
          keyText: AppStrings.plateNumber.tr(),
          valueText: '${driver.numberPlate}',
        ),
        const SizedBox(
          height: 5,
        ),
        const Divider(
          thickness: 1.5,
        ),
        const SizedBox(
          height: 5,
        ),
        BuildInfoWindowRow(
          keyText: AppStrings.seatsAvailable.tr(),
          valueText: '${driver.availableSeats}',
        ),
        const SizedBox(
          height: 5,
        ),
        const Divider(
          thickness: 1.5,
        ),
        const SizedBox(
          height: 5,
        ),
        BuildInfoWindowRow(
          keyText: AppStrings.nextDestination.tr(),
          valueText: '${driver.nextDestination}',
        ),
        const SizedBox(
          height: 5,
        ),
        const Divider(
          thickness: 1.5,
        ),
        InkWell(
          onTap: () {
            Navigator.of(context).pop(true);
          },
          child: Card(
            shadowColor: ColorManager.error,
            elevation: AppSize.s5,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSize.s10)),
            child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width * 0.95,
              height: MediaQuery.of(context).size.height * 0.055,
              decoration: BoxDecoration(
                  color: ColorManager.error,
                  borderRadius: BorderRadius.circular(AppSize.s10)),
              child: Text(
                AppStrings.cancel.tr(),
                style: getBoldStyle(
                    color: ColorManager.white, fontSize: FontSize.s22),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () {},
          child: Card(
            shadowColor: ColorManager.primary,
            elevation: AppSize.s5,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSize.s10)),
            child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width * 0.95,
              height: MediaQuery.of(context).size.height * 0.055,
              decoration: BoxDecoration(
                  color: ColorManager.primary,
                  borderRadius: BorderRadius.circular(AppSize.s10)),
              child: Text(
                AppStrings.book.tr(),
                style: getBoldStyle(
                    color: ColorManager.white, fontSize: FontSize.s22),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class DriverInfoDialog extends StatelessWidget {
  final String firstName;
  final String nextDestination;
  final String carModel;
  final String carColor;
  final String plateNumber;
  final String availableSeats;
  final String reservedSeats;
  final double rating;
  final VoidCallback onConfirm;

  const DriverInfoDialog({
    Key? key,
    required this.firstName,
    required this.nextDestination,
    required this.carModel,
    required this.carColor,
    required this.plateNumber,
    required this.availableSeats,
    required this.reservedSeats,
    required this.rating,
    required this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: ContentBox(
        firstName: firstName,
        nextDestination: nextDestination,
        carModel: carModel,
        carColor: carColor,
        plateNumber: plateNumber,
        availableSeats: availableSeats,
        reservedSeats: reservedSeats,
        rating: rating,
        onConfirm: onConfirm,
      ),
    );
  }
}

class ContentBox extends StatelessWidget {
  final String firstName;
  final String nextDestination;
  final String carModel;
  final String carColor;
  final String plateNumber;
  final String availableSeats;
  final String reservedSeats;
  final double rating;
  final VoidCallback onConfirm;

  const ContentBox({
    super.key,
    required this.firstName,
    required this.nextDestination,
    required this.carModel,
    required this.carColor,
    required this.plateNumber,
    required this.availableSeats,
    required this.reservedSeats,
    required this.rating,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildInfoRow(Icons.location_on,
                    AppStrings.nextDestination.tr(), nextDestination),
                _buildInfoRow(
                    Icons.directions_car, AppStrings.carModel.tr(), carModel),
                _buildInfoRow(
                    Icons.color_lens, AppStrings.carColor.tr(), carColor),
                _buildInfoRow(Icons.confirmation_number,
                    AppStrings.plateNumber.tr(), plateNumber),
                _buildInfoRow(Icons.event_seat, AppStrings.seatsAvailable.tr(),
                    availableSeats),
                _buildInfoRow(
                    Icons.people, AppStrings.reservedSeats.tr(), reservedSeats),
              ],
            ),
          ),
          _buildButtons(context),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ColorManager.primary,
        borderRadius:
            const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 40, color: ColorManager.primary),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  firstName,
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 5),
                RatingBar.builder(
                  initialRating: rating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 20,
                  itemPadding:
                      const EdgeInsets.symmetric(horizontal: 1.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    // Handle rating update if needed
                  },
                  ignoreGestures: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String key, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: ColorManager.primary, size: 24),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(key,
                    style: TextStyle(
                        fontSize: 14, color: Colors.grey[600])),
                const SizedBox(height: 2),
                Text(value,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              onPressed: onConfirm,
              child: Text(
                AppStrings.book.tr(),
                style: getSemiBoldStyle(
                    color: ColorManager.white,
                    fontSize: FontSize.s18.sp),
              ),
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: ColorManager.error,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: BorderSide(color: ColorManager.error),
              ),
              padding: const EdgeInsets.symmetric(
                  vertical: 15, horizontal: 20),
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              AppStrings.cancel.tr(),
              style: getSemiBoldStyle(
                  color: ColorManager.error,
                  fontSize: FontSize.s18.sp),
            ),
          ),
        ],
      ),
    );
  }
}

class BuildInfoRow extends StatelessWidget {
  final IconData icon;
  final String keyText;
  final String valueText;

  const BuildInfoRow(
      {super.key,
      required this.icon,
      required this.keyText,
      required this.valueText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: ColorManager.primary, size: 24),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              keyText,
              style: TextStyle(
                  fontSize: 16.sp, color: Colors.grey[800]),
            ),
          ),
          Text(
            valueText,
            style: TextStyle(
                fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
