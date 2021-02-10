///
/// exercise.dart
/// -------------
///

import 'package:shared_preferences/shared_preferences.dart';

class Exercise {
	String typestring;
	int type;
	int length;
	int rest;
	int warning;
	int rounds;
	int avg;

	Exercise( 
		this.typestring, 
		this.length, 
		this.rest, 
		this.warning, 
		this.rounds
	);

	static void persist( Exercise e ) async {
		SharedPreferences p = await SharedPreferences.getInstance();
		p.setString( "typestring", e.typestring );
		p.setInt( "length", e.length );
		p.setInt( "rest", e.rest );
		p.setInt( "warning", e.warning );
		p.setInt( "rounds", e.rounds );
	}

	static void recall() async {
		Exercise e = new Exercise( "", 0, 0, 0, 0 );
		SharedPreferences p = await SharedPreferences.getInstance();
		e.typestring = p.getString( "typestring" );
		e.length = p.getInt( "length" );
		e.rest = p.getInt( "rest" );
		e.warning = p.getInt( "warning" );
		e.rounds = p.getInt( "rounds" );
	}
}


