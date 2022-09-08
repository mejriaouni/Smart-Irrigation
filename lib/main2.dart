// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

//  main() => runApp(MyApp());

// class MyApp extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState(){
//   return MyAppState();
//   }
// }

// class MyAppState extends State<MyApp>{
//   int count = 0;
//   @override
//   Widget build(BuildContext context) {
    
//     return MaterialApp(theme: ThemeData.dark(),debugShowCheckedModeBanner: false,
//       home: Scaffold(drawer:Drawer(
//         child : ListTile(
//           title: Text(
//             'About ESP8266',style: TextStyle(
//               fontSize: 50)
//               ,)
//               ,)
//               ),
//         appBar:AppBar(
//           title:Center( 
//             child : Text(
//             'Smart Garden',
//             style: TextStyle(fontSize: 30,
//             fontStyle: FontStyle.italic),
//             ),
//           ),
//         ),
//         body: Column(
//           children: <Widget> [
//           ListTile(title : Text('Water Management',
//             style : TextStyle(fontSize: 45,fontStyle: FontStyle.italic)
//             ),leading: Icon(Icons.cast_connected,size: 50,color:Colors.blue,
//             ),subtitle: Text('Esp8266 & App Flutter',style: TextStyle(fontSize: 20,fontStyle: FontStyle.italic),),
//           ),
//           ElevatedButton.icon(onPressed:(){
//             count++;
//             print('count = $count');
//             //light1();
//             setState(() {}
//           );},
//           style: ButtonStyle(
//             foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
//             backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
//             shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//             RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20.0),
//             side: BorderSide(color: Colors.blue)
//             )
//           )
//           ),
//            icon: Icon(
//              Icons.lightbulb_outline,
//              color : Colors.redAccent,
//              size : 45,
//              ), 
//             label: Text(
//               'Zone 1 $count',
//               style: TextStyle(fontSize: 30),
//               ),
//             ),
//             SizedBox(height: 50,),

//           ElevatedButton.icon(onPressed:(){light();},
           
//            style: ButtonStyle(
//             foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
//             backgroundColor: MaterialStateProperty.all<Color>(Colors.blueAccent),
//             shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//             RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20.0),
//             side: BorderSide(color: Colors.blue)
//             )
//           )
//           ),
//            icon: Icon(
//             Icons.lightbulb_outline,
//             color : Colors.redAccent,
//             size : 45,
//              ), 
//             label:
//               Text(
//               'Zone 2',
//               style: TextStyle(fontSize: 30),
        
//             ),
//             ),


            
//           ],
//           ),
//       ),
//     );
      
//   }

// }

// Future light() async{
//  var url = 'http://192.168.4.1:81';
//  var res =  await http.get(Uri.parse(url));
//  print(res.body);
 
 
 

// }
// Future light1() async{
//  var url = 'http://192.168.4.1/Relay2';
//  var res =  await http.get(Uri.parse(url));

 
//  //print(res.body.split(pattern));

// }
