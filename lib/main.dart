import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';
import 'dart:async';
import 'wop.dart';

const String app_title = "It's Boxing Time";

void main() => runApp(BoxingTimeApp());

class BoxingTimeApp extends StatelessWidget {
  @override
  Widget build(BuildContext ctx) {
    return MaterialApp(
      title: app_title,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: new Home(),
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

	//Pointer to repeating timer.
	Timer _timer;

	//Pointer to repeating timer.
	bool _canceled = false;

	//Length of workout time
	static final _workoutLength = 3;

	//Length of rest interval
	static final _restLength = 1;

	//Total time passed
	int _elapsedMs = 0;

	//Display seconds
	int _secs = 0;

	//Display minutes
	int _min = 0;

	//Display centiseconds
	int _msecs = 0;

	//Update the time
  void _updateTime() {
		setState( () {
			_elapsedMs += resolution;
			_secs = _elapsedMs ~/ 1000;
			_min = _secs ~/ 60;
			_msecs = _elapsedMs % 1000; 
    });
  }

	//Stop the time
	void _toggleTime() {
		( _canceled = !_canceled ) ? 0 : _timer.cancel();
	}

	@override
	initState() {
		_timer = Timer.periodic( new Duration( milliseconds: resolution ), ( Timer t ) {
			//this fires once, so play a sound when it does
			_updateTime();
			return t;
		} );
	}

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
						new RaisedButton(
							onPressed: () => _toggleTime
						, child: Row( 
								children: [ 
									Text( "${_min}:${sprintf( '%02i', [_secs] )}:" )
								, Text( "${sprintf( '%03i', [_msecs] )}" ) 
								]
							)
						)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleTime,
        tooltip: 'Increment',
        child: Icon(Icons.add),
			)
    );
  }
}
