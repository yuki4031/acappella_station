import 'package:acappella_station/screens/home/home.dart';
import 'package:acappella_station/screens/signup/signup.dart';
import 'package:acappella_station/states/currentUser.dart';
import 'package:acappella_station/widgets/ourContainer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OurLoginForm extends StatefulWidget {
  @override
  _OurLoginFormState createState() => _OurLoginFormState();
}

class _OurLoginFormState extends State<OurLoginForm> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  void _loginUser(String email, String password, BuildContext context) async {
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);

    try {
      String _returnString =
          await _currentUser.loginUserWithEmail(email, password);
      if (_returnString == 'success') {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
            (route)=>false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_returnString),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return OurContainer(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
            child: Text(
              'LOGIN',
              style: TextStyle(
                color: Theme.of(context).secondaryHeaderColor,
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.email),
              hintText: 'Email',
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.lock_outline),
              hintText: 'Password',
            ),
            obscureText: true,
          ),
          SizedBox(
            height: 20.0,
          ),
          ElevatedButton(
            onPressed: () {
              _loginUser(
                  _emailController.text, _passwordController.text, context);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 100),
              child: Icon(Icons.login_rounded),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => OurSignUp(),
                ),
              );
            },
            child: Text(
              "Don't have an account? Sign up here.",
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }
}
