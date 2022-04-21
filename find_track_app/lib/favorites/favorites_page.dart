import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:find_track_app/home/bloc/home_page_bloc.dart';

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
          Container(
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
                  color: Color(
                      Theme.of(context).colorScheme.primary.value + 0xAA000000),
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
          IconButton(
              tooltip: "Remove from favorite",
              onPressed: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) =>
                        RemoveFavotiteDialog(id: song["id"]),
                  ),
              icon: Icon(Icons.favorite)),
        ],
      ),
    );
  }
}

class RemoveFavotiteDialog extends StatelessWidget {
  final String id;
  const RemoveFavotiteDialog({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Remove Song'),
      content: const Text(
          'This Song is going to be removed from your favorite list. Do you want to continue?'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, 'continue');
            BlocProvider.of<HomePageBloc>(context)
                .add(HomePageRemoveSongEvent(id));
          },
          child: const Text('continue'),
        ),
      ],
    );
  }
}
