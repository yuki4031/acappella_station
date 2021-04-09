import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class CurrentUser extends ChangeNotifier {
  String _uid;
  String _email;

  String get getUid => _uid;
  String get getEmail => _email;


  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> onStartUp() async {
    String retVal = 'error';

    try{
      User _firebaseUser = _auth.currentUser;
      _uid = _firebaseUser.uid;
      _email = _firebaseUser.email;
      retVal = 'success';
    }catch(e){
      print(e);
    }
    return retVal;
  }

  Future<String> signOut() async {
    String retVal = 'error';

    try{
      _auth.signOut();
      _uid = null;
      _email = null;
      retVal = 'success';
    }catch(e){
      print(e);
    }
    return retVal;
  }


  Future<String> signUpUser(String email, String password) async {
    String retVal = 'error';

    try{
      await _auth.createUserWithEmailAndPassword(email: email, password: password);

      retVal = 'success';
    }catch(e){
      retVal = e.message;
    }

    return retVal;
  }

  Future<String> loginUserWithEmail(String email, String password) async {
    String retVal = 'error';

    try{
      UserCredential _authResult = await _auth.signInWithEmailAndPassword(email: email, password: password);

        _uid = _authResult.user.uid;
        _email = _authResult.user.email;
        retVal = 'success';

    }catch(e){
      retVal = e.message;
    }

    return retVal;
  }
}
