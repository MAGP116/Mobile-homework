import 'dart:typed_data';

import 'package:examen_01/bloc/loading_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Column createCountryTile(
    BuildContext context, List<Map<String, String>> countries) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: countries.map(
      (e) {
        return ListTile(
          title: Text(
            e["name"]!,
            style: TextStyle(color: Colors.white70),
          ),
          leading: Image.memory(Uint8List.fromList(e["flag"]!.codeUnits)),
          onTap: () {
            BlocProvider.of<LoadingBloc>(context).add(
              LoadingUpdateEvent(e),
            );
          },
        );
      },
    ).toList(),
  );
}
