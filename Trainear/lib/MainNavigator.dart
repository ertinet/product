import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trainear/AudioRecipes.dart';

import 'AlbumPage.dart';
import 'OutroPage.dart';
import 'RecordingPage.dart';
import 'SongSelectionPage.dart';
import 'SongsPage.dart';

class MainNavigator {

  static int partNumber = 0;
  static AudioRecipe audioRecipe = AudioRecipe([]);
  static Reference? chosenAlbumDbRef;
  static String? currentRecordingPath;

  static void setAlbumRef(Reference? albumRef){
    chosenAlbumDbRef = albumRef;
  }

  static Reference? getChosenAlbumRef() {return chosenAlbumDbRef;}
  static AudioRecipe getAudioRecipe() {return audioRecipe;}
  static String? getCurrentRecordingPath() {return currentRecordingPath;}
  static int getPartNumber() {return partNumber;}


  static void setCurrentRecordingPath(String? path) {currentRecordingPath = path;}

  static void increasePart(){
    partNumber += 1;
  }

  static void goToAlbumPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AlbumPage(),
      ),
    );
  }

  static void goToSongSelectionPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SongSelectionPage(),
      ),
    );
  }

  static void goToNextRecordingPage(BuildContext context) {
    increasePart();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => RecordingPage(),
      ),
    );
  }

  static void goToOutroPage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => OutroPage(),
      ),
    );
  }

  static void goToSongIntroductionPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SongsPage(),
      ),
    );
  }
  static void goToIntroPage() {}
}
