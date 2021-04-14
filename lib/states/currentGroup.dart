import 'package:acappella_station/models/group.dart';
import 'package:acappella_station/models/song.dart';
import 'package:acappella_station/services/database.dart';
import 'package:flutter/material.dart';

class CurrentGroup extends ChangeNotifier{
  OurGroup _currentGroup = OurGroup();
  OurSong _currentSong = OurSong();

  OurGroup get getCurrentGroup => _currentGroup;
  OurSong get getCurrentSong => _currentSong;

  void updateStateFromDatabase(String groupId) async {
    try{
      // get the groupInfo from firebase
      // and get current book info from firebase
      _currentGroup = await OurDatabase().getGroupInfo(groupId);
      _currentSong = await OurDatabase().getCurrentSong(groupId, _currentGroup.currentSongId);
      notifyListeners();
    }catch(e){
      print(e);
    }
  }
}