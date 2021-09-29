import 'package:flutter/material.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/Screens/Home/components/body.dart';
import 'package:flutter_auth/Screens/Input/input_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return InputScreen();
              },
            ),
          );
        },
        label: const Text('Input'),
        icon: const Icon(Icons.add),
        backgroundColor: kPrimaryColor,
      ),
    );
  }
}
