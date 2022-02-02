import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calcular IMC',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green)),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Gender _gender = Gender();

  var _controller_height = TextEditingController();
  var _controller_weight = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context),
      child: Scaffold(
          appBar: AppBar(
            title: Text('Calcular IMC'),
            actions: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      _controller_height.clear();
                      _controller_weight.clear();
                      _gender.Clear();
                    });
                  },
                  icon: Icon(Icons.delete))
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Text("Ingrese sus datos para calcular el IMC"),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            _gender.setGender(true);
                          });
                        },
                        icon: _gender.femaleIcon),
                    SizedBox(
                      width: 16.0,
                    ),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            _gender.setGender(false);
                          });
                        },
                        icon: _gender.maleIcon),
                  ],
                ),
                TextField(
                  controller: _controller_height,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Ingresar altura (Metros)",
                      icon: Icon(Icons.square_foot)),
                  keyboardType: TextInputType.number,
                  onChanged: (val) {
                    setState(() {});
                  },
                  onSubmitted: (val) {
                    setState(() {});
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _controller_weight,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Ingresar peso (KG)",
                      icon: Icon(Icons.monitor_weight)),
                  keyboardType: TextInputType.number,
                  onChanged: (val) {
                    setState(() {});
                  },
                  onSubmitted: (val) {
                    setState(() {});
                  },
                ),
                Center(
                  child: CalcularButton(
                      height_text: _controller_height.text,
                      weight_text: _controller_weight.text,
                      gender: _gender),
                )
              ],
            ),
          )),
    );
  }
}

class CalcularButton extends StatelessWidget {
  const CalcularButton(
      {Key? key,
      required this.height_text,
      required this.weight_text,
      required this.gender})
      : super(key: key);

  final String height_text;
  final String weight_text;
  final Gender gender;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              // ignore: deprecated_member_use
              double? height;
              double? weight;
              try {
                weight = double.parse(weight_text);
              } catch (e) {
                weight = null;
              }
              try {
                height = double.parse(height_text);
              } catch (e) {
                height = null;
              }

              return (gender.gender != null && height != null && weight != null)
                  ? AlertDialogCalculation(
                      height: height, weight: weight, gender: gender)
                  : AlertDialogMiss(
                      height_value: height,
                      weight_value: weight,
                      gender: gender);
            });
      },
      child: Text(
        "Calcular",
        style: TextStyle(color: Colors.black87),
      ),
    );
  }
}

class AlertDialogCalculation extends StatelessWidget {
  const AlertDialogCalculation({
    Key? key,
    required this.height,
    required this.weight,
    required this.gender,
  }) : super(key: key);

  final double? height;
  final double? weight;
  final Gender gender;
  final String _tableIMCWomen = "Tabla de IMC de mujeres:\n\n" +
      "Edad\t\tIMC ideal\n" +
      "16-17\t\t19-24\n" +
      "18-18\t\t19-24\n" +
      "19-24\t\t19-24\n" +
      "25-34\t\t20-25\n" +
      "35-44\t\t21-26\n" +
      "45-54\t\t22-27\n" +
      "55-64\t\t23-28\n" +
      "65-90\t\t25-30";
  final String _tableIMCmen = "Tabla de IMC de hombres:\n\n" +
      "Edad\t\tIMC ideal\n" +
      "16-17\t\t19-24\n" +
      "18-18\t\t19-24\n" +
      "19-24\t\t19-24\n" +
      "25-34\t\t20-25\n" +
      "35-44\t\t21-26\n" +
      "45-54\t\t22-27\n" +
      "55-64\t\t23-28\n" +
      "65-90\t\t25-30";

  @override
  Widget build(BuildContext context) {
    var imc = weight! / (height! * height!);
    return AlertDialog(
        title: Text("Tu IMC es: " + imc.toStringAsFixed(2)),
        content: Text(gender.gender == true ? _tableIMCWomen : _tableIMCmen),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'aceptar'),
            child: const Text('aceptar'),
          )
        ]);
  }
}

class AlertDialogMiss extends StatelessWidget {
  const AlertDialogMiss({
    Key? key,
    required this.height_value,
    required this.weight_value,
    required this.gender,
  }) : super(key: key);

  final double? height_value;
  final double? weight_value;
  final Gender gender;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text("Datos incompletos"),
        content: Text((height_value == null ? "Hace falta altura\n" : "") +
            (weight_value == null ? "Hace falta peso\n" : "") +
            (gender.gender == null ? "Hace falta genero" : "")),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'aceptar'),
            child: const Text('aceptar'),
          )
        ]);
  }
}

class Gender {
  bool? gender = null; //male false, female true
  Icon maleIcon = Icon(Icons.male, color: Colors.black);
  Icon femaleIcon = Icon(Icons.female, color: Colors.black);

  void setGender(bool gender) {
    this.gender = gender;
    maleIcon =
        Icon(Icons.male, color: (!(gender)) ? Colors.blue : Colors.black);
    femaleIcon =
        Icon(Icons.female, color: (gender) ? Colors.blue : Colors.black);
  }

  void Clear() {
    gender = null;
    maleIcon = Icon(Icons.male, color: Colors.black);
    femaleIcon = Icon(Icons.female, color: Colors.black);
  }
}
