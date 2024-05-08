import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'libN2.dart';
import 'libnello.dart';
import 'dart:math';


// variable

String title="Giocatori";

int xColorBn=1;

String page="Player";

// Player
//*
Map mapPlayer={
  /*
  "Damiano":{
    "attack": "10.0",
    "defend":"20.0"
  },*/
};

const Map mapProperties={
  "DRI":"0",
  "PAC":"0",
  "DEF":"0",
  "PAS":"0",
  "SHO":"0",
  "PHY":"0",

};

// Match
//*
List<String> lPlayer=[];
List<String> lPlayerSelectable=[];

//Calculated

List<String> lTeamA=[];
List<String> lTeamB=[];

double avgA=0;
double avgB=0;

// function

Widget Body()
{

  switch (page) {
    case "Calculated":
      return Wello(
        builder: (iwFather){
        },
        view: (iwFather){
          return Container(
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(10),
            color: Color(0x3F000000),
            child: ListView(
                children: [
                  // copy
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Wello(
                        builder: (iw){
                          iw.style.color=Colors.deepPurpleAccent.value;
                          iw.setMapElement("colorDefault",update:iw.style.color);
                        },
                        view: (iw){
                          iw.style.color= iw.style.color==0?iw.getMapElement("colorDefault")??Colors.deepPurpleAccent.value:iw.style.color; // errore strano
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(onPressed: (){
                                iw.style.color=Colors.green.value;
                                iw.content.text="copy";
                                iw.setStateWello();

                                String textCopy;
                                textCopy="White";
                                int i=0;
                                for(String name in lTeamA)
                                {
                                  i++;
                                  textCopy+="\n"+i.toString()+". "+name;
                                }
                                textCopy+="\n\nBlack";
                                i=0;
                                for(String name in lTeamB)
                                {
                                  i++;
                                  textCopy+="\n"+i.toString()+". "+name;
                                }

                                Clipboard.setData(ClipboardData(text:
                                textCopy
                                ));
                                Timer(const Duration(seconds:1),(){
                                  iw.style.color=iw.getMapElement("colorDefault");
                                  iw.content.text="";
                                  iw.setStateWello();
                                });
                              }, child: Icon(Icons.copy_sharp,color: Color(iw.style.color),)),
                              Text(iw.content.text)
                            ],
                          )
                          ;
                        },
                      ),
                    ],),
                  // 2 teams
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // White
                      Column(
                        children: [
                          Text("WHITE"),
                          for(String name in lTeamA)
                          // playerA
                            Container(
                              padding: EdgeInsets.all(20),
                              color: Color(0x3DFFFFFF),
                              child:
                              Text(name)
                              ,),

                          Text("avg:"+avgA.toString()),
                        ],),
                      // Black
                      Column(children: [
                        Text("BLACK"),
                        for(String name in lTeamB)
                        // playerB
                          Container(
                            padding: EdgeInsets.all(20),
                            color: Color(0x51000000),
                            child:
                            Text(name,style: TextStyle(color: Colors.white),)
                            ,),

                        Text("avg:"+avgB.toString()),
                      ],),
                    ],),

                  TextButton(onPressed: (){
                    page="Player";
                    xColorBn=1;
                    title="Giocatori";
                    main();
                  }, child: Text("Fine"))

                ]
            ),
          );
        },
      );

    case "Match":
      lPlayerSelectable=GetPlayerSelectable();
      return Wello(
        builder: (iwFather){
        },
        view: (iwFather){
          return Container(
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(10),
            color: Color(0x3F000000),
            child: ListView(
                children: [
                  // remove All
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(onPressed: (){
                        RemoveAllPlayer();
                        iwFather.setStateWello();
                      }, child: Text("Remove All"))
                    ],),
                  TextButton(onPressed: (){
                    if(lPlayer.length>0)
                    {
                      // calcola...
                      Calculated();
                      //
                      saveCalculated(lTeamA, lTeamB);
                      page="Calculated";
                      title="ALGORITMO";
                      xColorBn=3;
                      main();
                    }
                  }, child: Text("Calcola")),
                  for(String name in lPlayer)
                  // player
                    Wello(
                        builder: (iwPlayer){
                          iwPlayer.content.text=name;
                        },
                        view: (iwPlayer){
                          if(iwPlayer.content.text=="")
                            iwPlayer.content.text=name;

                          return Container(
                              margin: EdgeInsets.all(10),
                              padding: EdgeInsets.all(10),
                              color: Color(0x42176885),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  //remove
                                  IconButton(onPressed: (){

                                    iwPlayer.content.count++;
                                    if(iwPlayer.content.count==1)
                                    {
                                      iwPlayer.setStateWello();
                                      Timer(const Duration(seconds:2),(){iwPlayer.content.count=0; iwPlayer.setStateWello();});
                                    }
                                    else if(iwPlayer.content.count==2)
                                    {
                                      RemovelPlayer( iwPlayer.content.text);
                                      iwFather.setStateWello();
                                    }
                                  }, icon: Icon(Icons.highlight_remove_rounded,color: iwPlayer.content.count==1?Colors.red:null,)),
                                  Text((lPlayer.indexOf(name)+1).toString()+". "),
                                  Column(children: [
                                    // name Player
                                    Container(
                                        padding: EdgeInsets.all(5),
                                        width:100,
                                        color:Color(0x35FFFFFF),
                                        child: Text(iwPlayer.content.text)), ],),
                                ],
                              ));
                        }),

                  Wello(
                    view: (iwDropDownBn){
                      return Container(
                        child: DropdownButton<String>(
                          value:iwDropDownBn.content.text,
                          items: lPlayerSelectable.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            // This is called when the user selects an item.
                            iwDropDownBn.content.text=value??"";

                            if(iwDropDownBn.content.text!="")
                            {
                              AddPlayer(iwDropDownBn.content.text);
                              iwFather.setStateWello();
                            }
                          },
                        ),
                      );
                    },),
                ]
            ),
          );
        },
      );

    case "Player":
      return Wello(
        id:"Player",
        view: (iwFather){
          return Container(
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(5),
            color: Color(0x3F000000),
            child: ListView(
                children: [
                  for(String name in mapPlayer.keys)
                  // player
                    Wello(
                        builder: (iwPlayer){
                          if(name=="") {
                            iwPlayer.style.visible=true;
                          }
                        },
                        view: (iwPlayer){
                          if(iwPlayer.content.text=="")
                          {
                            iwPlayer.content.text=name;
                          }

                          return Container(
                              margin: EdgeInsets.all(10),
                              padding: EdgeInsets.all(3),
                              color: Color(0x42176885),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  //remove
                                  IconButton(onPressed: (){

                                    iwPlayer.content.count++;
                                    if(iwPlayer.content.count==1)
                                    {
                                      iwPlayer.setStateWello();
                                      Timer(const Duration(seconds:2),(){iwPlayer.content.count=0; iwPlayer.setStateWello();});
                                    }
                                    else if(iwPlayer.content.count==2)
                                    {
                                      RemoveInListAllPlayer(iwPlayer.content.text);
                                      iwFather.setStateWello();
                                    }
                                  }, icon: Icon(Icons.highlight_remove_rounded,color: iwPlayer.content.count==1?Colors.red:null,)),
                                  //Player
                                  Column(children: [
                                    // name Player
                                    Container(
                                        width: 100,
                                        child: TextField(controller: TextEditingController(text: iwPlayer.content.text),
                                          onChanged: (value){

                                            if(iwPlayer.content.text!=value)
                                            {
                                              if(!mapPlayer.keys.contains(value))
                                              {
                                                UpdateListAllPlayer(iwPlayer.content.text,value.toString());

                                                iwPlayer.content.text=value;

                                                iwPlayer.setMapElement("error",update: false);
                                              }
                                              else
                                              {
                                                // errore
                                                iwPlayer.setMapElement("error",update: true);

                                              }
                                              iwPlayer.getWe("error").setStateWello();
                                            }
                                          },)),
                                    // error name
                                    Wello(
                                      id:"error",
                                      father: iwPlayer,
                                      view: (iw){
                                        return Visibility(
                                            visible: iwPlayer.getMapElement("error")??false,
                                            child:  Text("errore stesso nome No no!",style: TextStyle(color: Color(0xB3C52828),fontSize: 8),));

                                      },) ],),
                                  // arrow
                                  IconButton(onPressed: (){
                                    iwPlayer.style.visible=!iwPlayer.style.visible;
                                    iwPlayer.setStateWello();
                                  }, icon: Icon(iwPlayer.style.visible?Icons.arrow_left:Icons.arrow_right)),
                                  // parameter
                                  Visibility(
                                      visible: iwPlayer.style.visible,
                                      child: Container(
                                        margin: EdgeInsets.only(left: 5),
                                        padding: EdgeInsets.all(5),
                                        color: Color(0x4AA6D31D),
                                        child: Column(
                                          children: [
                                            for(String keyParameter in mapProperties.keys)
                                              Row(
                                                children: [
                                                  Text(keyParameter,style: TextStyle(fontSize: 12),),
                                                  Container(
                                                      margin: EdgeInsets.only(left: 5),
                                                      width:50,
                                                      height:40,
                                                      child: TextField(
                                                        style:TextStyle(fontSize: 12),
                                                        controller: TextEditingController(text: mapPlayer[iwPlayer.content.text][keyParameter].toString()),
                                                        onChanged: (value){
                                                          UpdateParameterMap(mapPlayer, iwPlayer.content.text, keyParameter,value.toString());
                                                        },
                                                      ))
                                                ],
                                              ),

                                          ],
                                        ),
                                      ))
                                ],
                              )
                          );
                        }),

                  // bn Add
                  TextButton(onPressed: (){
                    Map mapSon={};
                    mapSon.addAll(mapProperties);
                    mapPlayer.addAll({"":mapSon});
                    iwFather.setStateWello();
                  }, child: Text("add")),
                ]
            ),
          );
        },
      );
    default:
      return Container();
  }
}

