import 'package:flutter/material.dart';
import 'package:kelimekartlari/db/db.dart';
import 'package:kelimekartlari/hazirmethodlar.dart';
import 'package:kelimekartlari/kolayc%C4%B1/app_bar.dart';
import 'package:kelimekartlari/kolayc%C4%B1/toast.dart';
import 'package:kelimekartlari/pages/create_list.dart';
import 'package:kelimekartlari/pages/words.dart';

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List<Map<String, Object?>> _lists = [];
  bool pressControler = false;
  List<bool> deleteIndexList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLists();
  }

  void getLists() async {
    _lists = await DB.instance.readListsAll();
    for (int i = 0; i < _lists.length; ++i) deleteIndexList.add(false);
    setState(() {
      _lists; //lists adlı değişken değişti sayfada güncelle demek için.
    });
  }

  void delete() async //veritabanı kodları yazılacağından asyc
  {
    List<int> removeIndexList = [];
    for (int i = 0; i < _lists.length; ++i)
      if (deleteIndexList[i] == true) removeIndexList.add(i);
    for (int i = removeIndexList.length - 1;
        i >= 0;
        --i) //silmeye sondan başladım
    {
      DB.instance.deleteListsAndWordByList(
          _lists[removeIndexList[i]]["list_id"] as int);
      _lists.removeAt(removeIndexList[i]);
      deleteIndexList.removeAt(removeIndexList[i]);
    }
    for (int i = 0; i < deleteIndexList.length; ++i) deleteIndexList[i] = false;
    setState(() {
      _lists;
      deleteIndexList;
      pressControler = false;
    });
    toastMessage("Seçili liste/listeler silindi");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context,
          left: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 22,
          ),
          center: Image.asset(
            "assets/imagers/lists.png",
            height: 40,
          ),
          right: pressControler != true
              ? Image.asset(
                  "assets/imagers/logo.jpg",
                  height: 35,
                  width: 35,
                )
              : InkWell(
                  onTap: delete,
                  child: Icon(
                    Icons.delete,
                    color: Colors.deepPurpleAccent,
                    size: 24,
                  ),
                ),
          leftWidgetOnClick: () => Navigator.pop(context)),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const CreateList()))
              .then((value) {
            getLists();
          });
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.purple,
      ),
      body: SafeArea(
        child: ListView.builder(
          itemBuilder: (context, index) {
            return ListItem(_lists[index]['list_id'] as int, index,
                listName: _lists[index]['name'].toString(),
                sumWords: _lists[index]['sum_word'].toString(),
                sumUnlearned: _lists[index]['sum_unlearned'].toString());
          },
          itemCount: _lists.length,
        ),
      ),
    );
  }

  InkWell ListItem(int id, int index,
      {@required String? listName,
      @required String? sumWords,
      @required String? sumUnlearned}) {
    return InkWell(
      onTap: () {
        debugPrint(id.toString());
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WordsPage(id, listName))).then((value) {
          getLists();
        });
      },
      onLongPress: () {
        setState(() {
          pressControler = true;
          deleteIndexList[index] = true;
        });
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
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
                pressControler == true
                    ? Checkbox(
                        checkColor: Colors.white,
                        activeColor: Colors.deepPurpleAccent,
                        hoverColor: Colors.blueAccent,
                        value: deleteIndexList[index],
                        onChanged: (bool? value) {
                          setState(() {
                            deleteIndexList[index] = value!;
                            bool deleteProcessControler = false;
                            deleteIndexList.forEach((element) {
                              if (element == true)
                                deleteProcessControler == true;
                            });
                            if (!deleteProcessControler) pressControler = false;
                          });
                        },
                      )
                    : Container()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
