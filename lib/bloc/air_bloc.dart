import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

import '../model/air_result.dart';

class AirBolc {
  final _airSubject = BehaviorSubject<AirResult>();

  AirBolc() {
    fetch();
  }

  Future<AirResult> getResult() async {
    var url = Uri.parse(
        'https://api.airvisual.com/v2/nearest_city?key=fc8e7a65-6fae-40d8-b916-aae4230b03c9');
    var response = await http.get(url);

    //expect(response.statusCode, 200);
    //print(response);

    AirResult result = await AirResult.fromJson(json.decode(response.body));
    print(result.status);
    return result;
  }

  void fetch() async {
    var airResult = await getResult();
    _airSubject.add(airResult);
  }

  Stream<AirResult> get airResult => _airSubject.stream;
}
