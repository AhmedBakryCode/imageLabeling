import 'package:flutter/material.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title:
          Text("first screen"),
        ),
        body: Container(
          height: 200,
          width: 400,

          child: Center(
            child: Column(
              children: [
                ElevatedButton(onPressed: (){
                  Navigator.pushNamed(context,"//" );
                }, child: Text(
            "Image labeling with Phote",style: TextStyle(color: Colors.white),
            ),),
                SizedBox(height: 30),
                ElevatedButton(onPressed: (){
                  Navigator.pushNamed(context,"/second");
                }, child: Text(
                  "Image labeling with camera",style: TextStyle(color: Colors.white),
                ),),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
