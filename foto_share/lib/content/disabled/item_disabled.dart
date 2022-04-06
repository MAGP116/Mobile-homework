import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foto_share/content/disabled/bloc/pending_bloc.dart';
import 'package:foto_share/content/disabled/to_publish_alert.dart';

class item_disabled extends StatefulWidget {
  final Map<String, dynamic> nonPublicFData;
  item_disabled({Key? key, required this.nonPublicFData}) : super(key: key);

  @override
  State<item_disabled> createState() => _item_disabledState();
}

class _item_disabledState extends State<item_disabled> {
  bool _switchValue = false;

  @override
  void initState() {
    _switchValue = widget.nonPublicFData["public"];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.network(
              widget.nonPublicFData["picture"],
              fit: BoxFit.cover,
            ),
          ),
          SwitchListTile(
              title: Text("${widget.nonPublicFData["title"]}"),
              subtitle:
                  Text("${widget.nonPublicFData["publishedAt"].toDate()}"),
              value: _switchValue,
              onChanged: (newVal) {
                setState(() {
                  _switchValue = newVal;
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => ToPublishAlert(
                      data: {
                        "id": widget.nonPublicFData["id"],
                        "picture": widget.nonPublicFData["picture"]
                      },
                    ),
                  );
                  _switchValue = false;
                });
              }),
        ],
      ),
    );
  }
}
