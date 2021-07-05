import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';

bouncingGridProgress() {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top: 10),
    child: LoadingBouncingGrid.square(
      backgroundColor: Colors.black38,
      size: 30.0,
    ),
  );
}
