import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:foto_share/content/my_pictures/bloc/my_pictures_bloc.dart';
import 'package:foto_share/content/my_pictures/my_items.dart';
import 'package:image_picker/image_picker.dart';

class MyContent extends StatefulWidget {
  const MyContent({Key? key}) : super(key: key);

  @override
  State<MyContent> createState() => _MyContentState();
}

class _MyContentState extends State<MyContent> {
  @override
  Widget build(BuildContext context) {
    String? _url;
    Uint8List? _image;
    bool _switchvalue = false;
    String? _id;
    final TextEditingController _title_controller = TextEditingController();
    //Returns the current content of the my content page. It returns diferent content depending on the bloc consumer of this page.
    return BlocConsumer<MyPicturesBloc, MyPicturesState>(
        builder: (context, state) {
      if (state is MyPicturesLoadigState) {
        //If loading it returns list of shimmers.
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 25,
          itemBuilder: (BuildContext context, int index) {
            return YoutubeShimmer();
          },
        );
      }
      if (state is MyPictureSuccessState) {
        //if the content was found it return a list with the content created by
        //the user, the content can be edited by click on the edit button
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: state.myData.length,
                  itemBuilder: (BuildContext context, int index) => myItem(
                    itemData: state.myData[index],
                  ),
                ),
              ),
              const Divider(
                height: 20,
                thickness: 4,
                indent: 10,
                endIndent: 10,
              ),
            ],
          ),
        );
      }
      if (state is MyPictureEmptyState) {
        //If there is no content return that it's empty
        return Center(child: Text("No hay nada que mostrar"));
      }

      if (state is MyPictureEditState) {
        //If started an edit, set the values
        _image = state.data["image"];
        _url = state.data["picture"];
        _title_controller.text = state.data["title"];
        _switchvalue = state.data["public"];
        _id = state.data["id"];
      }
      if (state is MyPicturesImageTakedState) {
        _image = state.image;
      }

      if (state is MyPictureEditState || state is MyPicturesImageTakedState) {
        //Edit screen
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              _image != null
                  ? AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Image.memory(
                        _image!,
                        fit: BoxFit.cover,
                      ),
                    )
                  : AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Image.network(
                        _url!,
                        fit: BoxFit.cover,
                      ),
                    ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<MyPicturesBloc>(context)
                            .add(TakePictureEvent(source: ImageSource.camera));
                      },
                      child: Text("Tomar foto"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<MyPicturesBloc>(context)
                            .add(TakePictureEvent(source: ImageSource.gallery));
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
                  BlocProvider.of<MyPicturesBloc>(context)
                      .add(EditPictureEvent(data: {
                    "id": _id,
                    "picture": _url,
                    "image": _image,
                    "public": value,
                    "title": _title_controller.text
                  }));
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<MyPicturesBloc>(context)
                            .add(GetAllPicturesEvent());
                      },
                      child: Text("cancelar"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<MyPicturesBloc>(context)
                            .add(UpdatePictureEvent(data: {
                          "id": _id,
                          "url": _url,
                          "image": _image,
                          "public": _switchvalue,
                          "title": _title_controller.text
                        }));
                      },
                      child: Text("Editar"),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      }
      return Center(child: CircularProgressIndicator());
    }, listener: (context, state) {
      if (state is MyPicturesReloadState) {
        BlocProvider.of<MyPicturesBloc>(context).add(GetAllPicturesEvent());
      }
    });
  }

  void listener(BuildContext context, state) {}
}
