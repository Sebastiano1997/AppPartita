
//import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // nel terminal-> flutter pub add shared_preferences


class MemoryN{
  static Map _mapKeyNlayer={"":["int",0]};// key:[type,nLayer]

static bool saveSharedPreferences(String key,dynamic value){
  List<String> ls;

  // + PS
  if(!_mapKeyNlayer.containsKey(key))
    {
      _mapKeyNlayer.addAll({key:[value.runtimeType,0]});
    }
  else
    {
      _mapKeyNlayer[key]=[value.runtimeType,0];
    }
  // -

  if(value is Map)
    {
      ls=_TraslateLsByMap(value,key: key);
      SharedPreferencesManager().setListSharedPreferences(key, ls);
    }
  else if(value is List)
    {
      ls=_TraslateLsByL(value,key: key);
      SharedPreferencesManager().setListSharedPreferences(key, ls);
    }

  if(key!="_mapKeyNlayer")
    {
      saveSharedPreferences("_mapKeyNlayer", _mapKeyNlayer);
    }

  return true;
}

static Future<dynamic> loadSharedPreferences(String key)
async {
  dynamic d;
  if(_mapKeyNlayer.length==1)
    {
      List<String>? lsMapKeyNlayer=await SharedPreferencesManager().getListSharedPreferences("_mapKeyNlayer");
      if(lsMapKeyNlayer!=null)
        {
          Map map=_BuildMapByLs(lsMapKeyNlayer,nLayer: 2);

          _mapKeyNlayer={};
          map.forEach((key1, value) {
            _mapKeyNlayer.addAll({key1:[ value[0],int.parse(value[1])]});
          });
        }
    }

  String? stype;
  int nLayer=0;
  List<String> ls=[];
  if(_mapKeyNlayer[key]!=null)
    {
      stype=_mapKeyNlayer[key][0].toString();
      nLayer=_mapKeyNlayer[key][1];
      ls=await SharedPreferencesManager().getListSharedPreferences(key);
    }
  print("stype=="+stype.toString());

  if(stype!=null)
    {
      if(stype.contains("Map")) //if(stype=="LinkedMap<dynamic, dynamic>") // ==Map
          {
        d=_BuildMapByLs(ls,nLayer:nLayer );
      }
      else if(stype.contains("List"))
      {
          d=_BuildLByLs(ls,nLayer:nLayer );
      }
    }

  return d;
}

  //++++++++++++++ Main
  static Map _BuildMapByLs (List<String> ls,{int nLayer=1})
  {
    Map map={};

    List<String> lsKey=_TraslateString0(ls[0]);
    ls.removeAt(0);
    int c=0;
    for (String s in ls) {
      map.addAll({lsKey[c]:_TraslateString0(s,nLayer:nLayer)});
      c++;
    }

    return map;
  }

  static List<String> _TraslateLsByMap(Map map,{String key=""})
  {
    List<String> ls0=[];

    List<String> lsKey=[];

    map.keys.forEach((key) {
      lsKey.add(key);
    });


    ls0.add(_BuildString0(lsKey,key: key)!);

    map.forEach((key1, value) {
      ls0.add(_BuildString0(value,key: key)!);
    });


    return ls0;

  }

  static List<String> _TraslateLsByL(List l,{String key=""})
  {
    List<String> ls0=[];

    l.forEach((value) {
      ls0.add(_BuildString0(value,key: key)!);
    });

    return ls0;

  }

  static List _BuildLByLs (List<String> ls,{int nLayer=1})
  {
    List l=[];

    for (String s in ls) {
      l.add(_TraslateString0(s,nLayer:nLayer));
    }

    return l;
  }


  //


  // **************** function

