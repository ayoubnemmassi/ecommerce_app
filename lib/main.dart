import 'package:e_commerce/Constants.dart';
import 'package:e_commerce/models/User.dart';
import 'package:e_commerce/provider/adminMode.dart';
import 'package:e_commerce/provider/cartitem.dart';
import 'package:e_commerce/provider/modelhud.dart';
import 'package:e_commerce/screens/admin/addAdmin.dart';
import 'package:e_commerce/screens/admin/addProduct.dart';
import 'package:e_commerce/screens/admin/adminHome.dart';
import 'package:e_commerce/screens/admin/editProduct.dart';
import 'package:e_commerce/screens/admin/manageProduct.dart';
import 'package:e_commerce/screens/admin/orderScreen.dart';
import 'package:e_commerce/screens/admin/order_details.dart';
import 'package:e_commerce/screens/admin/users.dart';
import 'package:e_commerce/screens/homepage_screen.dart';
import 'package:e_commerce/screens/login_screen.dart';
import 'package:e_commerce/screens/signup_screen.dart';
import 'package:e_commerce/user/cartScreen.dart';
import 'package:e_commerce/user/product.dart';
import 'package:e_commerce/user/productInfo.dart';
import 'package:e_commerce/user/userHome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  bool isUserLoggedIn=false;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>
      (
      future: SharedPreferences.getInstance(),
      builder: (context,snapshot)
      {
        if(!snapshot.hasData)
        {
          return MaterialApp(home: Scaffold(body: Center(child: Text('Loading....'),),),);
        }else
          {
            isUserLoggedIn=snapshot.data.getBool(KKeepMeLoggedIn)??false;
            return MultiProvider(
              providers: [
                ChangeNotifierProvider<ModelHud>(
                  create: (context)=>ModelHud(),),
                ChangeNotifierProvider<AdminMode>(
                  create: (context)=>AdminMode(),),
                ChangeNotifierProvider<CartItem>(
                  create: (context)=>CartItem(),),
              ],
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                initialRoute: isUserLoggedIn ? UserHome.id: LoginScreen.id,
                routes:
                {
                  LoginScreen.id:(context)=>LoginScreen(),
                  SignupScreen.id:(context)=>SignupScreen(),
                  HomePage.id:(context)=>HomePage(),
                  AdminHome.id:(context)=>AdminHome(),
                  UserHome.id:(context)=>UserHome(),
                  AddProduct.id:(context)=>AddProduct(),
                  AddAdmin.id:(context)=>AddAdmin(),
                  ManageProduct.id:(context)=>ManageProduct(),
                  EditProduct.id:(context)=>EditProduct(),
                  ProductInfo.id:(context)=>ProductInfo(),
                  CartScreen.id:(context)=>CartScreen(),
                  OrdersScreen.id:(context)=>OrdersScreen(),
                  OrderDetails.id:(context)=>OrderDetails(),
                  ProductPage.id:(context)=>ProductPage(),
                  UsersInfo.id:(context)=>UsersInfo(),
                },
              ),
            );
          }
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
