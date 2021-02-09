/*
audio.dart

https://pub.dev/packages/audioplayers/example
*/
import 'package:audioplayers/audio_cache.dart';

class Audio {
	AudioCache _actx;

	var _bytes;

	Audio( List<String> asset ) {
		load( asset );
	}

	void load( List<String> asset ) {
		_actx = new AudioCache( prefix: 'wav/' );	
		_actx.loadAll( asset );
	}

	void play( String asset ) {
		_actx.play( asset );
	}
}
