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

	static String string ( Exercise e ) {
		return """
		 Typestring ${ e.typestring   }
		 len ${ e.length   }
		 rest ${ e.rest   }
		 warning ${ e.warning   }
		 rounds ${ e.rounds  }
		""";
	}

	static void persist( Exercise e ) async {
		if ( e.type == 0 ) {
			e.length = 180;
			e.rest = 60;
			e.rounds = 3;
		}
		else if ( e.type == 1 ) {
			e.length = 180;
			e.rest = 30;
			e.rounds = 12;
		}
		else {
			; //custom
		}

		SharedPreferences p = await SharedPreferences.getInstance();
		p.setString( "typestring", e.typestring );
		p.setInt( "length", e.length );
		p.setInt( "rest", e.rest );
		p.setInt( "warning", e.warning );
		p.setInt( "rounds", e.rounds );
	}

	static bool check () {
		return false;
	}

	static Future<Exercise> recall() async {
		Exercise e = new Exercise( "boo", 0, 0, 0, 0 );
		SharedPreferences p = await SharedPreferences.getInstance();
		e.typestring = p.getString( "typestring" );
		e.length = p.getInt( "length" );
		e.rest = p.getInt( "rest" );
		e.warning = p.getInt( "warning" );
		e.rounds = p.getInt( "rounds" );
		return e;
	}
}


