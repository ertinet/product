import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trainear/MainNavigator.dart';
import 'package:trainear/TestSongsPage.dart';

import 'AudioUtils.dart';

class OutroPage extends StatelessWidget {

  OutroPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trainear'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Text(
                'Outro',
                style: TextStyle(
                  fontSize: 25,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: () async {
                if (MainNavigator.getAudioRecipe().getLength() > 0) {
                  await AudioUtils.concatenateAudio(MainNavigator.getAudioRecipe());
                }
              },
              child: Text('Save'),
            ),ElevatedButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TestSongsPage(),
                  ),
                );
              },
              child: Text('Songs'),
            ),
          ],
        ),
      ),
    );
  }
}
