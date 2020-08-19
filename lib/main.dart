import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Login(),
    );
  }
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  var a= new Map() ;

  void PostReq() async{
    var url = "http://13.233.250.194:8080/login";
    var response = await http.post(url,body: json.encode({"email":_email.text,"password":_password.text}),
        headers:{"Content-Type":"application/json"});
    print(response.body);

    setState(() {
      var convertDataToJson = json.decode(response.body);
      a = convertDataToJson;
    });


  }


  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();


  GlobalKey<FormState> _form = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white38,
      body:SingleChildScrollView(

        child: Form(
          key: _form,
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 640,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/back.png'),
                        fit: BoxFit.fill
                    ),
                  ),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 30,
                        width: 80,
                        height: 200,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/calendar.png'),
                            ),

                          ),
                        ),
                      ), //Backround
                      Positioned(
                        left: 250,
                        width: 50,
                        height: 600,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/calendar.png'),

                            ),
                          ),
                        ),
                      ),//calendar
                      Positioned(
                        child: Center(
                          child: Container(
                            color: Colors.white,
                            margin: EdgeInsets.fromLTRB(100, 100, 100, 320),
                            child: Text("ToDo List",style: TextStyle(color: Colors.black,fontSize: 35,fontWeight: FontWeight.bold),),
                          ),
                        ),
                      ),//Center Title
                      Padding(
                        padding: EdgeInsets.fromLTRB(30, 350, 30, 30),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color.fromRGBO(400, 52, 50, 1),
                                      blurRadius: 10.0,
                                      offset: Offset(0,10)
                                  ),
                                ],
                              ),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    height:70,
                                    padding: EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                        border: Border(bottom: BorderSide(color:Colors.grey[100]))
                                    ),
                                    child: TextFormField(
                                      controller: _email,
                                      validator: (String value) {
                                        Pattern pattern = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
                                        RegExp regex = new RegExp(pattern);
                                        if (regex.hasMatch(value)) {
                                          return null;
                                        }else
                                          return "Please Enter valid Email";
                                      },

                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: "Email",
                                          labelStyle: TextStyle(color: Colors.black),
                                          hintText: "Enter your Email",
                                          hintStyle: TextStyle(color: Colors.grey[400])
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),//Text box1 with shadow
                            SizedBox(height: 20),
                            Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color.fromRGBO(400, 52, 50, 1),
                                      blurRadius: 10.0,
                                      offset: Offset(0,10)
                                  ),
                                ],
                              ),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    height:70,
                                    padding: EdgeInsets.all(2),
                                    child: TextFormField(
                                      obscureText: true,
                                      controller: _password,
                                      validator: (String v) {
                                        if (v.length == 0) {
                                          return "Enter your Password";
                                        }if (v.length < 5 ){
                                          return "Enter Valid Password";
                                        }else
                                          return null;
                                      },
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: "Password",
                                          labelStyle: TextStyle(color: Colors.black),
                                          hintText: "Enter your Password",
                                          hintStyle: TextStyle(color: Colors.grey[400])
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),////Text box1 with shadow
                            SizedBox(height: 30),
                            RaisedButton(
                              onPressed: (){

                                if (_form.currentState.validate()) {
                                  print("success");
                                  PostReq();


                                  Timer(Duration(seconds: 3), () {
                                    if(a["message"]=="Authorized"){
                                      print("Authorized");
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => SecondRoute()),
                                      );
                                    }else{
                                      print("Unauthorized");
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context){
                                            return AlertDialog(
                                              title: Text("Warning!"),
                                              content: Text("Unauthorized Credentials"),
                                              actions: <Widget>[
                                                FlatButton(
                                                  child: Text("Close"),
                                                  onPressed: (){
                                                    Navigator.of(context).pop();
                                                  },
                                                )
                                              ],
                                            );
                                          }
                                      );
                                    }

                                    print("print after every 3 seconds");
                                  });

                                } else {
                                  print("error");
                                }
                              },

                              child: new Text("Login"),
                              textColor: Colors.white,
                              color: Colors.redAccent,

                            ),//Login Button
                          ],
                        ),
                      ),

                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );

  }
}


















class SecondRoute extends StatefulWidget {
  @override
  _SecondRouteState createState() => _SecondRouteState();
}

class _SecondRouteState extends State<SecondRoute> {


  List data;
  List todos =List();
  List completed =List();

  var b =new Map();
  var c =new Map();
  bool checkBoxValue;

