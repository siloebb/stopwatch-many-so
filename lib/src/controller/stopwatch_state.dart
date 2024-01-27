import 'dart:collection';

import 'package:flutter/foundation.dart';

@immutable
class StopwatchState {
  final List<Duration> laps;
  final bool isRunning;

  factory StopwatchState.clean() {
    return const StopwatchState(
      laps: [],
      isRunning: true,
    );
  }

  const StopwatchState({
    required this.laps,
    required this.isRunning,
  });
}