// Main

bool  enableBnAlgorithm()
{
  return GenericN.listContainListB(lPlayer,lTeamA) && GenericN.listContainListB(lPlayer,lTeamB) && lPlayer.length==lTeamA.length+lTeamB.length && lPlayer.length>0;
}

void RemoveInListAllPlayer(String key)
{
  bool fRemoveInList(List list){
    if(list.contains(key))
    {
      list.remove(key);
      return true;
    }
    return false;
  }
  bool b;

  RemoveKeyMap(mapPlayer, key);


  b=fRemoveInList(lPlayer);
  b|=fRemoveInList(lPlayerSelectable);
  b?saveMatch(lPlayer):();

}

void UpdateListAllPlayer(String oldKey,String keyUpdate)
{
  bool fUpdateList(List list){
    if(list.contains(oldKey))
    {
      int index=list.indexOf(oldKey);
      list.remove(oldKey);
      list.insert(index, keyUpdate);
      return true;
    }
    return false;
  }
  bool b;

  UpdateKeyMapPlayer(mapPlayer, oldKey, keyUpdate);


  b=fUpdateList(lPlayer);
  b|=fUpdateList(lPlayerSelectable);
  b?saveMatch(lPlayer):();

  b=fUpdateList(lTeamA);
  b|=fUpdateList(lTeamB);
  b?saveCalculated(lTeamA, lTeamB):();

  print(lTeamA);
}

