import 'package:flutter/material.dart';
import 'wop.dart';

const String app_title = "It's Boxing Time";

void main() => runApp(BoxingTimeApp());

class BoxingTimeApp extends StatelessWidget {
  @override
  Widget build(BuildContext ctx) {
    return MaterialApp(
      title: app_title,
      theme: ThemeData(
        primarySwatch: Colors.red,
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

class _HomeState extends State<Home> {
  void _incrementCounter() {
    setState(() {
    });
  }
  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
						new RaisedButton(
							onPressed: () => debugPrint( "Olympic mode was started" )
						, child: Text( "Olympic" )
						)
					, new RaisedButton(
							onPressed: () => debugPrint( "Pro mode was started" )
						, child: Text( "Pro" )
						)
					, new RaisedButton(
							onPressed: () => debugPrint( "Olympic mode was started" )
						, child: Text( "Hell" )
						)
					,	new RaisedButton(
							onPressed: () => debugPrint( "About mode was started" )
						, child: Text( "About" )
						)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
			)
    );
  }
}
