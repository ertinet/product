import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:just_audio/just_audio.dart';
import 'package:trainear/AudioRecipes.dart';
import 'package:trainear/MainNavigator.dart';

import 'OutroPage.dart';
import 'RecordingPage.dart';

class SongSelectionPage extends StatefulWidget {

  SongSelectionPage();

  @override
  _SongSelectionPageState createState() => _SongSelectionPageState();
}

class _SongSelectionPageState extends State<SongSelectionPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  String _selectedSong = '';
  int _selectedMinutes = 1;

  void addRecording(){
    MainNavigator.getAudioRecipe().addPart(
        MainNavigator.getCurrentRecordingPath(), _selectedSong, _selectedMinutes);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trainear'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<ListResult>(
              future: MainNavigator.getChosenAlbumRef()?.listAll(),
              builder:
                  (BuildContext context, AsyncSnapshot<ListResult> snapshot) {
                if (snapshot.hasError) {
                  return Text("Something went wrong");
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  return ListView.builder(
                    itemCount: snapshot.data!.items.length,
                    itemBuilder: (context, index) {
                      var songRef = snapshot.data!.items[index];
                      return FutureBuilder<String>(
                        future: songRef.getDownloadURL(),
                        builder: (BuildContext context,
                            AsyncSnapshot<String> snapshot) {
                          if (snapshot.hasError) {
                            return Text("Failed to load song");
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            var songName = songRef.name
                                .split('/')
                                .last
                                .split('.')
                                .first;
                            return ListTile(
                              title: Text(songName),
                              onTap: () async {
                                // Play the song
                                _selectedSong = await songRef.getDownloadURL();
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
          ),
          DropdownButton<int>(
            value: _selectedMinutes,
            onChanged: (value) {
              setState(() {
                _selectedMinutes = value!;
              });
            },
            items: List.generate(10, (index) {
              int minutes = index + 1;
              return DropdownMenuItem<int>(
                value: minutes,
                child: Text('$minutes seconds'),
              );
            }),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Handle water button action
                },
                child: Text('Water'),
              ),
              ElevatedButton(
                onPressed: () {
                  addRecording();
                  MainNavigator.goToNextRecordingPage(context);
                },
                child: Text('Next'),
              ),
              ElevatedButton(
                onPressed: () {
                  addRecording();
                  MainNavigator.goToOutroPage(context);
                },
                child: Text('Finish'),
              ),
            ],
          ),
        ],
      ),
    );
  }



}
