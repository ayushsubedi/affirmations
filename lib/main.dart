import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'AffirmationsModel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Affirmations',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AffirmationsPage(),
    );
  }
}

class AffirmationsPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<AffirmationsModel>(
          future: getAffirmations(),
          builder: (context, snapshot){
            if (snapshot.hasData){
              final result = snapshot.data;
              return Text("${result.affirmation}");
            }else if(snapshot.hasError){
              return Text(snapshot.error.toString());
            }
            return CircularProgressIndicator();
          },
        )
      )
    );
  }
}


Future <AffirmationsModel> getAffirmations() async{
  final response = await http.get('https://www.affirmations.dev/');
  if (response.statusCode==200){
    final jsonAffirmations = jsonDecode(response.body);
    return AffirmationsModel.fromJson(jsonAffirmations);
  }
  else{
    throw Exception();
  }
}