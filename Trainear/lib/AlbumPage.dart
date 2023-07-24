import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'MainNavigator.dart';

class AlbumPage extends StatelessWidget {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AlbumPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User? user = _auth.currentUser;
    final String userEmail = user?.email ?? 'UnknownUser';

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome $userEmail'),
        centerTitle: true,
      ),
      body: FutureBuilder<ListResult>(
        future: storage.ref('albums').listAll(),
        builder:
            (BuildContext context, AsyncSnapshot<ListResult> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.prefixes.length,
              itemBuilder: (context, index) {
                var album = snapshot.data!.prefixes[index];
                return ListTile(
                  title: Text('Album ${index + 1}'),
                  onTap: () {
                    MainNavigator.setAlbumRef(album);
                    MainNavigator.goToSongIntroductionPage(context);
                  },
                );
              },
            );
          }
          return Text("Loading");
        },
      ),
    );
  }
}

