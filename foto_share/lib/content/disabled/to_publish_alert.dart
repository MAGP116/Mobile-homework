import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/pending_bloc.dart';

class ToPublishAlert extends StatelessWidget {
  final Map<String, dynamic> data;
  const ToPublishAlert({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(context),
          child: Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(context);
            BlocProvider.of<PendingBloc>(context)
                .add(PendingEnablePictureEvent(data["id"]));
          },
          child: Text("Publicar"),
        ),
      ],
      title: Text("Publicar la imagen"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.network(
              data["picture"],
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
