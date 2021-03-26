/*settings.dart - Configuration for the app itself - Might load from SQL in the future*/
import 'package:flutter/material.dart';
import '../toggler.dart';
import '../input.dart';
import '../exercise.dart';
import 'dart:math';
import 'package:sprintf/sprintf.dart';


Exercise _g;


class ExerciseInput extends StatefulWidget {
	//reference to an object coming from elsewhere	
	Exercise exercise;
	void Function( String, int ) updater;
	String field;
	int initial;

	ExerciseInput( {
		Key key, 
		@required this.field, 
		@required this.initial, 
		@required this.updater
	} ) : super( key: key );

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


TableRow tSpacer() {
	return TableRow( children: [ 
		TableCell( child: Text( "" ) ), 
		TableCell( child: Text( "" ) ) ] 
	);
}




class _CustomSettingsWidget extends StatefulWidget {

	//Get this elsewhere 
	Exercise custom, ce = null;

	_CustomSettingsWidget( { Key key, this.custom } ) : super( key : key );
	
	@override
  _CustomSettingsWidgetState createState() => _CustomSettingsWidgetState();

}


class _CustomSettingsWidgetState extends State<_CustomSettingsWidget> {

	//Initialize the custom exercise set here
	@override
	initState() {
		_g.typestring = "Custom";
	}

	@override	
	Widget build( BuildContext ctx ) {
		return Container( 
			padding: new EdgeInsets.symmetric( vertical: 20.0 ),
			child: Column( children: [
				new Row( children: <Widget>[ 
					Text( "Custom Timer Settings"
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
										Text( 
											"${sprintf( '%01i',[ _g.length ~/ 1000 ~/ 60 ] )}"
											":${sprintf( '%02i',[ _g.length ~/ 1000 % 60 ])}", 
											textScaleFactor: 1.5 
										)
									,	Column( children: [
											new MaterialButton( 
												child: Icon( Icons.arrow_circle_up, size: 30 )
											, onPressed: () => setState( () => _g.length += 1000 )
											)
										, new MaterialButton( 
												child: Icon( Icons.arrow_circle_down, size: 30 )
											, onPressed: () => setState( () => _g.length -= 1000 )
											)
										])
									]
								)
							)
						])
					
					, tSpacer()
					,	TableRow( children: [
							TableCell( child: Text( "Round Count" ) )
						, TableCell( 
										child: Row( 
											mainAxisAlignment: MainAxisAlignment.end
										,	children: [ 
											Text( "${_g.rounds > 0 ? _g.rounds : 'Inf' }", textScaleFactor: 1.5 )
										,	Column( children: [
												new MaterialButton( 
													child: Icon( Icons.arrow_circle_up, size: 30 )
												, onPressed: () { setState( () => _g.rounds ++ ); } 
												)
											, new MaterialButton( 
													child: Icon( Icons.arrow_circle_down, size: 30 )
												,	onPressed: () => setState( () {	
														_g.rounds = (_g.rounds == 0) ? 0 : _g.rounds - 1;
													} )
												)
										])
									])
								)
							])

					, tSpacer()
					,	TableRow( children: [
							TableCell( child: Text( "Rest Interval" ) )
						, TableCell( child: 
								Row( 
									mainAxisAlignment: MainAxisAlignment.end
								,	children: [ 
											Text( "${_g.rest ~/ 1000}s", textScaleFactor: 1.5 )
										,	Column( children: [
												new MaterialButton( 
													child: Icon( Icons.arrow_circle_up, size: 30 )
												, height: 2 
												,	onPressed: () { setState( () => _g.rest += 1000 ); } 
												)
											, new MaterialButton( 
													child: Icon( Icons.arrow_circle_down, size: 30 )
												, height: 2
												,	onPressed: () { setState( () => _g.rest -= 1000 ); } 
												)
										])
									]
								))
						])

					, tSpacer()
					,	TableRow( children: [
							TableCell( child: Text( "Warning Length" ) )
						, TableCell( child: 
								Row(
									mainAxisAlignment: MainAxisAlignment.end	
								,	children: [	
										Text( "${_g.warning ~/ 1000}s", textScaleFactor: 1.5 )
									,	Column( children: [
											new MaterialButton( 
												child: Icon( Icons.arrow_circle_up, size: 30 )
											, height: 2 
											,	onPressed: () { setState( () => _g.warning += 1000 ); } 
											)
										, new MaterialButton( 
												child: Icon( Icons.arrow_circle_down, size: 30 )
											, height: 2
											,	onPressed: () { setState( () => _g.warning -= 1000 ); } 
											)
									])
								]
							)
						)
					])
					])
				]));
	}	
}




class SettingsPage extends StatefulWidget {

 	SettingsPage({Key key}) : super(key: key);

	@override
  _SettingsPageState createState() => _SettingsPageState();
}



class _SettingsPageState extends State<SettingsPage> {

	BuildContext _ctx;

	bool custom = false; 

	_CustomSettingsWidget ce = null;

	//Update app settings
	saveSettings() async  {
		Exercise e = await Exercise.persist( _g );
		Navigator.pop( _ctx, e ); 
		debugPrint( "Saving exercise..." );
		debugPrint( Exercise.string( e ) );
	}

	//sigh...
	void boing( int i ) {
		setState( () => custom = ( i == 2 ) ? true : false );
	}

	@override
	initState() {
		//TODO: check for a record in sharedprefs first, then recall
		_g = new Exercise( "", 0, 0, 0, 0 );
	}

  @override
	Widget build( BuildContext ctx ) {
		_ctx = ctx;
		//widget.ex = _exercise;
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
											angle: 180 * pi / 180,
											child: Icon( Icons.arrow_right_alt, color: Colors.grey, size: 40 )
										)
									, color: Colors.grey[50]
									, height: 70.0
									, minWidth: 35.0
									, shape: new RoundedRectangleBorder( 
											borderRadius: new BorderRadius.circular( 40 )
										)
									, onPressed: saveSettings
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
										style: TextStyle( fontWeight: FontWeight.bold )
									)
								])

							, Table(
								  defaultVerticalAlignment: TableCellVerticalAlignment.middle
								,	children: [
										/*
										TableRow( children: [
											TableCell( child: Text( "Theme" ) )
										, TableCell( child: Align( 
												alignment: Alignment.topRight,
												child: new Toggler(
													sel: 0
												, keys: [ "Light", "Dark" ]
												, upd: (int i) { 
														;//_exercise.warning = i;
													}
												)
											) )
										])
										*/

									 	TableRow( children: [
											TableCell( child: Text( "Play Warning" ) )
										, TableCell( child: Align( 
												alignment: Alignment.topRight,
												child: new Toggler(
													sel: 0
												, keys: [ "On", "Off" ]
												, upd: (int i) { 
														//wow...
														_g.willWarn = i == 0 ? 1 : 0;
													}
												)
											) )
										])

									, tSpacer()
									,	TableRow( children: [
											TableCell( child: Text( "Timer Type" ) )
										, TableCell( 
												child: Align( 
													alignment: Alignment.topRight,
													child: new Toggler(
														sel: 0
													, keys: [ "Olympic", "Pro", "Custom" ]
													, upd: (int i) { 
															_g.type = i; 
															boing( i );
														}
													)
												)
											)
										])
								])
							])
						)
					, Spacer( flex: 2 )
					, ( !custom ) ? 
							Spacer( flex: 1 ) : _CustomSettingsWidget()
				]))));
	}
}
