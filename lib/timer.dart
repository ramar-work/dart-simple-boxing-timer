/*timer.dart*/
class BTimer {
	
	//Spot for the timer
	Timer _timer;

	//Define the different intervals here.
	int restInterval, workInterval, warnInterval;

	//Thinking about passing a different structure to control the different times	
	BTimer( ) {
	}

	//Start a timer
	void start() {
		_timer = Timer.periodic( new Duration( milliseconds: _resolution ), ( Timer t ) {
			_updateTime();
			if ( !_tswarnTriggered && !rest && ( _elapsedMs >= ( _len - tswarn ) ) ) {
				warnBell.play();
				_tswarnTriggered = true;
			}
			else if ( _elapsedMs >= _len ) {
				_roundCurrent += ( rest = !rest ) ? 0 : 1;
				if ( !rest && ( _roundCurrent > _roundLimit ) ) {
					debugPrint( "@ end of workout." );
					_timer.cancel();
				}
				else {
					_roundText = ( rest ) ? "REST" : "ROUND ${ _roundCurrent }";
					_elapsedMs = 0;
					_len = ( rest ) ? _restLen : _roundLen; 	
					mainColor = ( rest ) ? Styling.rest : Styling.active; 	
					mainBell.play();	
					_tswarnTriggered = false;
				}
			}
			return t;
		});
	}
	
	//Stop a timer	
	void stop() {

	}		
}
