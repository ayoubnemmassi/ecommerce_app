import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/models/User.dart';
import 'package:e_commerce/models/product.dart';
import 'package:e_commerce/screens/admin/addAdmin.dart';
import 'package:e_commerce/screens/admin/adminHome.dart';
import 'package:e_commerce/services/auth.dart';
import 'package:e_commerce/services/store.dart';
import 'package:e_commerce/user/cartScreen.dart';
import 'package:e_commerce/user/productInfo.dart';
import 'package:e_commerce/user/userHome.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Constants.dart';
import '../../functions.dart';
import '../login_screen.dart';
import 'addProduct.dart';
import 'manageProduct.dart';
import 'orderScreen.dart';

class UsersInfo extends StatefulWidget {
  static String id = 'UserInfo';
  @override
  _UsersInfoState createState() => _UsersInfoState();
}

class _UsersInfoState extends State<UsersInfo> {

  int _bottomBarIndex = 0;

  final _auth = Auth();
  final _store = Store();
  List<User> _Users;
  @override
  Widget build(BuildContext context) {
    String role=ModalRoute.of(context).settings.arguments;
    return
    DefaultTabController(length: 1,
      child: Scaffold(
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
          title: Text('Shop It',style: TextStyle(color: Colors.black),),
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
        body:         Container(decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/bw.png'),
            fit: BoxFit.cover,
          ),
        ),
            child: UsersView(role)),),
    );
  }

Widget getUsers(String ucategory)
  {
    return StreamBuilder<QuerySnapshot>(
        stream: _store.loadUsers(),
    builder: (context, snapshot) {
  if (snapshot.hasData) {
  List<User> Users = [];
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
  Users = getUserByCategory(ucategory, _Users);
  return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      childAspectRatio: .8,
  ),
      itemBuilder: (context, index) =>  DataTable(
      sortColumnIndex: 1,
      sortAscending: true,
      columns: <DataColumn>[
        DataColumn(
          label: Text("Company Name"),
        /*  onSort: (_, __) {
            setState(() {
              widget.photos.sort((a, b) => a.data["quote"]["companyName"]
                  .compareTo(b.data["quote"]["companyName"]));
            });
          },*/
        ),
        DataColumn(
          label: Text("Dividend Yield"),
         /* onSort: (_, __) {
            setState(() {
              widget.photos.sort((a, b) => a.data["stats"]["dividendYield"]
                  .compareTo(b.data["stats"]["dividendYield"]));
            });
          },*/
        ),

      ],
      rows: Users
          .map(
            (user) => DataRow(
          cells: [
            DataCell(
              Text(user.uMail),
            ),

            DataCell(
              Text(user.uRole),
            ),
          ],
        ),
      )
          .toList()),
    itemCount: Users.length,
  );
  } else {
          return Center(child: Text('Loading...'));
        }
        },

    );
  }

  Widget UsersView(String ucategory) {
    return StreamBuilder<QuerySnapshot>(
      stream: _store.loadUsers(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<User> Users = [];
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
         Users = getUserByCategory(ucategory, _Users);
         if(Users.length==0){return Center(child: Text('no users  '));}
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 4
            ),
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Stack(
                children: <Widget>[
                  Positioned(

                  child: Container( decoration: BoxDecoration(borderRadius: BorderRadius.circular(40), image: DecorationImage(image: AssetImage('images/silver.jpg') ,fit: BoxFit.cover)),
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    height: 80,

                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '${Users[index].uName} ${Users[index].uPrenom}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10,),
                          Text(' ${Users[index].uMail}')
                        ],
                      ),
                    ),
                  ),
                ),
                  Positioned(
                    top: 5,
                    child: Image(
                      width: MediaQuery.of(context).size.width*.17,
                      fit: BoxFit.fill,
                      image: AssetImage(Users[index].uImage),
                    ),
                  ),
                  Positioned(
                    top: 17,
                    right: 0,
                    child: InkWell(onTap: (){_store.deleteUser(Users[index].uId);},borderRadius: BorderRadius.circular(25),splashColor: Colors.blueGrey,
                      child: Image(
                        width: MediaQuery.of(context).size.width*.1,
                        fit: BoxFit.fill,
                        image: AssetImage('images/delete1.png'),
                      ),
                    ),
                  ),


                ],
              ),
            ),

            itemCount: Users.length,
          );
        }
        else {
          return Center(child: Text('Loading...'));
        }
      },
    );
  }
 /* Widget bodyData() => DataTable(
      sortColumnIndex: 1,
      sortAscending: true,
      columns: <DataColumn>[
        DataColumn(
          label: Text("Company Name"),
        /*  onSort: (_, __) {
            setState(() {
              widget.photos.sort((a, b) => a.data["quote"]["companyName"]
                  .compareTo(b.data["quote"]["companyName"]));
            });
          },*/
        ),
        DataColumn(
          label: Text("Dividend Yield"),
         /* onSort: (_, __) {
            setState(() {
              widget.photos.sort((a, b) => a.data["stats"]["dividendYield"]
                  .compareTo(b.data["stats"]["dividendYield"]));
            });
          },*/
        ),
        DataColumn(
          label: Text("IEX Bid Price"),
         /* onSort: (_, __) {
            setState(() {
              widget.photos.sort((a, b) => a.data["quote"]["iexBidPrice"]
                  .compareTo(b.data["quote"]["iexBidPrice"]));
            });
          },*/
        ),
        DataColumn(
          label: Text("Latest Price"),
          /*onSort: (_, __) {
            setState(() {
              widget.photos.sort((a, b) => a.data["stats"]["latestPrice"]
                  .compareTo(b.data["stats"]["latestPrice"]));
            });
          },*/
        ),
      ],
      rows: widget.photos
          .map(
            (photo) => DataRow(
          cells: [
            DataCell(
              Text('${photo.data["quote"]["companyName"] ?? ""}'),
            ),
            DataCell(
              Text("Dividend Yield:"
                  '${photo.data["stats"]["dividendYield"] ?? ""}'),
            ),
            DataCell(
              Text("Last Price:"
                  '${photo.data["quote"]["iexBidPrice"] ?? ""}'),
            ),
            DataCell(
              Text("Last Price:"
                  '${photo.data["stats"]["latestPrice"] ?? ""}'),
            ),
          ],
        ),
      )
          .toList());*/
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
