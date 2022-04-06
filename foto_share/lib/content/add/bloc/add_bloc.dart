import 'dart:async';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

part 'add_event.dart';
part 'add_state.dart';

class AddBloc extends Bloc<AddEvent, AddState> {
  final ImagePicker _picker = ImagePicker();

  AddBloc() : super(AddInitial()) {
    on<AddInitEvent>(_init);
    on<AddGetImageEvent>(_getImage);
    on<AddUploadEvent>(_upload);
  }

  FutureOr<void> _init(event, emit) {
    emit(AddEmptyState());
  }

  FutureOr<void> _getImage(AddGetImageEvent event, emit) async {
    try {
      final XFile? file = await _picker.pickImage(source: event.source);
      if (file != null) {
        Uint8List image = await file.readAsBytes();
        emit(AddImageTakedState(data: {"image": image}));
      }
    } catch (e) {
      emit(AddErrorState());
      emit(AddEmptyState());
    }
  }

  FutureOr<void> _upload(AddUploadEvent event, emit) async {
    //get date
    var time = DateTime.now();
    String dir = '${time.microsecondsSinceEpoch}_${event.data["title"]}.png';
    try {
      //upload file
      var ref = FirebaseStorage.instance.ref(dir);
      await ref.putData(event.data["image"]);

      //get file url
      String url = await ref.getDownloadURL();

      //upload post
      var doc = await FirebaseFirestore.instance.collection("fshare").add({
        "picture": url,
        "public": event.data["public"],
        "publishedAt": Timestamp.fromDate(time),
        "stars": 0,
        "title": event.data["title"],
        "username": FirebaseAuth.instance.currentUser!.displayName
      });
      //get user's posts
      var posts = await FirebaseFirestore.instance
          .collection("userPictures")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      var pictures = posts.data()!["pictureIDs"];
      //add post to user
      pictures.add(doc.id);
      await FirebaseFirestore.instance
          .collection("userPictures")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({"pictureIDs": pictures});
      emit(AddEmptyState());
    } catch (e) {
      print(e);
      emit(AddErrorState());
    }
  }
}
