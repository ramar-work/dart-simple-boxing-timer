/*settings.dart - Configuration for the app itself - Might load from SQL in the future*/
import 'package:flutter/material.dart';

/*this isn't really a widget, it's just data... */
class Styling {
	//These really shouldn't change...
	static final Color help = Colors.yellow;
	static final Color reset = Colors.indigo;
	static final Color settings = Colors.blueGrey[200];

	//
	String bgImage; // "assets/img/bg-top-white.png"; 
	Color rest; // Colors.red[800];
	Color active; // Colors.grey[100];
	Color warn; // Colors.orange;

	//Initialize the changeable elements
	Styling(
		this.bgImage
	, this.rest
	, this.active	
	, this.warn
	);
}
