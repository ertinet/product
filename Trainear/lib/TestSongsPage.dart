import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:trainear/AudioUtils.dart';

class TestSongsPage extends StatefulWidget {
  @override
  _TestSongsPageState createState() => _TestSongsPageState();
}

class _TestSongsPageState extends State<TestSongsPage> {
  late Stream<QuerySnapshot> _songsStream;
  String? _currentlyPlaying;

  @override
  void initState() {
    super.initState();
    _songsStream = FirebaseFirestore.instance.collection('songs').snapshots();
  }

  void _play(String url) async {
    await AudioUtils.playAudioFromUri(url);
    setState(() {
      _currentlyPlaying = url;
    });
  }

  void _pause() async {
    await AudioUtils.pauseAudio();
    setState(() {
      _currentlyPlaying = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Songs'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _songsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;
              return FutureBuilder(
                future: FirebaseStorage.instance.ref(data['fileURL']).getDownloadURL(),
                builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return ListTile(
                      title: Text(data['title']),
                    );
                  } else {
                    String downloadUrl = snapshot.data!;
                    bool isPlaying = _currentlyPlaying == downloadUrl;

                    return ListTile(
                      title: Text(data['title']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                            onPressed: () {
                              if (isPlaying) {
                                _pause();
                              } else {
                                _play(downloadUrl);
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  }
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
