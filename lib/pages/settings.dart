/*settings.dart - Configuration for the app itself - Might load from SQL in the future*/
import 'package:flutter/material.dart';
import '../toggler.dart';
import '../input.dart';
import '../exercise.dart';

/*
class Settings extends StatelessWidget {
	@override
	Widget build ( BuildContext ctx ) {
		return Scaffold( 
			body: Center( 
				child: Column(
					children: [ 
						Text( 'settings' )
					, ElevatedButton( 
							child: Text( 'Go back' ) 
						, onPressed: () {
								Navigator.pop( ctx );
							}
						)
					]
				)
			)
		);
	}
}
*/


class SettingsPage extends StatefulWidget {

 	SettingsPage({Key key}) : super(key: key);

	@override
  _SettingsPageState createState() => _SettingsPageState();
}



class _SettingsPageState extends State<SettingsPage> {

  @override
	Widget build(BuildContext ctx) {

		Exercise exercise = new Exercise( "Custom", 0, 0, 0, 0 );

		return Scaffold( 
			body: Center( 
				child: Container(
					padding: new EdgeInsets.all( 30.0 ),
					//crossAxisAlignment: CrossAxisAlignment.stretch,
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
										, TableCell( child: ExerciseInput( exercise: exercise, field: "length" ) )
										])
									,	TableRow( children: [
											TableCell( child: Text( "Round Count" ) )
										, TableCell( child: ExerciseInput( exercise: exercise, field: "rounds" ) )
										])
									,	TableRow( children: [
											TableCell( child: Text( "Rest Interval" ) )
										, TableCell( child: ExerciseInput( exercise: exercise, field: "rest" ) )
										])
									]
								)
							])
						)

					, ElevatedButton( 
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
