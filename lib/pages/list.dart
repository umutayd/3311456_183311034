import 'package:flutter/material.dart';
import 'package:kelimekartlari/db/db.dart';
import 'package:kelimekartlari/hazirmethodlar.dart';
import 'package:kelimekartlari/pages/create_list.dart';

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List<Map<String, Object?>> _lists = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLists();
  }

  void getLists() async {
    _lists = await DB.instance.readListsAll();
    setState(() {
      _lists; //lists adlı değişken değişti sayfada güncelle demek için.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              width: MediaQuery.of(context).size.width * 0.2,
              child: InkWell(
                onTap: () {},
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.cyan,
                  size: 34,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              width: MediaQuery.of(context).size.width * 0.2,
              child: Image.asset(
                "assets/imagers/logo.jpg",
                height: 40,
                width: 40,
              ),
            ),
            Container(
              alignment: Alignment.topCenter,
              width: MediaQuery.of(context).size.width * 0.5,
              child: Image.asset(
                "assets/imagers/lists.png",
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => CreateList()));
          },
          child: Icon(
            Icons.add,
          ),
          backgroundColor: Colors.cyan.withOpacity(0.4)),
      body: SafeArea(
        child: ListView.builder(
          itemBuilder: (context, index) {
            return ListItem(_lists[index]["list_id"] as int,
                listName: _lists[index]["name"].toString(),
                sumWords: _lists[index]["sum_word"].toString(),
                sumUnlearned: _lists[index]["sum_unlearned"].toString());
          },
          itemCount: _lists.length,
        ),
      ),
    );
  }

  InkWell ListItem(int id,
      {@required String? listName,
      @required String? sumWords,
      @required String? sumUnlearned}) {
    return InkWell(
      onTap: () {
        debugPrint(id.toString());
      },
      child: Center(
        child: Container(
          width: double.infinity, //sayanın tamamını kapsaması için.
          child: Card(
            color: Color(HazirMethodlar.HexaColorConverter("#DCD2FF")),
            elevation: 10, //gölge
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            margin: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 15, top: 5),
                  child: Text(
                    listName!,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: "Robotomedium"),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 30, top: 5),
                  child: Text(
                    sumWords! + " terim",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: "RobotoRegular"),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 30, top: 5),
                  child: Text(
                    (int.parse(sumWords) - int.parse(sumUnlearned!))
                            .toString() +
                        " öğrenildi",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: "RobotoRegular"),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 30, bottom: 5),
                  child: Text(
                    sumUnlearned + " öğrenilmedi",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: "RobotoRegular"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
