import 'dart:async';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

part 'my_pictures_event.dart';
part 'my_pictures_state.dart';

class MyPicturesBloc extends Bloc<MyPicturesEvent, MyPicturesState> {
  final ImagePicker _picker = ImagePicker();
  MyPicturesBloc() : super(MyPicturesInitial()) {
    on<GetAllPicturesEvent>(_LoadPictures);
    on<EditPictureEvent>(_edit);
    on<TakePictureEvent>(_takePicture);
    on<UpdatePictureEvent>(_update);
  }

  FutureOr<void> _LoadPictures(event, emit) async {
    emit(MyPicturesLoadigState());

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
      List<Map<String, dynamic>> myContentList = queryPictures.docs
          .where((doc) => listIds.contains(doc.id))
          .map((doc) {
        var t = doc.data();
        t["id"] = doc.id;
        return t;
      }).toList();
      emit(MyPictureSuccessState(myData: myContentList));
    } catch (e) {
      print(e);
      emit(MyPicturesErrorState());
      emit(MyPictureEmptyState());
    }
  }

  FutureOr<void> _edit(EditPictureEvent event, Emitter<MyPicturesState> emit) {
    emit(MyPictureEditState(data: event.data));
  }

  FutureOr<void> _takePicture(
      TakePictureEvent event, Emitter<MyPicturesState> emit) async {
    try {
      final XFile? file = await _picker.pickImage(source: event.source);
      if (file != null) {
        Uint8List image = await file.readAsBytes();
        emit(MyPicturesImageTakedState(image: image));
      }
    } catch (e) {
      emit(MyPicturesErrorState());
      emit(MyPictureEmptyState());
    }
  }

  FutureOr<void> _update(
      UpdatePictureEvent event, Emitter<MyPicturesState> emit) async {
    //get date
    var time = DateTime.now();
    String dir = '${time.microsecondsSinceEpoch}_${event.data["title"]}.png';
    try {
      if (event.data["image"] != null) {
        //upload file
        var ref = FirebaseStorage.instance.ref(dir);
        await ref.putData(event.data["image"]);

        //get file url
        event.data["url"] = await ref.getDownloadURL();
      }

      //update post
      await FirebaseFirestore.instance
          .collection("fshare")
          .doc(event.data["id"])
          .update({
        "picture": event.data["url"],
        "public": event.data["public"],
        "publishedAt": Timestamp.fromDate(time),
        "title": event.data["title"],
      });

      emit(MyPicturesReloadState());
    } catch (e) {
      print(e);
      emit(MyPicturesErrorState());
    }
  }
}
