import 'dart:async';
import 'dart:io';

import 'package:acappella_station/states/currentGroup.dart';
import 'package:acappella_station/states/currentUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

const int tSampleRate = 44000;

class FeatureButtonsView extends StatefulWidget {
  final Function onUploadComplete;

  const FeatureButtonsView({
    Key key,
    @required this.onUploadComplete,
  }) : super(key: key);

  @override
  _FeatureButtonsViewState createState() => _FeatureButtonsViewState();
}

class _FeatureButtonsViewState extends State<FeatureButtonsView> {
  bool _isPlaying;
  bool _isUploading;
  bool _isRecorded;
  bool _isRecording;

  var _mPlayer = FlutterSoundPlayer();
  var _mRecorder = FlutterSoundRecorder();

  String _filePath;
  StreamSubscription _mRecordingDataSubscription;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isPlaying = false;
    _isUploading = false;
    _isRecorded = false;
    _isRecording = false;
    _mPlayer.openAudioSession();
    _openRecorder();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _isRecorded
          ? _isUploading
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: LinearProgressIndicator(),
                    ),
                    Text('Uploading to Firebase'),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.replay),
                      onPressed: _onRecordAgainButtonPressed,
                    ),
                    IconButton(
                      icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                      onPressed: _onPlayButtonPressed,
                    ),
                    IconButton(
                      icon: Icon(Icons.upload_file),
                      onPressed: () => _onFileUploadButtonPressed(context),
                    ),
                  ],
                )
          : IconButton(
              icon: _isRecording
                  ? Icon(Icons.pause)
                  : Icon(Icons.fiber_manual_record),
              onPressed: _onRecordButtonPressed,
            ),
    );
  }

  Future<void> _onFileUploadButtonPressed(BuildContext context) async {
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    String groupId = _currentUser.getCurrentUser.groupId;
    print(groupId);

    setState(() {
      _isUploading = true;
    });
    try {
      //TODO:childが機能していない
      await firebaseStorage
          .ref('upload-voice-firebase/$groupId')
          .child(
              _filePath.substring(_filePath.lastIndexOf('/'), _filePath.length))
          .putFile(File(_filePath));
      widget.onUploadComplete();
    } catch (e) {
      print('Error occured while uploading to Firebase ${e.toString()}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error occured while uploading'),
          duration: Duration(seconds: 2),
        ),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  void _onRecordAgainButtonPressed() {
    setState(() {
      _isRecorded = false;
    });
  }

  Future<void> _onRecordButtonPressed() async {
    if (_isRecording) {
      _mRecorder.stopRecorder();
      _isRecording = false;
      _isRecorded = true;
    } else {
      _isRecorded = false;
      _isRecording = true;

      await _startRecording();
    }
    setState(() {});
  }

  void _onPlayButtonPressed() {
    if (!_isPlaying) {
      _isPlaying = true;

      _mPlayer.startPlayer(
          fromURI: _filePath,
          sampleRate: tSampleRate,
          codec: Codec.pcm16,
          numChannels: 1,
          whenFinished: () {
            setState(() {
              _isPlaying = false;
            });
          });
    } else {
      _mPlayer.pausePlayer();
      _isPlaying = false;
    }
    setState(() {});
  }

  Future<void> _startRecording() async {
    // ignore: close_sinks
    var sink = await createFile();
    // ignore: close_sinks
    var recordingDataController = StreamController<Food>();
    _mRecordingDataSubscription =
        recordingDataController.stream.listen((buffer) {
      if (buffer is FoodData) {
        sink.add(buffer.data);
      }
    });
    await _mRecorder.startRecorder(
      toStream: recordingDataController.sink,
      codec: Codec.pcm16,
      numChannels: 1,
      sampleRate: tSampleRate,
    );
    setState(() {});
  }

  Future<void> _openRecorder() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission not granted');
    }
    await _mRecorder.openAudioSession();

    setState(() {});
  }

  Future<IOSink> createFile() async {
    var tempDir = await getTemporaryDirectory();
    _filePath = '${tempDir.path}/flutter_sound_example' +
        DateTime.now().millisecondsSinceEpoch.toString() +
        '.pcm';
    var outputFile = File(_filePath);
    if (outputFile.existsSync()) {
      await outputFile.delete();
    }
    return outputFile.openWrite();
  }

  Future<void> stopPlayer() async {
    await _mPlayer.stopPlayer();
  }

  Future<void> stopRecorder() async {
    await _mRecorder.stopRecorder();
    if (_mRecordingDataSubscription != null) {
      await _mRecordingDataSubscription.cancel();
      _mRecordingDataSubscription = null;
    }
  }

  void dispose() {
    stopPlayer();
    _mPlayer.closeAudioSession();
    _mPlayer = null;

    stopRecorder();
    _mRecorder.closeAudioSession();
    _mRecorder = null;
    super.dispose();
  }
}
