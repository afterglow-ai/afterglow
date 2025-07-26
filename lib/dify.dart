import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

Future<String?> getPersonShort(String name) async {
  try {
    final data = await Dio().post(
      'https://api.dify.ai/v1/workflows/run',
      data: {
        'inputs': {"name": name},
        'user': 'abc-123',
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer app-4AND1s3ajEeX2KLsU118F2MD',
          'Content-Type': 'application/json',
        },
      ),
    );

    if (data.statusCode == 200) {
      final text = data.data["data"]["outputs"]["text"];
      return text;
    } else {
      debugPrint('Request failed with status: ${data.statusCode}');
    }
  } catch (e) {
    debugPrint('Request failed: $e');

    return null;
  }
  return null;
}
