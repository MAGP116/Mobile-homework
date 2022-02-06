import 'package:flutter/material.dart';
import 'donativos.dart';
import 'dart:math';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _MAXDONATION = 10000;
  Map<String, double> _payments = {
    "Paypal": 0.0,
    "Tarjeta": 0.0,
    "acumulado": 0.0
  };
  String? _payMethod = null;
  var _PaymentMethods = ["Paypal", "Tarjeta"];

  String? _DropDownValue = null;
  var _PaymentsSizes = [100, 350, 850, 1050, 9999];

  radioGroupGenerator() {
    return _PaymentMethods.map((e) => ListTile(
          leading: Image.asset(
            "assets/${e}.png",
            width: 30,
            height: 30,
          ),
          title: Text(
            e,
            style: Theme.of(context).textTheme.bodyText2,
          ),
          trailing: Radio(
            groupValue: _payMethod,
            value: e,
            onChanged: (String? newSelectedRadio) {
              setState(() {
                _payMethod = newSelectedRadio;
              });
            },
          ),
        )).toList();
  }

  DropDownMenuGenerator() {
    return _PaymentsSizes.map<DropdownMenuItem<String>>((int e) {
      return DropdownMenuItem<String>(
        child: Text(e.toString()),
        value: e.toString(),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Donaciones"),
        ),
        body: ListView(children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Es para una buena causa",
                    style: Theme.of(context).textTheme.headline1),
                Text(
                  "Elija modo de donativo",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Container(
                  padding: EdgeInsets.all(16.0),
                  margin: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1),
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    children: this.radioGroupGenerator(),
                  ),
                ),
                ListTile(
                  title: Text("Cantidad a donar"),
                  trailing: DropdownButton<String>(
                    value: _DropDownValue,
                    items: DropDownMenuGenerator(),
                    onChanged: (value) {
                      setState(() {
                        _DropDownValue = value;
                      });
                    },
                  ),
                ),
                LinearProgressIndicator(
                  minHeight: 20,
                  value: _payments["acumulado"]! / _MAXDONATION,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                        "${(min<double>((_payments["acumulado"]! / _MAXDONATION * 100), 100.0)).toStringAsFixed(2)}%"),
                  ),
                ),
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (_payMethod != null && _DropDownValue != null) {
                            _payments[_payMethod!] = _payments[_payMethod!]! +
                                double.parse(_DropDownValue!);
                            _payments["acumulado"] = _payments["acumulado"]! +
                                double.parse(_DropDownValue!);
                          }
                        });
                      },
                      child: Text("Donar"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Donativos(donations: _payments)));
          },
          child: Icon(Icons.arrow_forward),
        ));
  }
}
