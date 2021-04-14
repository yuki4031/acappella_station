import 'package:acappella_station/screens/creategroup/createGroup.dart';
import 'package:acappella_station/screens/joingroup/joinGroup.dart';
import 'package:acappella_station/screens/root/root.dart';
import 'package:acappella_station/states/currentUser.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OurNoGroup extends StatelessWidget {

  void _signOut(BuildContext context) async {
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    String _returnString = await _currentUser.signOut();
    if (_returnString == 'success') {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => OurRoot()), (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    void _goToJoin(BuildContext context) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OurJoinGroup(),
        ),
      );
    }

    void _goToCreate(BuildContext context) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OurCreateGroup(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Acappella Station'),
      ),
      body: Column(
        children: <Widget>[
          Spacer(
            flex: 1,
          ),
          Padding(
            padding: EdgeInsets.all(80.0),
            child: Image.asset(
              'assets/logo.png',
              width: 220.0,
              height: 80.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              'Welcome to Acappella Station',
              style: TextStyle(
                fontSize: 30.0,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'Since you are not in a Acappella Station, you can select either' +
                  'to join or create',
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.grey[600],
              ),
            ),
          ),
          Spacer(
            flex: 5,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                TextButton(
                  onPressed: () => _goToCreate(context),
                  child: Text(
                    'Create',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
                TextButton(
                  onPressed: () => _goToJoin(context),
                  child: Text(
                    'Join',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => _signOut(context),
            child: Text('SIGN OUT'),
          ),
          SizedBox(height: 30.0,),
        ],
      ),
    );
  }
}
