import 'package:flutter/material.dart';

contShadow() {
  return [
    const BoxShadow(
      color: Color.fromARGB(221, 75, 103, 122),
      blurRadius: 15,
      spreadRadius: 1,
      offset: Offset(5, 5),
    ),
    const BoxShadow(
      color: Color.fromARGB(221, 0, 0, 0),
      blurRadius: 15,
      spreadRadius: 1,
      offset: Offset(-5, -5),
    ),
  ];
}