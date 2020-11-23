/* help.dart */
import 'package:flutter/material.dart';
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
