import 'package:examen_01/bloc/loading_bloc.dart';
import 'package:examen_01/home_page/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: BlocProvider(
        create: (context) => LoadingBloc(),
        child: HomePage(),
      ),
    );
  }
}