  @override
  void initState(){
    super.initState();
    this.getJsonData();
  }


  Future<String> getJsonData() async {
    var url = "http://13.233.250.194:8080/get/todo/123456";
    var response = await http.get(
        Uri.encodeFull(url),
        headers:  {"Accept":"application/json"}
    );
    print(response.body);

    setState(() {
      var convertDataToJson = json.decode(response.body);
      data = convertDataToJson;
    });


    return "Success";
  }
  void changeData(int index) async{


    var url = "http://13.233.250.194:8080/change/todo/123456";
    var response = await http.post(url,body: json.encode({"id":data[index]['id'],"completed":data[index]['completed']}),
        headers:{"Content-Type":"application/json"});
    print(response.body);

    setState(() {
      var convertDataToJson = json.decode(response.body);
      b = convertDataToJson;
    });


  }






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List of Tasks"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return Scaffold(
                    appBar: AppBar(
                      title: Text("Completed Tasks List"),
                    ),
                    body: ListView.builder(
                      itemCount: data == null?  0 : data.length,
                      itemBuilder: (BuildContext context,int index){
                        return Container(
                          child: data[index]['completed']==false? new Container(): new Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Card(
                                  elevation:5,
                                  child: ListTile(
                                    contentPadding: EdgeInsets.all(3),
                                    leading: Checkbox(

                                      value: data[index]['completed'],
                                      onChanged: (bool value){
                                        changeData(0);
                                        if(b['message']=='success'){
                                          setState(() {
                                            data[index]['completed']=value;
                                            value=checkBoxValue;
                                            todos.add(data[index]['todo']);

                                          });

                                        }else{
                                          return null;
                                        }

                                      },

                                    ),
                                    title: Text(data[index]['todo']),



                                  ),
                                ),
                              ],
                            ),
                          )
                        );
                      },

                    ),
                  );
                }),
              );




            },
          ),
        ],
      ),
      body: new  ListView.builder(
        itemCount: data == null?  0 : data.length,
        itemBuilder: (BuildContext context,int index){
          return Container(
            child: data[index]['completed']==true? new Container():new Container(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Card(
                      elevation:5,
                      child: ListTile(
                        contentPadding: EdgeInsets.all(3),
                        leading: Checkbox(

                          value: data[index]['completed'],
                          onChanged: (bool value){
                            changeData(0);
                            if(b['message']=='success'){
                              setState(() {

                                data[index]['completed']=value;
                                value=checkBoxValue;
                                completed.add(data[index]['todo']);

                              });

                            }else{
                              return null;
                            }


                          },

                        ),
                        title: Text(data[index]['todo']),


                      ),
                    ),
                  ],
                ),
              ),
            )
          );
        },

      ),





      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FourthRoute()),
          );

          // Navigate back to first route when tapped.
        },
      ),


    );

  }
}






























class FourthRoute extends StatefulWidget {
  @override
  _FourthRouteState createState() => _FourthRouteState();
}

class _FourthRouteState extends State<FourthRoute> {

  List todos =List();


  TextEditingController _newtask = TextEditingController();

  var d =new Map();

  void addToList() async{

    var url = "http://13.233.250.194:8080/add/todo/123456";
    var response = await http.post(url,body: json.encode({"todo":_newtask.text,"completed":false}),
        headers:{"Content-Type":"application/json"});
    print(response.body);


    setState(() {
      var convertDataToJson = json.decode(response.body);
      d = convertDataToJson;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Task"),
      ),
      body: Form(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20,80,20,0),
          child: Column(
            children:<Widget>[
              TextFormField(
                controller: _newtask,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "NEW Task",
                    labelStyle: TextStyle(color: Colors.black),
                    hintText: "Enter your Task",
                    hintStyle: TextStyle(color: Colors.grey[400])
                ),
              ),
              RaisedButton(
                onPressed: (){
                  addToList();
                  Timer(Duration(seconds: 3),(){
                    if(d["message"]=="Todo created successfully"){
                      print("Valid message");
                      setState(() {
                        todos.add(_newtask);
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SecondRoute()),
                      );

                    }else{
                      print("Invalid message");
                      showDialog(
                          context: context,
                          builder: (BuildContext context){
                            return AlertDialog(
                              title: Text("Warning!"),
                              content: Text("Invalid Data"),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text("Close"),
                                  onPressed: (){
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            );
                          }
                      );

                    }
                  });
                },
                child: new Text("Add to List"),
                textColor: Colors.white,
                color: Colors.blueAccent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}





