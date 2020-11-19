/* wop.dart */
import 'package:flutter/material.dart';

class Wop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new RawMaterialButton(
			onPressed: () {}
    ,	shape: new CircleBorder() 
    ,	elevation: 2.0
    ,	fillColor: Colors.blue
    ,	padding: const EdgeInsets.all( 15.0 )
    );
  }
}
