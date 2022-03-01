import 'package:backdrop/backdrop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:typed_data';
import '../bloc/loading_bloc.dart';
import 'country_tile.dart';
import 'motivational_content.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<LoadingBloc>(context).add(
      LoadingSentenceEvent(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BackdropScaffold(
      appBar: BackdropAppBar(
        title: Text("La frase diaria"),
        actions: const <Widget>[
          BackdropToggleButton(
            icon: AnimatedIcons.list_view,
          )
        ],
      ),
      stickyFrontLayer: true,
      backLayer: Container(
        width: MediaQuery.of(context).size.width,
        child: BlocConsumer<LoadingBloc, LoadingState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is LoadingFullState) {
              return Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                        color: Colors.white60,
                      ),
                    ]),
              );
            }
            if (state is LoadingDisplayMediaState) {
              return createCountryTile(context, state.countries);
            }
            if (state is LoadingUpdateMediaState) {
              return createCountryTile(context, state.countries);
            }

            return Text("ERROR STATE");
          },
        ),
      ),
      frontLayer: BlocConsumer<LoadingBloc, LoadingState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          if (state is LoadingFullState || state is LoadingUpdateMediaState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is LoadingErrorState) {
            return Text("Error: ${state.errorMsg}");
          }

          if (state is LoadingDisplayMediaState) {
            return createMotivationalContent(
              context: context,
              image: state.image,
              country: state.country,
              time: state.time,
              quote: state.sentence[0]["q"],
              author: state.sentence[0]["a"],
            );
          }
          return Text("ERROR: STATE UNKNOWN");
        },
      ),
    );
  }
}
