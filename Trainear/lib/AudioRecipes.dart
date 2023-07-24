import 'dart:io';
import 'dart:io';
import 'dart:io';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_session.dart';

class AudioRecipe {
  List<AudioPart> audioParts;
  AudioRecipe(this.audioParts);

  int getLength() {return audioParts.length;}
  void addPart(String? audioRecordingPath, String songUrl, int lengthSeconds) {
    audioParts.add(AudioPart(audioRecordingPath, songUrl, lengthSeconds));
  }
  void addRecordingOnly(String? audioRecordingPath) {
    audioParts.add(AudioPart(audioRecordingPath, "", 0));
  }
  void addSongOnly(String songUrl, int lengthSeconds) {
    audioParts.add(AudioPart("", songUrl, lengthSeconds));
  }
  List<AudioPart>getParts() {return audioParts;}
}

class AudioPart {
  final String? audioRecordingPath;
  final String songUrl;
  final int lengthSeconds;

  AudioPart(this.audioRecordingPath, this.songUrl, this.lengthSeconds);
}
