import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:meshwark_rider/app/app_pref.dart';
import 'package:meshwark_rider/app/constants.dart';
import 'package:meshwark_rider/app/di.dart';

import 'package:meshwark_rider/presentation/bloc/add_profile/add_profile_cubit.dart';

import 'package:meshwark_rider/presentation/bloc/login_bloc/login_cubit.dart';
import 'package:meshwark_rider/presentation/bloc/map_bloc/map_cubit.dart';
import 'package:meshwark_rider/presentation/bloc/notification_bloc/notifications_cubit.dart';
import 'package:meshwark_rider/presentation/bloc/profile_bloc/profile_cubit.dart';
import 'package:meshwark_rider/presentation/bloc/register_bloc/register_cubit.dart';
import 'package:meshwark_rider/presentation/bloc/select_gender_bloc/select_gender_cubit.dart';
import 'package:meshwark_rider/presentation/bloc/select_service_bloc/select_service_cubit.dart';
import 'package:meshwark_rider/presentation/bloc/wallet_bloc/wallet_cubit.dart';

import '../driver_hub.dart';
import '../driver_respnose.dart';
import '../map_realTime.dart';
import '../move_hub.dart';
import '../presentation/bloc/trip_history_bloc/trip_history_cubit.dart';
import '../presentation/cancel_trip.dart';
import '../presentation/resources/routes_manager.dart';
import '../presentation/resources/theme_manager.dart';
import '../presentation/rating/rating_view.dart';

import '../presentation/send_data.dart';
import '../presentation/trip_information.dart';

class MyApp extends StatefulWidget {
  const MyApp._internal();

  static const MyApp _instance = MyApp._internal();

  factory MyApp() => _instance; // factory

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppPreferences _appPreferences = instance<AppPreferences>();
  ScrollController scrollController = ScrollController();
  @override
  void didChangeDependencies() {
    _appPreferences.getLocale().then((locale) => {context.setLocale(locale)});
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LoginCubit()),
        BlocProvider(create: (_) => RegisterCubit()),
        BlocProvider(create: (_) => NotificationsCubit()),
        BlocProvider(create: (_) => ProfileCubit()),
        BlocProvider(create: (_) => MapCubit()),
        BlocProvider(create: (_) => TripHistoryCubit()),
        BlocProvider(create: (_) => SelectServiceCubit()),
        BlocProvider(create: (_) => SelectGenderCubit()),
        BlocProvider(create: (_) => WalletCubit()),
        BlocProvider(create: (_) => AddProfileCubit()),
      ],
      child: MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        onGenerateRoute: RouteGenerator.getRoute,
        initialRoute: Constants.isBoarding == 0
            ? Routes.onBoardingRoute
            : Constants.id == ""
                ? Routes.loginRoute
                : Routes.selectServiceRoute,
        // home: CancellationNotificationPage(),

        theme: getApplicationLightTheme(),
      ),
    );
  }
}
