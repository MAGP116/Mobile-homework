import 'dart:typed_data';

import 'package:flutter/material.dart';

Stack createMotivationalContent(
    {required BuildContext context,
    required image,
    required country,
    required time,
    required quote,
    required author}) {
  return Stack(
    children: [
      //Image
      Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: Image.memory(Uint8List.fromList(image.codeUnits)).image,
          ),
        ),
      ),
      Container(
        color: Color(0xAA000000),
      ),
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              //Time
              Text(country,
                  style: TextStyle(color: Colors.white70, fontSize: 34)),
              Text(time, style: TextStyle(color: Colors.white70, fontSize: 34)),
              //Motivational Text
            ],
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '${quote}\n-${author}',
              style: TextStyle(color: Colors.white60),
            ),
          ],
        ),
      ),
    ],
  );
}
