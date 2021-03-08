import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/Constants.dart';
import 'package:e_commerce/models/User.dart';
import 'package:e_commerce/screens/admin/addAdmin.dart';
import 'package:e_commerce/screens/admin/addProduct.dart';
import 'package:e_commerce/screens/admin/orderScreen.dart';
import 'package:e_commerce/screens/admin/users.dart';
import 'package:e_commerce/screens/homepage_screen.dart';
import 'package:e_commerce/services/auth.dart';
import 'package:e_commerce/services/store.dart';
import 'package:e_commerce/user/cartScreen.dart';
import 'package:e_commerce/user/productInfo.dart';
import 'package:e_commerce/user/userHome.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../functions.dart';
import '../login_screen.dart';
import 'manageProduct.dart';

class AdminHome extends StatefulWidget {
  static String id ='AdminHome';

  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  final _store = Store();

  int _bottomBarIndex = 0;

  final _auth = Auth();

  List<User> _Users;

  @override
  Widget build(BuildContext context) {
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
     body:  Container(
         decoration: BoxDecoration(
           image: DecorationImage(
             image: AssetImage('images/bw.png'),
             fit: BoxFit.cover,
           ),
         ),
         child: UsersView()
     ),

     /* body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: double.infinity,
          ),
          RaisedButton(
              onPressed: (){Navigator.pushNamed(context, AddProduct.id);},
            child: Text('Add Product'),
              ),
          RaisedButton(
              onPressed: (){Navigator.pushNamed(context, ManageProduct.id);},
            child: Text('Edit Product'),
              ),
          RaisedButton(
              onPressed: (){Navigator.pushNamed(context, OrdersScreen.id);},
            child: Text('View Product'),
              ),
        ],
      ),*/
    );
  }

  Widget UsersView() {
    return ListView(
      children:[ StreamBuilder<QuerySnapshot>(
        stream: _store.loadUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<User> Users = [];
            List<User> UsersNormal = [];
            for (var doc in snapshot.data.docs) {
              var data = doc.data();
              Users.add(User(
                  uId: doc.id,
                  uMail: data[KUsersMail],
                  uName: data[KUsersName],
                  uPrenom: data[KUsersPrenom],
                  uRole: data[KUsersRole],
                  uImage: data[KUsersImage]
              ));
            }
            _Users = [...Users];
            Users.clear();
            Users = getUserByCategory('admin', _Users);
            UsersNormal = getUserByCategory('user', _Users);
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(

                  children: [
                    GestureDetector(onTap:(){Navigator.pushNamed(context, UsersInfo.id,arguments: 'admin');} ,
                      child: Stack(

                        children:[
                          Opacity(
                            opacity: 1,
                            child: Container(

                              decoration: BoxDecoration(image:  DecorationImage(
                                image: AssetImage('images/silver.jpg'),
                                fit: BoxFit.cover,
                              ),
                                  shape: BoxShape.rectangle,color: Colors.blue, borderRadius: BorderRadius.circular(20)),
                              height: MediaQuery.of(context).size.height*.25,
                              width: MediaQuery.of(context).size.width*.5,

                            ),
                          ),
                          Positioned(
                          left: 35,
                          child: CircleAvatar(
                            radius: MediaQuery.of(context).size.height * .15 / 2,
                            backgroundImage: AssetImage(
                               'images/admins.png'),
                          ),
                        ),

                          Positioned(bottom: 0,
                            child: Opacity(opacity: .2,
                              child: Container(alignment: Alignment.center,

                                decoration: BoxDecoration(shape: BoxShape.rectangle,color: Colors.black,borderRadius: BorderRadius.only(bottomRight: Radius.circular(20),bottomLeft: Radius.circular(20))),
                                height: MediaQuery.of(context).size.height*.1,
                                width: MediaQuery.of(context).size.width*.5,
                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Text('Admins : ',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 25),),
                                    Text(Users.length.toString(),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 25),),

                                  ],
                                )
                              ),
                            ),
                          )
                        ]
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height*.05,),
                    GestureDetector(onTap:(){Navigator.pushNamed(context, UsersInfo.id,arguments: 'user');} ,
                      child: Stack(

                        children:[
                          Opacity(
                            opacity: 1,
                            child: Container(

                              decoration: BoxDecoration(image:  DecorationImage(
                                image: AssetImage('images/silver.jpg'),
                                fit: BoxFit.cover,
                              ),
                                  shape: BoxShape.rectangle,color: Colors.blue, borderRadius: BorderRadius.circular(20)),
                              height: MediaQuery.of(context).size.height*.25,
                              width: MediaQuery.of(context).size.width*.5,

                            ),
                          ),
                          Positioned(
                          left: 35,
                          child: CircleAvatar(
                            radius: MediaQuery.of(context).size.height * .15 / 2,
                            backgroundImage: AssetImage(
                               'images/users.png'),
                          ),
                        ),

                          Positioned(bottom: 0,
                            child: Opacity(opacity: .2,
                              child: Container(alignment: Alignment.center,

                                decoration: BoxDecoration(shape: BoxShape.rectangle,color: Colors.black,borderRadius: BorderRadius.only(bottomRight: Radius.circular(20),bottomLeft: Radius.circular(20))),
                                height: MediaQuery.of(context).size.height*.1,
                                width: MediaQuery.of(context).size.width*.5,
                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Text('Users : ',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 25),),
                                    Text(UsersNormal.length.toString(),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 25),),

                                  ],
                                )
                              ),
                            ),
                          )
                        ]
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(child: Text('Loading...'));
          }
        },
      ),
   ] );
  }
  Widget UsersImage() {
    return StreamBuilder<QuerySnapshot>(
      stream: _store.loadUsers(),
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
