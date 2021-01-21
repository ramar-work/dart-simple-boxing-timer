import 'package:flutter/material.dart';

//
class TogglerState extends State<Toggler> {
	List<bool> tSelected = new List(); 
	List<Text> texts = new List();

	@override
	Widget build(BuildContext ctx) {
		for ( int i = 0; i < widget.keys.length; i++ ) {
			tSelected.add( false );
			texts.add( Text( widget.keys[ i ] ) );
		}

		//Generate the widgets on the fly.  Unsure why the widget doens't already do this... 
		return ToggleButtons(
			children:	texts
		, onPressed: (int index) {
				setState() {
					for ( int bi = 0; bi < tSelected.length; bi++ ) {
						tSelected[ bi ] = ( bi == index ) ? true : false;
					}
				}
			}
		, isSelected: tSelected
		);
	}
}



//Might need to be stateful?
class Toggler extends StatefulWidget {
	
	List<String> keys;

 	Toggler({Key key, @required this.keys}) : super(key: key);

	@override
	TogglerState createState() => TogglerState(); 
}