  // i.
  static String? _BuildString0(dynamic value,{int ascii=33,String key=""})
  {
    String s="";
    dynamic x;

    // + PS
      if(_mapKeyNlayer[key][1]<ascii-32) {
      _mapKeyNlayer[key][1]=ascii-32;
      }
      // -

    if(value is Map)
    {
      int i=0;
      for(dynamic value0 in value.values)
      {
        x= _BuildString0(value0,ascii:ascii+1,key: key);
        if(x==null)
        {
          s+=_BuildStringForMap(value,ascii:ascii);
          break;
        }
        else {
          s+="$x${value.keys.elementAt(i)} ${String.fromCharCode(ascii)} ";
        }
        i++;
      }
    }
    else if(value is List)
    {

      for(dynamic d in value)
      {
        x= _BuildString0(d,ascii:ascii+1,key: key);
        if(x==null)
        {
          s+=_BuildStringForListStr(value,ascii:ascii);
          break;
        }
        else {
          s+="$x ${String.fromCharCode(ascii)} ";
        }
      }
    }
    else
    {
      return null;
    }


    return s;
  }

 // 95%
  static dynamic _TraslateString0(String s,{int ascii=33,int nLayer=1})
  {
    List list0=[];
    Map map0={};


         List<String> lsPattern1=[];

         String pattern1=String.fromCharCode(ascii);
         String pattern2=String.fromCharCode(ascii+1);

         lsPattern1=s.split(" $pattern1 ");

         if(lsPattern1.last=="") {
           lsPattern1.removeLast();
         }


         for (String element in lsPattern1)
         {

           bool bContains=true;
           for(int i=0;i<nLayer;i++)
             {
               if(element.contains(" ${String.fromCharCode(i+33)} ")) {
                 bContains=true;
                 break;
               }
               else {
                 bContains=false;
               }
             }

           if(!bContains) {
             lsPattern1.forEach((element) {
               element=_ReplacePattern(element,maxAscii: 33+nLayer);
             });
             return lsPattern1;
           }


           List<String> lsPattern2=element.split(" $pattern2 ");


           if(lsPattern2.last!="")
           {
             // map
             String key=lsPattern2.last;
             lsPattern2.removeLast();
             String s2=lsPattern2.join(" $pattern2 ");
             Map map={key:_TraslateString0(s2,ascii: ascii+1,nLayer: nLayer)};

             map0.addAll(map);

           }
           else
           {
             // list
             dynamic d=_TraslateString0(element,ascii: ascii+1,nLayer: nLayer);
             list0.add(d);
           }
         }


    if(map0.isNotEmpty) {
      return map0;
    } else {
      return list0;
    }



  }


  //
  static String _ReplacePattern(String s,{int minAscii=33, int maxAscii=33,bool replaceReverse=false})
  {
    for(int i=minAscii;i<=maxAscii;i++)
      {
        String pattern=String.fromCharCode(i);
        if(replaceReverse)
          {
            s=s.replaceAll("$pattern$pattern", "$pattern");
          }
        else
          {
            s=s.replaceAll(pattern, "$pattern$pattern");
          }
      }
    return s;
  }


//i.
// List<String>

  static String _BuildStringForListStr(List ls, {int ascii=33})
  {
    String s="";
    String pattern=String.fromCharCode(ascii);

    ls.forEach((element) {
      element=element.toString().replaceAll(pattern, "$pattern$pattern");
      element+=" $pattern ";
      s+=element;
    });
    return s;
  }

  // Map

  static String _BuildStringForMap(Map map,{int ascii=33})
  {
    String s="";
    String pattern1=String.fromCharCode(ascii);
    String pattern2=String.fromCharCode(ascii+1);

    map.forEach((key, value) {
      key=(key as String).replaceAll(pattern1, "$pattern1$pattern1");
      value=(value as String).replaceAll(pattern1, "$pattern1$pattern1");
      key=(key).replaceAll(pattern2, "$pattern2$pattern2");
      value=(value).replaceAll(pattern2, "$pattern2$pattern2");

      s+="$value $pattern2 $key $pattern1 ";
    });
    return s;
  }



}

