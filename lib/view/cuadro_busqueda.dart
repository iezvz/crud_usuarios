import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CuadroBusqueda extends StatelessWidget {
  CuadroBusqueda({super.key, this.hintText, this.onChanged});

  final String? hintText;
  Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        onChanged: (value) {
          onChanged!(value);
        },
        decoration: InputDecoration(
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          hintText: hintText.toString(),
        ),
      ),
    );
  }
}