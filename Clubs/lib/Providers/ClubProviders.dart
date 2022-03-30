import 'dart:convert';
import 'package:club/Models/Club.dart';
import 'package:club/Models/Response.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';

class ClubsProvider extends ChangeNotifier {
  Response request = new Response();
  final String _host = 'http://clubsapi.somee.com';
  //final Map<String, dynamic> _parameters = {'key':'960d9f80'};
  // ignore: non_constant_identifier_names
  ClubProvider() {
    fetchetiqueta();
  }

  fetchetiqueta() async {
    const String endPoint = '/api/Club';
    final url = Uri.http(_host, endPoint);
    final client = RetryClient(http.Client());

    try {
      final response = await client.read(url);
      notifyListeners();
      // ignore: avoid_print
      print(response);
      request = decode(json.decode(response));
    } finally {
      client.close();
    }
  }

  decode(Map<String, dynamic> json) => Response(
        exito: json["exito"],
        mensaje: json["mensaje"],
        data: List<Club>.from(json["data"].map((x) => Club.fromJson(x))),
      );

  Map<String, dynamic> encode(Response object) => {
        "exito": object.exito,
        "mensaje": object.mensaje,
        "data": object.data?.map((x) => x.toJson())
      };
}
