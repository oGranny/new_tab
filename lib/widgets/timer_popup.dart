import 'package:flutter/material.dart';
import 'package:new_tab_app/widgets/notes/notes_alert.dart';
// import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

class PomodoroTimerWindow extends StatefulWidget {
  final VoidCallback onClose;

  const PomodoroTimerWindow({super.key, required this.onClose});

  @override
  _PomodoroTimerWindowState createState() => _PomodoroTimerWindowState();
}

class _PomodoroTimerWindowState extends State<PomodoroTimerWindow> {
  double dx = 1200;
  double dy = 2;
  Timer? _timer;
  int _remainingTime = 0;
  // final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void dispose() {
    _timer?.cancel();
    // _audioPlayer.dispose();
    super.dispose();
  }

  void _startTimer(int seconds) {
    setState(() {
      _remainingTime = seconds;
    });

    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          timer.cancel();
          _playSound();
        }
      });
    });
  }

  void _playSound() async {
    print("Timer Over");
    // await _audioPlayer.play(AssetSource('assets/sound/notification.mp3'));
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: dx,
      top: dy,
      child: Draggable(
        feedback: SizedBox.shrink(),
        onDragEnd: (dragDetails) {
          setState(() {
            dx = dragDetails.offset.dx;
            dy = dragDetails.offset.dy;
          });
        },
        child: Material(
          elevation: 10,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 300,
            height: 230,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black),
            ),
            child: Column(
              children: [
                GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      dx += details.delta.dx;
                      dy += details.delta.dy;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Color(0xFF191515),
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(10)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Timer",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.close, color: Colors.white),
                              onPressed: widget.onClose,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Clock Display
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    _formatTime(_remainingTime),
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.add, color: Colors.white),
                      onPressed: () {
                        TextEditingController controller =
                            TextEditingController();
                        showDialog(
                          context: context,
                          builder: (context) {
                            return NoteAlert(
                              controller: controller,
                              onSave: () {
                                setState(() {
                                  _startTimer(int.parse(controller.text));
                                });
                              },
                              hint: 'Time in Seconds',
                              title: 'Add Timer',
                            );
                          },
                        );
                      },
                    ),
                    IconButton(
                      onPressed: () {
                        _timer?.cancel();
                        setState(() {
                          _remainingTime = 0;
                        });
                      },
                      icon: Icon(Icons.replay_outlined, color: Colors.white),
                    )
                  ],
                )
                // Timers List
                // Expanded(
                //   child: ListView.builder(
                //     padding: EdgeInsets.all(10),
                //     itemCount: timers.length,
                //     itemBuilder: (context, index) {
                //       return GestureDetector(
                //         onTap: () {
                //           _startTimer(int.parse(timers[index]));
                //         },
                //         onDoubleTap: () {
                //           TextEditingController controller =
                //               TextEditingController(text: timers[index]);
                //           showDialog(
                //             context: context,
                //             builder: (context) {
                //               return NoteAlert(
                //                 controller: controller,
                //                 onSave: () {
                //                   setState(() {
                //                     timers[index] = controller.text;
                //                   });
                //                 },
                //                 hint: 'Edit Timer (in minutes)',
                //                 title: 'Edit Timer',
                //               );
                //             },
                //           );
                //         },
                //         child: ListTile(
                //           leading: Checkbox(
                //             value: false,
                //             onChanged: (bool? value) {},
                //           ),
                //           title: Text("${timers[index]} minutes"),
                //         ),
                //       );
                //     },
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
