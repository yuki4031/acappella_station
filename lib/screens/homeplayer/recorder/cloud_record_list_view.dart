import 'dart:io';
import 'dart:typed_data';

import 'package:acappella_station/states/currentUser.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

const int tSampleRate = 44000;

class CloudRecordListView extends StatefulWidget {
  final List<Reference> references;

  const CloudRecordListView({Key key, this.references}) : super(key: key);

  @override
  _CloudRecordListViewState createState() => _CloudRecordListViewState();
}

class _CloudRecordListViewState extends State<CloudRecordListView> {
  bool isPlaying;
  var mPlayer = FlutterSoundPlayer();
  int selectedIndex;
  String filePath;
  FirebaseStorage storage = FirebaseStorage.instance;
  Reference ref = FirebaseStorage.instance.ref('upload-voice-firebase');

  String getGroupId(BuildContext context){
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    String groupId = _currentUser.getCurrentUser.groupId;
    return groupId;
  }

  _CloudRecordListViewState();

  @override
  void initState() {
    super.initState();
    mPlayer.openAudioSession();
    isPlaying = false;
    selectedIndex = -1;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.references.length,
      reverse: true,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(widget.references.elementAt(index).name),
          trailing: IconButton(
            icon: isPlaying ? Icon(Icons.pause) : Icon(Icons.play_arrow),
            onPressed: () => _onListTileButtonPressed(index),
          ),
        );
      },
    );
  }

  //TODO:再生できるようにする
  Future<void> _onListTileButtonPressed(int index) async {
    if (!isPlaying) {
      isPlaying = true;
      Uint8List buffer = await widget.references.elementAt(index).getData();
      mPlayer.startPlayer(
          fromDataBuffer: buffer,
          sampleRate: tSampleRate,
          codec: Codec.pcm16,
          numChannels: 1,
          whenFinished: () {
            setState(() {
              isPlaying = false;
            });
          });
    } else {
      mPlayer.pausePlayer();
      isPlaying = false;
    }
    setState(() {});
  }

  void dispose() {
    stopPlayer();
    mPlayer.closeAudioSession();
    mPlayer = null;

    super.dispose();
  }

  Future<void> stopPlayer() async {
    await mPlayer.stopPlayer();
  }
}
