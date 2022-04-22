import 'package:http/http.dart' as http;
import 'package:find_track_app/secrets/secrets.dart';
import 'package:http/http.dart';

class AuddMusicRepository {
  Future<Response> getSong(String audio) async {
    return http.post(Uri.parse('https://api.audd.io/'), body: {
      'return': 'apple_music,spotify',
      'api_token': audioToken,
      'audio': audio
    });
  }
}
