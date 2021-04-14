import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:acappella_station/screens/nogroup/noGroup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

/*
 * This is an example showing how to record to a Dart Stream.
 * It writes all the recorded data from a Stream to a File, which is completely stupid:
 * if an App wants to record something to a File, it must not use Streams.
 *
 * The real interest of recording to a Stream is for example to feed a
 * Speech-to-Text engine, or for processing the Live data in Dart in real time.
 *
 */

///
const int tSampleRate = 44000;
typedef _Fn = void Function();

/// Example app.
class RecordToStreamExample extends StatefulWidget {
  @override
  _RecordToStreamExampleState createState() => _RecordToStreamExampleState();
}

class _RecordToStreamExampleState extends State<RecordToStreamExample> {
  var _mPlayer1 = FlutterSoundPlayer();
  var _mPlayer2 = FlutterSoundPlayer();
  var _mPlayer3 = FlutterSoundPlayer();
  var _mRecorder1 = FlutterSoundRecorder();
  var _mRecorder2 = FlutterSoundRecorder();
  var _mRecorder3 = FlutterSoundRecorder();
  bool _mPlayer1IsInited = false;
  bool _mPlayer2IsInited = false;
  bool _mPlayer3IsInited = false;
  bool _mRecorder1IsInited = false;
  bool _mRecorder2IsInited = false;
  bool _mRecorder3IsInited = false;
  bool _mplaybackReady1 = false;
  bool _mplaybackReady2 = false;
  bool _mplaybackReady3 = false;
  String _mPath1;
  String _mPath2;
  String _mPath3;
  StreamSubscription _mRecordingDataSubscription1;
  StreamSubscription _mRecordingDataSubscription2;
  StreamSubscription _mRecordingDataSubscription3;

  void _goToNoGroup(BuildContext context) {
    Navigator.push(
      context, MaterialPageRoute(builder: (context) => OurNoGroup(),),
    );
  }

