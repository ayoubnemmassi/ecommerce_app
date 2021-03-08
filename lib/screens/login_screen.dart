import 'package:e_commerce/Widgets/custom_logo.dart';
import 'package:e_commerce/Widgets/custom_textfield.dart';
import 'package:e_commerce/provider/adminMode.dart';
import 'package:e_commerce/provider/modelhud.dart';
import 'package:e_commerce/screens/admin/adminHome.dart';
import 'package:e_commerce/screens/homepage_screen.dart';
import 'package:e_commerce/screens/signup_screen.dart';
import 'package:e_commerce/user/userHome.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce/Constants.dart';
import 'package:e_commerce/services/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class LoginScreen extends StatefulWidget {
  static String id = 'LoginScreen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email, password;

  final auth = Auth();

  final GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  final adminPassword = 'yugigx1998';

  bool keepMeLoggedIn=false;

  bool isAdmin = false;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(

      backgroundColor: Colors.white,
      body: Container( decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/bw.png'),
          fit: BoxFit.cover,
        ),
      ),
        child: ModalProgressHUD(

          inAsyncCall: Provider.of<ModelHud>(context).isLoading,
          child: Form(
            key: globalKey,
            child: ListView(
              children: [
                CustomLogoWidget(),
                SizedBox(
                  height: height * .05,
                ),
                CustomTextField(
                  onClick: (value) {
                    email = value;
                  },
                  hint: 'Enter your email',
                  icon: Icons.email,
                ),
                SizedBox(
                  height: height * .03,
                ),
                CustomTextField(
                  onClick: (value) {
                    password = value;
                  },
                  hint: 'Enter your password',
                  icon: Icons.lock,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Row(
                    children: [

                      Theme(
                        data:ThemeData(unselectedWidgetColor: Colors.blue),
                        child: Checkbox(checkColor: Colors.black,
                            activeColor: Colors.white,
                            value: keepMeLoggedIn, onChanged: (value){setState(() {keepMeLoggedIn=value;

                            }); }),
                      ),
                      Stack(children: [Text('Remember Me',style: TextStyle( foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 2
                        ..color = Colors.black,
                      fontSize: 16),
                      ),
                      Text('Remember Me',style: TextStyle(color: Colors.white,fontSize: 16),)
                    ]
                  )
                    ],
                  ),
                ),
                SizedBox(
                  height: height * .05,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 120),
                  child: Builder(
                    builder: (context) => FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        onPressed: () {
                          if(keepMeLoggedIn)
                          {
                            keepUserLoggedIn();
                          }
                          validate(context);
                        },
                        color: Colors.black,
                        child: Text(
                          'Login',
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                ),
                SizedBox(
                  height: height * .04,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'don\'t have an account ?',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    SizedBox(
                      width: width * .02,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, SignupScreen.id);
                      },
                      child: Text(
                        'Signup',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: height * .02,
                ),
                Row(
                  children: [
                          SizedBox(width: MediaQuery.of(context).size.width*.2,),
                    GestureDetector(onTap: () {
                      final adminmode =
                      Provider.of<AdminMode>(context, listen: false);
                      adminmode.changeIsAdmin(true);
                    },
                      child: Column(
                        children: [
                          Icon(Icons.person,color: Provider.of<AdminMode>(context).isAdmin
                          ? Colors.black
                          : Colors.grey,),
                          Text(
                            'i\'m an admin',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Provider.of<AdminMode>(context).isAdmin
                                    ? Colors.black
                                    : Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width*.25,),
                    GestureDetector( onTap: () {
                      final adminmode =
                      Provider.of<AdminMode>(context, listen: false);
                      adminmode.changeIsAdmin(false);
                    },
                      child: Column(
                        children: [
                          Icon(Icons.person ,color:  Provider.of<AdminMode>(context).isAdmin
                              ? Colors.grey
                              : Colors.black,),
                          Text(
                          'i\'m a user',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Provider.of<AdminMode>(context).isAdmin
                                ? Colors.grey
                                : Colors.black),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> validate(BuildContext context) async {
    final modelhud = Provider.of<ModelHud>(context, listen: false);
    modelhud.changeisLoading(true);
    if (globalKey.currentState.validate()) {
      globalKey.currentState.save();
      if (Provider.of<AdminMode>(context,listen: false).isAdmin) {
        if (password == adminPassword) {
          try {
              await auth.signIn(email.trim(), password.trim());
            modelhud.changeisLoading(false);
            Navigator.pushNamed(context, AdminHome.id);
          } catch (e) {
            modelhud.changeisLoading(false);
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(e.message),
            ));
          }
        } else {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text('Something went wrong !'),
          ));
        }
      } else {
        try {
         await auth.signIn(email.trim(), password.trim());
          modelhud.changeisLoading(false);
          Navigator.pushNamed(context, UserHome.id);
        } catch (e) {
          modelhud.changeisLoading(false);
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(e.message),
          ));
        }
      }
    }
    modelhud.changeisLoading(false);
  }

  void keepUserLoggedIn()async
  {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool(KKeepMeLoggedIn, keepMeLoggedIn);
  }
}
