import 'package:find_track_app/home/bloc/home_page_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../general_alert_dialog.dart';

class SongPage extends StatelessWidget {
  const SongPage({Key? key, required this.data}) : super(key: key);

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Song Found'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            BlocProvider.of<HomePageBloc>(context).add(HomePageToHomeEvent());
          },
        ),
        actions: [
          IconButton(
            onPressed: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => GeneralAlertDialog(
                title: 'Add to favorites',
                submit: 'continue',
                content:
                    'This Song is going to be added to your favorite list. Do you want to continue?',
                onSubmit: () {
                  BlocProvider.of<HomePageBloc>(context).add(
                    HomePageAddSongEvent(data),
                  );
                },
              ),
            ),
            tooltip: 'Add to favorites',
            icon: Icon(Icons.favorite),
          ),
        ],
      ),
      body: ListView(
        children: [
          Image.network(data['image_url']),
          SizedBox(
            height: 50,
          ),
          Center(
              child: Text(
            data['title'],
            style: TextStyle(fontSize: 32),
          )),
          Center(
              child: Text(
            data['album'],
            style: TextStyle(fontSize: 24),
          )),
          Center(
            child: Text(
              data['artist'],
            ),
          ),
          Center(
            child: Text(
              data['release_date'],
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Divider(),
          Center(
            child: Text('Open with:'),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  tooltip: 'Listen in Spotify',
                  onPressed: () async {
                    await launch(data['spotify_url']);
                  },
                  icon: FaIcon(FontAwesomeIcons.spotify, size: 48),
                ),
                IconButton(
                  onPressed: () async {
                    await launch(data['song_url']);
                  },
                  icon: FaIcon(FontAwesomeIcons.towerBroadcast, size: 48),
                ),
                IconButton(
                  tooltip: 'listen in Apple music',
                  onPressed: () async {
                    await launch(data['apple_url']);
                  },
                  icon: FaIcon(FontAwesomeIcons.apple, size: 48),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
