import 'dart:convert';

import 'package:digital_couture_ui/main.dart';
import 'package:digital_couture_ui/models/MODELE/model.dart';
import 'package:digital_couture_ui/utils/classes/end-points.class.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ModeleService {
  static final options = BaseOptions(
      connectTimeout: 1000000,
      headers: <String, String>{"Content-Type": "application/json"});
  static final dio = Dio(options);
 
  static dynamic modele(Map<String, dynamic> modelePayload) async {
    var payload = json.encode(modelePayload);
    print(payload);
    try {
      final response = await dio.post<String>(EndPoints.MODELE, data: payload);
      String serveranswer = "${response.data}";
      print(serveranswer);

      final decodedAnswer = jsonDecode(serveranswer);

      dynamic nom = decodedAnswer["nom"];
      dynamic description = decodedAnswer["description"];
      dynamic prix = decodedAnswer["prix"];
      dynamic avance_obligatoire = decodedAnswer["avance_obligatoire"];
      dynamic delai_livraison = decodedAnswer["delai_livraison"];

      dynamic image_model = decodedAnswer["image_model"];
      ;

      print(nom);
      final result = DigitalCoutureApp();

      result.storage.setItem('nom', nom);
      result.storage.setItem('description', description);
      result.storage.setItem('prix', prix);
      result.storage.setItem('avance_obligatoire', avance_obligatoire);
      result.storage.setItem('delai_livraison', delai_livraison);


      return decodedAnswer;
    } catch (error) {
      print(error);
      return error;
    }
  }
 
 
 Future<List<Modele>>? _fetchModels() async {
 final response = await dio.get<String>(EndPoints.MODELE);

  if (response.statusCode == 200) {
    List jsonResponse = jsonDecode(response.data);

    return jsonResponse.map((modele) => new Modele.fromJson(modele)).toList();
  } else {
    throw Exception('Failed to load jobs from API');
  }
} 

  @override
  void initState() {
    super.initState();
    futureData = _fetchJobs();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter API and ListView Example',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter ListView'),
        ),
        body: Center(
          child: FutureBuilder<List<Modele>>(
            future: _fetchJobs(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Modele> modele = snapshot.requireData;
                return ListView.builder(
                    itemCount: modele.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        height: 75,
                        color: Colors.white,
                        child: Center(
                          child: Text(modele[index].nom),
                        ),
                      );
                    });
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              // By default show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}





}


