/*settings.dart - Configuration for the app itself - Might load from SQL in the future*/
import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
	@override
	Widget build ( BuildContext ctx ) {
		return Scaffold( 
			body: Center( 
				child: Column(
					children: [ 
						Text( 'settings' )
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
