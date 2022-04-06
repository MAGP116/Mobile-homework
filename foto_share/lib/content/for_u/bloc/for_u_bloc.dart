import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:share_plus/share_plus.dart';
import 'package:image_downloader/image_downloader.dart';

part 'for_u_event.dart';
part 'for_u_state.dart';

class ForUBloc extends Bloc<ForUEvent, ForUState> {
  ForUBloc() : super(ForUInitial()) {
    on<ForUGetAllPicturesEvent>(_getPictures);
  }

  FutureOr<void> _getPictures(event, emit) async {
    emit(ForULoadingState());
    try {
      //Query to get list of pictures
      var queryUser = FirebaseFirestore.instance.collection("fshare");
      //Query to take data from doc
      var docsRef = await queryUser.get();
      List<Map<String, dynamic>> data = docsRef.docs
          .where((doc) => doc.data()["public"])
          .map((doc) => doc.data())
          .toList();
      emit(ForUSuccessState(data: data));
    } catch (e) {
      print(e);
      emit(ForUErrorState());
      emit(ForUEmptyState());
    }
  }
}
