import 'package:acappella_station/models/group.dart';
import 'package:acappella_station/models/song.dart';
import 'package:acappella_station/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OurDatabase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> createUser(OurUser user) async {
    String retVal = 'error';

    try {
      await _firestore.collection('users').doc(user.uid).set({
        'fullName:': user.fullName,
        'email': user.email,
        'accountCreated': Timestamp.now(),
      });
      retVal = 'success';
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<OurUser> getUserInfo(String uid) async {
    OurUser retVal = OurUser();

    try {
      DocumentSnapshot _docSnapshot =
          await _firestore.collection('users').doc(uid).get();
      retVal.uid = uid;
      retVal.fullName = _docSnapshot.data()['fullName'];
      retVal.email = _docSnapshot.data()['email'];
      retVal.accountCreated = _docSnapshot.data()['accountCreated'];
      retVal.groupId = _docSnapshot.data()['groupId'];
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<String> createGroup(String groupName, String userUid) async {
    String retVal = 'error';
    List<String> members = [];

    try {
      members.add(userUid);
      DocumentReference _docRef = await _firestore.collection('groups').add({
        'name': groupName,
        'leader': userUid,
        'members': members,
        'groupCreate': Timestamp.now(),
      });

      await _firestore.collection('users').doc(userUid).update({
        'groupId': _docRef.id,
      });

      retVal = 'success';
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<String> joinGroup(String groupId, String userUid) async {
    String retVal = 'error';
    List<String> members = [];

    try {
      members.add(userUid);
      await _firestore.collection('groups').doc(groupId).update({
        'members': FieldValue.arrayUnion(members),
      });
      await _firestore.collection('users').doc(userUid).update({
        'groupId': groupId,
      });
      retVal = 'success';
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<OurGroup> getGroupInfo(String groupId) async {
    OurGroup retVal = OurGroup();

    try {
      DocumentSnapshot _docSnapshot =
          await _firestore.collection('groups').doc(groupId).get();
      retVal.id = groupId;
      retVal.name = _docSnapshot.data()['name'];
      retVal.leader = _docSnapshot.data()['leader'];
      retVal.members = List<String>.from(_docSnapshot.data()['members']);
      retVal.groupCreated = _docSnapshot.data()['groupCreated'];
      retVal.currentSongId = _docSnapshot.data()['currentSongId'];
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<OurSong> getCurrentSong(String groupId, String songId) async {
    OurSong retVal = OurSong();

    try {
      DocumentSnapshot _docSnapshot = await _firestore
          .collection('groups')
          .doc(groupId)
          .collection('songs')
          .doc(songId)
          .get();
      retVal.id = songId;
      retVal.name = _docSnapshot.data()['name'];
    } catch (e) {
      print(e);
    }

    return retVal;
  }
}
