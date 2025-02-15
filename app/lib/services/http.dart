import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:susya/authentication/auth_class.dart';

Future<dynamic> sendToPredictor(imagePath) async {
  final imageBytes = File(imagePath).readAsBytesSync();
  String imageBase64 = base64Encode(imageBytes);
  print(imageBase64);
  var dio = Dio();

  final response = await dio
      .post("https://susya.onrender.com/", data: {
    'image': imageBase64,
  });

  // final String plant = response.data['plant'];
  // final String disease = response.data['disease'];

  // final result = {'plant': plant, 'disease': disease};

  return response.data;
}

sendAlerts({plant, disease, username}) async {
  final User user = Authentication.getCurrentUser();
  var dio = Dio();

  final response = await dio.post(
      "https://susya.onrender.com/notification",
      data: {'plant': plant, 'disease': disease, 'user': user.displayName});

  // final String plant = response.data['plant'];
  // final String disease = response.data['disease'];

  // final result = {'plant': plant, 'disease': disease};

  return response.data;
}
