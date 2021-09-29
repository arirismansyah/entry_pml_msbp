import 'package:flutter/material.dart';
import 'package:flutter_auth/components/text_field_container.dart';
import 'package:flutter_auth/constants.dart';

class RoundedPasswordField extends StatefulWidget {
  @override
  _RoundedPasswordField createState() => _RoundedPasswordField();
}

class _RoundedPasswordField extends State<RoundedPasswordField> {
  bool isObscure = true;
  TextEditingController passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        controller: passwordController,
        obscureText: isObscure,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          hintText: "Password",
          icon: Icon(
            Icons.lock,
            color: kPrimaryColor,
          ),
          suffixIcon: IconButton(
            icon: Icon(isObscure ? Icons.visibility : Icons.visibility_off),
            color: kPrimaryColor,
            onPressed: () {
              setState(() {
                isObscure = !isObscure;
              });
            },
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
