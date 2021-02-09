/* help.dart */
import 'package:flutter/material.dart';
import 'dart:math';


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
    return Scaffold( 
			body: Center( 
				child: Container(
					padding: new EdgeInsets.all( 30.0 ),
					child: Column( children: <Widget>[ 
						Spacer( flex: 1 )

					,	new Row( 
						 children: <Widget>[
								Align( 
									alignment: Alignment.topLeft
								,	child: Text(
										"Help", textScaleFactor: 4.0, 
										style: TextStyle( fontWeight: FontWeight.bold )
									) 
								)
							,	Spacer( flex: 1 )
							,	Align(
									alignment: Alignment.topRight
								,	child: new MaterialButton( 
										child: Transform.rotate( 
											angle: 180 * pi/180,
											child: Icon( Icons.arrow_right_alt, color: Colors.grey, size: 40 )
										)
									, color: Colors.grey[50]
									, height: 70.0
									, minWidth: 35.0
									, shape: new RoundedRectangleBorder( 
											borderRadius: new BorderRadius.circular( 40 )
										)
									, onPressed: () {
											Navigator.pop( ctx );
										}
									)
								)
							]
						)

					, Spacer( flex: 1 )

					, new Row(
							children: [
								Spacer()
							, new Image.asset( 'assets/img/ibtw.png' )
							, Spacer()
							]) 

					, Spacer( flex: 2 )
					])
				)
			)
		);
	}
}