class SharedPreferencesManager{
  List<String> lsKey=[];
  Object? x;
   late SharedPreferences sharedPreferences;



  void setSharedPreferences(String key,dynamic value)async{ // lo modifica
    sharedPreferences = await SharedPreferences.getInstance();
    await   sharedPreferences.setString(key, value.toString());

    if(!lsKey.contains(key)) {
      lsKey.add(key);
    }


  }

  void setListSharedPreferences(String key,dynamic value)async{ // lo modifica
    sharedPreferences = await SharedPreferences.getInstance();
    await   sharedPreferences.setStringList(key, value);

    if(!lsKey.contains(key)) {
      lsKey.add(key);
    }

  }


  Future<dynamic> getSharedPreferences(String? key)async{ // lo fa vedere tramite x
    sharedPreferences = await SharedPreferences.getInstance();

    if(!(key==null))
    {
      if(sharedPreferences.containsKey(key!)) {
        x = sharedPreferences.getString(key);
        return x;
      }
    }


    x=null;
    return x;

  }

  Future<dynamic> getListSharedPreferences(String? key)async{ // lo fa vedere tramite x
    sharedPreferences = await SharedPreferences.getInstance();

    if(!(key==null))
    {
      if(sharedPreferences.containsKey(key!)) {
        x = sharedPreferences.getStringList(key);
        return x;
      }
    }


    x=null;
    return x;

  }


  void clear()
  {
    sharedPreferences.clear();
  }

}

class GenericN{

  static dynamic mapDynamicStruct(List lKey,Map mapValue,{dynamic value}){

        dynamic fLoop(Map map){

          dynamic element;

          dynamic elementOfLastKeyContain;

          for(String key in map.keys)
          {
            if(lKey.contains(key))
            {
              elementOfLastKeyContain=map[key];
              lKey.remove(key);
              if(lKey.length==0) {
                if(value!=null) {
                  map[key]=value;
                }
                element= map[key];
                break;
              } else
              {
                if(map[key] is Map ) {
                  element= fLoop(map[key]);
                  break;
                }
              }
            }
          }

          if(element==null)
          {
            // se non hanno una parentela diretta
            for(String key in map.keys)
            {
              if(map[key] is Map) {
                element=fLoop(map[key]);
              }

              if(element!=null)
              {
                break;
              }
            }

            // se eventualmente non contiene tutti le key (almeno qualcuna)
            if(elementOfLastKeyContain!=null) {
              element=elementOfLastKeyContain;
            }
          }

          return element;
        }

        return fLoop(mapValue);

  }

  static  dynamic toStringStruct(dynamic struct)
  {
   if(struct is List)
     {
       List l=[];
       for(dynamic value in struct)
         {
           l.add(toStringStruct(value));
         }
       struct=l;
     }
   else if(struct is Map)
     {
       Map m={};
       for(dynamic key in struct.keys)
       {
         m.addAll({key.toString():toStringStruct(struct[key])});
       }
       struct=m;
     }
   else
     {
       return struct.toString();
     }


    return struct;
  }

// +
// verify if the word contain at least one and all and not contain word of the lists, if else return null
  static String? ValueFilter(String word , List lAtLeastOneContain, List lNotContain,{List? lMostContain})
  {
    String sWord=word;
    bool bVerify=true;

    // if the word contain all word of list
    if(bVerify)
    {
      if(lMostContain!=null)
      {
        for(String contain in lMostContain)
        {
          if( !sWord.contains(contain))
          {
            bVerify=false;
            break;
          }
          else {
            sWord=sWord.substring(0,sWord.indexOf(contain));
          }

        }
      }
    }

    // if the word contain at least one word of list
    if(bVerify)
    {
      sWord=word;
      for(String contain in lAtLeastOneContain)
      {
        if( !sWord.contains(contain))
        {


        }
        else {
          sWord=sWord.substring(0,sWord.indexOf(contain));
        }

      }
    }

    // if word NotContain in the list
    if(bVerify)
    {
      sWord=word;
      for(String notContain in lNotContain)
      {
        if( sWord.contains(notContain))
        {
          bVerify=false;
          break;
        }
      }

    }


    if(bVerify) {
      return word;
    } else {
      return null;
    }

  }

// -

static bool listContainListB(List list, List listB)
{
  bool b=true;

  for(dynamic d in listB)
    {
      if(!list.contains(d))
        {
          b=false;
          break;
        }
    }

  return b;

}

}


