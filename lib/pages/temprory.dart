import 'package:flutter/material.dart';
import 'package:kelimekartlari/pages/main.dart';

class TemproryPage extends StatefulWidget {
  @override
  _TemproryPageState createState() => _TemproryPageState();
}

class _TemproryPageState extends State<TemproryPage> {
  @override
  void initState() {
    // Bir sınıf çalıştığında ilk çalışan fonksiyondur.
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  MainPage())); // Bir önceki sayfayı ilmek için pushreplacement.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        color: Colors.white,
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Image.asset("assets/imagers/logo.jpg"),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "KELIME KARTLARIM",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Fresh",
                            fontSize: 40),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "KARTLAR SENI BEKLIYOR",
                    style: TextStyle(
                        color: Colors.black, fontFamily: "Fresh", fontSize: 30),
                  ),
                ),
              ]),
        ),
      )),
    );
  }
}
