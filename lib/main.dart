/**
main.dart
---------

TODO

*/
import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

import 'settings.dart';

const String app_title = "It's Boxing Time";

void main() => runApp( BoxingTimeApp() );

class BoxingTimeApp extends StatelessWidget {
  @override
  Widget build(BuildContext ctx) {
    return MaterialApp(
      //home: new Home(),
      title: app_title,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
			routes: {
				"/": (ctx) => Home() 
			, "/help": (ctx) => Help() 
			, "/settings": (ctx) => Settings() 
			}
    );
  }
}


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

class Help extends StatelessWidget {
	@override
	Widget build ( BuildContext ctx ) {
		return Scaffold( 
			body: Center( 
				child: Column(
					children: [ 
						Text( 'help' )
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

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

/*
we'll need a timer within this widget
*/
class _HomeState extends State<Home> {

	//Granularity of our timer
	final resolution = 50; //const Duration( milliseconds: 50 );
	final double _elevation = 3;
	final double _xButtonSize = 60;

	BuildContext _ctx;

	//Colors
	Color _mainColor;

	//Pointer to repeating timer.
	Timer _timer;

	//...
	static final List<int> _roundLenOptions = [ 15000, 180000, 180000, -1 ];	//Length of workout time
	static final List<int> _restOptions = [ 2000, 60000, 30000, -1 ]; //Length of rest interval
	static final List<int> _roundLimitOptions = [ 2, 3, 12, -1 ]; //Round count
	static final List<int> _impendingEndOptions = [ 2000, 10000, 10000, -1 ]; //Round count

	static final int tswarn = 10000;	
	int _elapsedMs = 0;//Total time passed
	int _secs = 0;//Display seconds
	int _min = 0;//Display minutes
	int _msecs = 0;//Display centiseconds

	//NOTE: All of this is set later
	int _roundCurrent = 1;  //Place for the round
	int _type = 1;   //Type of workout
	int _roundLen = 0;
	int _restLen = 0;
	int _roundLimit = 0; 
	int _len = 0;

	String _roundText;

	//Canceled
	bool _canceled = true;

	bool rest = false;

	bool _alarmTriggered = false;

	bool _tswarnTriggered = false;

	//Update the time
  void _updateTime() {
		setState( () {
			var localms = ( _elapsedMs += resolution ) ~/ 1000;
			_secs = localms % 60;
			_min = localms ~/ 60;
			_msecs = _elapsedMs % 1000; 
    });
  }

	//Stop the time
	void _toggleTime() {
		if ( _canceled = !_canceled )
			_timer.cancel();
		else {
			//Play the sound ONCE
			!_alarmTriggered ? _playSound() : 0 ;
			_alarmTriggered = true;

			_timer = Timer.periodic( new Duration( milliseconds: resolution ), ( Timer t ) {
				_updateTime();
				if ( !_tswarnTriggered && !rest && ( _elapsedMs >= ( _len - tswarn ) ) ) {
					_playtswarn();
					_tswarnTriggered = true;
				}
				else if ( _elapsedMs >= _len ) {
					_roundCurrent += ( rest = !rest ) ? 0 : 1;
					if ( !rest && ( _roundCurrent > _roundLimit ) ) {
						debugPrint( "@ end of workout." );
						_timer.cancel();
					}
					else {
						_roundText = ( rest ) ? "REST" : "ROUND ${ _roundCurrent }";
						_elapsedMs = 0;
						_len = ( rest ) ? _restLen : _roundLen; 	
						_mainColor = ( rest ) ? Styling.rest : Styling.active; 	
						_playSound();
						_tswarnTriggered = false;
					}
				}
				return t;
			} );
		}
	}

	//Stop the time
	void _help() {
		debugPrint( "Help pressed!" );
		Navigator.pushNamed( _ctx, "/help" );
		//( _canceled = !_canceled ) ? 0 : _timer.cancel();
	}


	//Generate a button
	MaterialButton xButton( IconData icon, Color color, VoidCallback callback ) {
		const double pv = 15;
		const double radius = 30;
		return new MaterialButton(
			onPressed: callback
		, padding: EdgeInsets.only( left: pv, right: pv )
		, color: color
		, height : 60 
		, minWidth: _xButtonSize
		, elevation: _elevation
		, child: Icon( icon, color: Colors.white, size: 30 )
		, shape: new RoundedRectangleBorder(
				borderRadius: new BorderRadius.circular( radius )
			)
		);
	}

	//Generate a settings button
	FloatingActionButton settingsButton() {
		return new FloatingActionButton(
			tooltip: 'Increment',
			child: Icon( Icons.settings ),
			onPressed: () { 
				Navigator.pushNamed( _ctx, '/settings' ); 
			},
		);
	}

	//Generate the giant watch
	MaterialButton watchButton() {
		return new MaterialButton(
			onPressed: _toggleTime
		, color: _mainColor 
		, padding: EdgeInsets.only( left: 50.0, right: 50.0 )
		, elevation: 3
		, height: 400
		, child: Column(
				children: <Widget>[
					Row( 
						children: [ 
							Text( 
								"${_min}:${sprintf( '%02i', [_secs] )}:" 
							, style: TextStyle( letterSpacing: -3, fontSize: 100 )
							)
						, Text( 
								"${sprintf( '%03i', [_msecs] )}" 
							, style: TextStyle( letterSpacing: -1, fontSize: 30 )
							)
						]
					)
				,	Row( 
						children: [ Text(
							"${_roundText}" 
						, style: TextStyle( letterSpacing: -2, fontSize: 40 )
						, textAlign: TextAlign.center
						)]
					)
				]
			)
		, shape: new RoundedRectangleBorder( 	
				borderRadius: new BorderRadius.circular( 200.0 )
			)
		);
	}


	//AudioAgent audio;
	//audio.playEndBell();
	//audio.playWarningBell();


	AudioCache ac_endbell;
	AudioCache ac_tsbell;
	var roundEndBell;
	var roundTenSecondBell;

	void _loadSounds() async {
		roundEndBell = await ( await ac_endbell.load( 'wav/eor.wav' ) ).readAsBytes(); ;
		roundTenSecondBell = await ( await ac_tsbell.load( 'wav/aeor.wav' ) ).readAsBytes(); ;
	}

	@override
	initState() {
		_roundLimit = _roundLimitOptions[ _type ];
		_restLen = _restOptions[ _type ];
		_len = _roundLen = _roundLenOptions[ _type ];
		_roundText = "ROUND ${ _roundCurrent }";
		_mainColor = Styling.active;
		ac_endbell = new AudioCache();
		ac_tsbell = new AudioCache();
		_loadSounds();
	}

	//Stop the time
	void _reset() {
		debugPrint( "Reset pressed!" );

		_timer.cancel();
		_canceled = true;	
		_alarmTriggered = false;
		_tswarnTriggered = false;

		setState( () {
			_elapsedMs = 0;
			_mainColor = Styling.active; 	
			_secs = 0;
			_min = 0;
			_msecs = 0;
    });
	}

	//Start the timer.
	void _startTimer() {
		_timer = Timer.periodic( new Duration( milliseconds: resolution ), ( Timer t ) {
			_updateTime();
			return t;
		} );
	}

	void _playSound() {
		ac_endbell.playBytes( roundEndBell );
	}

	void _playtswarn () {
		ac_tsbell.playBytes( roundTenSecondBell );
	}

  @override
  Widget build(BuildContext ctx) {
		_ctx = ctx;
		//needs three rows
    return Scaffold(
      body: Center( child: Column(
				crossAxisAlignment: CrossAxisAlignment.stretch,
				children: <Widget>[ 
					Spacer( flex: 1 )
				,	new Row( 
					 children: <Widget>[
							xButton( Icons.help_center, Colors.orange, _help )
						, Spacer()
						, xButton( Icons.restore, Colors.purple, _reset )
						]
					) 
				, Spacer( flex: 1 )
				, new Row( 
						children: [ 
							Center( child: watchButton() ) 
						] )
				, Spacer( flex: 2 )
				]
			) ),
      floatingActionButton: settingsButton()
    );
  }
}
