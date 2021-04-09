import 'package:acappella_station/screens/login/localwidgets/loginform.dart';
import 'package:flutter/material.dart';

class OurLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Acappella Station'),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
              child: Padding(
            padding: EdgeInsets.all(20.0),
            child: ListView(
              padding: EdgeInsets.all(20.0),
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(40.0),
                  child: Image.asset(
                    'assets/logo.png',
                    width: 220.0,
                    height: 80.0,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                OurLoginForm(),
              ],
            ),
          ))
        ],
      ),
    );
  }
}
