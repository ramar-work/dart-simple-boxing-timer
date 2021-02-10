/* help.dart */
import 'package:flutter/material.dart';
import 'dart:math';
import '../const.dart';


//HelpPage menu
class HelpPage extends StatelessWidget {
	
	//All are multi-line paragraphs	
	final String intro = """
The ${ Const.name } helps you clock your boxing workouts.   
	""";

	final String olympic = """
Olympic mode starts a timer that runs for three rounds at three minutes a piece.  
The default break time between rounds is one minute.
	""";

	final String pro = """
Pro mode starts a timer that runs for twelve rounds at three minutes a piece.  
The default break time between rounds is thirty seconds.
	""";

	final String custom = """
	Finally, custom workouts can last as long as you wish and are configurable via
	the Settings (display icon here) menu on the home screen.
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

					, Container( child: Column( children: [
							Text( intro )
						,	Text( olympic )
						,	Text( pro )
						] ) )

					, Spacer( flex: 1 )
					, new Row(
							children: [
								Spacer()
							, new Image.asset( 'assets/img/ibtw.png' )
							, Spacer()
							]) 

					, Spacer( flex: 1 )
					])
				)
			)
		);
	}
}
