import 'package:flutter/material.dart';
import 'package:flutter_auth/components/text_field_container.dart';
import 'package:dropdownfield/dropdownfield.dart';
import 'package:flutter_auth/constants.dart';

class NksInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final TextEditingController nksSelected;
  final ValueChanged<String> onChanged;
  final List<String> listNks;
  const NksInputField({
    Key key,
    this.hintText,
    this.icon,
    this.nksSelected,
    this.onChanged,
    this.listNks,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: DropDownField(
        required: true,
        controller: nksSelected,
        hintText: 'NKS',
        enabled: true,
        items: listNks,
        icon: Icon(Icons.location_on, color: kPrimaryColor,),
        onValueChanged: (value){
          
        },
      ),
    );
  }
}

String selectNks = '';