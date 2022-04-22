import 'package:cloud_firestore/cloud_firestore.dart';

class TrackRepository {
  Future<Map<String, dynamic>?> getSong(id) async {
    var res =
        await FirebaseFirestore.instance.collection("track").doc(id).get();
    if (res.exists) {
      var t = res.data()!;
      t['id'] = id;
      return t;
    }
  }

  Future<String> findOrCreateSong(Map<String, dynamic> data) async {
    var res = await findSong(data);
    if (res != null) {
      return res;
    }

    return createSong(data);
  }

  Future<String?> findSong(Map<String, dynamic> data) async {
    var res = await FirebaseFirestore.instance
        .collection("track")
        .where('title', isEqualTo: data['title'])
        .get();
    if (res.docs.isEmpty) {
      return null;
    }
    if (res.docs.length == 1) {
      return res.docs[0].id;
    }
    return res.docs.firstWhere((song) => song['artist'] == data['artist']).id;
  }

  Future<String> createSong(Map<String, dynamic> data) async {
    var res = await FirebaseFirestore.instance.collection('track').add({
      'artist': data['artist'],
      'title': data['title'],
      'imageUrl': data['imageUrl'],
      'songUrl': data['songUrl']
    });
    return res.id;
  }
}
