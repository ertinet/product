import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class MusicControls extends StatelessWidget {
  final AudioPlayer player;

  MusicControls({required this.player});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.pause),
            onPressed: () {
              player.pause();
            },
          ),
        ],
      ),
    );
  }
}
