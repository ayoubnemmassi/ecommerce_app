import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/Constants.dart';
import 'package:e_commerce/functions.dart';
import 'package:e_commerce/models/User.dart';
import 'package:e_commerce/models/product.dart';
import 'package:e_commerce/screens/admin/addProduct.dart';
import 'package:e_commerce/screens/admin/orderScreen.dart';
import 'package:e_commerce/screens/homepage_screen.dart';
import 'package:e_commerce/screens/login_screen.dart';
import 'package:e_commerce/services/auth.dart';
import 'package:e_commerce/services/store.dart';
import 'package:e_commerce/user/cartScreen.dart';
import 'package:e_commerce/user/product.dart';
import 'package:e_commerce/user/productInfo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

//import 'manageProduct.dart';

class UserHome extends StatefulWidget {
  static String id ='UserHome';

  @override

  _UserHomeState createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  final _auth = Auth();
  // FirebaseUser _loggedUser;
  int _tabBarIndex = 0;
  int _bottomBarIndex = 0;
  final _store = Store();
  static String cat;
  List<Product> _products;
  List<User> _Users;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Stack(
      children:[
      DefaultTabController(
        length: 4,
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
              else if(value==0){Navigator.pushNamed(context, UserHome.id);}
              else if(value==1){Navigator.pushNamed(context, CartScreen.id);}
              setState(() {
                _bottomBarIndex = value;
              });
            },
            items: [
              BottomNavigationBarItem(
                  title: Text('My Space'), icon: Icon(Icons.person)),
              BottomNavigationBarItem(
                  title: Text('Cart'), icon: Icon(Icons.shopping_cart)),
              BottomNavigationBarItem(
                  title: Text('Sign Out'), icon: Icon(Icons.close)),
            ],
          ),
          appBar: AppBar(

            backgroundColor: Colors.white,

            iconTheme: IconThemeData(color: Colors.black),
            elevation: 0,


            title : TabBar(
              indicatorColor: KMainColor,
              onTap: (value) {
                setState(() {
                  _tabBarIndex = value;
                });
              },
              tabs: <Widget>[

                Image(image: AssetImage('images/clothes.png'),
                  color: _tabBarIndex == 0 ? Colors.black : KUnActiveColor,),

            Image(image: AssetImage('images/devices.png'), color: _tabBarIndex == 1 ? Colors.black : KUnActiveColor),
            Image(image: AssetImage('images/sports.png'),color: _tabBarIndex == 2 ? Colors.black : KUnActiveColor),

                Image(image: AssetImage('images/couch.png'),color: _tabBarIndex == 3 ? Colors.black : KUnActiveColor),
              ],
            ),

          ),
          body: TabBarView(
            children: <Widget>[
              categories('clothes',context),
              categories('devices',context),
              categories('sport',context),
              categories('home',context),




            ],
          ),
          drawer: new Drawer(

            child: new ListView(
              children: <Widget>[
                //header
                new UserAccountsDrawerHeader(
                  accountEmail: FutureBuilder<String>(
                      future: _auth.inputData(),
                      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                        if (snapshot.hasData) {
                          return Text(snapshot.data);
                        }
                        else {
                          return Text("Loading user data...");
                        }

                      }
                  ),
                  currentAccountPicture:GestureDetector(child: new CircleAvatar(
                    backgroundColor: KSeconddaryColor,
                    child: UsersImage(),
                  ),
                  ) ,
                  decoration: new BoxDecoration(
                      image: DecorationImage(image: AssetImage('images/black.jpg'))
                  ),
                ),
//                  body
                InkWell(
                  onTap: (){Navigator.pushNamed(context, UserHome.id);},
                  child: ListTile(
                    title: Text('Home Page'),
                    leading: Icon(Icons.home,size: 30,),
                  ),
                ),

                InkWell(
                  onTap: (){Navigator.pushNamed(context, CartScreen.id);},
                  child: ListTile(
                    title: Text('View Cart'),
                    leading: Icon(Icons.shopping_basket,size: 30,),
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
        ),
      ),

    ],
    );
  }

@override
void initState() {
  getCurrenUser();
}

Future<String> getCurrenUser() async {
return  _auth.inputData();
}
Widget categories(String cat,BuildContext context)
{
  double width = MediaQuery.of(context).size.width;
  List<String> images =new List();
  List<String> ID =new List();

  if(cat=='clothes'){images.add('jbg.jpg');images.add('tbg.jpg');images.add('tsbg.jpg');images.add('sbg.jpg');
  ID.add('jackets');ID.add('trousers');ID.add('t-shirts');ID.add('shoes');
  }
 else if(cat=='sport'){images.add('jsbg.jpg');images.add('psbg.jpg');images.add('tssbg.jpg');images.add('ssbg.jpg');
  ID.add('sjackets');ID.add('spants');ID.add('st-shirts');ID.add('sshoes');
  }
  else if(cat=='home'){images.add('kbg.jpg');images.add('brbg.jpg');images.add('lrbg.jpg');images.add('bathbg.jpg');
  ID.add('kitchen');ID.add('bedroom');ID.add('living room');ID.add('bathroom');
  }
  else if(cat=='devices'){images.add('pbg.jpg');images.add('tabg.jpg');images.add('cbg.jpg');images.add('swbg.jpg');
  ID.add('Phones');ID.add('tablets');ID.add('Computers');ID.add('Smart Watches');
  }
  return Padding(
    padding: const EdgeInsets.all(20.0),
    child: ListView(

      children:[ SizedBox(height: MediaQuery.of(context).size.height*.03,),
        Column
        (
        mainAxisAlignment: MainAxisAlignment.center,

        children: [

          Container(
            height:MediaQuery.of(context).size.height * .15 ,
            decoration: BoxDecoration( image:  DecorationImage(
              image: AssetImage('images/${images.elementAt(0)}'),
              fit: BoxFit.cover,
            ),
              borderRadius: BorderRadius.circular(12), color: Color(0xFFB7C3CD),),
            child: InkWell(

              onTap: (){Navigator.pushNamed(context, ProductPage.id,arguments:ID.elementAt(0));},
              child: ListTile(
                title: Stack(
                  children:[Text('${ID.elementAt(0)}', style: TextStyle(
                      fontFamily: 'lobster',
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 2
                        ..color = Colors.black,
                      fontSize: 26,
                      //color: Colors.white

                  ),),
                    Text('${ID.elementAt(0)}', style: TextStyle(
                        fontFamily: 'lobster',

                        fontSize: 25,
                        color: Colors.white

                    ),),
              ]
                ),

              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * .03,
          ),

          Container(
            height:MediaQuery.of(context).size.height * .15 ,
            decoration: BoxDecoration( image:  DecorationImage(
              image: AssetImage('images/${images.elementAt(1)}'),
              fit: BoxFit.cover,
            ),
              borderRadius: BorderRadius.circular(12), color: Color(0xFFB7C3CD),),

            child: InkWell(
              onTap: (){Navigator.pushNamed(context, ProductPage.id,arguments:ID.elementAt(1));},
              child: ListTile(
                title:  Stack(
                    children:[Text('${ID.elementAt(1)}', style: TextStyle(
                      fontFamily: 'lobster',
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 2
                        ..color = Colors.black,
                      fontSize: 26,
                      //color: Colors.white

                    ),),
                      Text('${ID.elementAt(1)}', style: TextStyle(
                          fontFamily: 'lobster',

                          fontSize: 25,
                          color: Colors.white

                      ),),
                    ]
                ),

              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * .03,
          ),

          Container(
            height:MediaQuery.of(context).size.height * .15 ,
            decoration: BoxDecoration( image:  DecorationImage(
              image: AssetImage('images/${images.elementAt(2)}'),
              fit: BoxFit.cover,
            ),
              borderRadius: BorderRadius.circular(12), color: Color(0xFFB7C3CD),),
            child: InkWell(
              onTap: (){Navigator.pushNamed(context, ProductPage.id,arguments:ID.elementAt(2));},
              child: ListTile(
                title:  Stack(
                    children:[Text('${ID.elementAt(2)}', style: TextStyle(
                      fontFamily: 'lobster',
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 2
                        ..color = Colors.black,
                      fontSize: 26,
                      //color: Colors.white

                    ),),
                      Text('${ID.elementAt(2)}', style: TextStyle(
                          fontFamily: 'lobster',

                          fontSize: 25,
                          color: Colors.white

                      ),),
                    ]
                ),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * .03,
          ),

          Container(
            height:MediaQuery.of(context).size.height * .15 ,
            decoration: BoxDecoration( image:  DecorationImage(
              image: AssetImage('images/${images.elementAt(3)}'),
              fit: BoxFit.cover,
            ),
              borderRadius: BorderRadius.circular(12), color: Color(0xFFB7C3CD),),
            child: InkWell(
              onTap: (){Navigator.pushNamed(context, ProductPage.id,arguments:ID.elementAt(3));},
              child: ListTile(
                title: Stack(
                    children:[Text('${ID.elementAt(3)}', style: TextStyle(
                      fontFamily: 'lobster',
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 2
                        ..color = Colors.black,
                      fontSize: 26,
                      //color: Colors.white

                    ),),
                      Text('${ID.elementAt(3)}', style: TextStyle(
                          fontFamily: 'lobster',

                          fontSize: 26,
                          color: Colors.white

                      ),),
                    ]
                ),

              ),
            ),
          ),
        ],
      ),
    ]),
  );
}
Widget jacketView(String pcategory) {

  return StreamBuilder<QuerySnapshot>(
    stream: _store.loadProduct(),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        List<Product> products = [];
        for (var doc in snapshot.data.docs) {
          var data = doc.data();
          products.add(Product(
              pId: doc.id,
              pPrice: data[KProductsPrice],
              pName: data[KProductsName],
              pDescription: data[KProductsDescription],
              pLocation: data[KProductsLocation],
              pCategory: data[KProductsCategory]));
        }
        _products = [...products];
        products.clear();
        products = getProductByCategory(pcategory, _products);
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: .8,
          ),
          itemBuilder: (context, index) => Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, ProductInfo.id,
                    arguments: products[index]);
              },
              child: Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: Image(
                      fit: BoxFit.fill,
                      image: AssetImage(products[index].pLocation),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Opacity(
                      opacity: .6,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 60,
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                products[index].pName,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
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
      } else {
        return Center(child: Text('Loading...'));
      }
    },
  );
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

