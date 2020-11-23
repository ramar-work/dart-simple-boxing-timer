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
import 'exercise.dart';
import 'help.dart';
import 'styling.dart';
import 'audio.dart';

const String app_title = "It's Boxing Time";

void main() => runApp( BoxingTimeApp() );

class BoxingTimeApp extends StatelessWidget {
  @override
  Widget build(BuildContext ctx) {

		List<Exercise> types = [
			Exercise( "Olympic", 180000, 30000, 17000, 100 )
		, Exercise( "Pro", 180000, 30000, 17000, 100 )
		, Exercise( "Custom", -1, -1, -1, -1 )
		];

    return MaterialApp(
      title: app_title,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
			routes: {
				"/": (ctx) => Home( types.get( 0 ) )
			, "/help": (ctx) => new Help() 
			, "/settings": (ctx) => new Settings() 
			}
    );
  }
}


class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}


class _HomeState extends State<Home> {

	//Private configuration that will most likely never change
	BuildContext _ctx;
	final double _elevation = 3;
	final List<int> _impendingEndOptions = [ 2000, 10000, 10000, -1 ]; //This should almost always be 10 secs
	final int _resolution = 50;
	final List<int> _roundLenOptions = [ 15000, 180000, 180000, -1 ];	//Length of workout time
	final List<int> _restOptions = [ 2000, 60000, 30000, -1 ]; //Length of rest interval
	final List<int> _roundLimitOptions = [ 2, 3, 12, -1 ]; //Round count
	Timer _timer;
	final int tswarn = 10000;	
	final double _xButtonSize = 60;
	Audio mainBell, warnBell;

	//Theme
	Color mainColor, settingsColor, helpColor, resetColor, bgColor, fgColor;

	//User's selected type of workout
	int type = 1;

	//Time tracking variables.
	int _elapsedMs = 0, _min = 0, _msecs = 0, _secs = 0;

	//NOTE: All of this is set later
	int _roundCurrent = 1;  //Place for the round
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
			var localms = ( _elapsedMs += _resolution ) ~/ 1000;
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
			!_alarmTriggered ? mainBell.play() : 0 ;
			_alarmTriggered = true;

			_timer = Timer.periodic( new Duration( milliseconds: _resolution ), ( Timer t ) {
				_updateTime();
				if ( !_tswarnTriggered && !rest && ( _elapsedMs >= ( _len - tswarn ) ) ) {
					warnBell.play();
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
						mainColor = ( rest ) ? Styling.rest : Styling.active; 	
						mainBell.play();	
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
		, color: mainColor 
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

	@override
	initState() {
		_roundLimit = _roundLimitOptions[ type ];
		_restLen = _restOptions[ type ];
		_len = _roundLen = _roundLenOptions[ type ];
		_roundText = "ROUND ${ _roundCurrent }";
		mainColor = Styling.active;
		mainBell = new Audio( 'wav/eor.wav' );
		warnBell = new Audio( 'wav/aeor.wav' );
	}

	//Stop the time
	void _reset() {
		_timer.cancel();
		_canceled = true;	
		_alarmTriggered = false;
		_tswarnTriggered = false;
		setState( () {
			_elapsedMs = 0;
			mainColor = Styling.active; 	
			_secs = 0;
			_min = 0;
			_msecs = 0;
    });
	}

	//Start the timer.
	void _startTimer() {
		_timer = Timer.periodic( new Duration( milliseconds: _resolution ), ( Timer t ) {
			_updateTime();
			return t;
		} );
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
				, new Row(
						children: [
							Center( child: Text( 'Pro' ) ) 
						]
					) 
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
