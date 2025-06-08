// import 'package:flutter_test/flutter_test.dart';
// import 'package:http/http.dart' as http;
// import 'package:meshwark_rider/presentation/bloc/cubit.dart';
// import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';
// import 'login_test.mocks.dart';
//
//
// @GenerateMocks([http.Client])
// void main() {
//   group("login", () {
//     test("make sure login function response true", () async {
//       // final client = MockClient();
//       when(client.post(Uri.parse('https://meshwark.mocklab.io/rider/login'),body: {
//         "number":"0115661911",
//         "password":"12345678"
//       }))
//           .thenAnswer((_) async =>
//           http.Response(
//               '{"status":0,"message":"you have been added your profile successfully","data":{"id":"1","first_name":"oqbah","middle_name":"ahmed","last_name":"dx","number":"0115661911","have_profile":1,"image_profile":""}}',
//               200));
//       ;
//       test('throws an exception if the http call completes with an error', () {
//         final client = MockClient();
//
//
//         when(client
//             .get(Uri.parse('https://meshwark.mocklab.io/rider/login')))
//             .thenAnswer((_) async => http.Response('Not Found', 404));
//          // expect(, throwsException);
//
//       });
//     });
//   });
// }