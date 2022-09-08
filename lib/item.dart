import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
// ignore: must_be_immutable
class item extends StatefulWidget {
  item({Key? key, required this.screen,current,required this.withSettings,required this.state,required this.onRoute,required this.offRoute,required this.name, required this.description,required this.index,required this.day1,required this.day2,required this.day3,required this.day4,required this.day5,required this.day6,required this.day7,required this.season,required this.fromHour,required this.fromMin,required this.toHour,required this.toMin})
      : super(key: key);
  String description = "This is a description of the this zone ";
  VoidCallback screen = () {};
  int day1=0;
  int day2=0;
  int day3=0;
  int day4=0;
  int day5=0;
  int day6=0;
  int day7=0;
  String season="summer";
  int fromHour=0;
  int fromMin=0;
  int toHour=0;
  int toMin=0;
  String state="off";
  String name="";
  String onRoute="";
  String offRoute="aa";
  bool withSettings=true;
  int current=0;

  int index;

  @override
  _itemState createState() => _itemState();
}

class _itemState extends State<item> {
  Future sendDescription(String desc,int i,bool withh) async{
 var url;
 if(withh==true){
 url="http://192.168.4.1/description?index="+i.toString()+"&desc="+desc+"&with="+"with";

 }else{
 url="http://192.168.4.1/description?index="+i.toString()+"&desc="+desc+"&with="+"withNo";

 }
 var res =  await http.get(Uri.parse(url));
 var x=json.decode(res.body);
 setState(() {
 
widget.description=desc;
   
   
 });
 print("hhhhhhhhhhhhhhhhhhhhhhhhh");
 print(res.body);

}
  Future<void> _handleClickMe() async {
    return showDialog<void>(
      context: context,

      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Modifying '),
          content: Column(
            children: [
              Text('Please enter the name of the field '),
              Material(
                color: Colors.transparent,
                child: TextField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    fillColor: Colors.orange,
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 2.0),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    isDense: true,
                  ),
                  cursorColor: Colors.green,
                  style: TextStyle(
                    color: Colors.green,
                  ),
                  onSubmitted: (String s) {
                    setState(() {
                      //widget.description = s;
                    });
                  },
                  onChanged: (String s) {
                    setState(() {
                      tempDescription = s;
                    });
                  },
                ),
              ),
            ],
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text(
                'Okay',
                style: TextStyle(color: Colors.orange),
              ),
              onPressed: () {
                setState(() {
                      sendDescription(tempDescription,widget.index,widget.withSettings);

                  //widget.description = tempDescription;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String tempDescription = "This is a description of this zone";
  String onoff = "OFF";
  Color colorOnOff = Colors.red;
  @override
  Widget build(BuildContext context) {
    var largeur = MediaQuery.of(context).size.width;
    // var longeur = MediaQuery.of(context).size.height;

Future lightON() async{
 var url;
 url="http://192.168.4.1/"+widget.onRoute;
 var res =  await http.get(Uri.parse(url));
 var x=json.decode(res.body);
 setState(() {
   widget.state=x["state"];
 });
 print(res.body);

}

Future lightOFF() async{
  var url;
  print(widget.onRoute);
  print(widget.day1);

 url="http://192.168.4.1/"+widget.offRoute;
 print(url);
 var res =  await http.get(Uri.parse(url));
 print(res.body);
 var x=json.decode(res.body);

  setState(() {
   widget.state=x["state"];
 });
 print(res.body);
}

    return Card(
      color: Colors.white,
      margin: EdgeInsets.only(
          left: largeur / 30,
          right: largeur / 30,
          bottom: largeur / 50,
          top: largeur / 50),
      // elevation: 40,
      child: Container(
        // padding: EdgeInsets.all(longeur / 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            widget.withSettings==true? Flexible(
                fit: FlexFit.tight,
                flex: 2,
                child: IconButton(
                  icon: Icon(
                    Icons.settings,
                    color: Colors.green[800],
                  ),
                  iconSize: largeur / 6,
                  onPressed: (){
print("aa");
                    widget.current=1;
                    widget.screen();
print("bb");

                  },
                )):
                Flexible(
                fit: FlexFit.tight,
                flex: 2,
                child: IconButton(
                  icon: Icon(
                    Icons.water_drop_outlined,
                    color: Colors.green[800],
                  ),
                  iconSize: largeur / 6,
                  onPressed: (){},
                )),
            Flexible(
              fit: FlexFit.tight,
              flex: 4,
              child: Container(
                // margin: EdgeInsets.only(left: largeur / 70, right: largeur / 70),
                child: GestureDetector(
                  onLongPress: () {
                    _handleClickMe();
                  },
                  child: Text(
                    widget.description,
                    style: GoogleFonts.aBeeZee(
                      textStyle: Theme.of(context).textTheme.headline4,
                      fontSize: largeur / 30,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            Flexible(
              fit: FlexFit.tight,
              flex: 2,
              child: Container(
                margin: EdgeInsets.only(right: largeur / 50),
                child: ElevatedButton(
                  child: Text(
                    widget.state,

                    style: TextStyle(
                        fontSize: largeur / 20, fontWeight: FontWeight.bold),
                    // style: GoogleFonts.anton(
                    //   textStyle: Theme.of(context).textTheme.headline4,
                    //   fontWeight: FontWeight.w600,
                    //   color: Colors.white,
                    //   letterSpacing: largeur / 70,
                    //   fontSize: longeur / 25,
                    // )),
                  ),
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(largeur / 4, largeur / 8),
                      primary: widget.state=="on"?Colors.green:Colors.red,
                      shadowColor: Colors.grey,
                      animationDuration: Duration(seconds: 3),
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      )),
                  onPressed: () {
                    setState(() {
                      if (widget.state.compareTo("on") == 0) {
                        onoff = "Off";
                       
                        lightON();
                      } else {
                        onoff = "on";
                       
                        lightOFF();
                        

                      }
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

