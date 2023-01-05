import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';  
import 'package:permission_handler/permission_handler.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Qasid',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Qasid'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<Contact> contacts = [];
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllContacts();
  }

  Future<void> getAllContacts() async{
    if (await Permission.contacts.request().isGranted) {
  // Either the permission was already granted before or the user just granted it.

    List<Contact> _contacts = (await ContactsService.getContacts()).toList();  

    // Permissions.contactPermissionsGranted()? (await ContactsService.getContacts()).toList(): [];    
    setState(() {
      contacts = _contacts;
      print('Length: ${contacts.length}');
    });
    
  }
  }

  Future<void> shuffleContact() async{
    // print(contacts.length);
    if (contacts.length !=0){
    Random random = new Random();
    int randomNumber = await random.nextInt(contacts.length);
    // print(randomNumber);
    // print(contacts[randomNumber].displayName);

    _showMyDialog((contacts[randomNumber].displayName).toString());
    }else{
      print("Length 0");
    }

  }


Future<void> _showMyDialog(String? contactName) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Connect with'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              new Text(contactName!),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),

      body: contacts.length ==0 ? Center(child: CircularProgressIndicator()): ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: contacts.length,
        // itemCount: 15,
        itemBuilder: (context,index){
          // Contact? contact = contacts[index];
          return Container(
            // height: 20,
            // color: Colors.red,
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.amber[100],
              borderRadius: BorderRadius.circular(15)
            ),
            child: ListTile(
              title: Text(contacts[index].displayName??'null'),
              // title: new Text(index.toString()),
              
              // subtitle: Text(contacts[index].phones?.elementAt(0).value??''),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: shuffleContact,
        // tooltip: 'Increment',
        child: const Icon(Icons.health_and_safety_rounded),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
