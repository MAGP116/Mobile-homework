import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foto_share/content/add/bloc/add_bloc.dart';
import 'package:image_picker/image_picker.dart';

class AddPost extends StatefulWidget {
  AddPost({Key? key}) : super(key: key);

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final TextEditingController _title_controller = TextEditingController();
  bool _switchvalue = true;
  Uint8List? _image;
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              BlocConsumer<AddBloc, AddState>(
                builder: (context, state) {
                  if (state is AddEmptyState) {
                    return AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(117, 39, 39, 39),
                        ),
                        constraints: const BoxConstraints.expand(),
                        child: const Center(
                          child: Text(
                            "Sin imagen",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  }
                  if (state is AddImageTakedState) {
                    _image = state.data["image"];
                    return AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Image.memory(
                        _image!,
                        fit: BoxFit.cover,
                      ),
                    );
                  }
                  return Text("Estado no manejado");
                },
                listener: (context, state) {
                  if (state is AddEmptyState) {
                    _switchvalue = true;
                    _title_controller.clear();
                  }
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<AddBloc>(context)
                            .add(AddGetImageEvent(source: ImageSource.camera));
                      },
                      child: Text("Tomar foto"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<AddBloc>(context)
                            .add(AddGetImageEvent(source: ImageSource.gallery));
                      },
                      child: Text("Buscar foto"),
                    ),
                  ),
                ],
              ),
              TextField(
                controller: _title_controller,
                decoration: const InputDecoration(
                  hintText: "Título",
                  border: OutlineInputBorder(),
                ),
              ),
              SwitchListTile(
                title: Text("Publicar"),
                value: _switchvalue,
                onChanged: (value) {
                  setState(() {
                    _switchvalue = value;
                  });
                },
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_image != null && _title_controller.text.isNotEmpty) {
                      BlocProvider.of<AddBloc>(context).add(AddUploadEvent({
                        "public": _switchvalue,
                        "title": _title_controller.text,
                        "image": _image
                      }));
                    }
                  },
                  child: Text("Crear"),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
