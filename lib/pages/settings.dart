/*settings.dart - Configuration for the app itself - Might load from SQL in the future*/
import 'package:flutter/material.dart';
import '../toggler.dart';
import '../input.dart';
import '../exercise.dart';



class ExerciseInput extends StatefulWidget {

	//reference to an object coming from elsewhere	
	Exercise exercise;
	void Function( String, int ) updater;
	String field;
	int initial;

	ExerciseInput( {Key key, 
		@required this.field, @required this.initial, @required this.updater} ) : super( key: key );

	@override
	ExerciseInputState createState() => ExerciseInputState();
}


 
class ExerciseInputState extends State<ExerciseInput> {
	final _controller = TextEditingController();
	
	void initState() {
		super.initState();
		_controller.addListener( () {
			//Need to now check that this is a number
			final _v = _controller.value;
			widget.updater( widget.field, _v as int );
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


class SettingsPage extends StatefulWidget {

 	SettingsPage({Key key}) : super(key: key);

	@override
  _SettingsPageState createState() => _SettingsPageState();
}



class _SettingsPageState extends State<SettingsPage> {

	Exercise exercise; 

	//Method that updates the exercise struct above 
	void _u( String text, int value ) {
		setState( () {
			if ( text == "length" )
				exercise.length = value;	
			else if ( text == "rest" )
				exercise.rest = value;	
			else if ( text == "rounds" ) {
				exercise.rounds = value;	
			}
		} );	
	}

  @override
	Widget build( BuildContext ctx ) {

		exercise = new Exercise( "Custom", 0, 0, 0, 0 );

		return Scaffold( 
			body: Center( 
				child: Container(
					padding: new EdgeInsets.all( 30.0 ),
					child: Column( children: <Widget>[ 
						Spacer( flex: 2 )

					,	new Row( 
						 children: <Widget>[
								Center( child: Text(
									"Settings",
									textScaleFactor: 4.0, 
									style: TextStyle( fontWeight: FontWeight.bold )
								) )
							])

					, new Container( 
							padding: new EdgeInsets.symmetric( vertical: 20.0 ),
							child: Column( children: [
								new Row( children: <Widget>[ 
									Text( "General",
										textScaleFactor: 2.0,
										style: TextStyle( fontWeight: FontWeight.bold  ) ) 
								])

							, Table(
									children: [
										TableRow( children: [
											TableCell( child: Text( "Theme" ) )
										, TableCell( child: new Toggler( keys: [ "Light", "Dark" ] ) )
										])
									,	TableRow( children: [
											TableCell( child: Text( "Bell" ) )
										, TableCell( child: new Toggler( keys: [ "On", "Off" ] ) )
										])
									,	TableRow( children: [
											TableCell( child: Text( "10 Minute Warning" ) )
										, TableCell( child: new Toggler( keys: [ "On", "Off" ] ) )
										])
									,	TableRow( children: [
											TableCell( child: Text( "Timer Type" ) )
										, TableCell( 
												child: new Toggler( keys: [ "Olympic", "Pro", "Custom" ] )
											)
										])
								])
							])
					)

					, new Container( 
							padding: new EdgeInsets.symmetric( vertical: 20.0 ),
							child: Column( children: [
								new Row( children: <Widget>[ 
									Text( "Custom Timer"
									, textScaleFactor: 2.0
									, style: TextStyle( fontWeight: FontWeight.bold  ) )  
									])

							, Table(
									//border:
									children: [
										TableRow( children: [
											TableCell( child: Text( "Round Length" ) )
										, TableCell( child: 
												ExerciseInput( field: "length", initial: exercise.length , updater: _u ) )
										])
									,	TableRow( children: [
											TableCell( child: Text( "Round Count" ) )
										, TableCell( child: 
												ExerciseInput( field: "rounds", initial: exercise.rounds, updater: _u ) )
										])
									,	TableRow( children: [
											TableCell( child: Text( "Rest Interval" ) )
										, TableCell( child: 
												ExerciseInput( field: "rest", initial: exercise.rest, updater: _u ) )
										])
									]
								)
							])
						)

					, RaisedButton( 
							child: Text( 'Go back' ) 
						, onPressed: () {
								Navigator.pop( ctx );
							}
						)

					, Text( """
						This widget is for testing only: 
						L ${ exercise.length }
						R ${ exercise.rounds }
						R ${ exercise.rest }
						""" )

					, Spacer( flex: 2 )
					]
			))) 
		);
	}
}
