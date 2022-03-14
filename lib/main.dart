import 'package:flutter/material.dart';
import 'package:flutter_project/bloc/air_bloc.dart';
import 'package:flutter_project/model/air_result.dart';

void main() {
  runApp(const MyApp());
}

final airBloc = AirBolc();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Main(),
    );
  }
}

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: StreamBuilder<AirResult>(
            stream: airBloc.airResult,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return buildBody(snapshot.data!);
              }
              return CircularProgressIndicator();
            }),
      ),
    );
  }

  Widget buildBody(AirResult _result) {
    String ic = _result.data!.current!.weather!.ic!;
    if (ic.contains('n')) {
      var temp = ic.split('n');
      ic = temp[0] + 'd';
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '현재 위치 미세먼지',
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(
              height: 16,
            ),
            Card(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    color: getColor(_result),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          '얼굴사진',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          '${_result.data!.current!.pollution!.aqius}',
                          style: TextStyle(fontSize: 40, color: Colors.white),
                        ),
                        Text(
                          getString(_result),
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            Image.network(
                              'https://airvisual.com/images/${ic}.png',
                              width: 32,
                              height: 32,
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Text(
                              '${_result.data!.current!.weather!.tp}º',
                              style: TextStyle(fontSize: 16),
                            )
                          ],
                        ),
                        Text('습도 ${_result.data!.current!.weather!.hu}%'),
                        Text('풍속 ${_result.data!.current!.weather!.ws}m/s'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 16,
            ),
            //RaisedButton(onPressed: onPressed)
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.deepOrangeAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  onPressed: () {
                    airBloc.fetch();
                  },
                  child: Icon(
                    Icons.refresh,
                    color: Colors.white,
                  )),
            )
          ],
        ),
      ),
    );
  }

  String getString(AirResult data) {
    if (data.data!.current!.pollution!.aqius! < 30) {
      return '매우좋음';
    } else if (data.data!.current!.pollution!.aqius! < 50) {
      return '좋음';
    } else if (data.data!.current!.pollution!.aqius! < 80) {
      return '보통';
    } else if (data.data!.current!.pollution!.aqius! < 100) {
      return '나쁨';
    } else if (data.data!.current!.pollution!.aqius! < 120) {
      return '매우나쁨';
    } else {
      return '최악';
    }
  }

  Color getColor(AirResult data) {
    if (data.data!.current!.pollution!.aqius! < 30) {
      return Colors.blue;
    } else if (data.data!.current!.pollution!.aqius! < 50) {
      return Colors.green;
    } else if (data.data!.current!.pollution!.aqius! < 80) {
      return Colors.yellow;
    } else if (data.data!.current!.pollution!.aqius! < 100) {
      return Colors.deepOrangeAccent;
    } else if (data.data!.current!.pollution!.aqius! < 120) {
      return Colors.red;
    } else {
      return Colors.black;
    }
  }
}
