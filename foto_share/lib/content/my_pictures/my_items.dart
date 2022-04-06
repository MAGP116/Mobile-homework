import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foto_share/content/my_pictures/bloc/my_pictures_bloc.dart';

class myItem extends StatefulWidget {
  final Map<String, dynamic> itemData;
  myItem({Key? key, required this.itemData}) : super(key: key);

  @override
  State<myItem> createState() => _myItemState();
}

class _myItemState extends State<myItem> {
  bool _switchValue = false;

  @override
  void initState() {
    _switchValue = widget.itemData["public"];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //Returns a Card that contain the info of image, owner, title, date published and stars.
    return Card(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                widget.itemData["picture"],
                fit: BoxFit.cover,
              ),
            ),
            ListTile(
              title: Text("${widget.itemData["title"]}"),
              subtitle: Text("${widget.itemData["publishedAt"].toDate()}"),
              leading: CircleAvatar(
                child: Text("${widget.itemData["username"][0]}"),
              ),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                Switch(
                  value: _switchValue,
                  onChanged: (newVal) {},
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star, color: Colors.amber[600]),
                    Text('${widget.itemData["stars"]}'),
                  ],
                ),
              ]),
            ),
            ElevatedButton(
              onPressed: () {
                BlocProvider.of<MyPicturesBloc>(context)
                    .add(EditPictureEvent(data: {
                  "id": widget.itemData["id"],
                  "title": widget.itemData["title"],
                  "picture": widget.itemData["picture"],
                  "public": widget.itemData["public"],
                }));
              },
              child: Text("Editar"),
            ),
          ],
        ),
      ),
    );
  }
}
