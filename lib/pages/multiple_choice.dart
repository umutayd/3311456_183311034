import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kelimekartlari/db/db.dart';
import 'package:kelimekartlari/global_degisken.dart';
import 'package:kelimekartlari/hazirmethodlar.dart';
import 'package:kelimekartlari/kolayc%C4%B1/app_bar.dart';
import 'package:kelimekartlari/kolayc%C4%B1/toast.dart';
import 'package:kelimekartlari/models/words.dart';

class MultipleChoicePage extends StatefulWidget {
  const MultipleChoicePage({Key? key}) : super(key: key);

  @override
  _MultipleChoicePage createState() => _MultipleChoicePage();
}

enum Which { learned, unlurned, all }

enum forWhat { forList, forListMixed }

class _MultipleChoicePage extends State<MultipleChoicePage> {
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
  List<List<String>> optionsList =
      []; //Kelime listesi uzunluğu kadar şık listesi, Her şık listesinde 4 şık olacak.
  List<String> correctAnswers =
      []; // Her kelime için doğru cevapları listede tutar.
  List<bool> clickControl =
      []; //kelimeye ait şıklardan herhangi biri işartelendi mi kontrolü yapılır.
  List<List<bool>> clickControlList =
      []; //hangi şıkkın işaretlendiğinin kontrolü.

  int correctCount = 0; //doğru cevaoların sayısını sayacak
  int wrongCount = 0;

  void getSelectedWordOfLists(List<int> selectedListID) async {
    if (_chooseQuestionType == Which.learned) {
      _words = await DB.instance.readWordByLists(selectedListID, status: true);
    } else if (_chooseQuestionType == Which.unlurned) {
      _words = await DB.instance.readWordByLists(selectedListID, status: false);
    } else {
      _words = await DB.instance.readWordByLists(selectedListID);
    }
    if (_words.isNotEmpty) {
      if (_words.length > 3) {
        if (listMixed) _words.shuffle();
        Random random = Random();
        for (int i = 0; i < _words.length; ++i) {
          clickControl
              .add(false); // her kelime için cevap verilip verilmediği kontr.
          clickControlList.add([
            false,
            false,
            false,
            false
          ]); // her kelime için 4 şık var, 4 şıkkında işaretlenmediği belirten 4 false ile doldurdum.
          List<String> tempOptions = []; //geçici olarak tutacak
          while (true) {
            int rand = random
                .nextInt(_words.length); // 0 ile (kelime liste uzunluğu -1)
            if (rand != i) {
              bool isThereSame = false;
              for (var element in tempOptions) {
                if (chooseLang == Lang.ing) {
                  if (element == _words[rand].word_tr!) {
                    isThereSame = true;
                  }
                } else {
                  if (element == _words[rand].word_ing!) {
                    isThereSame = true;
                  }
                }
              }
              if (!isThereSame)
                tempOptions.add(chooseLang == Lang.ing
                    ? _words[rand].word_tr!
                    : _words[rand].word_ing!);
            }
            if (tempOptions.length == 3) {
              break;
            }
          }
          tempOptions.add(chooseLang == Lang.ing
              ? _words[i].word_tr!
              : _words[i].word_ing!);
          tempOptions
              .shuffle(); // içine eklediğim elemanların sırasını karıştırdım
          correctAnswers.add((chooseLang == Lang.ing
              ? _words[i].word_tr!
              : _words[i].word_ing!));
          optionsList.add(tempOptions);
        }

        start = true;
        setState(() {
          _words;
          start;
        });
      } else {
        toastMessage("Minimum 4 kelime gereklidir.");
      }
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
              "Çoktan Seçmeli",
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
                        margin: const EdgeInsets.only(right: 20),
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
                          child: const Text("Başla",
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
                    return Column(
                      children: [
                        Expanded(
                          child: Stack(
                            children: [
                              Container(
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
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      (chooseLang == Lang.ing
                                          ? _words[itemIndex].word_ing!
                                          : _words[itemIndex].word_tr!),
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontFamily: "RobotoRegular",
                                          color: Colors.black),
                                    ),
                                    const SizedBox(height: 15),
                                    customRadioButtonList(
                                        itemIndex,
                                        optionsList[itemIndex],
                                        correctAnswers[itemIndex]),
                                  ],
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
                              ),
                              Positioned(
                                child: Text(
                                  "D:" +
                                      correctCount.toString() +
                                      "/" +
                                      "Y:" +
                                      wrongCount.toString(),
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontFamily: "RobotoRegular",
                                      color: Colors.black),
                                ),
                                right: 30,
                                top: 10,
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 160,
                          child: CheckboxListTile(
                            title: const Text("Öğrendim"),
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
      width: double.infinity,
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

  Container customRadioButton(int index, List<String> options, int order) {
    Icon uncheck = const Icon(Icons.radio_button_off_outlined, size: 16);
    Icon check = const Icon(Icons.radio_button_checked_outlined, size: 16);
    return Container(
      margin: const EdgeInsets.all(4),
      child: Row(
        children: [
          clickControlList[index][order] == false ? uncheck : check,
          const SizedBox(width: 10),
          Text(
            options[order],
            style: const TextStyle(fontSize: 18),
          )
        ],
      ),
    );
  }

  Column customRadioButtonList(
      int index, List<String> options, String correctAnswer) {
    Divider dV = const Divider(thickness: 1, height: 1);

    return Column(
      children: [
        dV,
        InkWell(
          onTap: () => toastMessage("Şeçmek için çift tıklayın."),
          onDoubleTap: () => checker(index, 0, options, correctAnswer),
          child: customRadioButton(index, options, 0),
        ),
        dV,
        InkWell(
          onTap: () => toastMessage("Şeçmek için çift tıklayın."),
          onDoubleTap: () => checker(index, 1, options, correctAnswer),
          child: customRadioButton(index, options, 1),
        ),
        dV,
        InkWell(
          onTap: () => toastMessage("Şeçmek için çift tıklayın."),
          onDoubleTap: () => checker(index, 2, options, correctAnswer),
          child: customRadioButton(index, options, 2),
        ),
        dV,
        InkWell(
          onTap: () => toastMessage("Şeçmek için çift tıklayın."),
          onDoubleTap: () => checker(index, 3, options, correctAnswer),
          child: customRadioButton(index, options, 3),
        ),
        dV
      ],
    );
  }

  void checker(index, order, options, correctAnswer) {
    if (clickControl[index] == false) {
      clickControl[index] = true;
      setState(() => clickControlList[index][order] = true);

      if (options[order] == correctAnswer) {
        correctCount++;
      } else {
        wrongCount++;
      }

      if ((correctCount + wrongCount) == _words.length) {
        toastMessage("Test bitti.");
      }
    }
  }
}
