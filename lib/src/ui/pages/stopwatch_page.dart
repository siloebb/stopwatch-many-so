import 'package:flutter/material.dart';
import 'package:stopwatch/src/controller/controller.dart';
import 'package:stopwatch/src/controller/stopwatch_state.dart';
import 'package:stopwatch/src/utils.dart';

class StopWatchPage extends StatefulWidget {
  const StopWatchPage({super.key});

  @override
  State<StopWatchPage> createState() => _StopWatchPageState();
}

class _StopWatchPageState extends State<StopWatchPage> {
  final controller = Controller();

  late StopwatchState stopwatchState =
      const StopwatchState(laps: [], isRunning: false);

  @override
  void initState() {
    super.initState();
    controller.streamState().listen(stateUpdate);
  }

  stateUpdate(StopwatchState state) {
    setState(() {
      stopwatchState = state;
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.close();
  }

  bool _isPortrait(BoxConstraints constraints) {
    return constraints.maxHeight > constraints.maxWidth;
  }

  bool _isWatch(BoxConstraints constraints) {
    return constraints.maxHeight < 200 && constraints.maxWidth < 200;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: LayoutBuilder(
            builder: (context, BoxConstraints constraints) {
              if (_isWatch(constraints)) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 6),
                    _buildTimer(),
                    Flexible(
                      child: _buildLaps(),
                    ),
                    _buildButtons(),
                    const SizedBox(height: 6),
                  ],
                );
              }
              if (_isPortrait(constraints)) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    _buildTimer(),
                    const SizedBox(height: 20),
                    Expanded(
                      child: _buildLaps(),
                    ),
                    _buildButtons(),
                    const SizedBox(height: 20),
                  ],
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildTimer(),
                            const SizedBox(height: 20),
                            _buildButtons(),
                          ],
                        ),
                      ),
                      if (stopwatchState.laps.isNotEmpty)
                        Flexible(
                          flex: 1,
                          fit: FlexFit.loose,
                          child: _buildLaps(),
                        ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTimer() {
    return StreamBuilder(
      key: const Key("timer"),
      initialData: Duration.zero,
      stream: controller.listenTimer(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(
            Utils.formatTime(snapshot.data!),
            style: const TextStyle(
              fontSize: 32,
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Widget _buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildLapResetBtn(stopwatchState),
        _buildPlayPauseBtn(stopwatchState),
      ],
    );
  }

  Widget _buildPlayPauseBtn(StopwatchState data) {
    final isRunning = data.isRunning;
    String text = isRunning ? "Pause" : "Play";
    return TextButton(
      onPressed: () {
        if (isRunning) {
          controller.stop();
        } else {
          controller.start();
        }
      },
      child: Text(text),
    );
  }

  Widget _buildLapResetBtn(StopwatchState data) {
    final isRunning = data.isRunning;
    String text = isRunning ? "Lap" : "Reset";
    return TextButton(
      onPressed: () {
        if (isRunning) {
          controller.trackLap();
        } else {
          controller.reset();
        }
      },
      child: Text(text),
    );
  }

  Widget _buildLaps({bool isWatch = true}) {
    if (stopwatchState.laps.isEmpty) {
      return const SizedBox();
    }
    return ListView.builder(
      itemCount: stopwatchState.laps.length + 1,
      itemBuilder: (_, index) {
        if (index == 0) {
          return Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1.5, color: Colors.grey),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Lap"),
                Text("Lap time"),
              ],
            ),
          );
        }

        final reverseIndex = stopwatchState.laps.length - index + 1;
        final lap = Utils.formatTime(stopwatchState.laps.elementAt(
          reverseIndex - 1,
        ));
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(reverseIndex.toString()),
            Text(lap),
          ],
        );
      },
    );
  }
}
