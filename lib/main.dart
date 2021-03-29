/**
 * main.dart
 * ---------
 * 
 * TODO
 * ====
 * 
**/
import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';
import 'dart:async';

//Components
import 'exercise.dart';
import 'styling.dart';
import 'audio.dart';
import 'toggler.dart';

//"Activities" / Pages
import 'pages/settings.dart';
import 'pages/help.dart';


const String app_title = "It's Boxing Time";


//Track time seperately
class Time {
	int elapsed = 0;
	int min = 0;
	int msecs = 0;
	int secs = 0;
	bool r_canceled = false;
	bool r_rest = false;
	bool r_triggered = false;
	bool w_triggered = false;
	Time();
}



//Define a round
class Round {
	int current;
	int length;
	String text;

	Round( this.current, this.length );
}



//Define a theme
class xTheme {
	Color main, settings, help, reset, bg, fg;
	xTheme(); 
}



//Clickable areas / text should be easy now
class Clickable {
	String text;
	BuildContext ctx;

	//This should be static
	Widget activate() {
		return GestureDetector(
			onTap: () {
				debugPrint( "Button Clicked." );
			}
		,	child: Text( text ) //this could just be a widget
		);
	}

	Clickable( this.ctx, this.text );
}


//Define styles here...
final Styling lightstyle = Styling(
	"assets/img/bg-top-white.png",
	Colors.red[800],
	Colors.grey[100],
	Colors.orange
);



//....
class Home extends StatefulWidget {
  Home({ Key key }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}



//....
class _HomeState extends State<Home> {
	
	//Private configuration that will most likely never change
	final double _elevation = 3;
	final int    _res = 50;
	final double _xButtonSize = 60;
	Styling style;
	int exnum = 0;
	Exercise ex;

	//Private accessible fields
	BuildContext _ctx;
	Timer _timer;
	Audio bell, mbell, wbell;

	//Theme
	Color mainColor, settingsColor, helpColor, resetColor, bgColor, fgColor;
	//xTheme theme;

	//Time tracking variables.
	int _elapsedMs = 0, _min = 0, _msecs = 0, _secs = 0;
	bool _canceled = true, rest = false, _alarmTriggered = false, _tswarnTriggered = false;

	//NOTE: All of this is set later
	Round round;

	//Update the time
  void _updateTime() {
		setState( () {
			var localms = ( _elapsedMs += _res ) ~/ 1000;
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
			( ! _alarmTriggered ) ? bell.play( 'eor.wav' ) : 0 ;
			_alarmTriggered = true;

			_timer = Timer.periodic( new Duration( milliseconds: _res ), ( Timer t ) {
				_updateTime();
				if ( !_tswarnTriggered && !rest && ( _elapsedMs >= ( round.length - ex.warning ) ) ) {
					bell.play( 'aeor.wav' );
					_tswarnTriggered = true;
				}
				else if ( _elapsedMs >= round.length ) {
					round.current += ( rest = !rest ) ? 0 : 1;
					if ( !rest && ( round.current == ( ex.rounds + 1 ) ) ) {
						debugPrint( "@ end of workout." );
						_timer.cancel();
					}
					else {
						_elapsedMs = 0;
						round.text = ( rest ) ? "REST" : "ROUND ${round.current}";
						round.length = ( rest ) ? ex.rest : ex.length; 	
						mainColor = ( rest ) ? style.rest : style.active; 	
						_tswarnTriggered = false;
						bell.play( 'eor.wav' );
					}
				}
				return t;
			} );
		}
	}


	//Stop the time
	void _help() {
		debugPrint( "HelpPage pressed!" );
		Navigator.pushNamed( _ctx, "help" );
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
			onPressed: () async { 
				var r = await Navigator.pushNamed( _ctx, 'settings' );
				setState( () {
					ex = r;
					_reset();
					round = Round( 1, ex.length );
					round.text = "ROUND ${round.current}";
					debugPrint( "Exe recvd: ${ ex } " );
					debugPrint( "Type is : ${ ex.typestring } " );
				} );
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
							"${ round.text }" 
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


	//Stop the time
	void _reset() {
		if ( _timer != null ) {
			_timer.cancel();
		}
		_canceled = true;	
		_alarmTriggered = false;
		_tswarnTriggered = false;
		setState( () {
			_elapsedMs = 0;
			_secs = 0;
			_min = 0;
			_msecs = 0;
			round = Round( 1, ex.length );
			round.text = "ROUND ${round.current}";
			mainColor = style.active; 	
    });
	}


	//Start the timer.
	void _startTimer() {
		_timer = Timer.periodic( new Duration( milliseconds: _res ), ( Timer t ) {
			_updateTime();
			return t;
		} );
	}


	@override
	initState() {
		//ex = Exercise.recall();
		ex = Exercise.types[ 1 ];
		style = lightstyle;
		round = Round( 1, ex.length );
		round.text = "ROUND ${round.current}";
		mainColor = style.active;
		bell = new Audio( [ 'eor.wav', 'aeor.wav' ] );
	}

  @override
  Widget build(BuildContext ctx) {
		_ctx = ctx;
	
    return Scaffold(
      body: Container(
				decoration: BoxDecoration( 
					image: DecorationImage( 
						image: AssetImage( style.bgImage )
					, fit: BoxFit.cover
					) 
				),
				child: Column(
					crossAxisAlignment: CrossAxisAlignment.stretch,
					children: <Widget>[ 
						Spacer( flex: 1 )
					,	new Row(
						 children: <Widget>[
								xButton( Icons.help, Colors.orange, _help )
							, Spacer()
							, xButton( Icons.restore, Colors.purple, _reset )
							])
					, new Row(
							children: [
								Spacer()
							, Center( child: Text(
									ex.typestring,
									textScaleFactor: 1.5, 
									style: TextStyle( fontStyle: FontStyle.italic )
								))
							, Spacer()
							])
					, Spacer( flex: 1 )
					, new Row( 
							children: [ 
								Spacer()
							, Center( child: watchButton() ) 
							, Spacer()
							] )
					, Spacer( flex: 1 )
					, new Row(
							children: [
								Spacer()
							, new Image.asset( 'assets/img/ibtw.png' )
							, Spacer()
							]) 
					, Spacer( flex: 2 )
					]
				) 
			),
      floatingActionButton: settingsButton()
    );
  }
}


class BoxingTimeApp extends StatefulWidget {
	BoxingTimeApp({Key key}) : super(key: key);

	@override
	_BoxingTimeAppState createState() => _BoxingTimeAppState();
}


class _BoxingTimeAppState extends State<BoxingTimeApp> {
	@override
	initState() {
		debugPrint( "Init state and create navigator" );
	}

  @override
  Widget build(BuildContext ctx) {
		return MaterialApp(
			title: app_title,
			routes: {
				"/": ( ctx ) => new Home()
			, "help": ( ctx ) => new HelpPage()
			, "settings": ( ctx ) => new SettingsPage() 
			}
		);
  }
}


void main() => runApp( BoxingTimeApp() );

