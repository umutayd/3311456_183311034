import 'package:flutter/material.dart';
import 'package:kelimekartlari/global_degisken.dart';
import 'package:kelimekartlari/hazirmethodlar.dart';
import 'package:kelimekartlari/pages/list.dart';
import 'package:kelimekartlari/pages/multiple_choice.dart';
import 'package:kelimekartlari/pages/word_cards.dart';
import 'package:url_launcher/url_launcher.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key); //ilki isim, ikincisi ad.

  @override
  _MainPageState createState() => _MainPageState();
}

const String _url = 'https://github.com/umutayd';

class _MainPageState extends State<MainPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>(); //drawer menüsü için verilmiştir.

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
          automaticallyImplyLeading:
              false, //leading otomatik olarak oluşturulmaz.
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
                    text: "ENG - TR", group: chooseLang, value: Lang.ing),
                langRadioButton(
                    text: "TR - ENG", group: chooseLang, value: Lang.tr),
                const SizedBox(
                  height: 25,
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
                          title: "Kelime\nKartlari", click: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const WordCardsPage()));
                      }),
                      card(context,
                          startColor: "#20AD7D",
                          endColor: "#7D20AD",
                          title: "Coktan\nSecmeli", click: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const MultipleChoicePage()));
                      }),
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

  InkWell card(BuildContext context,
      {@required String? startColor,
      @required String? endColor,
      @required String? title,
      @required Function? click}) {
    return InkWell(
      onTap: () => click!(),
      child: Container(
        alignment: Alignment.center,
        height: 200,
        width: MediaQuery.of(context).size.width * 0.37,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            // 10% of the width, so there are ten blinds.
            colors: <Color>[
              Color(HazirMethodlar.HexaColorConverter(startColor!)),
              Color(HazirMethodlar.HexaColorConverter(endColor!)),
            ],
            // red to yellow
            tileMode: TileMode.repeated, // repeats the gradient over the canvas
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              title!,
              style: const TextStyle(
                  fontSize: 28, fontFamily: "Carter", color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const Icon(
              Icons.file_copy,
              size: 32,
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }

  SizedBox langRadioButton({
    @required String? text,
    @required Lang? value,
    @required Lang? group,
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
          value: value!,
          groupValue: chooseLang,
          onChanged: (Lang? value) {
            setState(() {
              chooseLang = value;
            });
          },
        ),
      ),
    );
  }
}
