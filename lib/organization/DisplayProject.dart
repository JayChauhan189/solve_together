import 'package:flutter/material.dart';
class DisplayProject extends StatelessWidget {
  const DisplayProject({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Project Details"),
        backgroundColor: Colors.black87,
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(20, 10, 20,5),
            child: Text("Project Title",style: TextStyle(fontSize: 30),
            ),
          ),
          Divider(color: Colors.black87,),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
              child: Text("Project Description"),
            ),
          )
        ],
      ),
    );
  }
}
