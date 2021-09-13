import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import "dart:async"; //Ela vai nos permitir fazer requisições sem ter que ficar esperando por elas. Não trava o progama.
import "dart:convert";

/*const request = "https://api.hgbrasil.com/finance/stock_price?key=f6c57415";*/ //link que peguei errado
const request = "https://api.hgbrasil.com/finance?format=json&?key=f6c57415";

void main() async { //esta função é assíncrona graças ao async

  /*print(json.decode(response.body)); //colocando o json, ele não está mais printando uma string mas sim um mapa
  print(json.decode(response.body)["results"]);//mostra apenas o que está em results
  print(json.decode(response.body)["results"]["currencies"]["USD"]);*///mostra o que está dentro de USD que entá em currencies que está dentro do results
  /*print(await getData());*/

  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(hintColor: Colors.amber, primaryColor: Colors.grey),
  ));
}

//Função que vai me retornar um dado futuro
Future<Map> getData() async{
  http.Response response = await http.get(request); //await espera os dados chegarem
  return json.decode(response.body);
}

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final realController = TextEditingController(); //Controlador do real
  final dolarController = TextEditingController(); //Controlador do real
  final euroController = TextEditingController(); //Controlador do real

  double dolar;
  double euro;

  void realChanged(String text){
    if(text.isEmpty){
      _clearAll();
      return;
    }
    
    double real = double.parse(text);
    dolarController.text = (real/dolar).toStringAsFixed(2);
    euroController.text = (real/euro).toStringAsFixed(2);
  }
  void dolarChanged(String text){
    if(text.isEmpty){
      _clearAll();
      return;
    }

    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar *this.dolar / euro).toStringAsFixed(2);
  }
  void euroChanged(String text){
    if(text.isEmpty){
      _clearAll();
      return;
    }

    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
  }

  void _clearAll(){ //Apaga o texto de todos os campos
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("\$ Conversor de moedas \$"),backgroundColor: Colors.amber, centerTitle: true,),  //Colocar <\> antes dos símbolos para que sejam interpretados como símbolos.
      body: FutureBuilder<Map>( //Widget que irá conter o mapa recebido do servidor
        future: getData(), //solicita e retorna o futuro
        builder: (context, snapshot){ //Especificar o que será mostrado em cada um dos casos
          switch(snapshot.connectionState){//Verifica qual o status da nossa conexão
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text("Carregando dados...", style: TextStyle(color: Colors.amber, fontSize: 25.0),
                textAlign: TextAlign.center,)
              );
            default: //caso ele tenha obtido alguma coisa
              if(snapshot.hasError){ //indicando o erro
                return Center(
                  child: Text("Erro ao carregar dados! :/", style: TextStyle(color: Colors.amber, fontSize: 25.0),
                  textAlign: TextAlign.center,)
                );
              }
              else{ //se não tiver erro
                dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];

                return SingleChildScrollView( //Campo que dá para rolar a tela p/ o teclado não cobrir nada
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(Icons.monetization_on, size:150.0, color: Colors.amber),
                      Divider(),
                      buildTextField("Dólares", "US\$", dolarController, dolarChanged),
                      Divider(),
                      buildTextField("Reais", "R\$", realController, realChanged),
                      Divider(),
                      buildTextField("Euros", "€", euroController, euroChanged),
                    ],
                  )
                );
              }
          }
        }),
    );
  }
}

Widget buildTextField(String label, String prefix, TextEditingController c, Function f){
  return TextField(
    controller: c,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.amber),
      border: OutlineInputBorder(),
      prefixText: prefix
    ),
    style: TextStyle(color: Colors.amber, fontSize: 25.0),
    onChanged: f,
    keyboardType: TextInputType.number,//vai deixar o teclado apenas numérico
  );
}
