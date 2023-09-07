
import 'package:flutter/material.dart';

menuButton(Icon icon, Text text,onClick) {
  return InkWell(
    onTap: onClick,
    child: Card(elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Container(
        height: 70,
        width: 160,
       // decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(60))),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            SizedBox(height: 5),
            text,
          ],
        ),
      ),
    ),
  );
}