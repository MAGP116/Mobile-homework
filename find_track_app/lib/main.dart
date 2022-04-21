import 'package:find_track_app/home/bloc/home_page_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'login/bloc/auth_bloc.dart';
import 'login/login_page.dart';

import 'home/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => AuthBloc()..add(VerifyAuthEvent()),
      ),
      BlocProvider(
          create: (context) => HomePageBloc()..add(HomePageToHomeEvent())),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Find Track',
      theme:
          ThemeData(brightness: Brightness.dark, primarySwatch: Colors.purple),
      home: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is AuthSuccessState) {
            return HomePage();
          }
          if (state is AuthErrorState || state is AuthSignOutState) {
            return LoginPage();
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
