import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'pending_event.dart';
part 'pending_state.dart';

class PendingBloc extends Bloc<PendingEvent, PendingState> {
  PendingBloc() : super(PendingInitial()) {
    on<GetAllDisabledPicturesEvent>(_getDisabledContent);
    on<PendingEnablePictureEvent>(_publishPicture);
  }

  FutureOr<void> _getDisabledContent(event, emit) async {
    emit(PendingLoadingState());

    try {
      //Query to get list of pictures from current user
      var queryUser = FirebaseFirestore.instance
          .collection("userPictures")
          .doc(FirebaseAuth.instance.currentUser!.uid);
      //Query to take data from doc
      var docsRef = await queryUser.get();
      List<dynamic> listIds = docsRef.data()?["pictureIDs"] ?? [];
      //Query to get content from fshare
      var queryPictures =
          await FirebaseFirestore.instance.collection("fshare").get();
      //filter
      List<Map<String, dynamic>> myDisabledContentList = queryPictures.docs
          .where((doc) =>
              doc.data()["public"] == false && listIds.contains(doc.id))
          .map((doc) {
        var t = doc.data();
        t["id"] = doc.id;
        return t;
      }).toList();
      //list of data filtered
      if (myDisabledContentList.isNotEmpty)
        emit(PendingSuccessState(myDisabledData: myDisabledContentList));
      else
        emit(PendingEmptyState());
    } catch (e) {
      print(e);
      emit(PendingErrorState());
      emit(PendingEmptyState());
    }
  }

  FutureOr<void> _publishPicture(PendingEnablePictureEvent event, emit) async {
    try {
      var picture = await FirebaseFirestore.instance
          .collection("fshare")
          .doc(event.id)
          .update({"publishedAt": Timestamp.now(), "public": true});
      emit(PendingUpdateState());
    } catch (e) {
      print(e);
      emit(PendingErrorState());
    }
  }
}
