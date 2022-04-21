import 'package:find_track_app/favorites/favorites_page.dart';
import 'package:find_track_app/home/bloc/home_page_bloc.dart';
import 'package:find_track_app/login/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:avatar_glow/avatar_glow.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomePageBloc, HomePageState>(
        builder: ((context, state) {
          if (state is HomePageEmptyState) {
            return const Home(
              searching: false,
              text: 'Toque para escuchar',
            );
          }
          if (state is HomePageSearchingState) {
            return Home(searching: true, text: "Escuchando...");
          }
          if (state is HomePageFavoritesState) {
            return FavoritesPage(
              songs: state.data,
            );
          }
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }),
        listener: (context, state) {});
  }
}

class Home extends StatelessWidget {
  const Home({
    Key? key,
    required this.searching,
    required this.text,
  }) : super(key: key);

  final bool searching;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(child: Text(text)),
        Center(
          child: AvatarGlow(
            endRadius: MediaQuery.of(context).size.width * 0.4,
            animate: searching,
            glowColor: Theme.of(context).colorScheme.primary,
            showTwoGlows: true,
            child: GestureDetector(
              onTap: () {
                BlocProvider.of<HomePageBloc>(context)
                    .add(HomePageSearchEvent());
              },
              child: CircleAvatar(
                backgroundColor: Colors.black54,
                radius: MediaQuery.of(context).size.width * 0.2,
                backgroundImage: AssetImage("assets/icons/app_icon.png"),
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              iconSize: 40,
              tooltip: "My favorites",
              onPressed: () {
                BlocProvider.of<HomePageBloc>(context)
                    .add(HomePageFavoritesEvent());
              },
              icon: Icon(Icons.favorite),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.05,
            ),
            IconButton(
                iconSize: 40,
                tooltip: "Log out",
                onPressed: () => showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => LogOutAlertDialog(),
                    ),
                icon: Icon(Icons.cancel))
          ],
        )
      ],
    ));
  }
}

class LogOutAlertDialog extends StatelessWidget {
  const LogOutAlertDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Log Out'),
      content: const Text(
          'If you choose to log out you will be redirected to the log In page. Do you want to continue?'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, 'continue');
            BlocProvider.of<AuthBloc>(context).add(SignOutEvent());
          },
          child: const Text('log out'),
        ),
      ],
    );
  }
}
