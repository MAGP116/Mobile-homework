import 'package:find_track_app/home/general_alert_dialog.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:find_track_app/home/bloc/home_page_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class FavoritesPage extends StatelessWidget {
  final List<Map<String, dynamic>> songs;
  const FavoritesPage({Key? key, required this.songs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Songs'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            BlocProvider.of<HomePageBloc>(context).add(HomePageToHomeEvent());
          },
        ),
      ),
      body: songs.length != 0
          ? ListView.builder(
              itemCount: songs.length,
              itemBuilder: (BuildContext context, int index) =>
                  SongCard(song: songs[index]))
          : Center(child: Text("There is no favorite song yet")),
    );
  }
}

class SongCard extends StatelessWidget {
  const SongCard({
    Key? key,
    required this.song,
  }) : super(key: key);

  final Map<String, dynamic> song;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Stack(
        children: [
          GestureDetector(
            onTap: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => GeneralAlertDialog(
                  title: 'Open Song',
                  submit: 'continue',
                  content:
                      'You are going to be redirected to a list of song options. Do you want to continue?',
                  onSubmit: () async {
                    await launch(song['songUrl']);
                  }),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(song["imageUrl"]),
                ),
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Color(Theme.of(context).colorScheme.primary.value +
                        0xDD000000),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                      topRight: Radius.circular(64),
                    ),
                  ),
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          song["title"],
                          style: TextStyle(fontSize: 32),
                        ),
                      ),
                      Center(
                        child: Text(song['artist']),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          IconButton(
              tooltip: "Remove from favorite",
              onPressed: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => GeneralAlertDialog(
                      title: 'Remove Song',
                      submit: 'continue',
                      content:
                          'This Song is going to be removed from your favorite list. Do you want to continue?',
                      onSubmit: () {
                        BlocProvider.of<HomePageBloc>(context).add(
                          HomePageRemoveSongEvent(song["id"]),
                        );
                      },
                    ),
                  ),
              icon: Icon(Icons.favorite)),
        ],
      ),
    );
  }
}
