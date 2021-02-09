/*settings.dart - Configuration for the app itself - Might load from SQL in the future*/
import 'package:flutter/material.dart';
import '../toggler.dart';
import '../input.dart';
import '../exercise.dart';
import 'dart:math';


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

		//exercise = new Exercise( "Custom", 0, 0, 0, 0 );

		return Scaffold( 
			body: Center( 
				child: Container(
					padding: new EdgeInsets.all( 30.0 ),
					child: Column( children: <Widget>[ 
						Spacer( flex: 2 )

					,	new Row( 
						 children: <Widget>[
								Align( 
									alignment: Alignment.topLeft
								,	child: Text(
										"Settings",
										textScaleFactor: 4.0, 
										style: TextStyle( fontWeight: FontWeight.bold )
									) 
								)
							,	Spacer( flex: 1 )
							,	Align(
									alignment: Alignment.topRight
								,	child: new MaterialButton( 
										child: Transform.rotate( 
											angle: 180 * pi/180,
											child: Icon( Icons.arrow_right_alt, color: Colors.grey, size: 40 )
										)
									, color: Colors.grey[50]
									, height: 70.0
									, minWidth: 35.0
									, shape: new RoundedRectangleBorder( 
											borderRadius: new BorderRadius.circular( 40 )
										)
									, onPressed: () {
											Navigator.pop( ctx );
										}
									)
								)
							]
						)

					, new Container( 
							padding: new EdgeInsets.symmetric( vertical: 20.0 ),
							child: Column( children: [
								new Row( children: <Widget>[ 
									Text( "General",
										textScaleFactor: 2.0,
										style: TextStyle( fontWeight: FontWeight.bold  ) ) 
								])

							, Table(
								  defaultVerticalAlignment: TableCellVerticalAlignment.middle
								,	children: [
										TableRow( children: [
											TableCell( child: Text( "Theme" ) )
										, TableCell( child: Center( child: new Toggler( sel: 0, keys: [ "Light", "Dark" ] ) ) )
										])
									,	TableRow( children: [ 
											TableCell( child: Text( "" ) ), 
											TableCell( child: Text( "" ) ) ] )
									,	TableRow( children: [
											TableCell( child: Text( "Bell" ) )
										, TableCell( child: Center( child: new Toggler( sel: 0, keys: [ "On", "Off" ] ) ) )
										])
									,	TableRow( children: [ 
											TableCell( child: Text( "" ) ), 
											TableCell( child: Text( "" ) ) ] )
									,	TableRow( children: [
											TableCell( child: Text( "10 Second Warning" ) )
										, TableCell( child: Center( child: new Toggler( sel: 0, keys: [ "On", "Off" ] ) ) )
										])
									,	TableRow( children: [ 
											TableCell( child: Text( "" ) ), 
											TableCell( child: Text( "" ) ) ] )
									,	TableRow( children: [
											TableCell( child: Text( "Timer Type" ) )
										, TableCell( 
												child: Center( child: new Toggler( 
													sel: 0, keys: [ "Olympic", "Pro" /*, "Custom" */ ] ) )
											)
										])
								])
							])
					)

					, Spacer( flex: 2 )
			
					/*
					, new Container( 
							padding: new EdgeInsets.symmetric( vertical: 20.0 ),
							child: Column( children: [
								new Row( children: <Widget>[ 
									Text( "Custom Timer"
									, textScaleFactor: 2.0
									, style: TextStyle( fontWeight: FontWeight.bold  ) )  
									])

							, Table(
								  defaultVerticalAlignment: TableCellVerticalAlignment.middle
								, children: [
										TableRow( children: [
											TableCell( child: Text( "Round Length" ) )
										, TableCell( child: 
												Row( 
													mainAxisAlignment: MainAxisAlignment.end
												,	children: [ 
														Text( "0", textScaleFactor: 1.5 )
													,	Column( children: [
															new MaterialButton( 
																child: Icon( Icons.arrow_circle_up, size: 30 )
															, onPressed: () {} 
															)
														, new MaterialButton( 
																child: Icon( Icons.arrow_circle_down, size: 30 )
															, onPressed: () {} 
															)
														])
													]
												)
											)
										])

									,	TableRow( children: [ 
											TableCell( child: Text( "" ) ), 
											TableCell( child: Text( "" ) ) ] )

									,	TableRow( children: [
											TableCell( child: Text( "Round Count" ) )
										, TableCell( 
														child: Row( 
															mainAxisAlignment: MainAxisAlignment.end
														,	children: [ 
															Text( "0", textScaleFactor: 1.5 )
														,	Column( children: [
																new MaterialButton( 
																	child: Icon( Icons.arrow_circle_up, size: 30 )
																, onPressed: () {} 
																)
															, new MaterialButton( 
																	child: Icon( Icons.arrow_circle_down, size: 30 )
																, onPressed: () {} 
																)
														])
													])
												)
											])

									,	TableRow( children: [ 
											TableCell( child: Text( "" ) ), 
											TableCell( child: Text( "" ) ) ] )

									,	TableRow( children: [
											TableCell( child: Text( "Rest Interval" ) )
										, TableCell( child: 
												Row( 
													mainAxisAlignment: MainAxisAlignment.end
												,	children: [ 
															Text( "0", textScaleFactor: 1.5 )
														,	Column( children: [
																new MaterialButton( 
																	child: Icon( Icons.arrow_circle_up, size: 30 )
																, height: 2 
																, onPressed: () {} 
																)
															, new MaterialButton( 
																	child: Icon( Icons.arrow_circle_down, size: 30 )
																, height: 2
																, onPressed: () {} 
																)
														])
													]
												)
											)
										])
									]
								)
							])
						)
					*/
					]
			))) 
		);
	}
}
