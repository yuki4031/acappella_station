import 'package:acappella_station/screens/nogroup/noGroup.dart';
import 'package:acappella_station/screens/root/root.dart';
import 'package:acappella_station/states/currentGroup.dart';
import 'package:acappella_station/states/currentUser.dart';
import 'package:acappella_station/widgets/ourContainer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    CurrentGroup _currentGroup = Provider.of<CurrentGroup>(
        context, listen: false);
    _currentGroup.updateStateFromDatabase(_currentUser.getCurrentUser.groupId);
  }

  void _signOut(BuildContext context) async {
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    String _returnString = await _currentUser.signOut();
    if (_returnString == 'success') {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => OurRoot()), (route) => false);
    }
  }

  void _goToNoGroup(BuildContext context) {
    Navigator.push(
      context, MaterialPageRoute(builder: (context) => OurNoGroup(),),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Acappella Station'),
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 20.0,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: OurContainer(
              child: Consumer<CurrentGroup>(
                  builder: (BuildContext context, value, Widget child) {
                    return Column(
                      children: <Widget>[
                        Text(
                          value.getCurrentSong.name ?? 'loading',
                          style: TextStyle(
                            fontSize: 30.0,
                            color: Colors.grey[600],
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'Finished Song',
                          ),
                        ),
                      ],
                    );
                  }

              ),
            ),
          ),
          TextButton(
            onPressed: () => _goToNoGroup(context),
            child: Text('Book Club History'),
          ),
          TextButton(
            onPressed: () => _signOut(context),
            child: Text('SIGN OUT'),
          ),
        ],
      ),
    );
  }
}
