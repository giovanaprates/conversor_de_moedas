import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
//import "package:async/async.dart"; //Ela vai nos permitir fazer requisições sem ter que ficar esperando por elas. Não trava o progama.
import "dart:convert";

//const request = "https://api.hgbrasil.com/finance/stock_price?key=f6c57415"; //link que peguei errado
const request = "https://api.hgbrasil.com/finance?format=json&?key=f6c57415";

void main() async { //esta função é assíncrona graças ao async

  http.Response response = await http.get(request); //await espera os dados chegarem
  //print(json.decode(response.body)); //colocando o json, ele não está mais printando uma string mas sim um mapa
  //print(json.decode(response.body)["results"]);//mostra apenas o que está em results
  print(json.decode(response.body)["results"]["currencies"]["USD"]);//mostra o que está dentro de USD que entá em currencies que está dentro do results

  runApp(MaterialApp(
    home: Container(),
  ));
}
