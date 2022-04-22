import 'package:find_track_app/home/bloc/home_page_bloc.dart';
import 'package:find_track_app/login/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:avatar_glow/avatar_glow.dart';

import 'Song/song_page.dart';
import 'favorites/favorites_page.dart';
import 'general_alert_dialog.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomePageBloc, HomePageState>(
        builder: ((context, state) {
      if (state is HomePageEmptyState) {
        return const Home(
          searching: false,
          text: 'Tap to listen',
        );
      }
      if (state is HomePageSearchingState) {
        return Home(searching: true, text: "Listenning...");
      }
      if (state is HomePageFavoritesState) {
        return FavoritesPage(
          songs: state.data,
        );
      }
      if (state is HomePageFoundState) {
        return SongPage(data: state.data);
      }
      if (state is HomePageErrorState) {
        return Home(
          searching: false,
          text: state.error,
        );
      }
      if (state is HomePageLoadingState) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }
      return Scaffold();
    }), listener: (context, state) {
      if (state is HomePageMessageState) {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(state.message)));
      }
    });
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
                      builder: (BuildContext context) => GeneralAlertDialog(
                        title: 'Log Out',
                        content:
                            'If you choose to log out you will be redirected to the log In page. Do you want to continue?',
                        onSubmit: () {
                          BlocProvider.of<AuthBloc>(context)
                              .add(SignOutEvent());
                        },
                        submit: 'Log Out',
                      ),
                    ),
                icon: Icon(Icons.cancel))
          ],
        )
      ],
    ));
  }
}
