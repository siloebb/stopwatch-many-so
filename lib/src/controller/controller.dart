import 'dart:async';
import 'package:stopwatch/src/controller/stopwatch_state.dart';

class Controller {
  final Stopwatch _stopwatch = Stopwatch();

  final List<Duration> _laps = [];

  final StreamController<StopwatchState> _stateStreamController =
      StreamController.broadcast();

  close() {
    _stateStreamController.close();
  }

  start() {
    if (isRunning == false) {
      _updateState();
      _stopwatch.start();
      _updateState();
    }
  }

  stop() {
    _stopwatch.stop();
    _updateState();
  }

  trackLap() {
    final elapsed = _stopwatch.elapsed;
    _laps.add(elapsed);
    _updateState();
  }

  reset() {
    _stopwatch.reset();
    _laps.clear();
    _updateState();
  }

  bool get isRunning => _stopwatch.isRunning;

  _updateState() {
    _stateStreamController.add(
      StopwatchState(
        laps: _laps,
        isRunning: isRunning,
      ),
    );
  }

  Stream<Duration> listenTimer() => Stream<Duration>.periodic(
        const Duration(milliseconds: 30),
        (x) => _stopwatch.elapsed,
      );

  Stream<StopwatchState> streamState() => _stateStreamController.stream;
}
