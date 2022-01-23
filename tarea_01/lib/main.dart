import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

//Variables
Likes likes = Likes();
bool mailClicked = false;
bool callClicked = false;
bool ruteClicked = false;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tarea 01',
      home: Scaffold(
        body: Column(
          children: [
            Image.network(
                "https://cruce.iteso.mx/wp-content/uploads/sites/123/2018/04/Portada-2-e1525031912445.jpg"),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  //Column that contains title and subtitle
                  Column(
                    children: const [
                      Text(
                        "El ITESO: Universidad Jesuita de Guadalajara",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      Text("San Pedro Tlaquepaque, Jalisco")
                    ],
                  ),
                  const ThumbUpDown(),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  MailSnackBar(),
                  CallSnackBar(),
                  RuteSnackBar()
                ],
              ),
            ),
            const Text(
                "El ITESO, Universidad Jesuita de Guadalajara, es una universidad privada ubicada en la Zona Metropolitana de Guadalajara, Jalisco, México, fundada en el año 1957. La institución forma parte del Sistema Universitario Jesuita que integra a ocho universidades en México. ")
          ],
        ),
      ),
    );
  }
}

class MailSnackBar extends StatefulWidget {
  const MailSnackBar({Key? key}) : super(key: key);
  @override
  State<MailSnackBar> createState() => _MailSnackBarWidgetState();
}

class _MailSnackBarWidgetState extends State<MailSnackBar> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: TextButton(
            onPressed: () {
              setState(() {
                final snackBar = SnackBar(
                    content: const Text("Enviar correo"),
                    action: SnackBarAction(label: 'close', onPressed: () {}));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                mailClicked = !mailClicked;
              });
            },
            child: Column(
              children: [
                Icon(
                  Icons.mail,
                  color: (mailClicked) ? Colors.indigo : Colors.black,
                  size: 48,
                ),
                Text("Correo",
                    style: TextStyle(
                        color: (mailClicked) ? Colors.indigo : Colors.black))
              ],
            )));
  }
}

class CallSnackBar extends StatefulWidget {
  const CallSnackBar({Key? key}) : super(key: key);
  @override
  State<CallSnackBar> createState() => _CallSnackBarWidgetState();
}

class _CallSnackBarWidgetState extends State<CallSnackBar> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: TextButton(
            onPressed: () {
              setState(() {
                final snackBar = SnackBar(
                    content: const Text("Hacer llamada"),
                    action: SnackBarAction(label: 'close', onPressed: () {}));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                callClicked = !callClicked;
              });
            },
            child: Column(
              children: [
                Icon(
                  Icons.call,
                  color: (callClicked) ? Colors.indigo : Colors.black,
                  size: 48,
                ),
                Text("Llamada",
                    style: TextStyle(
                        color: (callClicked) ? Colors.indigo : Colors.black))
              ],
            )));
  }
}

class RuteSnackBar extends StatefulWidget {
  const RuteSnackBar({Key? key}) : super(key: key);
  @override
  State<RuteSnackBar> createState() => _RuteSnackBarWidgetState();
}

class _RuteSnackBarWidgetState extends State<RuteSnackBar> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: TextButton(
            onPressed: () {
              setState(() {
                final snackBar = SnackBar(
                    content: const Text("Ir al ITESO"),
                    action: SnackBarAction(label: 'close', onPressed: () {}));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                ruteClicked = !ruteClicked;
              });
            },
            child: Column(
              children: [
                Icon(
                  Icons.directions,
                  color: (ruteClicked) ? Colors.indigo : Colors.black,
                  size: 48,
                ),
                Text("Ruta",
                    style: TextStyle(
                        color: (ruteClicked) ? Colors.indigo : Colors.black))
              ],
            )));
  }
}

class ThumbUpDown extends StatefulWidget {
  const ThumbUpDown({Key? key}) : super(key: key);
  @override
  State<ThumbUpDown> createState() => _ThumbUpDownWidgetState();
}

class _ThumbUpDownWidgetState extends State<ThumbUpDown> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
            onPressed: () {
              setState(() {
                likes.upVote();
              });
            },
            icon: likes.likeIcon),
        IconButton(
            onPressed: () {
              setState(() {
                likes.downVote();
              });
            },
            icon: likes.dislikeIcon),
        Text(
          likes.likesVotes.toString(),
          style: TextStyle(
            fontSize: 11,
          ),
        )
      ],
    );
  }
}

class Likes {
  int likesVotes = 9999;
  bool liked = false;
  bool disliked = false;
  Icon likeIcon = const Icon(Icons.thumb_up, color: Colors.black);
  Icon dislikeIcon = const Icon(Icons.thumb_down, color: Colors.black);

  void upVote() {
    if (disliked) {
      likesVotes += 1;
      dislikeIcon = const Icon(Icons.thumb_down, color: Colors.black);
      disliked = false;
    }
    if (!liked) {
      likesVotes += 1;
      likeIcon = const Icon(Icons.thumb_up, color: Colors.blue);
    } else {
      likesVotes -= 1;
      likeIcon = const Icon(Icons.thumb_up, color: Colors.black);
    }
    liked = !liked;
  }

  void downVote() {
    if (liked) {
      likesVotes -= 1;
      likeIcon = const Icon(Icons.thumb_up, color: Colors.black);
      liked = false;
    }
    if (!disliked) {
      likesVotes -= 1;
      dislikeIcon = const Icon(Icons.thumb_down, color: Colors.red);
    } else {
      likesVotes += 1;
      dislikeIcon = const Icon(Icons.thumb_down, color: Colors.black);
    }
    disliked = !disliked;
  }
}
