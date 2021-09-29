import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Input/components/date_input_field.dart';
import 'package:flutter_auth/Screens/Login/components/background.dart';
import 'package:flutter_auth/Screens/Home/home_screen.dart';
import 'package:flutter_auth/Screens/Input/components/nks_input_field.dart';
import 'package:flutter_auth/Screens/Input/components/dokumen_input_field.dart';
import 'package:flutter_auth/Screens/Input/components/deskripsi_input_field.dart';
import 'package:flutter_auth/components/rounded_button.dart';
import 'package:flutter_auth/components/rounded_input_field.dart';
import 'package:flutter_auth/constants.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class Body extends StatefulWidget {
  @override
  _Body createState() => _Body();
}

class _Body extends State<Body> {

  void initState() {
    super.initState();
    _populateNks();
  }

  TextEditingController nksController = new TextEditingController();
  TextEditingController dokDiterimaController = new TextEditingController();
  TextEditingController dokDiserahkanController = new TextEditingController();
  TextEditingController deskripsiController = new TextEditingController();
  TextEditingController dateController = new TextEditingController();
  List<String> listNks;
  bool _isLoading = false;
  final _inputForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Form(
          key: _inputForm,
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            NksInputField(
              nksSelected: nksController,
              listNks: listNks,
            ),

            DateInputField(
              controller: dateController,
              hintText: "Tanggal Laporan 2-1-2",
              labelText: "Tangal",
              icon: Icons.date_range,
              onChanged: (value) {},
            ),

            DokumenInputField(
              controller: dokDiterimaController,
              hintText: "Jumlah Kumulatif",
              labelText: "Dokumen Diterima",
              icon: Icons.drive_file_move_outlined,
              onChanged: (value) {},
            ),
            
            DokumenInputField(
              controller: dokDiserahkanController,
              hintText: "Jumlah Kumulatif",
              labelText: 'Dokumen Diserahkan',
              icon: Icons.drive_file_move_outlined,
              onChanged: (value) {},
            ),
            
            DeskripsiInputField(
              controller: deskripsiController,
              hintText: "Keterangan mengenai dokumen",
              labelText: "Deskripsi",
              icon: Icons.comment,
              onChanged: (value) {},
            ),
            RoundedButton(
              text: "SUBMIT",
              press: () {
                if (_inputForm.currentState.validate()) {
                setState(() {
                  _isLoading = true;
                });
                inputData(nksController.text, dokDiterimaController.text, dokDiserahkanController.text, deskripsiController.text, dateController.text);
                }
              },
            ),
            SizedBox(height: size.height * 0.03),
          ],
        )
          ),
      ),
    );
  }

  _populateNks() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var kode_pml = sharedPreferences.getString('kode_pml');

    Map data = {
      'kode_pml':kode_pml
    };

    var jsonResponse = null;
    var response = await http.post(Uri.parse('http://56d4-125-165-165-26.ngrok.io/pmlmsbp/public/getnksbypml'),
        body: data);
    if(response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if(jsonResponse != null) {
        if (jsonResponse['data']!=null) {
          var datas = jsonResponse['data'];
          List<String> list_nks = [];
          for (var d in datas) {
            var nks = d['nks'];
            list_nks.add(nks);
          }
          setState(() {
            listNks = list_nks;
          });
        }
      }
    }
    else {
      print(response.body);
    }

  }

  inputData(nks, jml_diterima, jml_diserahkan, deskripsi, tangal_laporan) async{

    DialogBuilder(context).showLoadingIndicator('Input Data');

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var kode_pml = sharedPreferences.getString('kode_pml');

    Map data = {
      'nks': nks,
      'dok_diterima': jml_diterima,
      'dok_diserahkan': jml_diserahkan,
      'deskripsi': deskripsi,
      'tanggal_laporan': tangal_laporan,
      'kode_pml':kode_pml,
    };

    var jsonResponse = null;
    var response = await http.post(Uri.parse('http://56d4-125-165-165-26.ngrok.io/pmlmsbp/public/updatenks'),
        body: data);
    if(response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if(jsonResponse != null) {
        DialogBuilder(context).hideOpenDialog();
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => HomeScreen()), (Route<dynamic> route) => false);
      }
    }
    else {
      setState(() {
        _isLoading = false;
      });
      print(response.body);
    }
  }

}

class DialogBuilder {
  DialogBuilder(this.context);

  final BuildContext context;

  void showLoadingIndicator([String text]) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0))
              ),
              backgroundColor: kPrimaryColor,
              content: LoadingIndicator(
                  text: text
              ),
            )
        );
      },
    );
  }

  void hideOpenDialog() {
    Navigator.of(context).pop();
  }
}

class LoadingIndicator extends StatelessWidget{
  LoadingIndicator({this.text = ''});

  final String text;

  @override
  Widget build(BuildContext context) {
    var displayedText = text;

    return Container(
        padding: EdgeInsets.all(16),
        color: kPrimaryColor,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              _getLoadingIndicator(),
              _getHeading(context),
              _getText(displayedText)
            ]
        )
    );
  }

  Padding _getLoadingIndicator() {
    return Padding(
        child: Container(
            child: CircularProgressIndicator(
                strokeWidth: 3
            ),
            width: 32,
            height: 32
        ),
        padding: EdgeInsets.only(bottom: 16)
    );
  }

  Widget _getHeading(context) {
    return
      Padding(
          child: Text(
            'Please wait …',
            style: TextStyle(
                color: Colors.white,
                fontSize: 16
            ),
            textAlign: TextAlign.center,
          ),
          padding: EdgeInsets.only(bottom: 4)
      );
  }

  Text _getText(String displayedText) {
    return Text(
      displayedText,
      style: TextStyle(
          color: Colors.white,
          fontSize: 14
      ),
      textAlign: TextAlign.center,
    );
  }
}