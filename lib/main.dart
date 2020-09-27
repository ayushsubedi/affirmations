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

class AffirmationsApp extends StatefulWidget{
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
      title: 'Update Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Update Data Example'),
        ),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder<AffirmationsModel>(
            future: _futureAffirmationsModel,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(snapshot.data.affirmation),
                      RaisedButton(
                        child: Text('Update Data'),
                        onPressed: () {
                          setState(() {
                            _futureAffirmationsModel = fetchAffirmations();
                          });
                        },
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
              }

              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }

}
