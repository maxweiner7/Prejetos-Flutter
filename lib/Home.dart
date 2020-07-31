import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<Map> _recuperaPreco() async {
    String url = "https://economia.awesomeapi.com.br/json/all";
    http.Response response = await http.get(url);
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map>(
      future: _recuperaPreco(),
      builder: (context, snapshot) {
        String resultado;
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            print("Waiting for connection");
            resultado = "Processando..";
            break;
          case ConnectionState.done:
            print("Connection done");
            if (snapshot.hasError) {
              resultado = "Error loading data";
            } else {
              String valor = snapshot.data["USD"]["high"];
              resultado = "R\$ ${valor}";
              print("R\$ ${valor}");
            }
            break;
        }
        return Scaffold(
            appBar: GradientAppBar(
                title: Text("Preço Dolar",
                style: TextStyle(
                  fontFamily: "Lobster",
                  fontSize: 30
                ),),
                gradient: LinearGradient(
                    colors: [Colors.red, Colors.purple, Colors.blue])),
            body: Center(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/color.jpg"),
                    fit: BoxFit.cover,
                  )
                ),
                  alignment: Alignment(0.0, 0.0),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Cotação Dólar Americano:",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        resultado,
                        style: TextStyle(
                          color: Color.fromRGBO(69, 184, 177, 1),
                          fontSize: 40,
                        ),
                      ),
                      FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              side: BorderSide(color: Colors.red)),
                          color: Colors.black12,
                          child: Text(
                            "Atulizar",
                            style: TextStyle(
                              fontSize: 25,
                              fontFamily: "Lobster",
                            ),
                          ),
                          textColor: Colors.red,
                          padding: EdgeInsets.all(8.0),
                          onPressed: () {
                            setState(() {
                              _recuperaPreco();
                            });
                          })
                    ],
                  )),
            ));
      },
    );

    return Container();
  }
}
