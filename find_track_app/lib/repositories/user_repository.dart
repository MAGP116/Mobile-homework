import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepository {
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
      var song = await FirebaseFirestore.instance
          .collection("track")
          .doc(songId)
          .get();
      if (song.exists) {
        var t = song.data()!;
        t['id'] = songId;
        ans.add(t);
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
}