Future<void> loadMain()async{
  await loadPlayer();

  await loadMatch();

  await loadCalculated();

  Wello.iwGranFather.getWe("Player").setStateWello();

}

List<List<int>> combinations(List<int> input, int size) {
  List<List<int>> result = [];

  void combine(int index, List<int> combo) {
    if (combo.length == size) {
      result.add(List<int>.from(combo));
      return;
    }
    if (index >= input.length) return;

    combo.add(input[index]);
    combine(index + 1, combo);
    combo.removeLast();
    combine(index + 1, combo);
  }

  combine(0, []);
  return result;
}

List<List<int>> findOptimalSplit(List<int> numbers) {
  int n = numbers.length;
  int half = n ~/ 2;
  double bestDifference = double.infinity;
  List<List<int>>? bestCombination;

  // Generate all combinations of half the numbers
  List<List<int>> allCombinations = combinations(numbers, half);

  // Calculate average and standard deviation for each combination
  for (List<int> combo in allCombinations) {


    List<int> group1 = combo;
    List<int> group2 = [];
    //numbers.where((num) => !group1.contains(num)).toList();

    List<int> xNumbers=[];
    xNumbers.addAll(numbers);
    for(int i in group1)
    {
      for(int i2=0;i2<xNumbers.length;i2++)
      {
        if(i==xNumbers[i2])
        {
          xNumbers.removeAt(i2);
          break;
        }
      }
    }
    group2=xNumbers;


    //numbers.where((num) => !group1.contains(num)).toList();

    double avg1 = group1.reduce((a, b) => a + b) / half;
    double avg2 = group2.reduce((a, b) => a + b) / half;

    double stdDev1 =
        sqrt(group1.map((x) => pow((x - avg1), 2)).reduce((a, b) => a + b) / half) * 0.5;
    double stdDev2 =
        sqrt(group2.map((x) => pow((x - avg2), 2)).reduce((a, b) => a + b) / half) * 0.5;

    // Calculate the difference between averages and standard deviations
    double difference = (avg1 - avg2).abs() + (stdDev1 - stdDev2).abs();

    // Update the best combination if the current one is better
    if (difference < bestDifference) {
      bestDifference = difference;
      bestCombination = [group1, group2];
    }
  }

  return bestCombination!;
}


