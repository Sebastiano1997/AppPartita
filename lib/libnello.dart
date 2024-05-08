library libnello;

import 'package:flutter/material.dart';

//*******variabili

//*******funzioni

//************ classi

// < IW >

class Wello extends StatefulWidget{
  Wello({super.key, required Widget Function(Wello) this.view, this.id, this.father,Function(Wello)? this.builder});

  // static
  static Wello iwGranFather=Wello(view: (iw){
    return Container();
  },);

  // --------------request and setting
  Widget? child;
  Function setStateWello=(){};
  Function(Wello)? builder;
  Function view;
  String? id;
  Wello? father;

  bool _bCallBuilder=false;

  // --------------use
  BuildContext? context;
  Style style=Style();
  Content content=Content();

  // -------------properties

  Map<String,Wello> _childInThe={};

  Wello childInThe([ dynamic key,Wello? iwChild ]){

    key=key??"";
    key=key.toString();

    if(!_childInThe.containsKey(key))
    {
      _childInThe.addAll({key: iwChild??Wello(view: (iw){return Container();},)});
    }

    return _childInThe[key]!;
  }

  Map<String,ChildrenWello> _childrenInThe={};

  ChildrenWello childrenInThe([ dynamic key,ChildrenWello? iwChildren ]){

    key=key??"";
    key=key.toString();

    if(!_childrenInThe.containsKey(key))
    {
      if(iwChildren==null)
      {
        ChildrenWello childrenIW0=ChildrenWello(child: Wello(view: (iw){return Container();},), builder: (childrenIW0){});
        iwChildren=childrenIW0;
      }

      _childrenInThe.addAll({key: iwChildren});
    }

    return _childrenInThe[key]!;
  }

  dynamic childrenParameter;


  // ---------------- other function

  List<Wello> _listWeChildren=[];
  List<Map> _listMap=[]; // map generica usate

  List<String> _listID=[]; // lista dei tag dei iw figli
  List<String> get listID{
    return _listID;
  }

  Map<String,List<Wello>> mapReview={}; // map per fare la review di più iw per argomento


  // ---------------funzioni

  Wello getWe(String? id)
  {
    Wello? iw;
    if(getListWe(id,bFirst: true).isNotEmpty) {
      iw=getListWe(id,bFirst: true).first;
    } else {
      iw=null;
    }

    if(iw==null)
    {
      print("Errore getw==null");
      return Wello(view:(iw){return Container();},father: null);
    }
    else
    {
      return iw;
    }
  }

  List<Wello> getListWe(String? id,{bool bFirst=false})
  {
    List<Wello> xliw=[];

    for(int i=0;i<_listWeChildren.length;i++)
    {
      if(_listWeChildren[i].id==id)
      {
        xliw.add(_listWeChildren[i]);
        if(bFirst) {
          return xliw;
        }
      }
      else
      {
        _cerca(id,_listWeChildren[i]._listWeChildren, xliw,bFirst);
      }
    }

    return xliw;
  }

  void _cerca(String? clas,List<Wello> kliw,List<Wello> xliw,bool bFirst) {
    for (int i = 0; i < kliw.length; i++)
    {
      if (kliw[i].id == clas)
      {
        xliw.add(kliw[i]);

        if(bFirst) {
          break;
        }
      }
      else
      {
        _cerca(clas,kliw[i]._listWeChildren, xliw,bFirst);
      }
    }
  }

  // map

  T? getMapElement<T>(String key,{bool index_value =false})
  {
    List<Map<dynamic,dynamic>> lm=_listMap;
    for(int i=0;lm.length>i;i++)
    {
      if(lm[i].keys.first==key) {

        if(index_value) {
          return i as T?;
        }

        return lm[i].values.first ;

      }
    }
    return null;
  }

  T? setMapElement<T>(String key,{ dynamic update,double updateSum=0,bool bIsetState=false})
  {
    List<Map<dynamic,dynamic>> lm=_listMap;
    Function fBisetstate=(){ if(bIsetState) {setStateWello();}};

    for(int i=0;lm.length>i;i++)
    {
      if(lm[i].keys.contains(key)) {

        if(updateSum!=0)
        {
          lm[i][key]=(lm[i][key]+updateSum);
          fBisetstate();
          return lm[i][key] ;
        }

        if(true) // update
            {
          lm[i][key]=update ;
          fBisetstate();
          return  true as T?;
        }

      }
    }

    if(updateSum==0) // se ci serve l'update
        {
      lm.add({key:update as T});
      fBisetstate();
      return  true as T?;
    }
    return null;
  }

  // review

  T getReview<T>(T valueReturn,String key)
  {
    Wello iw=this;
    if(mapReview[key] !=null)
    {
      mapReview[key]!.contains(iw)?() : mapReview[key]!.add(iw);
    }
    else{
      List<Wello> liw1=[iw];
      mapReview[key]=liw1;
    }
    return valueReturn;
  }

  void setReview(String key,Function set)
  {
    set();

    if(mapReview[key] !=null)
    {
      mapReview[key]!.forEach((element) {
        element.setStateWello();
      });
    }


  }

  //

