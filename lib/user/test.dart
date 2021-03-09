import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
class test extends StatefulWidget {
  static String id='test';

  @override
  _testState createState() => _testState();
}

class _testState extends State<test> {
  PickedFile _imageFile;
  String imageUrl;
  final ImagePicker Picker=ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: imagearticle(),);
  }
  Widget imagearticle()
  {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 80.0,
            backgroundImage:_imageFile==null? AssetImage("images/noimage.jpg"):FileImage(File(_imageFile.path)),
          ),
          Positioned(bottom: 20.0,
              right: 20.0,
              child: InkWell(onTap: (){takePhoto();},
                  child: Icon(Icons.camera_alt,color: Colors.teal,size: 28.0,)))
        ],
      ),
    );
  }
  void takePhoto() async{
    final pickedFile=await Picker.getImage(source: ImageSource.gallery);
    final storage =FirebaseStorage.instance;
  var snapshot=await storage.ref().
   child('folderName/${context.basename(pickedFile.path)}').
   putFile(File(pickedFile.path));
  var downloadedUrl=await snapshot.ref.getDownloadURL();
  print(downloadedUrl);
    setState(() {
      _imageFile=pickedFile;
      imageUrl=downloadedUrl;
    });
  }
}
