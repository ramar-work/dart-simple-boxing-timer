import 'package:flutter/material.dart';
import 'exercise.dart';


class ExerciseInput extends StatefulWidget {

	//reference to an object coming from elsewhere	
	Exercise exercise;
	String field;

	ExerciseInput( {Key key, @required this.exercise, @required this.field} ) : super( key: key );

	@override
	ExerciseInputState createState() => ExerciseInputState();
}


 
class ExerciseInputState extends State<ExerciseInput> {
	final _controller = TextEditingController();
	
	void initState() {
		super.initState();
		_controller.addListener( () {
			final _text = _controller.value;
		} );
	}

	void dispose() {
		_controller.dispose();
		super.dispose();
	}

	Widget build( BuildContext ctx ) {
		return Container(
		//alignment and padding can be set here...
			child: TextFormField( 
				controller: _controller
			, decoration: InputDecoration( border: OutlineInputBorder() )
			)
		);
	}
}