// +
// verify if the text has the letter of the sequence (lSequence) ( by right at left)
class Sequence{

  static const String Word="<String>";
  static const String  Num="<int>";
  static const String NumWord="<int,String>";
  static const String sign="<sign>";
  static const String Sign="<Sign>";
  static const String SpaceTab="<Space,Tab>";

  static const String Orsymbol=",,";

  static int _FindType(String symbolSequence,String word, int count,int sum){
    int cCount=  count;

    switch(symbolSequence) {
      case Word:
        while((sum==-1?cCount>=0:cCount<word.length) &&  word.toLowerCase()[cCount].codeUnits[0]>=97 && word.toLowerCase()[cCount].codeUnits[0]<=122)
        {
          cCount=cCount+sum;
        }
        break;
      case Num :
        while((sum==-1?cCount>=0:cCount<word.length) && word[cCount].codeUnits[0]>=48 && word[cCount].codeUnits[0]<=57)
        {
          cCount=cCount+sum;
        }
          break;
      case NumWord:
        while((sum==-1?cCount>=0:cCount<word.length) &&  (_FindType(Num,word,cCount,sum)>=0 ||  _FindType( Word, word,cCount,sum)>=0   )  )
        {
          cCount=cCount+sum;
        }
        break;
      case sign:
        String letter=word [count];
        if( (letter.codeUnits[0]>=33 && letter.codeUnits[0]<=47) || (letter.codeUnits[0]>=58 && letter.codeUnits[0]<=64) )
        {
          cCount=cCount+sum;
        }
        else {
          cCount=-1;
        }
        break;
      case Sign:
        while ((sum==-1?cCount>=0:cCount<word.length) && ( (word[cCount].codeUnits[0]>=33 && word[cCount].codeUnits[0]<=47) || (word[cCount].codeUnits[0]>=58 && word[cCount].codeUnits[0]<=64) ))
        {
          cCount=cCount+sum;
        }
        break;
      case SpaceTab:
        while((sum==-1?cCount>=0:cCount<word.length) && (word[cCount].codeUnits[0]==32 || word[cCount].codeUnits[0]==9))
        {
          cCount=cCount+sum;
        }
        break;
    }

    if(  cCount!= count && cCount>=-1 && cCount<=word.length ) {
      cCount=cCount-sum;
    } else {
      cCount=-1;
    }

    return cCount;
  }

  static bool _ContainKeyType(String symbolSequence){
    bool b=true;

    switch(symbolSequence) {
      case Word:
        break;
      case Num :
        break;
      case NumWord:
        break;
      case sign:
        break;
      case Sign:
        break;
      case SpaceTab:
        break;
      default:
        b=false;
        break;
    }

    return b;
  }

