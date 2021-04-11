import 'package:acappella_station/screens/nogroup/noGroup.dart';
import 'package:acappella_station/screens/root/root.dart';
import 'package:acappella_station/states/currentUser.dart';
import 'package:acappella_station/widgets/ourContainer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {

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
              child: Column(
                children: <Widget>[
                  Text(
                    'I song this song for you.',
                    style: TextStyle(
                      fontSize: 30.0,
                      color: Colors.grey[600],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          'Due In : ',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          '8 days',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Finished Book',
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: OurContainer(
              child: Text('2'),
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
