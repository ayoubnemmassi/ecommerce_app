
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class imageupload extends StatefulWidget {
  @override
  _imageuploadState createState() => _imageuploadState();
}

class _imageuploadState extends State<imageupload> {
  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }






  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }

   
}


