/*
audio.dart

https://pub.dev/packages/audioplayers/example
*/
import 'dart:async';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

class Audio {
	AudioCache _actx;

	var _bytes;

	Audio( String asset ) {
		load( asset );
	}

	void load( String asset ) async {
		_actx = new AudioCache();	
		_bytes = await( await _actx.load( asset ) ).readAsBytes();
	}

	void play() {
		_actx.playBytes( _bytes );
	}
		
	/*
	where is the destructor?
	*/
}
