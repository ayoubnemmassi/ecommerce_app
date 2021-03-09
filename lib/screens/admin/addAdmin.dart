import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/Widgets/custom_textfield.dart';
import 'package:e_commerce/models/User.dart';
import 'package:e_commerce/models/product.dart';
import 'package:e_commerce/services/auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce/services/store.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Constants.dart';
import '../login_screen.dart';
import 'addProduct.dart';
import 'adminHome.dart';
import 'manageProduct.dart';
import 'orderScreen.dart';
// ignore: must_be_immutable
class AddAdmin extends StatefulWidget {
  static String id='AddAdmin';

  @override
  _AddAdminState createState() => _AddAdminState();
}

class _AddAdminState extends State<AddAdmin> {
  final Store store =Store();

  final auth =Auth();

  int _bottomBarIndex = 0;

  List<User> _Users;
  PickedFile _imageFile;
  String imageUrl;
  final ImagePicker Picker=ImagePicker();
  String fname,lname,email,password,imagelocation;

  final GlobalKey<FormState> globalKey=GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: KUnActiveColor,
        currentIndex: _bottomBarIndex,
        fixedColor: KMainColor,
        onTap: (value) async {
      if (value == 2) {
        SharedPreferences pref =
            await SharedPreferences.getInstance();
        pref.clear();
        await auth.signOut();
        Navigator.popAndPushNamed(context, LoginScreen.id);
      }
      else if(value==0){Navigator.pushNamed(context, AdminHome.id);}
      else if(value==1){Navigator.pushNamed(context, AddAdmin.id);}
      setState(() {
        _bottomBarIndex = value;
      });
    },
    items: [
    BottomNavigationBarItem(
    title: Text('My Space'), icon: Icon(Icons.person)),
    BottomNavigationBarItem(
    title: Text('Admin'), icon: Icon(Icons.add_moderator)),
    BottomNavigationBarItem(
    title: Text('Sign Out'), icon: Icon(Icons.close)),
    ],
    ),

    appBar: new AppBar(
    iconTheme: IconThemeData(color: Colors.black),
    elevation: 0.0,
    backgroundColor: Colors.white ,
    title: Text('Shop It' ,style: TextStyle(color: Colors.black),),
    actions: <Widget>[
    new IconButton(icon: Icon(Icons.search),color: Colors.black, onPressed: (){}),
    //new IconButton(icon: Icon(Icons.shopping_cart),color: Colors.white, onPressed: (){})
    ],
    ),
    drawer: new Drawer(

    child: new ListView(
    children: <Widget>[
    //header
    new UserAccountsDrawerHeader(accountName: Text('Ayoub Nemmassi'),
    accountEmail: Text('ayoub.nemmassi@gmail.com'),
    currentAccountPicture:GestureDetector(child: new CircleAvatar(
    backgroundColor: Colors.white,
    child: UsersImage(),
    ),
    ) ,
    decoration: new BoxDecoration(
    image: DecorationImage(image: AssetImage('images/black.jpg'))
    ),
    ),
//                  body
    InkWell(
    onTap: (){Navigator.pushNamed(context, AdminHome.id);},
    child: ListTile(
    title: Text('Home Page'),
    leading: Icon(Icons.home),
    ),
    ),
    InkWell(
    onTap: (){Navigator.pushNamed(context, AddProduct.id);},
    child: ListTile(
    title: Text('Add Product'),
    leading: Icon(Icons.add),
    ),
    ),
    InkWell(
    onTap: (){Navigator.pushNamed(context, ManageProduct.id);},
    child: ListTile(
    title: Text('Edit Product'),
    leading: Icon(Icons.edit),
    ),
    ),
    InkWell(
    onTap: (){Navigator.pushNamed(context, OrdersScreen.id);},
    child: ListTile(
    title: Text('View Orders'),
    leading: Icon(Icons.shopping_basket),
    ),
    ),
    /*InkWell(
              onTap: (){},
              child: ListTile(
                title: Text('Favourites'),
                leading: Icon(Icons.favorite),
              ),
            ),*/
    Divider(),
    InkWell(
    onTap: (){},
    child: ListTile(
    title: Text('Settings '),
    leading: Icon(Icons.settings),
    ),
    ),
    InkWell(
    onTap: (){},
    child: ListTile(
    title: Text('About '),
    leading: Icon(Icons.info ,color: Colors.blue,),
    ),
    )
    ],
    ),
    ),

      body: ListView(
        children:[ Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/bw.png'),

              fit: BoxFit.cover,
            ),
          ),
          child: Form(
            key: globalKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                  Text('Add Admin',style:TextStyle( fontWeight:FontWeight.bold,fontSize: 20, color:Colors.white),),
                SizedBox(height: height*.01,),
                CustomTextField(onClick: (value){fname=value;}, icon: null, hint: 'Admin first Name'),
                SizedBox(height: height*.01,),
                CustomTextField(onClick: (value){lname=value;}, icon: null, hint: 'Admin last Name'),
                SizedBox(height: height*.01,),
                CustomTextField(onClick: (value){email=value;}, icon: null, hint: 'Admin email'),
                SizedBox(height: height*.01,),
                CustomTextField(onClick: (value){password=value;}, icon: null, hint: 'Admin password'),
                SizedBox(height: height*.01,),
               // CustomTextField(onClick: (value){imagelocation=value;}, icon: null, hint: 'image location'),
                imagearticle(),
                SizedBox(height: height*.02,),
                RaisedButton(onPressed: ()
                async {
                  if(globalKey.currentState.validate())
                  {
                    globalKey.currentState.save();
                    await auth.signUp(email.trim(), password.trim());
                    if(imageUrl!=null){
                    store.addUser(User(uName: lname,uPrenom :fname,uMail: email,uMdp :password,uImage: imageUrl,uRole: 'admin'));
                  }
                  else{store.addUser(User(uName: lname,uPrenom :fname,uMail: email,uMdp :password,uImage: 'images/admins.png',uRole: 'admin'));}
                  }
                },child: Text('Add Admin'),)
              ],
            ),
          ),
        ),
     ] ),
    );
  }
  Widget imagearticle()
  {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 80.0,
            backgroundImage:_imageFile==null? AssetImage("images/admins.png"):FileImage(File(_imageFile.path)),
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
  Widget UsersImage() {
    return StreamBuilder<QuerySnapshot>(
      stream: store.loadUsers(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<User> Users = [];
          for (var doc in snapshot.data.docs) {
            var data = doc.data();

            //if(data[KUsersMail]==_auth.inputData()){
            Users.add(User(
                uId: doc.id,
                uMail: data[KUsersMail],
                uName: data[KUsersName],
                uPrenom: data[KUsersPrenom],
                uRole: data[KUsersRole],
                uImage: data[KUsersImage]
            ));
          }

          if(Users.length==0){return Center(child: Text('no users  '));}
          return Image(  image: AssetImage(Users[1].uImage),);
        }
        else {
          return Center(child: Text('Loading...'));
        }
      },
    );
  }
}
