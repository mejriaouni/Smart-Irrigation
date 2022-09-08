import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:developer' as dev;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:showcaseview/showcaseview.dart';
// import 'package:progress_state_button/iconed_button.dart';
import 'item.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:system_settings/system_settings.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Irrigation',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.green,
      ),
      home: ShowCaseWidget(onComplete: (index,key){
        
       
      },builder:Builder(builder: (_)=>MyHomePage(title: "Smart Irrigation")) ),      
    );
  }
}



class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late SharedPreferences shared;
 final keyWifi = GlobalKey();
 final keySwitch = GlobalKey();

 final keyDrawer = GlobalKey();
 final keyRefresh= GlobalKey();

 final keyAct1= GlobalKey();
 final keyAct2= GlobalKey();

 final keyAct3= GlobalKey();
 final keyAct4= GlobalKey();

 final keyMission= GlobalKey();
 final keySetting= GlobalKey();

 final keyTime= GlobalKey();
 final keyDays= GlobalKey();
 final keySeason= GlobalKey();
 final keySequence= GlobalKey();






  int screen = 1;
  int GlobalIndex = 1;
  String GlobalState = "off";
 bool missionScreen=false;



  void switchScreen() {
    setState(() {
      if (switchValue) {

        for (var i = 0; i < itemsSettings.length; i++) {

          // print(itemsSettings[i].current);

          if (itemsSettings[i].current == 1) {
            GlobalIndex = itemsSettings[i].index;
            GlobalState = itemsSettings[i].state;
            _timefrom = TimeOfDay(
                hour: itemsSettings[i].fromHour,
                minute: itemsSettings[i].fromMin);
      print("aaa");

            _timeto = TimeOfDay(
                hour: itemsSettings[i].toHour, minute: itemsSettings[i].toMin);
            print(_timefrom);
            print(_timeto);

            season = itemsSettings[i].season;
            print(season);

            List<String> newdays = [];
            if (itemsSettings[i].day1 == 1) {
              newdays.add("Sunday");
            }
            if (itemsSettings[i].day2 == 1) {
              newdays.add("Monday");
            }
            if (itemsSettings[i].day3 == 1) {
              newdays.add("Tuesday");

            }

            if (itemsSettings[i].day4 == 1) {
              newdays.add("Wednesday");
            }
            if (itemsSettings[i].day5 == 1) {
              newdays.add("Thursday");
            }
            if (itemsSettings[i].day6 == 1) {
              newdays.add("Friday");
            }
            if (itemsSettings[i].day7 == 1) {
              newdays.add("Saturday");
            }
            days = newdays;
print(days);
            break;
          }
        }
        for (var i = 0; i < itemsSettings.length; i++) {
          itemsSettings[i].current = 0;
        }
        screen = 2;
      } else {
        
        _handleClickMe();
      }
    });
    print(GlobalIndex);
  }

  TimeOfDay _timefrom = TimeOfDay.now().replacing(minute: 30);
  void onTimeChanged(TimeOfDay neww) {
    setState(() {
      _timefrom = neww;
    });
  }

  TimeOfDay _timeto = TimeOfDay.now().replacing(minute: 30);
  void onTimeChanged2(TimeOfDay neww) {
    setState(() {
      _timeto = neww;
    });
  }

  var selecteddays;
  bool switchValue = false;
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  String season = "summer";
  bool sequence = false;
  Future<void> _handleClickMe() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Information '),
          content: Column(
            children: [
              Text('You shoud activate the switch of the auto mode !'),
              CupertinoSwitch(
                value: false,
                onChanged: null,
                trackColor: Colors.red,
              )
            ],
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future getInit() async {
    var url = 'http://192.168.4.1/getInit';
    var res = await http.get(Uri.parse(url));
    print(res.body);
    var x = json.decode(res.body);
    List<dynamic> actionneurs = x["Actionneurs"];
    print(x["number"]);
    List<item> newItems = [];

    for (int i = 0; i < actionneurs.length; i++) {
      newItems.add(item(
          day1: 0,
          day2: 0,
          day3: 0,
          day4: 0,
          day5: 0,
          day6: 0,
          day7: 0,
          fromHour: 0,
          fromMin: 0,
          season: "summer",
          toHour: 0,
          toMin: 0,
          withSettings: false,
          screen: () {
            switchScreen();
          },
          description: actionneurs[i]["description"],
          name: actionneurs[i]["name"],
          state: actionneurs[i]["state"],
          index: i,
          onRoute: actionneurs[i]["onRoute"],
          offRoute: actionneurs[i]["offRoute"]));
      print(actionneurs[i]["name"]);
      print(actionneurs[i]["description"]);
      print(actionneurs[i]["state"]);
      print(actionneurs[i]["onRoute"]);
      print(actionneurs[i]["offRoute"]);
    }
    setState(() {
      items = newItems;
    });

    //print(res.body);
  }

  Future getMissions() async {
    var url = 'http://192.168.4.1/missions';
    var res = await http.get(Uri.parse(url));
    print(res.body);
    var x = json.decode(res.body);
    List<dynamic> missions = x["Missions"];
    print(x["number"]);
    List<item> newItems = [];

    for (int i = 0; i < missions.length; i++) {
      newItems.add(item(
        withSettings: true,
        screen: () {
          switchScreen();
        },
        description: missions[i]["description"],
        name: missions[i]["name"],
        state: missions[i]["state"],
        index: missions[i]["index"],
        onRoute: missions[i]["onRoute"],
        offRoute: missions[i]["offRoute"],
        day1: missions[i]["day1"],
        day2: missions[i]["day2"],
        day3: missions[i]["day3"],
        day4: missions[i]["day4"],
        day5: missions[i]["day5"],
        day6: missions[i]["day6"],
        day7: missions[i]["day7"],
        fromHour: missions[i]["fromHour"],
        fromMin: missions[i]["fromMin"],
        toHour: missions[i]["toHour"],
        toMin: missions[i]["toMin"],
        season: missions[i]["season"],
      ));
    }
    setState(() {
      itemsSettings = newItems;
      print(itemsSettings[0].offRoute.toString());
    });

    //print(res.body);
  }

  Future sendMission() async {
    int day1 = 0, day2 = 0, day3 = 0, day4 = 0, day5 = 0, day6 = 0, day7 = 0;
    if (days.contains("Sunday")) {
      day1 = 1;
    }
    if (days.contains("Monday")) {
      day2 = 1;
    }
    if (days.contains("Tuesday")) {
      day3 = 1;
    }
    if (days.contains("Wednesday")) {
      day4 = 1;
    }
    if (days.contains("Thursday")) {
      day5 = 1;
    }
    if (days.contains("Friday")) {
      day6 = 1;
    }
    if (days.contains("Saturday")) {
      day7 = 1;
    }
    String url = "http://192.168.4.1/mission?" +
        "day1=" +
        day1.toString() +
        "&" +
        "day2=" +
        day2.toString() +
        "&" +
        "day3=" +
        day3.toString() +
        "&" +
        "day4=" +
        day4.toString() +
        "&" +
        "day5=" +
        day5.toString() +
        "&" +
        "day6=" +
        day6.toString() +
        "&" +
        "day7=" +
        day7.toString() +
        "&" +
        "season=" +
        season +
        "&" +
        "fromHour=" +
        _timefrom.hour.toString() +
        "&" +
        "fromMin=" +
        _timefrom.minute.toString() +
        "&" +
        "toHour=" +
        _timeto.hour.toString() +
        "&" +
        "toMin=" +
        _timeto.minute.toString() +
        "&" +
        "index=" +
        GlobalIndex.toString();
    var res;
    try {
      res = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 1));
    } on TimeoutException catch (e) {
      print("timeout");
      setState(() {
        stateOnlyText = ButtonState.fail;
      });
    } on Error catch (e) {
      print("error");
      setState(() {
        stateOnlyText = ButtonState.fail;
      });
    } catch (e) {
      print("errrrrrrrrrrror");
    }
    print("doneeee");
    setState(() {
      if (res != null) {
        stateOnlyText = ButtonState.success;
      } else {
        stateOnlyText = ButtonState.fail;
      }
    });
    print(res.body);
    getMissions();
  }

  var items = [];
  var itemsSettings = [];
