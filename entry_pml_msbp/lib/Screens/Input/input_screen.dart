import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Input/components/body.dart';
import 'package:flutter_auth/constants.dart';

class InputScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Input'),
        backgroundColor: kPrimaryColor,
      ),
      body: Body(),
    );
  }
}
