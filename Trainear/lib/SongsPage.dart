import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:just_audio/just_audio.dart';
import 'package:trainear/AudioRecipes.dart';
import 'package:trainear/AuthenticationUtils.dart';
import 'package:trainear/MainNavigator.dart';

import 'MusicControls.dart';
import 'RecordingPage.dart';

class SongsPage extends StatefulWidget {

  SongsPage({Key? key}) : super(key: key);

  @override
  _SongsPageState createState() => _SongsPageState();
}

class _SongsPageState extends State<SongsPage> {
  final AudioPlayer player = AudioPlayer();
  late Stream<ProcessingState> _processingStateStream;

  @override
  void initState() {
    super.initState();
    _processingStateStream = player.processingStateStream;
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trainear'),
        centerTitle: true,
      ),
      body: FutureBuilder<ListResult>(
        future: MainNavigator.getChosenAlbumRef()?.listAll(),
        builder: (BuildContext context, AsyncSnapshot<ListResult> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            var songs = snapshot.data!.items;
            songs.sort((a, b) {
              var aSongName = a.name.split('/').last.split('.').first;
              var bSongName = b.name.split('/').last.split('.').first;
              return int.parse(aSongName).compareTo(int.parse(bSongName));
            });
            return ListView.builder(
              itemCount: songs.length,
              itemBuilder: (context, index) {
                var songRef = songs[index];
                return FutureBuilder<String>(
                  future: songRef.getDownloadURL(),
                  builder: (BuildContext context,
                      AsyncSnapshot<String> snapshot) {
                    if (snapshot.hasError) {
                      return Text("Failed to load song");
                    }

                    if (snapshot.connectionState == ConnectionState.done) {
                      var songName = songRef.name.split('/').last.split('.').first;
                      return ListTile(
                        title: Text(songName),
                        onTap: () async {
                          await player.setAudioSource(AudioSource.uri(Uri.parse(snapshot.data!)));
                          player.play();
                          showMusicControls(context);
                        },
                      );
                    }

                    return Text("Loading song...");
                  },
                );
              },
            );
          }

          return Text("Loading");
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          player.stop();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecordingPage(),
            ),
          );
        },
        child: Icon(Icons.navigate_next),
      ),
    );
  }


  void showMusicControls(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => MusicControls(player: player),
    );
  }
}