// Player
void savePlayer(Map map){
  MemoryN.saveSharedPreferences("player", map);

}

Future<void> loadPlayer() async {
  mapPlayer=(await MemoryN.loadSharedPreferences("player") as Map?)?? {};
  // ritorna un valore e non una lista avente solo un elemento
  for(String key in mapPlayer.keys)
  {
    for(String key2 in mapPlayer[key].keys)
    {
      mapPlayer[key][key2]=mapPlayer[key][key2].first;
    }
  }

}

void UpdateKeyMapPlayer(Map map,String oldKey,String keyUpdate)
{
  map.addAll({keyUpdate:map[oldKey]});
  map.remove(oldKey);

  savePlayer(map);
}

void UpdateParameterMap(Map map,String key,String keyParameter,String value )
{
  map[key][keyParameter]=value;

  savePlayer(map);
}

void RemoveKeyMap(Map map,String key)
{
  map.remove(key);

  savePlayer(map);
}

// Match

void saveMatch(List<String> l){
  SharedPreferencesManager().setListSharedPreferences("match", l);

  Wello.iwGranFather.getWe("textCalculate").setStateWello();
}

Future<void> loadMatch() async {
  lPlayer=(await SharedPreferencesManager().getListSharedPreferences("match"))?? [];
}

void RemovelPlayer(String name){
  lPlayer.remove(name);
  lPlayerSelectable=GetPlayerSelectable();

  saveMatch(lPlayer);
}

void RemoveAllPlayer(){
  lPlayer=[];
  lPlayerSelectable=GetPlayerSelectable();

  saveMatch(lPlayer);
}

void AddPlayer(String value)
{
  lPlayerSelectable.remove(value);

  lPlayer.add(value);

  print("-------------");
  print(lPlayer);

  saveMatch(lPlayer);
}

List<String> GetPlayerSelectable(){
  List<String> l=(mapPlayer.keys.toList().cast<String>());

  for(String name in lPlayer)
  {
    l.remove(name);
  }

  if(!l.contains(""))
    l.add("");

  return l;
}