  static List SequenceSymbol(String text,List lSequence,{bool isDirectionOfLast=true}){

    bool b=true;
    List lText=[];

    int length=lSequence.length-1;
    int iText=text.length-1;
    int sum=-1;

    if(!isDirectionOfLast)
    {
      sum=1;
      length=0;
      iText=0;
    }
    // -

    // + for list Symbol Sequence
    for(int iSequence=length; (b && (isDirectionOfLast?iSequence>=0:iSequence<lSequence.length) );iSequence=iSequence+sum)
    {
      int iTextOld=0;
        // + OrSymbol

        bool isOrSymbolOk=true;
        if( lSequence[iSequence].contains(Orsymbol) ){
          List lTextInOrSymbol=[];
          List lSequenceInOrSymbol=[];
          String textInOrSymbol="";
          List  lWordOr= lSequence[iSequence].split(Orsymbol);

          isOrSymbolOk=false;
          for(String wordOr in  lWordOr){
            if(text.length>iText && iText!=-1){
              if((isSequenceSymbol(text[iText],[wordOr] ) || wordOr=="")){
                lSequence[iSequence]=wordOr;

                int iSubStartSequence=0;
                int iSubStartText=0;
                int iSubEndSequence=iSequence+1;
                int iSubEndText=iText+1;
                if(!isDirectionOfLast)
                {
                  iSubStartSequence=iSequence;
                  iSubStartText=iText;
                  iSubEndSequence=lSequence.length;
                  iSubEndText=text.length;
                }
                lSequenceInOrSymbol=lSequence.sublist(iSubStartSequence,iSubEndSequence); // #n
                textInOrSymbol=text.substring(iSubStartText,iSubEndText); //#n
                lTextInOrSymbol=SequenceSymbol(textInOrSymbol, lSequenceInOrSymbol,isDirectionOfLast: isDirectionOfLast);


                if(lTextInOrSymbol.isNotEmpty)
                {
                  isOrSymbolOk=true;
                  break;

                }
              }

            }
          }

          if(isOrSymbolOk) {
            lText.addAll(lTextInOrSymbol);
          }
          else
            {
              b=false;
            }

          break;
        }

        // -

        if(iText<text.length && iText>=0){
          if(text[iText]!=lSequence[iSequence])
          {
            if(!_ContainKeyType(lSequence[iSequence]) && !lSequence[iSequence].contains(Orsymbol) && lSequence[iSequence]!="")
            {
              b=false;
            }
            else {
              //print("iText=="+iText.toString()+"   lSequence=="+lSequence.toString());

              iTextOld=iText;
              if(lSequence[iSequence]!="")
              {
                if(_ContainKeyType(lSequence[iSequence]))
                {
                  iText=_FindType(lSequence[iSequence],text,iText,sum);

                }else if(text[iText]==lSequence[iSequence])
                {

                }else
                {
                  b=false;
                }


                if(iText<=-1) {
                  b=false;
                }
                else if(b){
                  if(iTextOld>iText)
                  {
                    lText.add(text.substring(iText, iTextOld+1));
                  }
                  else
                  {
                    lText.add(text.substring(iTextOld,iText+1));
                  }
                }
              }
              else
              {
                if(iText>=0)
                  {
                    iText=iText-sum;
                    lText.add("");
                  }
              }
            }

          }
          else
          {
            // continue
            lText.add(text[iText]);
          }
        }
        else {
          b=false;
        }



      iText=iText+sum;
    }
    // -


      if(b)
        {
          if(isDirectionOfLast)
            {
              lText=lText.reversed.toList();
            }

          return lText;
        }else{
        return [];
      }
  }

  static bool isSequenceSymbol(String text,List lSequence,{bool isDirectionOfLast=true})
  {
    bool b=false;

    if(SequenceSymbol(text, lSequence,isDirectionOfLast: isDirectionOfLast).isNotEmpty) {
      b=true;
    }

    return b;

  }


}

// -

class TextEditingControllerN extends TextEditingController{
  TextEditingControllerN();

  TextEditingController _textEditingController=TextEditingController();

  _PropertieMultiLineTextField? _propertieMultiLineTextField=null;
  _PropertieMultiLineTextField get propertieMultiLineTextField{

    if(_propertieMultiLineTextField==null) {
      _propertieMultiLineTextField=_PropertieMultiLineTextField(text: text,selection: selection);
      return _propertieMultiLineTextField!;
    } else {
      _propertieMultiLineTextField!.text=text;
      _propertieMultiLineTextField!.selection=selection;
      return _propertieMultiLineTextField!;
    }
  }
  @override
  TextEditingController builder(BuildContext context)
  {
    return _textEditingController;
  }
}

