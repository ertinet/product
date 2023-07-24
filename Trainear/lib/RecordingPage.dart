import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trainear/MainNavigator.dart';
import 'dart:async';
import 'AudioUtils.dart';

class RecordingPage extends StatefulWidget {

  RecordingPage({Key? key}) : super(key: key);

  @override
  _RecordingPageState createState() => _RecordingPageState();
}

class _RecordingPageState extends State<RecordingPage> {
  late Timer _timer;

  int _recordDuration = 0;
  bool _isRecording = false;
  bool _isPlaying = false;
  String? _recordedFilePath;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _recordDuration++;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _startRecording() async {
    try {
      if (await AudioUtils.hasRecordingPermission()) {
        setState(() {
          _isRecording = true;
          _recordDuration = 0;
          _recordedFilePath = null;
        });

        await AudioUtils.startRecording();

      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _stopRecording() async {
    if (!_isRecording) return;

    try {
      setState(() {
        _isRecording = false;
      });

      final path = await AudioUtils.stopRecordingAndGetPath();
      if (path != null) {
        setState(() {
          _recordedFilePath = path;
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _playRecordingPlayback() async {
    if (_isRecording || _recordedFilePath == null) return;

    setState(() {
      _isPlaying = true;
    });

    AudioUtils.playAudioFromPath(_recordedFilePath!);

    setState(() {
      _isPlaying = false;
    });
  }

  Future<void> _pauseRecordingPlayback() async {
    if (_isRecording) {
      await AudioUtils.pauseAudio();
    }
  }

  Future<void> _navigateToSongSelection() async {
    MainNavigator.setCurrentRecordingPath(_recordedFilePath);
    MainNavigator.goToSongSelectionPage(context);
  }

  Future<void> _navigateToNextPart() async {
    MainNavigator.getAudioRecipe().addRecordingOnly(_recordedFilePath);
    MainNavigator.goToNextRecordingPage(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trainear'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            Center(
              child: Text(
                'Album ${MainNavigator.getChosenAlbumRef()?.name}',
                style: const TextStyle(
                  fontSize: 30,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            if (MainNavigator.getPartNumber() == 0) ...[
              const SizedBox(height: 50),
              Center(
                child: Text(
                  'Intro',
                  style: const TextStyle(
                    fontSize: 25,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 50),
              _buildRecordingControls(),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _navigateToNextPart,
                    child: const Text('Start exercise'),
                  ),
                ],
              ),
            ],
            if (MainNavigator.getPartNumber() > 0) ...[
              const SizedBox(height: 50),
              Center(
                child: Text(
                  'Part ${MainNavigator.getPartNumber()}',
                  style: const TextStyle(
                    fontSize: 25,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 50),
              _buildRecordingControls(),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _navigateToSongSelection,
                    child: const Text('Choose song'),
                  ),
                ],
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildRecordingControls() {
    final isRecording = _isRecording;

    return Column(
      children: [
        ClipOval(
          child: Material(
            color: Colors.red,
            child: InkWell(
              onTap: () {
                if (isRecording) {
                  _stopRecording();
                } else {
                  _startRecording();
                }
              },
              child: const SizedBox(
                width: 56,
                height: 56,
                child: Icon(
                  Icons.mic,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        if (_recordedFilePath != null)
          ClipOval(
            child: Material(
              color: Colors.green,
              child: InkWell(
                onTap: () {
                  if (_isPlaying) {
                    _pauseRecordingPlayback();
                  } else {
                    _playRecordingPlayback();
                  }
                },
                child: const SizedBox(
                  width: 56,
                  height: 56,
                  child: Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ),
          ),
        const SizedBox(height: 20),
        if (_isRecording) _buildTimer(),
      ],
    );
  }

  Widget _buildTimer() {
    final minutes = (_recordDuration ~/ 60).toString().padLeft(2, '0');
    final seconds = (_recordDuration % 60).toString().padLeft(2, '0');

    return Text(
      '$minutes:$seconds',
      style: const TextStyle(
        color: Colors.red,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
