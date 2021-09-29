import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Login/login_screen.dart';
import 'package:flutter_auth/Screens/Signup/components/background.dart';
import 'package:flutter_auth/Screens/Signup/components/or_divider.dart';
import 'package:flutter_auth/Screens/Signup/components/social_icon.dart';
import 'package:flutter_auth/components/already_have_an_account_acheck.dart';
import 'package:flutter_auth/components/rounded_button.dart';
import 'package:flutter_auth/components/rounded_input_field.dart';
import 'package:flutter_auth/components/rounded_password_field.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_auth/Screens/Input/input_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'dart:async';

class Body extends StatefulWidget {
  @override
  _Body createState() => _Body();
}

class _Body extends State<Body> {
  @override
  void initState() {
    super.initState();
    checkLoginStatus();
    _loadData();
  }

  String ket_pml = '';
  String ket_wilayah = '';
  SharedPreferences sharedPreferences;
  bool _isLoaded = true;

  Future<List<DataNKS>> _getDataNKS() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var kode_pml = sharedPreferences.getString('kode_pml');

    Map data = {'kode_pml': kode_pml};

    var jsonResponse = null;
    var response = await http.post(
        Uri.parse(
            'http://56d4-125-165-165-26.ngrok.io/pmlmsbp/public/nkslogbypml'),
        body: data);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        if (jsonResponse['success']) {
          var data = jsonResponse['data'];

          List<DataNKS> datas = [];

          for (var d in data) {
            DataNKS data_nks = DataNKS(
                d['id'],
                d['nks'],
                d['tanggal_laporan'],
                d['dok_diserahkan'],
                d['dok_diterima'],
                d['deskripsi'],
                d['kode_pml'],
                d['created_at'],
                d['updated_at']);
            datas.add(data_nks);
          }
          return datas;
        }
      }
    }
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("nama_petugas") == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
          (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          SliverAppBar(
            forceElevated: true,
            centerTitle: true,
            floating: true,
            pinned: true,
            snap: true,
            automaticallyImplyLeading: false,
            backgroundColor: kPrimaryColor,
            title: const Text('Input PML MSBP'),
            flexibleSpace: const FlexibleSpaceBar(),
            bottom: PreferredSize(
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.account_circle,
                      color: Colors.white,
                    ),
                    title: Text(
                      'PML : ' + ket_pml,
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      'Wilayah : ' + ket_wilayah,
                      style: TextStyle(color: Colors.white.withOpacity(0.6)),
                    ),
                  ),
                ],
              ),
              preferredSize: Size.fromHeight(100),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(80))),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.logout_outlined),
                tooltip: 'Logout',
                onPressed: () {
                  _logout();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (BuildContext context) => LoginScreen()),
                      (Route<dynamic> route) => false);
                },
              ),
            ],
          ),
          CupertinoSliverRefreshControl(
            onRefresh: () async {
              await FutureBuilder(
                future: _getDataNKS(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  var _childCount = 0;
                  if (snapshot.connectionState != ConnectionState.done ||
                      snapshot.data == null) {
                    _childCount = 1;
                  } else {
                    _childCount = snapshot.data.length;
                  }
                  print(_childCount);
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        if (snapshot.connectionState != ConnectionState.done) {
                          return Container(
                            child: LinearProgressIndicator(),
                          );
                        }
                        if (snapshot.data == null) {
                          // nanti diisi data belum diisi
                          return Container(
                            color: kPrimaryLightColor,
                            height: size.height * 0.65,
                            child: Column(
                              children:[
                                Text("Anda belum melakukan input data.",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SvgPicture.asset(
                                  "assets/icons/login.svg",
                                  height: size.height * 0.35,
                                ),
                              ],
                            ),
                          );
                        }
                        if (snapshot.connectionState == ConnectionState.none) {
                          // nanti diisi koneksi internet
                          return Container(
                            color: kPrimaryLightColor,
                            height: size.height * 0.65,
                            child: Column(
                              children: [
                                Text("Server atau koneksi internet anda bermasalah.",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SvgPicture.asset(
                                  "assets/icons/login.svg",
                                  height: size.height * 0.35,
                                ),
                              ],
                            ),
                          );
                        }
                        return Card(
                          margin: EdgeInsets.all(10),
                          child: Container(
                            color: kPrimaryLightColor,
                            height: 150,
                            alignment: Alignment.center,
                            child: Card(
                              child: InkWell(
                                splashColor: Colors.blue.withAlpha(30),
                                onTap: () {
                                  print('Card tapped.');
                                },
                                child: Column(
                                  children: [
                                    ListTile(
                                        leading:
                                            Icon(Icons.dashboard_customize),
                                        title: Text("Tanggal : " +
                                            snapshot
                                                .data[index].tanggal_laporan),
                                        subtitle: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'NKS : ' +
                                                      snapshot.data[index].nks,
                                                  style: TextStyle(
                                                      color: Colors.black
                                                          .withOpacity(0.6)),
                                                ),
                                                Text(
                                                  'Dokumen Diterima : ' +
                                                      snapshot.data[index]
                                                          .dok_diterima
                                                          .toString(),
                                                  style: TextStyle(
                                                      color: Colors.black
                                                          .withOpacity(0.6)),
                                                ),
                                                Text(
                                                  'Dokumen Diserahkan : ' +
                                                      snapshot.data[index]
                                                          .dok_diserahkan
                                                          .toString(),
                                                  style: TextStyle(
                                                      color: Colors.black
                                                          .withOpacity(0.6)),
                                                ),
                                                Text(
                                                  'Deskripsi : '+snapshot.data[index].deskripsi,
                                                  style: TextStyle(
                                                      color: Colors.black
                                                          .withOpacity(0.6)),
                                                ),
                                                
                                              ],
                                            ))),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: _childCount,
                    ),
                  );
                },
              );

              await Future.delayed(Duration(seconds: 2));
            },
          ),
          FutureBuilder(
            future: _getDataNKS(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              var _childCount = 0;
              if (snapshot.connectionState != ConnectionState.done ||
                  snapshot.data == null) {
                _childCount = 1;
              } else {
                _childCount = snapshot.data.length;
              }

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return Container(
                        child: LinearProgressIndicator(),
                      );
                    }
                    if (snapshot.data == null) {
                      // nanti diisi data belum diisi
                      print('belum diisi');
                      return Container(
                        color: kPrimaryLightColor,
                        height: size.height * 0.65,
                        child: Column(
                          children:[
                            Text("Anda belum melakukan input data.",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SvgPicture.asset(
                              "assets/icons/login.svg",
                              height: size.height * 0.35,
                            ),
                          ],
                        ),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.none) {
                      // nanti diisi koneksi internet
                      return Container(
                        color: kPrimaryLightColor,
                        height: size.height * 0.65,
                        child: Column(
                          children: [
                            Text("Server atau koneksi internet anda bermasalah.",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SvgPicture.asset(
                              "assets/icons/login.svg",
                              height: size.height * 0.35,
                            ),
                          ],
                        ),
                      );
                    }
                    if(snapshot.data != null){
                      return Card(
                        margin: EdgeInsets.all(10),
                        child: Container(
                          color: kPrimaryLightColor,
                          height: 150,
                          alignment: Alignment.center,
                          child: Card(
                            child: InkWell(
                              splashColor: Colors.blue.withAlpha(30),
                              onTap: () {
                                print('Card tapped.');
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ListTile(
                                      leading: Icon(Icons.dashboard_customize),
                                      title: Text("Tanggal : " +
                                          snapshot.data[index].tanggal_laporan),
                                      subtitle: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'NKS : ' +
                                                    snapshot.data[index].nks,
                                                style: TextStyle(
                                                    color: Colors.black
                                                        .withOpacity(0.6)),
                                              ),
                                              Text(
                                                'Dokumen Diterima : ' +
                                                    snapshot
                                                        .data[index].dok_diterima
                                                        .toString(),
                                                style: TextStyle(
                                                    color: Colors.black
                                                        .withOpacity(0.6)),
                                              ),
                                              Text(
                                                'Dokumen Diserahkan : ' +
                                                    snapshot.data[index]
                                                        .dok_diserahkan
                                                        .toString(),
                                                style: TextStyle(
                                                    color: Colors.black
                                                        .withOpacity(0.6)),
                                              ),
                                              Text(
                                                'Deskripsi : '+snapshot.data[index].deskripsi,
                                                style: TextStyle(
                                                    color: Colors.black
                                                        .withOpacity(0.6)),
                                              ),

                                            ],
                                          ))),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                    else {
                      return Container(
                        color: kPrimaryLightColor,
                        height: size.height * 0.65,
                        child: Column(
                          children:[
                            Text("Anda belum melakukan input data.",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SvgPicture.asset(
                              "assets/icons/login.svg",
                              height: size.height * 0.35,
                            ),
                          ],
                        ),
                      );
                    }
                    }
                    ,
                  childCount: _childCount,
                ),
              );
            },
          )
        ],
      ),
    );
  }

  _loadData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var nama = sharedPreferences.getString('nama_petugas');
    var kode_prov = sharedPreferences.getString('kode_prov');
    var kode_kab = sharedPreferences.getString('kode_kab');

    setState(() {
      ket_pml = nama;
      ket_wilayah = kode_prov + kode_kab;
    });
  }

  _logout() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
  }
}

class DataNKS {
  final int id;
  final String nks;
  final String tanggal_laporan;
  final int dok_diserahkan;
  final int dok_diterima;
  final String deskripsi;
  final String kode_pml;
  final String created_at;
  final String update_at;

  DataNKS(
    this.id,
    this.nks,
    this.tanggal_laporan,
    this.dok_diserahkan,
    this.dok_diterima,
    this.deskripsi,
    this.kode_pml,
    this.created_at,
    this.update_at,
  );
}
