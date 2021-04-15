import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';

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
          title: Text(widget.references
              .elementAt(index)
              .name),
          trailing: IconButton(
            icon: selectedIndex == index
                ? Icon(Icons.pause)
                : Icon(Icons.play_arrow),
            onPressed: () => _onListTileButtonPressed(index),
          ),
        );
      },
    );
  }


  //TODO:再生できるようにする
  Future<void> _onListTileButtonPressed(int index) async {
    setState(() {
      selectedIndex = index;
    });
    mPlayer.startPlayer(
        fromURI: await widget.references.elementAt(index).getDownloadURL(),
        sampleRate: tSampleRate,
        codec: Codec.pcm16,
        numChannels: 1,
        whenFinished: () {
          setState(() {
            isPlaying = false;
            selectedIndex = -1;
          });
        });
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
