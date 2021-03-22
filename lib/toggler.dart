import 'package:flutter/material.dart';

//Toggle buttons can take up a full width, and be selected when clicked

//
class TogglerState extends State<Toggler> {
	List<bool> tSelected = new List(); 
	List<Text> texts = new List();

	@override
	initState() {
		super.initState();
		for ( int i = 0; i < widget.keys.length; i++ ) {
			tSelected.add( i == widget.sel ? true : false );
			texts.add( Text( widget.keys[ i ] ) );
		}
	}

	@override
	Widget build(BuildContext ctx) {
		debugPrint( "TOGGLER-BUILD: ${tSelected.length}" );
		//Generate the widgets on the fly.  Unsure why the widget doens't already do this... 
		return ToggleButtons(
			children:	texts
		, color: Colors.black
		, focusColor: Colors.white
		, highlightColor: Colors.white
		, selectedColor: Colors.white
		, fillColor: Colors.blue
		, borderColor: Colors.lightBlue
		, borderRadius: BorderRadius.circular( 10 )
		, textStyle: TextStyle( height: 1, fontSize: 10 )
		, onPressed: ( int index ) {
				widget.upd( index );
				setState( () {
					debugPrint( "TOGGLER-UPDATE: ${index}" );
					debugPrint( "TOGGLER-UPDATE: ${tSelected.length}" );
					for ( int bi = 0; bi < tSelected.length; bi++ ) {
						tSelected[ bi ] = ( bi == index ) ? true : false;
					}
					widget.sel = index;
					//}
				} );
			}
		, isSelected: tSelected
		);
	}
}



//Might need to be stateful?
class Toggler extends StatefulWidget {
	List<String> keys;
	int sel;
	Function upd;
	
 	Toggler({
		Key key
	, @required this.keys
	, @required this.upd
	, @required this.sel 
	}) : super(key: key);

	@override
	TogglerState createState() => TogglerState(); 
}