  void printListKey({String word=""})
  {
    List<String> lsClassCut=[];
    if(word!="")
    {
      word=word.toUpperCase();
      for(String value in _listID)
      {
        String valueUpper=value.toUpperCase();
        if(valueUpper.contains(word) || word.contains(valueUpper)) {
          lsClassCut.add(value);
        }
      }}else {
      lsClassCut=_listID;
    }
    print("lsClas==$lsClassCut");
  }

  // create state
  @override
  _Wello createState() => _Wello();

}

class _Wello extends State<Wello> {


  // function

  void mainState(){

    if(widget.builder!=null) {
      widget.builder!(widget);
    }


    widget.father=widget.father??Wello.iwGranFather;

    widget.father!._listWeChildren.add(widget);

    if(widget.id!=null && !widget.father!.listID.contains(widget.id))
      {
        widget.father!.listID.add(widget.id!);
      }
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //mainState();
  }

  @override
  void initState() {
    super.initState();
    // Il widget è stato inserito nell'albero widget

  }


  @override
  Widget build(BuildContext context) {
    if(!widget._bCallBuilder )
      {
        mainState();
        widget._bCallBuilder=true;
      }

    widget.child=widget.view(widget);
    widget.setStateWello=({bool bChildren=false}){
      if(mounted) {
        if(bChildren)
          {
            for(Wello iw in widget._listWeChildren)
              {
                iw.setStateWello(bChildren:bChildren);
              }
          }

        setState(() {});
      }
    };
    widget.context=context;

    return widget.child!;
  }

}

// </ IW >

class ChildrenWello{
    ChildrenWello({
      required Wello this.child,
      required void Function(ChildrenWello) this.builder,
    }){
  builder(this);
  }

  Wello child;
  Function builder;

  List<Wello> children=[];

  void build(){
    builder(this);
  }

  void add([dynamic parameter])
  {
    Wello iw=Wello(view: (iw){
      return Container();
    },);
    iw.childrenParameter=parameter;
    iw.view=child.view;
    iw.builder=child.builder;

      children.add(
        iw
      );
  }


}

class Style{
  bool visible=false;

  int color=0;
  int background=0;
}

class Content{
  String text="";
  int count=0;
  int index=0;
  double size=0.0;
}

//-------





// _____________________________________________________________
//* WidgetN


class N_ChooseColor extends StatelessWidget {
  N_ChooseColor({Function(Color)? this.OnChageValue, Color? this.ColorDefault});


  Function(Color)? OnChageValue;
  Color? ColorDefault;

  Map map = {};

  @override
  Widget build(BuildContext context) {
    Color color = ColorDefault ?? Color.fromARGB(100, 255, 0, 0);

    for (String l in ['a', 'r', 'g', 'b']) {
      switch (l) {
        case 'a':
          {
            map[l] = color.alpha as double;
            map[l + "active"] = Colors.white60;
          }
        case 'r':
          {
            map[l] = color.red as double;
            map[l + "active"] = Colors.red;
          }
        case 'g':
          {
            map[l] = color.green as double;
            map[l + "active"] = Colors.green;
          }
        case 'b':
          {
            map[l] = color.blue as double;
            map[l + "active"] = Colors.blue;
          }
      }
    }


    return Wello(
      view: (iw1){
        return Column(
      children: [
        Container(color: color, height: 10,),
        Column(
          children: [
            for(String l in ['a', 'r', 'g', 'b'])
            Slider(
                  label: map[l].toString(),
                  divisions: 255,
                  max: 255,
                  min: 0,
                  value: map[l],
                  activeColor: map[l + "active"],
                  onChanged: (d) {
                    map[l] = d;

                  switch (l){
                       case 'a':
                      {
                      color=color.withAlpha(d.round());
                      }
                      case 'r':
                      {
                      color=color.withRed(d.round());
                      }
                      case 'g':
                      {
                      color=color.withGreen(d.round());
                      }
                      case 'b':
                      {
                      color=color.withBlue(d.round());
                      }
                    }

                    if(OnChageValue!=null) {
                      OnChageValue!(color);
                    }

                    iw1.setStateWello();


                  }),
          ],
        ),
      ],
    );
      },);
  }
}

class RowEllo extends StatelessWidget {
  RowEllo({required this.children, this.contextFather});

  List<ElementRowEllo> children;
  BuildContext? contextFather;

  @override
  Widget build(BuildContext context) {

    return Wello(
      id: "we",
      view: (iw1){
        double width;

        if(!iw1.style.visible)
        width=MediaQuery.of(context).size.width;
        else
        width=contextFather!.size!.width;

        double widthTotP0=0;
        double priorityTot=0;
        double count0=0;
        double section;

        for( ElementRowEllo row in children)
        {
          if(row.priority==0)
          {
            count0++;
            widthTotP0+= width/children.length;
          }
          priorityTot+=row.priority;

        }

        if(priorityTot!=0)
          {
            section= (width - widthTotP0)/ priorityTot;
          }
        else
          {
            section=width/count0;

          }

        if(count0!=0)
        {
          for( ElementRowEllo row in children)
          {
            if(row.priority==0)
            {
              row.priority= (widthTotP0)/ ( count0*section);
            }
          }
        }



        return Row(
          children: [
            for(ElementRowEllo row in children)
              Container(
                width:  section*row.priority,
                child: row.child,),
          ],
        );
      },);
  }
}

class ElementRowEllo {
  ElementRowEllo({required this.child, this.priority=0});

  Widget child;
  double priority;
}
// ----------------


class libN {


}





