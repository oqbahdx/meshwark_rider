

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:meshwark_rider/data/network/dio_helper.dart';

class TestApi extends StatelessWidget {
  const TestApi({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title:const Text("test apis"),),
      floatingActionButton: FloatingActionButton(
        onPressed: ()async{
          DioHelper.postData(endPoint: "/save-rider-trip", data: {
            "trip_number":12,
            "day":14,
            "time":"2:30 PM",
            "month":7,
            "start_point":"riyadh",
            "end_point":"jeddah",
            "rider_id":2,
          }).then((value){
            if (kDebugMode) {
             
            }
          }).catchError((error){
            if (kDebugMode) {
             
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
