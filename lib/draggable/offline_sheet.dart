import 'package:cyclopath/models/user_session.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OfflineSheet extends StatelessWidget {
  const OfflineSheet({
    this.model,
    required this.drawerController,
    required this.dropArrowController,
  });

  final UserSession? model;
  final AnimationController drawerController;
  final AnimationController dropArrowController;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Column(
          children: [
            const SizedBox(
              height: 6.0,
            ),
            Container(
              width: 30,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: const BorderRadius.all(
                  Radius.circular(12.0),
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Row(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                const Expanded(
                  child: Text(
                    'Starte Schicht um:',
                    style: TextStyle(fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            const Divider(
              height: 20,
            ),
            ShiftStarts(
              drawerController: drawerController,
              dropArrowController: dropArrowController,
            ),
            Container(
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Visibility(
                    visible: false,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('Go online'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class ShiftStarts extends StatelessWidget {
  ShiftStarts({
    required this.drawerController,
    required this.dropArrowController,
  });

  final AnimationController drawerController;
  final AnimationController dropArrowController;

  final TimeOfDay now = TimeOfDay.now();
  final DateTime timely =
      DateTime.now().subtract(Duration(minutes: TimeOfDay.now().minute % 5));

  @override
  Widget build(BuildContext context) {
    final timingButtons = <Widget>[];

    for (var i = 0; i < 6; i++) {
      timingButtons.add(
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: ElevatedButton(
            onPressed: () {
              drawerController.reverse();
              dropArrowController.forward();
              Future.delayed(
                Duration(
                  milliseconds: drawerController.value == 1 ? 300 : 120,
                ),
                () {
                  // Wait until animations are complete to reload the state.
                  // Delay scales with the timeDilation value of the gallery.
                  context.read<UserSession>().selectedUserSessionType =
                      UserSessionType.online;
                },
              );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(20),
              minimumSize: const Size(260, 0.0),
            ),
            child: shiftTimer(i, context),
          ),
        ),
      );
    }

    return Column(
      children: timingButtons,
    );
  }

  Text shiftTimer(int i, BuildContext context) {
    return Text(
      i < 2
          ? i < 1
              ? '${fiveBelow().format(context)} (vor ${now.minute % 5} Minuten)'
              : 'JETZT'
          : TimeOfDay.fromDateTime(
              timely.add(
                Duration(
                  minutes: 5 * (i - 1),
                ),
              ),
            ).format(context),
      style: const TextStyle(fontSize: 20),
    );
  }

  TimeOfDay fiveBelow() => TimeOfDay.fromDateTime(
        DateTime.now().subtract(
          Duration(minutes: now.minute % 5),
        ),
      );
}

  // var _dateTime = DateTime.now();
  // late Timer _timer;

  // @override
  // void initState() {
  //   super.initState();
  //   _updateTime();
  // }

  // @override
  // void dispose() {
  //   super.dispose();
  //   _timer.cancel();
  // }
  // void _updateTime() {
  //   setState(() {
  //     _dateTime = DateTime.now();
  //     _timer = Timer(
  //       const Duration(seconds: 1) -
  //           Duration(milliseconds: _dateTime.millisecond),
  //       _updateTime,
  //     );
  //   });
  // }
