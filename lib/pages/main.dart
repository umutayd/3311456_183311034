import 'package:flutter/material.dart';
import 'package:kelimekartlari/hazirmethodlar.dart';
import 'package:kelimekartlari/pages/list.dart';
import 'package:url_launcher/url_launcher.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

enum Lang { ing, tr }
const String _url = 'https://github.com';

class _MainPageState extends State<MainPage> {
  Lang? _chooseLang = Lang.ing;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width * .5,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(children: [
                Image.asset(
                  "assets/imagers/logo.jpg",
                  height: 80,
                ),
                Text(
                  "Kelime Kartları",
                  style: TextStyle(fontFamily: "Robotolight", fontSize: 28),
                ),
                Text(
                  "Öğrenmenizi Kolaylaştırır",
                  style: TextStyle(fontFamily: "Robotolight", fontSize: 14),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .30,
                  child: Divider(
                    color: Colors.black,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 50, right: 8, left: 8),
                  child: Text(
                    "Umut Servan AYDIN\n        183311034",
                    style: TextStyle(fontFamily: "Robotolight", fontSize: 18),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    if (!await launch(_url)) throw 'Could not launch $_url';
                  },
                  child: Text(
                    "GitHub için TIKLA",
                    style: TextStyle(
                        fontFamily: "Robotolight",
                        fontSize: 14,
                        color: Color(
                            HazirMethodlar.HexaColorConverter("#0A588D"))),
                  ),
                ),
              ]),
              Text(
                "umutayd@hotmail.com",
                style: TextStyle(
                    fontFamily: "Robotolight",
                    fontSize: 14,
                    color: Color(HazirMethodlar.HexaColorConverter("#0A588D"))),
              ),
            ],
          ),
        ),
      ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          title: Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.2,
                child: InkWell(
                  onTap: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                  child: Icon(
                    Icons.drag_handle_outlined,
                    color: Colors.cyan,
                    size: 34,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Center(
            child: Column(
              children: [
                langRadioButton(
                    //extract method denenmiştir
                    text: "ENG - TR",
                    group: _chooseLang,
                    value: Lang.tr),
                SizedBox(
                  width: 150,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(0),
                    title: Text(
                      "TR - ENG",
                      style: TextStyle(fontFamily: "Fresh"),
                    ),
                    leading: Radio<Lang>(
                      value: Lang.ing,
                      groupValue: _chooseLang,
                      onChanged: (Lang? value) {
                        setState(() {
                          _chooseLang = value;
                        });
                      },
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ListPage()));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 55,
                    margin: EdgeInsets.only(bottom: 20),
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        // 10% of the width, so there are ten blinds.
                        colors: <Color>[
                          Color(
                            HazirMethodlar.HexaColorConverter("#7D20AD"),
                          ),
                          Color(HazirMethodlar.HexaColorConverter("#20AD7D")),
                        ], // red to yellow
                        tileMode: TileMode
                            .repeated, // repeats the gradient over the canvas
                      ),
                    ),

                    // borderRadius= kutucuğa kıvrım sağlıyor
                    child: Text(
                      "Listelerim",
                      style: TextStyle(
                          fontSize: 30,
                          fontFamily: "Fresh",
                          color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      card(context,
                          startColor: "#20AD7D",
                          endColor: "#7D20AD",
                          title: "Kelime\nKarlari"),
                      card(context,
                          startColor: "#20AD7D",
                          endColor: "#7D20AD",
                          title: "Coktan\nSecmeli"),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container card(BuildContext context,
      {@required String? startColor,
      @required String? endColor,
      @required String? title}) {
    return Container(
      alignment: Alignment.center,
      height: 200,
      width: MediaQuery.of(context).size.width * 0.35,
      //her cihaz için boyutlandırma mediaQuery
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          // 10% of the width, so there are ten blinds.
          colors: <Color>[
            Color(
              HazirMethodlar.HexaColorConverter(startColor!),
            ),
            Color(HazirMethodlar.HexaColorConverter(endColor!)),
          ], // red to yellow
          tileMode: TileMode.repeated, // repeats the gradient over the canvas
        ),
      ),

      // borderRadius= kutucuğa kıvrım sağlıyor
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            title!,
            style: TextStyle(
                fontSize: 30, fontFamily: "Fresh", color: Colors.white),
            textAlign: TextAlign.center,
          ),
          Icon(Icons.file_copy_rounded, size: 32, color: Colors.white),
        ],
      ),
    );
  }

  SizedBox langRadioButton({
    @required String? text,
    @required Lang? value,
    @required
        Lang?
            group, //null safety(boş güvenliği) ne olursa olsun bunları gönder.
  }) {
    return SizedBox(
      width: 150, //ekranı ortalamak için.
      height: 30,
      child: ListTile(
        contentPadding: EdgeInsets.all(0),
        title: Text(
          text!,
          style: TextStyle(
            fontFamily: "fresh",
            fontSize: 15,
          ),
        ),
        leading: Radio<Lang>(
          value: Lang.tr,
          groupValue: _chooseLang,
          onChanged: (Lang? value) {
            setState(() {
              _chooseLang = value;
            });
          },
        ),
      ),
    );
  }
}
