// import 'package:bloc/bloc.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:meta/meta.dart';

// import '../../resources/color_manager.dart';

// part 'otp_state.dart';

// class OtpCubit extends Cubit<OtpState> {
//   OtpCubit() : super(OtpInitial());
//   Future<void> submitOtp(String otpCode) async {
//     late String verificationId;
//     void codeSent(String verificationId, int? resendToken) {
//       if (kDebugMode) {
//         print("code sent");
//       }
//       this.verificationId = verificationId;
//       emit(OtpSuccessState());
//     }
//     PhoneAuthCredential credential = PhoneAuthProvider.credential(
//         verificationId: verificationId, smsCode: otpCode);
//     await signIn(credential);
//   }

//   Future<void> signIn(PhoneAuthCredential credential) async {
//     try {
//       await FirebaseAuth.instance.signInWithCredential(credential);
//       emit(OtpVerifiedState());
//     } catch (e) {
//       Fluttertoast.showToast(
//           msg: "invalid code 2", backgroundColor: ColorManager.error);
//       emit(OtpErrorState(e.toString()));
//     }
//   }
//   void verificationCompleted(PhoneAuthCredential credential) async {
//     if (kDebugMode) {
//       print("verification Completed");
//     }
//     await signIn(credential);
//   }
// }
// todo : refactor otp cubit