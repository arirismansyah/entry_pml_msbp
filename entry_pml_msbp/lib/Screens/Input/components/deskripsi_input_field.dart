import 'package:flutter/material.dart';
import 'package:flutter_auth/components/text_field_container.dart';
import 'package:flutter_auth/constants.dart';

class DeskripsiInputField extends StatelessWidget {
  final String hintText;
  final String labelText;
  final IconData icon;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  const DeskripsiInputField({
    Key key,
    this.hintText,
    this.labelText,
    this.icon,
    this.controller,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Harus diisi!';
          }
          return null;
        },
        controller: controller,
        onChanged: onChanged,
        cursorColor: kPrimaryColor,
        maxLines: 8,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: kPrimaryColor,
          ),
          hintText: hintText,
          labelText: labelText,
          border: InputBorder.none,
        ),
        
      ),
    );
  }
}
