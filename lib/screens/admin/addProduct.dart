import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/Widgets/custom_textfield.dart';
import 'package:e_commerce/models/User.dart';
import 'package:e_commerce/models/product.dart';
import 'package:e_commerce/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce/services/store.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Constants.dart';
import '../login_screen.dart';
import 'addAdmin.dart';
import 'adminHome.dart';
import 'manageProduct.dart';
import 'orderScreen.dart';
// ignore: must_be_immutable
class AddProduct extends StatefulWidget {
  static String id='AddProduct';

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final Store store =Store();

  int _bottomBarIndex = 0;

  final _auth = Auth();

  List<User> _Users;

  String name,price,description,category,imagelocation;

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
        await _auth.signOut();
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
        children:[ Container( decoration: BoxDecoration(
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
                Text('Add Product',style:TextStyle( fontWeight:FontWeight.bold,fontSize: 20, color:Colors.white),),
                SizedBox(height: height*.01,),
                CustomTextField(onClick: (value){name=value;}, icon: null, hint: 'Product Name'),
                SizedBox(height: height*.01,),
                CustomTextField(onClick: (value){price=value;}, icon: null, hint: 'Product Price'),
                SizedBox(height: height*.01,),
                CustomTextField(onClick: (value){description=value;}, icon: null, hint: 'Product Description'),
                SizedBox(height: height*.01,),
                CustomTextField(onClick: (value){category=value;}, icon: null, hint: 'Product Category'),
                SizedBox(height: height*.01,),
                CustomTextField(onClick: (value){imagelocation=value;}, icon: null, hint: 'Product Location'),
                SizedBox(height: height*.02,),
                RaisedButton(onPressed: ()
                {
                  if(globalKey.currentState.validate())
                  {
                    globalKey.currentState.save();
                    store.addProduct(Product(pName: name,pPrice :price,pDescription: description,pLocation :imagelocation,pCategory: category));
                  }
                },child: Text('Add Product'),)
              ],
            ),
          ),
        ),
      ]),
    );
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
