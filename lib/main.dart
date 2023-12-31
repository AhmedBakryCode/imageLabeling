import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_labeling_complete/second_screen.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:image_picker/image_picker.dart';

import 'first_screen.dart';

void main() async{
  late List<CameraDescription> _cameras;
  WidgetsFlutterBinding.ensureInitialized();
  _cameras = await availableCameras();
  runApp(MaterialApp(
    initialRoute: '/',
      routes: {
        '//':(context)=> const MyHomePage(),
        '/first': (context) => const FirstScreen(),
        '/second': (context) => const CameraScreen(),
      },

      home: const FirstScreen()));

}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late ImagePicker imagePicker;
  File? _image;
  String result = 'Results will be shown here';

  //TODO declare ImageLabeler
dynamic imageLabeler;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imagePicker = ImagePicker();
    //TODO initialize labeler
    final ImageLabelerOptions options = ImageLabelerOptions(confidenceThreshold: 0.5);
     imageLabeler = ImageLabeler(options: options);
  }

  @override
  void dispose() {
    super.dispose();

  }

  //TODO capture image using camera
  _imgFromCamera() async {
    XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    _image = File(pickedFile!.path);
    setState(() {
      _image;
      doImageLabeling();
    });
  }

  //TODO choose image using gallery
  _imgFromGallery() async {
    XFile? pickedFile =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        doImageLabeling();
      });
    }
  }

  //TODO image labeling code here
  doImageLabeling() async {
 InputImage inputImage = InputImage.fromFile(_image!!);

 final List<ImageLabel> labels = await imageLabeler.processImage(inputImage);
result=" ";
 for (ImageLabel label in labels) {
   final String text = label.label;
   final int index = label.index;
   final double confidence = label.confidence;
   result+= "$text     "+confidence.toStringAsFixed(2)+"\n";
 }
 setState(() {
   result;
 });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/bg.jpg'), fit: BoxFit.cover),
        ),
        child: Scaffold(
          body:  SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    width: 100,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 100),
                    child: Stack(children: <Widget>[
                      Stack(children: <Widget>[
                        Center(
                          child: Image.asset(
                            'images/frame.png',
                            height: 510,
                            width: 500,
                          ),
                        ),
                      ]),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.transparent,
                              shadowColor: Colors.transparent),
                          onPressed: _imgFromGallery,
                          onLongPress: _imgFromCamera,
                          child: Container(
                            margin: const EdgeInsets.only(top: 8),
                            child: _image != null
                                ? Image.file(
                                    _image!,
                                    width: 335,
                                    height: 495,
                                    fit: BoxFit.fill,
                                  )
                                : Container(
                                    width: 340,
                                    height: 330,
                                    child: const Icon(
                                      Icons.camera_alt,
                                      color: Colors.black,
                                      size: 100,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ]),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: Text(
                      result,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }
}
