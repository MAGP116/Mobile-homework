import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'bloc/auth_bloc.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FractionallySizedBox(
            widthFactor: 1,
            heightFactor: 1,
            child: Image.asset(
              'assets/icons/giphy.webp',
              fit: BoxFit.fitHeight,
            ),
          ),
          Container(
            color: Color.fromARGB(175, 0, 0, 0),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView(
              children: [
                Text(
                  "Sign In",
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                ),
                Image.asset(
                  "assets/icons/app_icon.png",
                  height: MediaQuery.of(context).size.width * 0.3,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
                ),
                MaterialButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(FontAwesomeIcons.google),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Iniciar con Google"),
                    ],
                  ),
                  color: Colors.red,
                  onPressed: () {
                    BlocProvider.of<AuthBloc>(context).add(GoogleAuthEvent());
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
