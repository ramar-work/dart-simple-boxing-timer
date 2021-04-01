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
	int willWarn = 1;
	//int countIn = 0;

	static final int lengthMax = ( 180 * 3 ) * 1000;
	static final int roundsMax = 20;
	//static final int countInMin = 0, countInMax = 30;
	//static bool willCountIn = false;

	static List<Exercise> types = [
		Exercise( "TEST"   , 10 * 1000, 3 * 1000, 3 * 1000, 3 )
	, Exercise( "Olympic", 180 * 1000, 60 * 1000, 10 * 1000, 3 )
	, Exercise( "Pro"    , 180 * 1000, 30 * 1000, 10 * 1000, 12 )
//, Exercise( "Custom" , -1, -1, -1, -1 )
	];

	Exercise( 
		this.typestring, 
		this.length, 
		this.rest, 
		this.warning, 
		this.rounds
	);

	static String string ( Exercise e ) {
		return """
		 Typestring ${ e.typestring }
		 len ${ e.length   }
		 rest ${ e.rest   }
		 warning ${ e.warning   }
		 rounds ${ e.rounds  }
		""";
	}

	static Future<Exercise> persist( Exercise e ) async {
		SharedPreferences p = await SharedPreferences.getInstance();
		p.setInt( "type", e.type );

		if ( e.type == 0 )
			return types[ 1 ];
		else if ( e.type == 1 )
			return types[ 2 ];	
		else { //custom or errors...
			//double check user settings and make sure they make sense
			//Exercise f = new Exercise( "Custom", 0, 0, 0, 0 );s
			if ( e.length > lengthMax ) 
				e.length = lengthMax;
			if ( e.rounds > roundsMax )
				e.rounds = roundsMax;
			
		}

		p.setString( "typestring", e.typestring );
		p.setInt( "length", e.length );
		p.setInt( "rest", e.rest );
		p.setInt( "warning", e.warning );
		p.setInt( "rounds", e.rounds );
		return e;
	}

	static bool check () {
		return false;
	}

	static Future<Exercise> recall() async {
		Exercise e = types[ 1 ];
		SharedPreferences p = await SharedPreferences.getInstance();
		e.typestring = p.getString( "typestring" );
		e.length = p.getInt( "length" );
		e.rest = p.getInt( "rest" );
		e.warning = p.getInt( "warning" );
		e.rounds = p.getInt( "rounds" );
		return e;
	}
}


