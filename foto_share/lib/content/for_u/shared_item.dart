import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class SharedItem extends StatefulWidget {
  final Map<String, dynamic> itemData;
  final ScreenshotController _screenshotController = ScreenshotController();

  SharedItem({Key? key, required this.itemData}) : super(key: key);

  @override
  State<SharedItem> createState() => _SharedItemState();
}

class _SharedItemState extends State<SharedItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Screenshot(
              controller: widget._screenshotController,
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  widget.itemData["picture"],
                  fit: BoxFit.cover,
                ),
              ),
            ),
            ListTile(
              title: Text("${widget.itemData["title"]}"),
              subtitle: Text("${widget.itemData["publishedAt"].toDate()}"),
              leading: CircleAvatar(
                child: Text("${widget.itemData["username"][0]}"),
              ),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star, color: Colors.amber[600]),
                    Text('${widget.itemData["stars"]}'),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.share),
                  onPressed: () async {
                    //get image
                    final image = await widget._screenshotController.capture();
                    if (image == null) {
                      return;
                    }
                    //save image
                    final directory = await getApplicationDocumentsDirectory();
                    final imagePath =
                        await File('${directory.path}/image.png').create();
                    await imagePath.writeAsBytes(image);

                    //share image
                    Share.shareFiles([imagePath.path],
                        text:
                            '${widget.itemData["title"]}\n${widget.itemData["publishedAt"].toDate()}');
                  },
                )
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
