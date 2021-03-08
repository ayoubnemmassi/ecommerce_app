import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/Constants.dart';
import 'package:e_commerce/Widgets/custom_menu.dart';
import 'package:e_commerce/models/User.dart';
import 'package:e_commerce/models/product.dart';
import 'package:e_commerce/screens/admin/editProduct.dart';
import 'package:e_commerce/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce/services/store.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../login_screen.dart';
import 'addAdmin.dart';
import 'addProduct.dart';
import 'adminHome.dart';
import 'orderScreen.dart';
class ManageProduct extends StatefulWidget {
  static String id ='manageproduct';

  @override
  _ManageProductState createState() => _ManageProductState();
}

class _ManageProductState extends State<ManageProduct> {
  final Store store=Store();
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
     
      body: StreamBuilder<QuerySnapshot>(
        stream:store.loadProduct() ,
        builder:(context,snapshot){
          if(snapshot.hasData){
            List<Product> products=[];
            for (var doc in snapshot.data.docs) {
              var data = doc.data();
              products.add(Product(
                  pId: doc.id,
                  pName: data[KProductsName],
                  pPrice:  data[KProductsPrice],
                  pDescription:  data[KProductsDescription],
                  pLocation:  data[KProductsLocation],
                  pCategory:  data[KProductsCategory]));
            }
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: .8,
              ),
              itemBuilder:(context,index)=>Padding(
                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                child: GestureDetector(
                  onTapUp: (details)
                  async {
                   double dx=details.globalPosition.dx;
                   double dy=details.globalPosition.dy;
                   double dx2=MediaQuery.of(context).size.width-dx;
                   double dy2=MediaQuery.of(context).size.height-dy;
                    await showMenu(
                        context: context,
                        position: RelativeRect.fromLTRB(dx, dy, dx2, dy2),
                        items: [
                          MyPopupMenuItem(onClick:(){Navigator.pushNamed(context, EditProduct.id,arguments: products[index]);} ,
                              child: Text('Edit')
                          ),
                          MyPopupMenuItem(onClick: (){store.deleteProduct(products[index].pId);
                          Navigator.pop(context);
                          },
                              child: Text('Delete')
                          )
                        ]
                    );
                  },
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image(
                          fit: BoxFit.fill,
                          image:AssetImage(products[index].pLocation),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: Opacity(
                          opacity: .6,
                          child: Container(
                            height: 60,
                            width: MediaQuery.of(context).size.width,
                            color: Colors.white,
                            child:Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                               child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(products[index].pName,style: TextStyle(fontWeight:FontWeight.bold ),),
                                  Text('\$ ${products[index].pPrice}')
                              ],
                            ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            itemCount: products.length,
          );
          }
          else{return Center(child: Text('Loading.....'));}
        
        },
      ),
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
