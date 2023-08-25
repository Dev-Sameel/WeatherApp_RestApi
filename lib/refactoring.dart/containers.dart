import 'package:flutter/material.dart';
import 'package:wheather/constants/constans.dart';
import 'package:wheather/refactoring.dart/box_shadow.dart';

class Containers extends StatelessWidget {
  const Containers({
    super.key,
    required this.value,
    required this.lastText,
    required this.title,
    required this.image
  });

  final num value;
  final String title;
  final String lastText;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20),
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.10,
      margin:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: kBgcolor,
        boxShadow:  
         contShadow()
        
      ),
      child: Row(
        children: [
          Image(
            image:  AssetImage(image),
            width: MediaQuery.of(context).size.width * 0.09,
            color: kWhite
            ,
          ),
          const SizedBox(width: 20),
          Text(
            '$title: ${value.toStringAsFixed(2)} $lastText',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 211, 247, 245)
            ),
          ),
        ],
      ),
    );
  }
}