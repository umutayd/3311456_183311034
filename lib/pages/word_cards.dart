import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kelimekartlari/db/db.dart';
import 'package:kelimekartlari/global_degisken.dart';
import 'package:kelimekartlari/hazirmethodlar.dart';
import 'package:kelimekartlari/kolayc%C4%B1/app_bar.dart';
import 'package:kelimekartlari/kolayc%C4%B1/toast.dart';
import 'package:kelimekartlari/models/words.dart';

class WordCardsPage extends StatefulWidget {
  const WordCardsPage({Key? key}) : super(key: key);
  @override
  _WordsCardsPageState createState() => _WordsCardsPageState();
}

enum Which { learned, unlurned, all }

enum forWhat { forList, forListMixed }

class _WordsCardsPageState extends State<WordCardsPage> {
  Which? _chooseQuestionType = Which.learned;
  bool listMixed = true;
  List<Map<String, Object?>> _list = [];
  List<bool> selectedListIndex = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLists();
  }

  void getLists() async {
    _list = await DB.instance.readListsAll();
    for (int i = 0; i < _list.length; ++i) {
      selectedListIndex.add(false);
    }

    setState(() {
      _list;
    });
  }

  List<Word> _words = [];
  bool start = false;
  List<bool> changeLang = [];
  void getSelectedWordOfLists(List<int> selectedListID) async {
    if (_chooseQuestionType == Which.learned) {
      _words = await DB.instance.readWordByLists(selectedListID, status: true);
    } else if (_chooseQuestionType == Which.unlurned) {
      _words = await DB.instance.readWordByLists(selectedListID, status: false);
    } else {
      _words = await DB.instance.readWordByLists(selectedListID);
    }
    if (_words.isNotEmpty) {
      for (int i = 0; i < _words.length; ++i) {
        changeLang.add(true);
      }

      if (listMixed) _words.shuffle();
      start = true;
      setState(() {
        _words;
        start;
      });
    } else {
      toastMessage("Seçilen şartlarda liste boş.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(context,
            left:
                const Icon(Icons.arrow_back_ios, color: Colors.black, size: 22),
            center: const Text(
              "Kelime Kartları",
              style: TextStyle(
                  fontSize: 22, fontFamily: "carter", color: Colors.black),
            ),
            leftWidgetOnClick: () => Navigator.pop(context)),
        body: SafeArea(
          child: start == false
              ? Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(
                      left: 16, right: 16, bottom: 16, top: 0),
                  padding: const EdgeInsets.only(
                    left: 4,
                    top: 10,
                    right: 4,
                  ),
                  decoration: BoxDecoration(
                      color:
                          Color(HazirMethodlar.HexaColorConverter("#DCD2FF")),
                      borderRadius: const BorderRadius.all(Radius.circular(8))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      whichRadioButton(
                          text: "Öğrenmediklerimi sor", value: Which.unlurned),
                      whichRadioButton(
                          text: "Öğrendiklerimi sor", value: Which.learned),
                      whichRadioButton(text: "Hepsini sor", value: Which.all),
                      checkBox(
                          text: "Listeyi karıştır",
                          fWhat: forWhat.forListMixed),
                      const SizedBox(
                        height: 20,
                      ),
                      const Divider(
                        color: Colors.black,
                        thickness: 1,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Text(
                          "Listeler",
                          style: TextStyle(
                              fontFamily: "RobotoRegular",
                              fontSize: 18,
                              color: Colors.black),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                            left: 8, right: 8, bottom: 10, top: 10),
                        height: 200,
                        decoration:
                            BoxDecoration(color: Colors.grey.withOpacity(0.1)),
                        child: Scrollbar(
                          thickness: 5,
                          isAlwaysShown: true,
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              return checkBox(
                                  index: index,
                                  text: _list[index]["name"].toString());
                            },
                            itemCount: _list.length,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        margin: EdgeInsets.only(right: 20),
                        child: InkWell(
                          onTap: () {
                            List<int> selectedIndexNoOfList = [];
                            for (int i = 0; i < selectedListIndex.length; ++i) {
                              if (selectedListIndex[i] == true) {
                                selectedIndexNoOfList.add(i);
                              }
                            }
                            List<int> selectedListIdList = [];
                            for (int i = 0;
                                i < selectedIndexNoOfList.length;
                                ++i) {
                              selectedListIdList.add(
                                  _list[selectedIndexNoOfList[i]]["list_id"]
                                      as int);
                            }
                            if (selectedListIdList.isNotEmpty) {
                              getSelectedWordOfLists(selectedListIdList);
                            } else {
                              toastMessage("Lütfen, liste seçiniz.");
                            }
                          },
                          child: Text("Başla",
                              style: TextStyle(
                                  fontFamily: "RobotoRegular",
                                  fontSize: 18,
                                  color: Colors.black)),
                        ),
                      )
                    ],
                  ),
                )
              : CarouselSlider.builder(
                  options: CarouselOptions(height: double.infinity),
                  itemCount: _words.length,
                  itemBuilder:
                      (BuildContext context, int itemIndex, int pageViewIndex) {
                    String word = "";

                    if (chooseLang == Lang.tr) {
                      word = changeLang[itemIndex]
                          ? (_words[itemIndex].word_tr!)
                          : (_words[itemIndex].word_ing!);
                    } else {
                      word = changeLang[itemIndex]
                          ? (_words[itemIndex].word_ing!)
                          : (_words[itemIndex].word_tr!);
                    }

                    return Column(
                      children: [
                        Expanded(
                          child: Stack(
                            children: [
                              InkWell(
                                onTap: () {
                                  if (changeLang[itemIndex] == true) {
                                    changeLang[itemIndex] = false;
                                  } else {
                                    changeLang[itemIndex] = true;
                                  }
                                  setState(() {
                                    changeLang[itemIndex];
                                  });
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width: double.infinity,
                                  margin: const EdgeInsets.only(
                                      left: 16, right: 16, bottom: 16, top: 0),
                                  padding: const EdgeInsets.only(
                                    left: 4,
                                    top: 10,
                                    right: 4,
                                  ),
                                  decoration: BoxDecoration(
                                      color: Color(
                                          HazirMethodlar.HexaColorConverter(
                                              "#DCD2FF")),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8))),
                                  child: Text(
                                    word,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontFamily: "RobotoRegular",
                                        color: Colors.black),
                                  ),
                                ),
                              ),
                              Positioned(
                                child: Text(
                                  (itemIndex + 1).toString() +
                                      "/" +
                                      (_words.length).toString(),
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontFamily: "RobotoRegular",
                                      color: Colors.black),
                                ),
                                left: 30,
                                top: 10,
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 160,
                          child: CheckboxListTile(
                            title: Text("Öğrendim"),
                            value: _words[itemIndex].status,
                            onChanged: (value) {
                              _words[itemIndex] =
                                  _words[itemIndex].copy(status: value);
                              DB.instance.markAsLearned(
                                  value!, _words[itemIndex].id as int);
                              toastMessage(value
                                  ? "Öğrenildi olarak işaretlendi."
                                  : "Öğrenilmedi olarak işaretlendi");
                              setState(() {
                                _words[itemIndex];
                              });
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
        ));
  }

  SizedBox whichRadioButton({@required String? text, @required Which? value}) {
    return SizedBox(
      width: 275,
      height: 30,
      child: ListTile(
        //listtile iki nesneyi yanyana konumlandırmamızı sağlar
        title: Text(
          text!,
          style: const TextStyle(
            fontFamily: "RobotoRegular",
            fontSize: 18,
          ),
        ),
        leading: Radio<Which>(
          value: value!,
          groupValue: _chooseQuestionType,
          onChanged: (Which? value) {
            setState(() {
              _chooseQuestionType = value;
            });
          },
        ),
      ),
    );
  }

  SizedBox checkBox(
      {int index = 0, String? text, forWhat fWhat = forWhat.forList}) {
    return SizedBox(
      width: 270,
      height: 35,
      child: ListTile(
        title: Text(
          text!,
          style: const TextStyle(fontFamily: "RobotoRegular", fontSize: 18),
        ),
        leading: Checkbox(
          checkColor: Colors.white,
          activeColor: Colors.deepPurpleAccent,
          hoverColor: Colors.blueAccent,
          value:
              fWhat == forWhat.forList ? selectedListIndex[index] : listMixed,
          onChanged: (bool? valeu) {
            setState(() {
              if (fWhat == forWhat.forList) {
                selectedListIndex[index] = valeu!;
              } else {
                listMixed = valeu!;
              }
            });
          },
        ),
      ),
    );
  }
}
