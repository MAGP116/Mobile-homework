import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foto_share/content/disabled/bloc/pending_bloc.dart';
import 'package:foto_share/content/for_u/bloc/for_u_bloc.dart';

import 'package:foto_share/content/my_pictures/bloc/my_pictures_bloc.dart';
import 'content/add/bloc/add_bloc.dart';
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
        create: (context) => PendingBloc()..add(GetAllDisabledPicturesEvent()),
      ),
      BlocProvider(
        create: (context) => MyPicturesBloc()..add(GetAllPicturesEvent()),
      ),
      BlocProvider(
        create: (context) => ForUBloc()..add(ForUGetAllPicturesEvent()),
      ),
      BlocProvider(
        create: (context) => AddBloc()..add(AddInitEvent()),
      ),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Foto Share',
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
