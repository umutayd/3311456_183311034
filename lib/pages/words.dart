import 'package:flutter/material.dart';
import 'package:kelimekartlari/db/db.dart';
import 'package:kelimekartlari/hazirmethodlar.dart';
import 'package:kelimekartlari/kolayc%C4%B1/app_bar.dart';
import 'package:kelimekartlari/kolayc%C4%B1/toast.dart';
import 'package:kelimekartlari/models/words.dart';
import 'package:kelimekartlari/pages/add_word.dart';

class WordsPage extends StatefulWidget {
  final int? listID;
  final String? listName;
  const WordsPage(this.listID, this.listName, {Key? key}) : super(key: key);
  @override
  _WordsPageState createState() =>
      _WordsPageState(listID: listID, listName: listName);
}

List<Word> _wordList = [];
bool pressControteller = false;
List<bool> deleteIndexList =
    []; //hangi indexteki elemanların seçildiği ile alakalı bilgi tutmak

class _WordsPageState extends State<WordsPage> {
  int? listID;
  String? listName;
  _WordsPageState({@required this.listID, @required this.listName});
  @override
  void initState() {
    // TODO: implement initState

    getWordByList();
  }

  void getWordByList() async {
    _wordList = await DB.instance.readWordByList(listID);
    for (int i = 0; i < _wordList.length; ++i) deleteIndexList.add(false);
    setState(() => _wordList);
  }

  void delete() async {
    List<int> removeIndexList = [];
    for (int i = 0; i < deleteIndexList.length; ++i) {
      if (deleteIndexList[i] == true) removeIndexList.add(i);
    }
    for (int i = removeIndexList.length - 1; i > 0; --i) {
      DB.instance.deleteWord(_wordList[removeIndexList[i]].id!);
      _wordList.removeAt(removeIndexList[i]);
      deleteIndexList.removeAt(removeIndexList[i]);
    }
    setState(() {
      _wordList;
      deleteIndexList;
      pressControteller = false;
    });
    toastMessage("Seçili kelimeler silindi");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(
          context,
          left: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 22,
          ),
          center: Text(
            listName!,
            style: TextStyle(
                fontFamily: "carter", fontSize: 22, color: Colors.black),
          ),
          right: pressControteller != true
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
          leftWidgetOnClick: () => Navigator.pop(context),
        ),
        body: SafeArea(
          child: ListView.builder(
            itemBuilder: (context, index) {
              return wordItem(_wordList[index].id!, index,
                  word_eng: _wordList[index].word_ing,
                  word_tr: _wordList[index].word_tr,
                  status: _wordList[index].status!);
            },
            itemCount: _wordList.length,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddWordPage(listID, listName)))
                .then((value) => getWordByList());
          },
          child: const Icon(Icons.add),
          backgroundColor: Colors.purple,
        ));
  }

  InkWell wordItem(int wordId, index,
      {@required String? word_tr,
      @required String? word_eng,
      @required bool? status}) {
    return InkWell(
      onLongPress: () {
        setState(() {
          pressControteller = true;
          deleteIndexList[index] = true;
        });
      },
      child: Container(
        width: double.infinity, //sayanın tamamını kapsaması için.
        child: Card(
          color: pressControteller != true
              ? Color(HazirMethodlar.HexaColorConverter("#DCD2FF"))
              : Color(HazirMethodlar.HexaColorConverter("#E7E3F5")),
          elevation: 10, //gölge
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
                    margin: EdgeInsets.only(left: 15, top: 10),
                    child: Text(
                      word_tr!,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontFamily: "Robotomedium"),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 30, bottom: 10),
                    child: Text(
                      word_eng!,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: "RobotoRegular"),
                    ),
                  ),
                ],
              ),
              pressControteller != true
                  ? Checkbox(
                      checkColor: Colors.white,
                      activeColor: Colors.deepPurpleAccent,
                      hoverColor: Colors.blueAccent,
                      value: status,
                      onChanged: (bool? value) {
                        _wordList[index] = _wordList[index].copy(
                            status: value); //copy word listesini güncelliyordu
                        if (value == true) {
                          toastMessage("Öğrenildi olarak işaretlendi");
                          DB.instance
                              .markAsLearned(true, _wordList[index].id as int);
                        } else {
                          toastMessage("Öğrenilmedi olarak işaretlendi");
                          DB.instance
                              .markAsLearned(false, _wordList[index].id as int);
                        }
                        setState(() {
                          _wordList;
                        });
                      },
                    )
                  : Checkbox(
                      checkColor: Colors.white,
                      activeColor: Colors.deepPurpleAccent,
                      hoverColor: Colors.blueAccent,
                      value: deleteIndexList[index],
                      onChanged: (bool? value) {
                        setState(() {
                          deleteIndexList[index] = value!;
                          bool deleteProcessController = false;
                          deleteIndexList.forEach((element) {
                            if (element == true) deleteProcessController = true;
                          });
                          if (!deleteProcessController) {
                            pressControteller = false;
                          }
                        });
                      },
                    )
            ],
          ),
        ),
      ),
    );
  }
}
