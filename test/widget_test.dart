// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';

import 'package:flutter_project/model/air_result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

void main() {
  test('http 통신 테스트', () async {
    var url = Uri.parse(
        'https://api.airvisual.com/v2/nearest_city?key=fc8e7a65-6fae-40d8-b916-aae4230b03c9');
    var response = await http.get(url);

    //expect(response.statusCode, 200);
    //print(response);

    AirResult result = await AirResult.fromJson(json.decode(response.body));
    print(result.status);
    expect(result.status, 'sucess');
  });
}
