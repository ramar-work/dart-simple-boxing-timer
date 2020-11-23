/*
audio.dart

All of the audio work COULD be hard to plug in together...

https://pub.dev/packages/audioplayers/example
*/
import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/src/foundation/constants.dart';

class Audio {
	AudioCache _actx;

	var _bytes;

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
