import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

class Requests {
  static final Requests _instance = Requests._internal();
  Requests._internal();
  factory Requests() {
    return _instance;
  }

  Requests get instance => _instance;

  Future<String> getFlag(country) async {
    var res =
        await http.get(Uri.parse("https://flagcdn.com/32x24/$country.png"));
    return res.body;
  }

  getSentence() async {
    var res = await http.get(Uri.parse("https://zenquotes.io/api/random"));
    if (res.statusCode != 200) {
      return null;
    }
    return jsonDecode(res.body);
  }

  getImage() async {
    var res = await http.get(Uri.parse("https://picsum.photos/600/1200"));
    if (res.statusCode != 200) {
      return null;
    }
    return res.body;
  }

  getTime(url) async {
    var res = await http
        .get(Uri.parse("http://worldtimeapi.org/api/timezone/${url}"));
    if (res.statusCode != 200) return null;
    return jsonDecode(res.body)["datetime"].substring(11, 19);
  }
}