class _PropertieMultiLineTextField{
  _PropertieMultiLineTextField({required  this.text,required this.selection});

  String text;
  TextSelection? selection;

  String? _text;
  TextSelection? _selection;

  // propertie

  String _row="";
  String _wordAfter="";
  String _wordBefore="";
  String _wordInside="";
  int _nRow=0;
  int _nRowSelectioned=0;
  int _nColumnSelectioned=0;
  String _textBeforeWord="";
  String _textAfterWord="";

  String get row{
    _Propertie(text,selection);
    return _row;
  }

  String get wordAfter{
    _Propertie(text,selection);
    return _wordAfter;
  }

  String get wordBefore{
    _Propertie(text,selection);
    return _wordBefore;
  }

  String get wordInside{
    _Propertie(text,selection);
    return _wordInside;
  }

  String get textBeforeWord{
    _Propertie(text,selection);
    return _textBeforeWord;
  }

  String get textAfterWord{
    _Propertie(text,selection);
    return _textAfterWord;
  }

  int get nRow{
    _Propertie(text,selection);
    return _nRow;
  }

  int get nRowSelectioned{
    _Propertie(text,selection);
    return _nRowSelectioned;
  }

  int get nColumnSelectioned{
    _Propertie(text,selection);
    return _nColumnSelectioned;
  }

  void _Propertie(String text,TextSelection? selection){

        if(selection!=null && (_text!=text || _selection!=selection) )
        {
          _text=text;
          _selection=selection;

          List lRow=text.split("\n");
          int nRow=0;
          int lengthAllRowUntilElement=0;
          String rowFind="";
          int lengthRowElement=0;

          for(String rowElement in lRow)
          {
            nRow++;

            if(nRow==lRow.length) {
              lengthAllRowUntilElement+=rowElement.length;
            } else {
              lengthAllRowUntilElement+=rowElement.length+1;
            }

            if(lengthAllRowUntilElement>=selection.baseOffset)
            {
              lengthRowElement=rowElement.length;
              if(nRow!=lRow.length) {
                lengthRowElement++;
              }

              rowFind=rowElement;
              break;
            }
          }
          _nRowSelectioned=nRow;

          _row=rowFind;


          List lWord=_row.split(" ");

          int xlengthRow=0;
          int baseOffsetRow=lengthRowElement - ( lengthAllRowUntilElement- (selection.baseOffset) );
          //int baseOffsetRow=lengthRowElement - ( lengthAllRowUntilElement- (selection.baseOffset+1) );
          _nColumnSelectioned=baseOffsetRow;
          for(String wordElement in lWord)
          {
            selection.baseOffset;
            xlengthRow+=wordElement.length+1;

            if(xlengthRow>=baseOffsetRow )
            {
              _wordInside=wordElement;
              if(xlengthRow>baseOffsetRow) {
                    _wordAfter=_row.substring(baseOffsetRow,xlengthRow-1);
              } else {
                _wordAfter="";
              }

              String before=_row.substring(0,baseOffsetRow);
              int findSpace=before.lastIndexOf(" ")==-1?0:before.lastIndexOf(" ");

              if(baseOffsetRow!=0 && baseOffsetRow> findSpace ) {
                _wordBefore=_row.substring(findSpace,baseOffsetRow);
              } else {
                _wordBefore="";
              }

              break;
            }
          }


          if(selection.baseOffset-_wordBefore.length>0) {
            _textBeforeWord=text.substring(0,selection.baseOffset-_wordBefore.length);
          }else
            {
              _textBeforeWord="";
            }

          _textAfterWord=text.substring(selection.baseOffset+_wordAfter.length);


          _nRow=lRow.length;
        }
    }

}
