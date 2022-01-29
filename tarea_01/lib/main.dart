import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Likes likes = Likes();
  bool mailClicked = false;
  bool callClicked = false;
  bool ruteClicked = false;

  @override
  Widget build(BuildContext context) {
    //Scaffold indica que se formara una pantalla
    return Scaffold(
      // Columna para alinear elementos en vertical (de arriba hacia abajo)
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Para agregar imagenes de una url
            Image.network(
              "https://cruce.iteso.mx/wp-content/uploads/sites/123/2018/04/Portada-2-e1525031912445.jpg",
            ),
            // Para poner elementos en renglon
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                // el eje main de la Row es horizontal (izq a dch)
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "El ITESO: Universidad Jesuita de Guadalajara",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        Text("San Pedro Tlaquepaque, Jalisco")
                      ]),

                  //boton de like
                  IconButton(
                    onPressed: () {
                      likes.upVote();
                      setState(() {});
                    },
                    icon: likes.likeIcon,
                  ),

                  //Boton de dislike
                  IconButton(
                    onPressed: () {
                      likes.downVote();
                      setState(() {});
                    },
                    icon: likes.dislikeIcon,
                  ),
                  Text(likes.likesVotes.toString(),
                      style: const TextStyle(
                        fontSize: 11,
                      )),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //EMAIL boton
                Column(
                  children: [
                    IconButton(
                      iconSize: 64,
                      color: (mailClicked) ? Colors.indigo : Colors.black,
                      onPressed: () {
                        // Muestra un snack bar con texto
                        ScaffoldMessenger.of(context).removeCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Correo del iteso: correo@iteso.com"),
                          ),
                        );
                        mailClicked = !mailClicked;
                        setState(() {});
                      },
                      icon: Icon(Icons.email),
                    ),
                    Text("Email",
                        style: TextStyle(
                            color:
                                (mailClicked) ? Colors.indigo : Colors.black)),
                  ],
                ),
                //Telefono Boton
                Column(
                  children: [
                    IconButton(
                      iconSize: 64,
                      color: (callClicked) ? Colors.indigo : Colors.black,
                      onPressed: () {
                        ScaffoldMessenger.of(context).removeCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("telefono del iteso: 3333333"),
                          ),
                        );
                        callClicked = !callClicked;
                        setState(() {});
                      },
                      icon: Icon(Icons.phone),
                    ),
                    Text("Telefono",
                        style: TextStyle(
                            color:
                                (callClicked) ? Colors.indigo : Colors.black)),
                  ],
                ),
                //Ruta boton
                Column(
                  children: [
                    IconButton(
                      iconSize: 64,
                      color: (ruteClicked) ? Colors.indigo : Colors.black,
                      onPressed: () {
                        ScaffoldMessenger.of(context).removeCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Ruta del iteso"),
                          ),
                        );
                        ruteClicked = !ruteClicked;
                        setState(() {});
                      },
                      icon: Icon(Icons.directions),
                    ),
                    Text("Ruta",
                        style: TextStyle(
                            color:
                                (callClicked) ? Colors.indigo : Colors.black)),
                  ],
                ),
              ],
            ),
            // Para poner padding alrededor de un widget
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "The university has approximately 10,000 students. Its academic options include Civil Engineering and Architecture, Food Engineering, Education, Electronic Engineering, International Business, International Relations, Chemical Engineering, Philosophy, Psychology and Social Studies, and Networks and Telecommunications Engineering.[2] The university is affiliated to the Jesuit University System, which includes the Iberoamerican Universities in Acapulco, Mexico City, Jaltepec, León, Torreón, Puebla and Tijuana.[3] According to the vision of Jesuits, local businesspeople, and others who planned the university, it would combine professional training with a firm sense of social responsibility.",
                textAlign: TextAlign.justify,
              ),
            ),
          ],
        ),
      ),
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
