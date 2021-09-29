import 'package:flutter/material.dart';
import 'package:flutter_auth/components/text_field_container.dart';
import 'package:flutter_auth/constants.dart';
import 'package:date_format/date_format.dart';

class DateInputField extends StatelessWidget {
  final String hintText;
  final String labelText;
  final IconData icon;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  const DateInputField({
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
        onTap: (){
          showDatePicker(
            context: context, firstDate: DateTime(2021), lastDate: DateTime(2025),
            initialDate: DateTime.now()
            ).then((date) {
              controller.text = formatDate(date, [yyyy, '-', mm, '-', dd]).toString();
            });
        },
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: kPrimaryColor,
          ),
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
