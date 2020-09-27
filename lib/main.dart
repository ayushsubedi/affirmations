import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'AffirmationsModel.dart';

Future<AffirmationsModel> fetchAffirmations() async {
  final response = await http.get('https://www.affirmations.dev/');
  if (response.statusCode == 200) {
    final jsonAffirmations = jsonDecode(response.body);
    return AffirmationsModel.fromJson(jsonAffirmations);
  } else {
    throw Exception('Failed');
  }
}

void main() {
  runApp(AffirmationsApp());
}

class AffirmationsApp extends StatefulWidget {
  AffirmationsApp({Key key}) : super(key: key);

  @override
  _AffirmationsAppState createState() {
    return _AffirmationsAppState();
  }
}

class _AffirmationsAppState extends State<AffirmationsApp> {
  Future<AffirmationsModel> _futureAffirmationsModel;

  @override
  void initState() {
    super.initState();
    _futureAffirmationsModel = fetchAffirmations();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Affirmations',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: Colors.deepPurpleAccent,
          appBar: AppBar(
            title: Text('Affirmations'),
            centerTitle: true,
          ),
          body: Column(children: <Widget>[
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.lightBlueAccent,
              ),
              // width: 300,
              height: 300,
              padding: EdgeInsets.all(20.0),
              margin: EdgeInsets.all(80.0),
              child: FutureBuilder<AffirmationsModel>(
                future: _futureAffirmationsModel,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    return Text(snapshot.data.affirmation,
                        textAlign: TextAlign.center,
                        textScaleFactor: 1.4,
                        style: TextStyle(color: Colors.white));
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return CircularProgressIndicator();
                },
              ),
            ),
            Divider(),
            Container(
              child: RaisedButton(
                onPressed: () {
                  setState(() {
                    _futureAffirmationsModel = fetchAffirmations();
                  });
                },
                textColor: Colors.white,
                padding: const EdgeInsets.all(0.0),
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[
                        Color(0xEEFF1461),
                        Color(0xDDFF1483),
                        Color(0xFFFF1493),
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(30.0),
                  child:
                  const Text('INSPIRE ME', style: TextStyle(fontSize: 15)),
                ),
              ),
            )
          ])),
    );
  }
}