  Future<void> _openRecorder1() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission not granted');
    }
    await _mRecorder1.openAudioSession();
    setState(() {
      _mRecorder1IsInited = true;
    });
  }

  Future<void> _openRecorder2() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission not granted');
    }
    await _mRecorder2.openAudioSession();
    setState(() {
      _mRecorder2IsInited = true;
    });
  }

  Future<void> _openRecorder3() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission not granted');
    }
    await _mRecorder3.openAudioSession();
    setState(() {
      _mRecorder3IsInited = true;
    });
  }

  @override
  void initState(){
    super.initState();
    // Be careful : openAudioSession return a Future.
    // Do not access your FlutterSoundPlayer or FlutterSoundRecorder before the completion of the Future
    _mPlayer1.openAudioSession().then((value) {
      setState(() {
        _mPlayer1IsInited = true;
      });
    });
    _openRecorder1();

    _mPlayer2.openAudioSession().then((value) {
      setState(() {
        _mPlayer2IsInited = true;
      });
    });
    _openRecorder2();

    _mPlayer3.openAudioSession().then((value) {
      setState(() {
        _mPlayer3IsInited = true;
      });
    });
    _openRecorder3();

  }

  @override
  void dispose() {
    stopPlayer1();
    _mPlayer1.closeAudioSession();
    _mPlayer1 = null;

    stopRecorder1();
    _mRecorder1.closeAudioSession();
    _mRecorder1 = null;

    stopPlayer2();
    _mPlayer2.closeAudioSession();
    _mPlayer2 = null;

    stopRecorder2();
    _mRecorder2.closeAudioSession();
    _mRecorder2 = null;

    stopPlayer3();
    _mPlayer3.closeAudioSession();
    _mPlayer3 = null;

    stopRecorder3();
    _mRecorder3.closeAudioSession();
    _mRecorder3 = null;

    super.dispose();
  }

  Future<IOSink> createFile1() async {
    var tempDir = await getTemporaryDirectory();
    _mPath1 = '${tempDir.path}/flutter_sound_example1.pcm';
    var outputFile = File(_mPath1);
    if (outputFile.existsSync()) {
      await outputFile.delete();
    }
    return outputFile.openWrite();
  }

  Future<IOSink> createFile2() async {
    var tempDir = await getTemporaryDirectory();
    _mPath2 = '${tempDir.path}/flutter_sound_example2.pcm';
    var outputFile = File(_mPath2);
    if (outputFile.existsSync()) {
      await outputFile.delete();
    }
    return outputFile.openWrite();
  }

  Future<IOSink> createFile3() async {
    var tempDir = await getTemporaryDirectory();
    _mPath3 = '${tempDir.path}/flutter_sound_example3.pcm';
    var outputFile = File(_mPath3);
    if (outputFile.existsSync()) {
      await outputFile.delete();
    }
    return outputFile.openWrite();
  }



  // ----------------------  Here is the code to record to a Stream ------------

  Future<void> record1() async {
    assert(_mRecorder1IsInited && _mPlayer1.isStopped);
    var sink = await createFile1();
    // ignore: close_sinks
    var recordingDataController = StreamController<Food>();
    _mRecordingDataSubscription1 =
        recordingDataController.stream.listen((buffer) {
          if (buffer is FoodData) {
            sink.add(buffer.data);
          }
        });
    await _mRecorder1.startRecorder(
      toStream: recordingDataController.sink,
      codec: Codec.pcm16,
      numChannels: 1,
      sampleRate: tSampleRate,
    );
    setState(() {});
  }

  Future<void> record2() async {
    assert(_mRecorder2IsInited && _mPlayer2.isStopped);
    var sink = await createFile2();
    // ignore: close_sinks
    var recordingDataController = StreamController<Food>();
    _mRecordingDataSubscription2 =
        recordingDataController.stream.listen((buffer) {
          if (buffer is FoodData) {
            sink.add(buffer.data);
          }
        });
    await _mRecorder2.startRecorder(
      toStream: recordingDataController.sink,
      codec: Codec.pcm16,
      numChannels: 1,
      sampleRate: tSampleRate,
    );
    setState(() {});
  }

  Future<void> record3() async {
    assert(_mRecorder3IsInited && _mPlayer3.isStopped);
    var sink = await createFile3();
    // ignore: close_sinks
    var recordingDataController = StreamController<Food>();
    _mRecordingDataSubscription3 =
        recordingDataController.stream.listen((buffer) {
          if (buffer is FoodData) {
            sink.add(buffer.data);
          }
        });
    await _mRecorder3.startRecorder(
      toStream: recordingDataController.sink,
      codec: Codec.pcm16,
      numChannels: 1,
      sampleRate: tSampleRate,
    );
    setState(() {});
  }


  // --------------------- (it was very simple, wasn't it ?) -------------------

  Future<void> stopRecorder1() async {
    await _mRecorder1.stopRecorder();
    if (_mRecordingDataSubscription1 != null) {
      await _mRecordingDataSubscription1.cancel();
      _mRecordingDataSubscription1 = null;
    }
    _mplaybackReady1 = true;
  }

  Future<void> stopRecorder2() async {
    await _mRecorder2.stopRecorder();
    if (_mRecordingDataSubscription2 != null) {
      await _mRecordingDataSubscription2.cancel();
      _mRecordingDataSubscription2 = null;
    }
    _mplaybackReady2 = true;
  }

  Future<void> stopRecorder3() async {
    await _mRecorder3.stopRecorder();
    if (_mRecordingDataSubscription3 != null) {
      await _mRecordingDataSubscription3.cancel();
      _mRecordingDataSubscription3 = null;
    }
    _mplaybackReady3 = true;
  }


  _Fn getRecorderFn1() {
    if (!_mRecorder1IsInited || !_mPlayer1.isStopped) {
      return null;
    }
    return _mRecorder1.isStopped
        ? record1
        : () {
      stopRecorder1().then((value) => setState(() {}));
    };
  }

  _Fn getRecorderFn2() {
    if (!_mRecorder2IsInited || !_mPlayer2.isStopped) {
      return null;
    }
    return _mRecorder2.isStopped
        ? record2
        : () {
      stopRecorder2().then((value) => setState(() {}));
    };
  }

  _Fn getRecorderFn3() {
    if (!_mRecorder3IsInited || !_mPlayer3.isStopped) {
      return null;
    }
    return _mRecorder3.isStopped
        ? record3
        : () {
      stopRecorder3().then((value) => setState(() {}));
    };
  }


  void play1() async {
    assert(_mPlayer1IsInited &&
        _mplaybackReady1 &&
        _mRecorder1.isStopped &&
        _mPlayer1.isStopped);
    await _mPlayer1.startPlayer(
        fromURI: _mPath1,
        sampleRate: tSampleRate,
        codec: Codec.pcm16,
        numChannels: 1,
        whenFinished: () {
          setState(() {});
        });
    // The readability of Dart is very special :-(
    setState(() {});
  }

  void play2() async {
    assert(_mPlayer2IsInited &&
        _mplaybackReady2 &&
        _mRecorder2.isStopped &&
        _mPlayer2.isStopped);
    await _mPlayer2.startPlayer(
        fromURI: _mPath2,
        sampleRate: tSampleRate,
        codec: Codec.pcm16,
        numChannels: 1,
        whenFinished: () {
          setState(() {});
        }); // The readability of Dart is very special :-(
    setState(() {});
  }

  void play3() async {
    assert(_mPlayer3IsInited &&
        _mplaybackReady3 &&
        _mRecorder3.isStopped &&
        _mPlayer3.isStopped);
    await _mPlayer3.startPlayer(
        fromURI: _mPath3,
        sampleRate: tSampleRate,
        codec: Codec.pcm16,
        numChannels: 1,
        whenFinished: () {
          setState(() {});
        }); // The readability of Dart is very special :-(
    setState(() {});
  }


  Future<void> stopPlayer1() async {
    await _mPlayer1.stopPlayer();
  }

  Future<void> stopPlayer2() async {
    await _mPlayer2.stopPlayer();
  }

  Future<void> stopPlayer3() async {
    await _mPlayer3.stopPlayer();
  }


  _Fn getPlaybackFn1() {
    if (!_mPlayer1IsInited || !_mplaybackReady1 || !_mRecorder1.isStopped) {
      return null;
    }
    return _mPlayer1.isStopped
        ? play1
        : () {
      stopPlayer1().then((value) => setState(() {}));
    };
  }

  _Fn getPlaybackFn2() {
    if (!_mPlayer2IsInited || !_mplaybackReady2 || !_mRecorder2.isStopped) {
      return null;
    }
    return _mPlayer2.isStopped
        ? play2
        : () {
      stopPlayer2().then((value) => setState(() {}));
    };
  }

  _Fn getPlaybackFn3() {
    if (!_mPlayer3IsInited || !_mplaybackReady3 || !_mRecorder3.isStopped) {
      return null;
    }
    return _mPlayer3.isStopped
        ? play3
        : () {
      stopPlayer3().then((value) => setState(() {}));
    };
  }



  // ----------------------------------------------------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    Widget makeBody() {
      return Column(
        children: [
          Container(
            margin: const EdgeInsets.all(3),
            padding: const EdgeInsets.all(3),
            height: 80,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Color(0xFFFAF0E6),
              border: Border.all(
                color: Colors.indigo,
                width: 3,
              ),
            ),
            child: Row(children: [
              ElevatedButton(
                onPressed: getRecorderFn1(),
                //color: Colors.white,
                //disabledColor: Colors.grey,
                child: Text(_mRecorder1.isRecording ? 'Stop' : 'Record'),
              ),
              SizedBox(
                width: 20,
              ),
              Text(_mRecorder1.isRecording
                  ? 'Recording in progress'
                  : 'Recorder is stopped'),
            ]),
          ),
          Container(
            margin: const EdgeInsets.all(3),
            padding: const EdgeInsets.all(3),
            height: 80,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Color(0xFFFAF0E6),
              border: Border.all(
                color: Colors.indigo,
                width: 3,
              ),
            ),
            child: Row(children: [
              ElevatedButton(
                onPressed: getPlaybackFn1(),
                //color: Colors.white,
                //disabledColor: Colors.grey,
                child: Text(_mPlayer1.isPlaying ? 'Stop' : 'Play'),
              ),
              SizedBox(
                width: 20,
              ),
              Text(_mPlayer1.isPlaying
                  ? 'Playback in progress'
                  : 'Player is stopped'),
            ]),
          ),
          Container(
            margin: const EdgeInsets.all(3),
            padding: const EdgeInsets.all(3),
            height: 80,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Color(0xFFFAF0E6),
              border: Border.all(
                color: Colors.indigo,
                width: 3,
              ),
            ),
            child: Row(children: [
              ElevatedButton(
                onPressed: getRecorderFn2(),
                //color: Colors.white,
                //disabledColor: Colors.grey,
                child: Text(_mRecorder2.isRecording ? 'Stop' : 'Record'),
              ),
              SizedBox(
                width: 20,
              ),
              Text(_mRecorder2.isRecording
                  ? 'Recording in progress'
                  : 'Recorder is stopped'),
            ]),
          ),
          Container(
            margin: const EdgeInsets.all(3),
            padding: const EdgeInsets.all(3),
            height: 80,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Color(0xFFFAF0E6),
              border: Border.all(
                color: Colors.indigo,
                width: 3,
              ),
            ),
            child: Row(children: [
              ElevatedButton(
                onPressed: getPlaybackFn2(),
                //color: Colors.white,
                //disabledColor: Colors.grey,
                child: Text(_mPlayer2.isPlaying ? 'Stop' : 'Play'),
              ),
              SizedBox(
                width: 20,
              ),
              Text(_mPlayer2.isPlaying
                  ? 'Playback in progress'
                  : 'Player is stopped'),
            ]),
          ),
          Container(
            margin: const EdgeInsets.all(3),
            padding: const EdgeInsets.all(3),
            height: 80,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Color(0xFFFAF0E6),
              border: Border.all(
                color: Colors.indigo,
                width: 3,
              ),
            ),
            child: Row(children: [
              ElevatedButton(
                onPressed: getRecorderFn3(),
                //color: Colors.white,
                //disabledColor: Colors.grey,
                child: Text(_mRecorder3.isRecording ? 'Stop' : 'Record'),
              ),
              SizedBox(
                width: 20,
              ),
              Text(_mRecorder3.isRecording
                  ? 'Recording in progress'
                  : 'Recorder is stopped'),
            ]),
          ),
          Container(
            margin: const EdgeInsets.all(3),
            padding: const EdgeInsets.all(3),
            height: 80,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Color(0xFFFAF0E6),
              border: Border.all(
                color: Colors.indigo,
                width: 3,
              ),
            ),
            child: Row(children: [
              ElevatedButton(
                onPressed: getPlaybackFn3(),
                //color: Colors.white,
                //disabledColor: Colors.grey,
                child: Text(_mPlayer3.isPlaying ? 'Stop' : 'Play'),
              ),
              SizedBox(
                width: 20,
              ),
              Text(_mPlayer3.isPlaying
                  ? 'Playback in progress'
                  : 'Player is stopped'),
            ]),
          ),
          TextButton(
            onPressed: () => _goToNoGroup(context),
            child: Text('Book Club History'),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Record to Stream ex.'),
      ),
      body: makeBody(),
    );
  }
}