import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:foto_share/content/disabled/bloc/pending_bloc.dart';
import 'package:foto_share/content/disabled/item_disabled.dart';

class OnWait extends StatelessWidget {
  const OnWait({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PendingBloc, PendingState>(
      listener: (context, state) {
        if (state is PendingUpdateState) {
          BlocProvider.of<PendingBloc>(context)
              .add(GetAllDisabledPicturesEvent());
        }
      },
      builder: (context, state) {
        if (state is PendingLoadingState) {
          return ListView.builder(
            itemCount: 25,
            itemBuilder: (BuildContext context, int index) {
              return YoutubeShimmer();
            },
          );
        }
        if (state is PendingEmptyState) {
          return Center(child: Text("No hay datos por mostrar"));
        }
        if (state is PendingSuccessState) {
          return ListView.builder(
            itemCount: state.myDisabledData.length,
            itemBuilder: (BuildContext context, int index) {
              return item_disabled(nonPublicFData: state.myDisabledData[index]);
            },
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
