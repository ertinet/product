import 'dart:io';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:trainear/AudioRecipes.dart';
import 'package:record/record.dart';
import 'package:uuid/uuid.dart';
import 'AudioPlayerHandler.dart';
import 'StorageUtils.dart';
import 'package:audio_service/audio_service.dart';

class AudioUtils {
  static Record audioRecorder = Record();

  static late AudioPlayerHandler _audioHandler;

  static Future<void> initAudioService() async {
    _audioHandler = await AudioService.init(
      builder: () => AudioPlayerHandler(),
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.naamani.trainear.channel.audio',
        androidNotificationChannelName: 'Audio playback',
        androidNotificationOngoing: true,
      ),
    );
  }

  // Play, pause, stop, and seek functionality using audio_service
  static Future<void> playAudioFromUri(String uri) async {
    await _audioHandler.setAudioUri(uri);
    await _audioHandler.play();
  }

  static Future<void> pauseAudio() async {
    await _audioHandler.pause();
  }

  static Future<void> seekAudio(Duration position) async {
    await _audioHandler.seek(position);
  }

  static Future<void> stopAudio() async {
    await _audioHandler.stop();
  }

  static Future<String> getOutputSongPath() async {
    final appDir = await getAudioDir();
    final outputFileName = '$appDir/concatenated.m4a';
    return outputFileName;
  }

  static Future<void> playAudioFromPath(String url) async {
    //await audioPlayer.setFilePath(url!);
    //await audioPlayer.play();
  }

  static Future<void> startRecording() async {
    final appDir = await getAudioDir();
    await audioRecorder.start(path: '$appDir/${const Uuid().v1()}.m4a');
  }

  static Future<String?> stopRecordingAndGetPath() async {
    return await audioRecorder.stop();
  }

  static Future<bool> hasRecordingPermission() async {
    return audioRecorder.hasPermission();
  }

  static Future<String?> getAudioDir() async {
    final appDocDir = await getExternalStorageDirectory();
    final appDir = appDocDir?.absolute.path;
    final audioDirPath = '$appDir/recordings';

    final audioDir = Directory(audioDirPath);
    if (!await audioDir.exists()) {
      await audioDir.create(recursive: true);
      print('Created audio directory: $audioDirPath');
    }

    return audioDirPath;
  }

  static Future<void> clearAudioDir() async {
    final audioDir = await getAudioDir();
    if (audioDir != null) {
      final directory = Directory(audioDir);
      if (await directory.exists()) {
        await directory.delete(recursive: true);
        print('Cleared audio directory: $audioDir');
      }
    }
  }

  static Future<void> listAudioFiles() async {
    final audioDir = await getAudioDir();
    if (audioDir != null) {
      final directory = Directory(audioDir);
      for (var file in directory.listSync()) {
        print(file.path);
      }
    }
  }

  static String createFfmpegCommand(AudioRecipe audioRecipe, String output) {
    List<String> segments = [];
    List<String> filters = [];
    List<String> indexes = [];
    int filter_index = 0;
    for (AudioPart audioPart in audioRecipe.getParts()) {
      if (audioPart.audioRecordingPath != null) {
        segments.add("-i ${audioPart.audioRecordingPath}");
        indexes.add("[$filter_index:a]");
        filter_index += 1;
      }

      if (audioPart.songUrl != null && audioPart.lengthSeconds != 0) {
        segments.add("-i ${audioPart.songUrl}");
        filters.add(
            "[$filter_index:a]atrim=duration=${audioPart.lengthSeconds}[a$filter_index];");
        indexes.add("[a$filter_index]");
        filter_index += 1;
      }
    }

    String segmentsStr = segments.join(" ");
    String filtersStr = filters.join("");
    String indexesStr = indexes.join("");

    return '-y $segmentsStr -filter_complex "$filtersStr${indexesStr}concat=n=${segments.length}:v=0:a=1[a]" -map "[a]" $output';
  }

  static Future<String?> concatenateAudio(AudioRecipe audioRecipe) async {
    final outputFileName = await getOutputSongPath();
    String ffmpegCommand = createFfmpegCommand(audioRecipe, outputFileName);

    await FFmpegKit.execute(ffmpegCommand).then((session) async {
      final command = session.getCommand();
      final output = await session.getOutput();
      await StorageUtils().uploadFinishedRecordingToCloud(outputFileName);
    });

    return outputFileName;
  }
}


class MediaState {
  final MediaItem? mediaItem;
  final Duration position;

  MediaState(this.mediaItem, this.position);
}

class AudioPlayerHandler extends BaseAudioHandler with SeekHandler {
  static final _item = MediaItem(
    id: 'https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3',
    album: "Science Friday",
    title: "A Salute To Head-Scratching Science",
    artist: "Science Friday and WNYC Studios",
    duration: const Duration(milliseconds: 5739820),
    artUri: Uri.parse(
        'https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg'),
  );

  final _player = AudioPlayer();

  /// Initialise our audio handler.
  AudioPlayerHandler() {
    // So that our clients (the Flutter UI and the system notification) know
    // what state to display, here we set up our audio handler to broadcast all
    // playback state changes as they happen via playbackState...
    _player.playbackEventStream.map(_transformEvent).pipe(playbackState);
    // ... and also the current media item via mediaItem.
    mediaItem.add(_item);

    // Load the player.
  }

  Future<void> setAudioUri(String uri){
    return _player.setAudioSource(AudioSource.uri(Uri.parse(uri)));
  }

  // In this simple example, we handle only 4 actions: play, pause, seek and
  // stop. Any button press from the Flutter UI, notification, lock screen or
  // headset will be routed through to these 4 methods so that you can handle
  // your audio playback logic in one place.

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> stop() => _player.stop();

  /// Transform a just_audio event into an audio_service state.
  ///
  /// This method is used from the constructor. Every event received from the
  /// just_audio player will be transformed into an audio_service state so that
  /// it can be broadcast to audio_service clients.
  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        MediaControl.rewind,
        if (_player.playing) MediaControl.pause else MediaControl.play,
        MediaControl.stop,
        MediaControl.fastForward,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 3],
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_player.processingState]!,
      playing: _player.playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
      queueIndex: event.currentIndex,
    );
  }
}
