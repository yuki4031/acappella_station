import 'package:acappella_station/screens/signup/localwidgets/signupform.dart';
import 'package:flutter/material.dart';

class OurSignUp extends StatelessWidget {
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
                SizedBox(
                  height: 20.0,
                ),
                OurSignUpForm(),
              ],
            ),
          ))
        ],
      ),
    );
    ;
  }
}
