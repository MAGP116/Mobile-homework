import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:foto_share/content/for_u/bloc/for_u_bloc.dart';
import 'package:foto_share/content/for_u/shared_item.dart';

class PicturesForU extends StatelessWidget {
  const PicturesForU({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForUBloc, ForUState>(
        builder: ((context, state) {
          if (state is ForULoadingState) {
            return ListView.builder(
              itemCount: 25,
              itemBuilder: (BuildContext context, int index) {
                return YoutubeShimmer();
              },
            );
          }
          if (state is ForUSuccessState) {
            return ListView.builder(
              itemCount: state.data.length,
              itemBuilder: (BuildContext context, int index) =>
                  SharedItem(itemData: state.data[index]),
            );
          }
          if (state is ForUEmptyState) {
            return Center(
              child: Text("Sin recomendaciones por ahora"),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        }),
        listener: (context, state) {});
  }
}