void setShared() async {
  shared=await SharedPreferences.getInstance();
  print(shared.get("first"));
  if(shared.get("first")==true){
ShowCaseWidget.of(context)!.dismiss();
print("1");
  }else{
      onFirstSwitchTap();
    
shared.setBool("first",true);
print("2");

  }

}
  @override
  void initState() {
    items.forEach((element) {
      element.screen = switchScreen;
    });
setShared();

    super.initState();
    
    WidgetsBinding.instance!.addPostFrameCallback((_)=>ShowCaseWidget.of(context)!.startShowCase([
keyWifi,
keySwitch,
keyAct1,
keyAct2,
keyAct3,
keyAct4,






    ]),);
  }

  Future<void> _season() async {
    setState(() {
      stateOnlyText = ButtonState.idle;
    });
    return showDialog<void>(
      context: context,

      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Choose Season '),
          actions: <Widget>[
            Row(
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: GestureDetector(
                    child: Image.asset("images/autumn.png"),
                    onTap: () {
                      setState(() {
                        season = "autumn";
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: GestureDetector(
                      onTap: () {
                        setState(() {
                          season = "winter";
                        });
                        Navigator.of(context).pop();
                      },
                      child: Image.asset("images/winter.png")),
                ),
              ],
            ),
            Row(
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: GestureDetector(
                      onTap: () {
                        setState(() {
                          season = "spring";
                        });
                        Navigator.of(context).pop();
                      },
                      child: Image.asset("images/spring.png")),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: GestureDetector(
                      onTap: () {
                        setState(() {
                          season = "summer";
                        });
                        Navigator.of(context).pop();
                      },
                      child: Image.asset("images/summer.png")),
                ),
              ],
            ),
            CupertinoDialogAction(
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.orange),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  ButtonState stateOnlyText = ButtonState.idle;
  List<Object?> days = [DateFormat("EEEEE").format(DateTime.now()).toString()];
  Widget buildCustomButton() {
    var progressTextButton = ProgressButton(
      stateWidgets: {
        ButtonState.idle: Text(
          "Submit",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        ButtonState.loading: Text(
          "Loading",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        ButtonState.fail: Text(
          "Fail",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        ButtonState.success: Text(
          "Success",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        )
      },
      stateColors: {
        ButtonState.idle: Colors.orange,
        ButtonState.loading: Colors.blue.shade300,
        ButtonState.fail: Colors.red,
        ButtonState.success: Colors.green.shade400,
      },
      onPressed: onPressedCustomButton,
      state: stateOnlyText,
      padding: EdgeInsets.all(8.0),
    );
    return progressTextButton;
  }

  void onPressedCustomButton() {
    // print(days);
    // print(_timefrom);
    // print(_timeto);
    // print(season);
    // print(sequence);
    // print(GlobalIndex);

    setState(() {
      switch (stateOnlyText) {
        case ButtonState.idle:
          stateOnlyText = ButtonState.loading;
          sendMission();
          // Future.delayed(Duration(seconds: 5), () {
          //   setState(() {
          //     stateOnlyText = Random.secure().nextBool()
          //         ? ButtonState.success
          //         : ButtonState.fail;
          //   });
          // });
          break;
        case ButtonState.loading:
          break;
        case ButtonState.success:
          stateOnlyText = ButtonState.idle;
          break;
        case ButtonState.fail:
          stateOnlyText = ButtonState.idle;
          break;
      }
    });
  }
void onFirstSwitchTap(){
  items.add(Showcase(
    title: "Act1",
    description: "You can Turn on or Off the irrigation of the garden from here",
    key: keyAct1,
    
    child: item(
            day1: 0,
            day2: 0,
            day3: 0,
            day4: 0,
            day5: 0,
            day6: 0,
            day7: 0,
            fromHour: 0,
            fromMin: 0,
            season: "summer",
            toHour: 0,
            toMin: 0,
            withSettings: false,
            screen: () {
              switchScreen();
            },
            description: "This Actuator is for opening the water in the garden",
            name: "Garden",
            state: "off",
            index: 0,
            onRoute: "",
            offRoute: ""),
  ));
         
           items.add(Showcase(
             title: "Act3",
    description: "You can change the desciption by a simple Long Press on the text",
    key: keyAct3,
             child: item(
                     day1: 0,
                     day2: 0,
                     day3: 0,
                     day4: 0,
                     day5: 0,
                     day6: 0,
                     day7: 0,
                     fromHour: 0,
                     fromMin: 0,
                     season: "summer",
                     toHour: 0,
                     toMin: 0,
                     withSettings: false,
                     screen: () {
              switchScreen();
                     },
                     description: "This Actuator is for opening the water in the house",
                     name: "House",
                     state: "on",
                     index: 0,
                     onRoute: "",
                     offRoute: ""),
           ));
        
           items.add(Showcase(
               title: "Act2",
    description: "You can Turn on or Off the irrigation of the flowers from here",
    key: keyAct2,
             child: item(
                     day1: 0,
                     day2: 0,
                     day3: 0,
                     day4: 0,
                     day5: 0,
                     day6: 0,
                     day7: 0,
                     fromHour: 0,
                     fromMin: 0,
                     season: "summer",
                     toHour: 0,
                     toMin: 0,
                     withSettings: false,
                     screen: () {
              switchScreen();
                     },
                     description: "This Actuator is for the irrigation of the flowers",
                     name: "Flower",
                     state: "off",
                     index: 0,
                     onRoute: "",
                     offRoute: ""),
           ));
       
           items.add(Showcase(
             key : keyRefresh,
          title: "Refresh :)",
          description: "Please Make sure you refresh your data from the device: drag down the screen with your finger",
             child: item(
                     day1: 0,
                     day2: 0,
                     day3: 0,
                     day4: 0,
                     day5: 0,
                     day6: 0,
                     day7: 0,
                     fromHour: 0,
                     fromMin: 0,
                     season: "summer",
                     toHour: 0,
                     toMin: 0,
                     withSettings: false,
                     screen: () {
              switchScreen();
                     },
                     description: "This Actuator is for the irrigation of the tree",
                     name: "tree",
                     state: "off",
                     index: 0,
                     onRoute: "",
                     offRoute: ""),
           ));
       
       itemsSettings.add(Showcase(
         key:keyMission,
         title:"Mission",
         description: "You can turn off and on your planified sequences",
         child: item(
          withSettings: true,
          screen: () {
            switchScreen();
          },
          description: "irrigation from 8 am to 10 am",
          name: "",
          state: "on",
          index: 0,
          onRoute: "",
          offRoute: "",
          day1: 1,
          day2: 0,
          day3: 1,
          day4: 0,
          day5: 1,
          day6: 0,
          day7: 1,
          
          fromHour: 8,
          fromMin: 0,
          toHour: 10,
          toMin: 0,
          season: "spring",
             ),
       ));
itemsSettings.add(Showcase(
  key:keySetting,
         title:"Settings",
         description: "You can set your sequences with the setting icon on the left",
  child:   item(
          withSettings: true,
          screen: () {
            switchScreen();
          },
          description: "irrigation in the summer",
          name: "",
          state: "off",
          index: 0,
          onRoute: "",
          offRoute: "",
          day1: 1,
          day2: 0,
          day3: 1,
          day4: 1,
          day5: 1,
          day6: 0,
          day7: 1,
          
          fromHour: 8,
          fromMin: 30,
          toHour: 17,
          toMin: 15,
          season: "summer",
        ),

));
setState(() {
      
    });
}
  @override
  Widget build(BuildContext context) {
    var longeur = MediaQuery.of(context).size.height;
    var largeur = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: (){
        print(ShowCaseWidget.of(context)!.activeWidgetId);
        if(ShowCaseWidget.of(context)!.activeWidgetId==5){
          setState(() {
            missionScreen=true;
            switchValue=true;
                       WidgetsBinding.instance!.addPostFrameCallback((_)=>ShowCaseWidget.of(context)!.startShowCase([
keyMission,
keySetting,
keyAct4,

    ]),);
          });}
          
          if(ShowCaseWidget.of(context)!.activeWidgetId==2 && missionScreen==true && screen==1){
          setState(() {
            screen=2;
                       WidgetsBinding.instance!.addPostFrameCallback((_)=>ShowCaseWidget.of(context)!.startShowCase([
keyTime,
keyDays,
keySeason,
keySequence,
keyAct4,

    ]),);
          });

        }
         if(ShowCaseWidget.of(context)!.activeWidgetId==4 && screen==2){
          setState(() {
            screen=1;
            missionScreen=false;
            switchValue=false;
                       WidgetsBinding.instance!.addPostFrameCallback((_)=>ShowCaseWidget.of(context)!.startShowCase([
keyRefresh,
keyDrawer,
keyAct4


    ]),);
          });

        }
         if(ShowCaseWidget.of(context)!.activeWidgetId==2 && screen==1 && missionScreen==false && switchValue==false){
          setState(() {
            items.clear();
            itemsSettings.clear();
ShowCaseWidget.of(context)!.dismiss();
          });

        }
      },
      child: Scaffold(
        key: _scaffoldkey,
        drawer: Drawer(
          elevation: 200,
          child: Container(
            color: Colors.green[800],
            child: Column(
              children: [
                SafeArea(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                            fit: FlexFit.tight,
                            flex: 1,
                            child: Image.asset("images/icon.png")),
                        Flexible(
                            fit: FlexFit.tight,
                            flex: 1,
                            child: IconButton(
                                color: Colors.orangeAccent,
                                iconSize: longeur / 18,
                                icon: Icon(Icons.exit_to_app),
                                onPressed: () {
                                  exit(0);
                                })),
                      ]),
                ),
                Container(
                  margin: EdgeInsets.all(longeur / 20),
                  child: Text(
                    "Enjoy the app , you can contact us on 25412563 ",
                    style: GoogleFonts.saira(
                        color: Colors.white, fontSize: longeur / 25),
                  ),
                )
              ],
            ),
          ),
        ),
        drawerScrimColor: Colors.orange[0],
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          //bottom navigation bar on scaffold
          color: Colors.amber[700],
          shape: CircularNotchedRectangle(), //shape of notch
          notchMargin:
              5, //notche margin between floating button and bottom appbar
          child: Row(
            //children inside bottom appbar
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Showcase(
                key: keyDrawer,
                title: "Contact Us !",
                description: "Click here to know about us",
                child: IconButton(
                  icon: Icon(
                    Icons.menu,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _scaffoldkey.currentState!.openDrawer();
                  },
                ),
              ),
              Showcase(
                 title: "You're Here !",
    
            key: keyWifi,
            description: "Start with connecting on your device HotSpot",
                child: IconButton(
                  icon: Icon(
                    Icons.wifi_outlined,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    print("wifi");
                    SystemSettings.wifi();
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green[200],
          onPressed: () {},
          elevation: 100,
          child: Showcase(
            title: "Hi",
            key: keySwitch,
            description: "Click here to switch between Missions and Actuators ",
            child: CupertinoSwitch(
              value: switchValue,
              onChanged: (bool x) {
                dev.log("waaaaaaaaaaaaa");
                setState(() {
                  switchValue = x;
                  if (!switchValue) {
                    setState(() {
                      missionScreen=false;
                      screen = 1;
                    });
                  }else{
                    setState(() {
                      missionScreen=true;
                   
                    });
                      
                    
                  }
                });
              },
              trackColor: Colors.red,
              activeColor: Colors.green,
            ),
          ),
        ),
        backgroundColor: Colors.greenAccent,
        body: RefreshIndicator(
          color: Colors.orange,
          backgroundColor: Colors.green,
          onRefresh: () async {
            getInit();
            getMissions();
            print("done refreshing... :)");
          },
          child: Container(
            margin: EdgeInsets.all(longeur / 100),
            decoration: BoxDecoration(
              // image: DecorationImage(
              //     fit: BoxFit.cover, image: AssetImage("images/motif9.png")),
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey[200],
             
            ),
            child: screen == 1
                ?  (items.length==0 && itemsSettings.length==0)?
                ListView.builder(
                    // itemExtent: 150,
                    itemCount: 1,
                    
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        
                        child: Image.asset("images/swipe.gif",
                      height: longeur,

                      ));
                    })
                :missionScreen == false? ListView.builder(
                    // itemExtent: 150,
                    itemCount: items.length,
                    itemBuilder: (BuildContext context, int index) {
                      return items[index];
                    }):
                    ListView.builder(
                    // itemExtent: 150,
                    itemCount: itemsSettings.length,
                    itemBuilder: (BuildContext context, int index) {
                      return itemsSettings[index];
                    })
                : SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          fit: FlexFit.tight,
                          flex: 2,
                          child: Showcase(
                            key:keyTime,
                            title: "Set Your Time",
                            description: "You can set when the duration of the irrigation",
                            child: Container(
                                margin: EdgeInsets.all(largeur / 30),
                                padding: EdgeInsets.all(largeur / 30),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Colors.green, Colors.orange],
                                  ),
                                  borderRadius: BorderRadius.circular(longeur / 50),
                                ),
                                child: Column(
                                  children: [
                                    Flexible(
                                      fit: FlexFit.tight,
                                      flex: 1,
                                      child: Row(
                                        children: [
                                          Flexible(
                                            fit: FlexFit.tight,
                                            flex: 1,
                                            child: Text(
                                              "From",
                                              style: GoogleFonts.amaranth(
                                                fontSize: longeur / 20,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            fit: FlexFit.tight,
                                            flex: 1,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                setState(() {
                                                  stateOnlyText = ButtonState.idle;
                                                });
                                                Navigator.of(context).push(
                                                  showPicker(
                                                      value: _timefrom,
                                                      onChange: onTimeChanged,
                                                      context: context),
                                                );
                                              },
                                              child: Text(
                                                _timefrom.hour.toString() +
                                                    ":" +
                                                    _timefrom.minute.toString(),
                                                style: GoogleFonts.amaranth(
                                                    fontSize: longeur / 30,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: largeur / 90),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Flexible(
                                      fit: FlexFit.tight,
                                      flex: 1,
                                      child: Row(
                                        children: [
                                          Flexible(
                                            fit: FlexFit.tight,
                                            flex: 1,
                                            child: Text(
                                              "To",
                                              style: GoogleFonts.amaranth(
                                                fontSize: longeur / 20,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            fit: FlexFit.tight,
                                            flex: 1,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                setState(() {
                                                  stateOnlyText = ButtonState.idle;
                                                });
                                                Navigator.of(context).push(
                                                  showPicker(
                                                      value: _timeto,
                                                      onChange: onTimeChanged2,
                                                      context: context),
                                                );
                                              },
                                              child: Text(
                                                _timeto.hour.toString() +
                                                    ":" +
                                                    _timeto.minute.toString(),
                                                style: GoogleFonts.amaranth(
                                                    fontSize: longeur / 30,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: largeur / 90),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                        ),
                        Flexible(
                            fit: FlexFit.tight,
                            flex: 2,
                            child: Showcase(
                               key:keyDays,
                            title: "Select Days",
                            description: "You can select the days of the week",
                              child: SingleChildScrollView(
                                child: Container(
                                  margin: EdgeInsets.all(largeur / 30),
                                  padding: EdgeInsets.all(largeur / 30),
                                  child: MultiSelectBottomSheetField(
                                    confirmText: Text(
                                      "Ok",
                                      style: TextStyle(color: Colors.orange),
                                    ),
                                    cancelText: Text(
                                      "Cancel",
                                      style: TextStyle(color: Colors.orange),
                                    ),
                                    backgroundColor: Colors.green[400],
                                    buttonText: Text("Select Days",
                                        style: TextStyle(color: Colors.orange)),
                                    checkColor: Colors.orange,
                                    items: [
                                      MultiSelectItem("Monday", "Monday"),
                                      MultiSelectItem("Tuesday", "Tuesday"),
                                      MultiSelectItem("Wednesday", "Wednesday"),
                                      MultiSelectItem("Thursday", "Thursday"),
                                      MultiSelectItem("Friday", "Friday"),
                                      MultiSelectItem("Saturday", "Saturday"),
                                      MultiSelectItem("Sunday", "Sunday"),
                                    ],
                                    initialValue: days,
                                    onConfirm: (tab) {
                                      print(tab);
                                      setState(() {
                                        stateOnlyText = ButtonState.idle;
                                        days = tab;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            )),
                        Flexible(
                          fit: FlexFit.tight,
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Flexible(
                                fit: FlexFit.tight,
                                flex: 1,
                                child: Column(
                                  children: [
                                    Flexible(
                                      fit: FlexFit.tight,
                                      flex: 1,
                                      child: Text(
                                        "Season",
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Flexible(
                                      fit: FlexFit.tight,
                                      flex: 1,
                                      child: Showcase(
                                         key:keySeason,
                            title: "Season",
                            description: "Tap here to Select the Season",
                                        child: Container(
                                          // width: largeur / 8,
                                          // height: longeur / 16,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  "images/" + season + ".png"),
                                              alignment: Alignment.center,
                                            ),
                                          ),
                                          child: IconButton(
                                            onPressed: _season,
                                            icon: Text(""),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Flexible(
                                fit: FlexFit.tight,
                                flex: 1,
                                child: Column(
                                  children: [
                                    Flexible(
                                      fit: FlexFit.tight,
                                      flex: 1,
                                      child: Text(
                                        "Sequence state",
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Showcase(
                                      key:keySequence,
                                
                                      title: "State",
                                      description: "You can see if your sequence is activated or not",
                                      child: Flexible(
                                        fit: FlexFit.tight,
                                        flex: 1,
                                        child: GlobalState == "on"
                                            ? Icon(
                                                Icons.task_alt_outlined,
                                                color: Colors.green,
                                              )
                                            : Icon(
                                                Icons.disabled_by_default_outlined,
                                                color: Colors.red,
                                              ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.tight,
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                fit: FlexFit.tight,
                                flex: 1,
                                child: Card(
                                  color: Colors.red,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.keyboard_backspace,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        screen = 1;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Flexible(
                                fit: FlexFit.tight,
                                flex: 1,
                                child: buildCustomButton(),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
