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

  double dolar;
  double euro;

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
                      TextField(
                        decoration: InputDecoration(
                          labelText: "Dólares",
                          labelStyle: TextStyle(color: Colors.amber),
                          border: OutlineInputBorder(),
                          prefixText: "US\$"
                        ),
                        style: TextStyle(color: Colors.amber, fontSize: 25.0)
                      ),
                      Divider(),
                      TextField(
                        decoration: InputDecoration(
                          labelText: "Reais",
                          labelStyle: TextStyle(color: Colors.amber),
                          border: OutlineInputBorder(),
                          prefixText: "R\$"
                        ),
                        style: TextStyle(color: Colors.amber, fontSize: 25.0)
                      ),
                      Divider(),
                      TextField(
                        decoration: InputDecoration(
                          labelText: "Euros",
                          labelStyle: TextStyle(color: Colors.amber),
                          border: OutlineInputBorder(),
                          prefixText: "€"
                        ),
                        style: TextStyle(color: Colors.amber, fontSize: 25.0)
                      )
                    ],
                  )
                );
              }
          }
        }),
    );
  }
}