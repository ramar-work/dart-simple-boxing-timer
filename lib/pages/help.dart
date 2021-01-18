/* help.dart */
import 'package:flutter/material.dart';


//HelpPage menu
class HelpPage extends StatelessWidget {
	
	//All are multi-line paragraphs	
	final String intro = """
		Something about how this is the best boxing app in the universe.
	""";

	final String olympic = """
		Describe an Olympic workout.
	""";

	final String pro = """
		Describe an Professional workout.
	""";

	final String custom = """
		Describe how custom workouts work.
	""";

  @override
  Widget build(BuildContext ctx) {
    return Scaffold( body: Center( child: Column(
			crossAxisAlignment: CrossAxisAlignment.stretch,
			children: <Widget>[ 
				Spacer( flex: 1 )
			,	new Row( 
				 children: <Widget>[
						Center( child: Text(
							"Help",
							textScaleFactor: 2.0, 
							style: TextStyle( fontWeight: FontWeight.bold )
						) )
					])
			,	Spacer( flex: 1 )
			, new Row(
					children: [
						Spacer()
					, Text(
							"Random Text",
							textScaleFactor: 1.5, 
							style: TextStyle( fontStyle: FontStyle.italic )
						)
					, Spacer()
					])
			, Spacer( flex: 1 )
			, new Row( 
					children: [ 
						Spacer()
					, Center( child: Text( "bang" ) ) 
					, Spacer()
					] )
			, Spacer( flex: 1 )
			, new Row(
					children: [
						Spacer()
					, new Image.asset( 'assets/img/ibtw.png' )
					, Spacer()
					]) 
			, ElevatedButton( 
					child: Text( 'Go back' ) 
				, onPressed: () {
						Navigator.pop( ctx );
					}
				)
			, Spacer( flex: 2 )
			]
		) ) );
	}
}
