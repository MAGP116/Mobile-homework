import 'package:find_track_app/repositories/track_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepository {
  final _trackRep = TrackRepository();
  Future<bool> userRegisterExist() async {
    return (await FirebaseFirestore.instance
            .collection("user")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get())
        .exists;
  }

  Future<void> createUser() async {
    await FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({"favoriteSongs": []});
  }

  Future<List<Map<String, dynamic>>> getUserFavoriteSongs() async {
    var res = await FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    if (res.exists == false) {
      return [];
    }
    List<dynamic> SongsId = res.data()!['favoriteSongs'];
    List<Map<String, dynamic>> ans = [];
    for (var songId in SongsId) {
      var song = await _trackRep.getSong(songId);
      if (song != null) {
        ans.add(song);
      }
    }
    return ans;
  }

  Future<void> removeFavoriteSong(String song) async {
    var res = await FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    if (!res.exists) {
      return;
    }
    var list = res.data()!["favoriteSongs"];
    list.remove(song);
    FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({"favoriteSongs": list});
  }

  Future<bool> addFavoriteSong(Map<String, dynamic> data) async {
    var songId = await _trackRep.findOrCreateSong(data);
    var res = await FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    var songs = res.data()!['favoriteSongs'];
    if (!songs.contains(songId)) {
      songs.add(songId);
      var user = await FirebaseFirestore.instance
          .collection("user")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'favoriteSongs': songs});
      return true;
    }

    return false;
  }
}