void Calculated(){
  Map mapAvg={};

  for(String key in lPlayer)
  {
    double avg;
    double somma=0;
    int nParam=mapPlayer[key].keys.length;
    for(String keyParam in mapPlayer[key].keys)
    {
      somma+= double.parse(mapPlayer[key][keyParam]);
    }
    avg=somma/nParam;
    mapAvg.addAll({key:avg});
  }

  //

  List<int> numbers =[]; //[74, 78, 86, 76, 77, 77, 77, 71, 90, 74];
  for(double value in mapAvg.values.toList())
  {
    numbers.add(value.toInt());
  }

  print(numbers);
  List<List<int>> optimalSplit = findOptimalSplit(numbers);
  print("Optimal Split: $optimalSplit");
  print("Average Split 1: ${optimalSplit[0].reduce((a, b) => a + b) / 5}");
  print("Average Split 2: ${optimalSplit[1].reduce((a, b) => a + b) / 5}");

  avgA=optimalSplit[0].reduce((a, b) => a + b) / 5;
  avgB=optimalSplit[1].reduce((a, b) => a + b) / 5;
  //

  lTeamA=[];
  for(int voto in optimalSplit[0])
  {
    for(String key in mapAvg.keys)
    {
      if(mapAvg[key].toInt()==voto)
      {
        mapAvg.remove(key);
        lTeamA.add(key);
        break;
      }
    }
  }

  lTeamB=[];
  for(int voto in optimalSplit[1])
  {
    for(String key in mapAvg.keys)
    {
      if(mapAvg[key].toInt()==voto)
      {
        mapAvg.remove(key);
        lTeamB.add(key);
        break;
      }
    }
  }


  /*
  int indexMiddle=(lPlayer.length/2).toInt();

  lTeamA=mapAvg.keys.toList().sublist(0,indexMiddle).cast<String>();
  lTeamB=mapAvg.keys.toList().sublist(indexMiddle).cast<String>();
   */


}

// Calculated

void saveCalculated(List teamA,List teamB){
  SharedPreferencesManager().setListSharedPreferences("teamA", teamA);
  SharedPreferencesManager().setListSharedPreferences("teamB", teamB);
}

Future<void> loadCalculated() async {
  lTeamA=(await SharedPreferencesManager().getListSharedPreferences("teamA"))?? [];
  lTeamB=(await SharedPreferencesManager().getListSharedPreferences("teamB"))?? [];
}

// main


Future<void> main() async {

  runApp(   MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Container(
            margin: EdgeInsets.all(100),
            padding: EdgeInsets.all(20),
            color:  Color(0x526B6565),
            child: Text(title,style: TextStyle(color: Colors.deepPurple),),
          ),
          actions: [
            //player
            Container(
              color: xColorBn==1?Color(0x223A3939):Color(0x00),
              child: TextButton(onPressed: (){
                xColorBn=1;
                title="Giocatori";
                page="Player";
                main();
              }, child: Text("Giocatori")),
            ),
            //match
            Container(
              color: xColorBn==2?Color(0x223A3939):Color(0x00),
              child: TextButton(onPressed: (){
                xColorBn=2;
                title="Partita";
                page="Match";
                main();
              }, child: Text("Partita")),
            ),
            // calculate
            Wello(
              id:"textCalculate",
              view: (iw){
                return  Container(
                  color: xColorBn==3?Color(0x223A3939):Color(0x00),
                  child: TextButton(
                      onPressed:
                      enableBnAlgorithm()?
                          (){
                        xColorBn=3;
                        title="ALGORITMO";
                        page="Calculated";
                        Calculated();
                        saveCalculated(lTeamA, lTeamB);
                        main();
                      }:null, child: Text("ALGORITMO")),
                );
              },)
          ],
        ),
        body: Body(),
      )
  )   );

  await loadMain(); // PS--> da errore in android se messo prima del runApp()

}

