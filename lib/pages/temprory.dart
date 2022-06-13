import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:kelimekartlari/pages/main.dart';

class TemproryPage extends StatefulWidget {
  @override
  _TemproryPageState createState() => _TemproryPageState();
}

class _TemproryPageState extends State<TemproryPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  MainPage())); // Bir önceki sayfayı ilmek için pushreplacement.
    });
    setFirebase();
  }

  void setFirebase() async {
    await Firebase.initializeApp();
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');
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
                      padding: const EdgeInsets.all(
                          10.0), //tüm kenarlardan aynı uzaklıkta vermek için.
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
