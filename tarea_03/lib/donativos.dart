import 'package:flutter/material.dart';

class Donativos extends StatelessWidget {
  final Map<String, double> donations;
  const Donativos({
    Key? key,
    required this.donations,
  }) : super(key: key);

  ListTileGenerator() {
    var t = donations.entries.map<Widget>((e) {
      if (e.key == "acumulado") {
        return Divider(
          thickness: 5,
        );
      }
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: Image.asset('assets/${e.key}.png'),
          trailing: Text(
            "${e.value}",
            style: TextStyle(fontSize: 32),
          ),
        ),
      );
    }).toList();

    t.add(
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: Icon(
            Icons.monetization_on_outlined,
            size: 50,
          ),
          trailing: Text(
            "${donations["acumulado"]}",
            style: TextStyle(fontSize: 32),
          ),
        ),
      ),
    );
    if (donations["acumulado"]! >= 10000) {
      t.add(Image.asset("assets/thank_you.png"));
    }
    return t;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Donativos obtenidos"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: ListTileGenerator()),
      ),
    );
  }
}
