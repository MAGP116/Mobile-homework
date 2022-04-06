import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foto_share/content/add/add_post.dart';
import 'package:foto_share/content/disabled/on_wait.dart';
import 'package:foto_share/content/for_u/bloc/for_u_bloc.dart';
import 'package:foto_share/content/for_u/pictures_for_u.dart';
import 'package:foto_share/content/my_pictures/my_content.dart';

import '../content/add/bloc/add_bloc.dart';
import '../content/disabled/bloc/pending_bloc.dart';
import '../content/my_pictures/bloc/my_pictures_bloc.dart';
import '../login/bloc/auth_bloc.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPageIndex = 0;
  final List<Widget> _pagesList = [
    PicturesForU(),
    OnWait(),
    MyContent(),
    AddPost(),
  ];

  final List<String> _pagesNameList = [
    "Fotos 4U",
    "En espera",
    "Mi contenido",
    "Agregar",
  ];

  final List<Function> _events = [
    (context) {
      BlocProvider.of<ForUBloc>(context).add(ForUGetAllPicturesEvent());
    },
    (context) {
      BlocProvider.of<PendingBloc>(context).add(GetAllDisabledPicturesEvent());
    },
    (context) {
      BlocProvider.of<MyPicturesBloc>(context).add(GetAllPicturesEvent());
    },
    (context) {
      BlocProvider.of<AddBloc>(context).add(AddInitEvent());
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pagesNameList[_currentPageIndex]),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              BlocProvider.of<AuthBloc>(context).add(SignOutEvent());
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentPageIndex,
        children: _pagesList,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentPageIndex,
        onTap: (index) {
          // Respond to item press.
          setState(() {
            _currentPageIndex = index;
            _events[_currentPageIndex](context);
          });
        },
        items: [
          BottomNavigationBarItem(
            label: _pagesNameList[0],
            icon: Icon(Icons.view_carousel),
          ),
          BottomNavigationBarItem(
            label: _pagesNameList[1],
            icon: Icon(Icons.query_builder),
          ),
          BottomNavigationBarItem(
            label: _pagesNameList[2],
            icon: Icon(Icons.photo_camera),
          ),
          BottomNavigationBarItem(
            label: _pagesNameList[3],
            icon: Icon(Icons.library_books),
          ),
        ],
      ),
    );
  }
}
