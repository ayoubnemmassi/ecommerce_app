import 'package:e_commerce/Widgets/custom_textfield.dart';
import 'package:e_commerce/models/User.dart';
import 'package:e_commerce/provider/modelhud.dart';
import 'package:e_commerce/screens/homepage_screen.dart';
import 'package:e_commerce/screens/login_screen.dart';
import 'package:e_commerce/services/store.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce/services/auth.dart';

import '../Constants.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
// ignore: must_be_immutable
class SignupScreen extends StatelessWidget {
  final Store store =Store();
  static  String id='SignupScreen';
  final GlobalKey<FormState> globalKey=GlobalKey<FormState>();
String email,password,nom,prenom,role;
final auth =Auth();
  @override
  Widget build(BuildContext context) {
    double height =MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return  Scaffold(


        body: Container(
          decoration: BoxDecoration(
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
                  Padding(
                    padding: EdgeInsets.only(top:50),
                    child: Container(
                      height: MediaQuery.of(context).size.height*.2,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image(image: AssetImage('images/logos.png'),
                            color: Colors.white,

                          ),
                          Positioned(
                            bottom: 0,
                            child: Text(
                              'Shop it',
                              style: TextStyle(
                                  fontFamily: 'lobster',
                                  fontSize: 25,
                                color: Colors.white
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height:height*.05 ,
                  ),

                  CustomTextField(
                    onClick: (value)
                    {
                       nom=value;

                    },
                    hint: 'Enter your last name',
                    icon: Icons.person,
                  ),
                  SizedBox(
                    height:height*.03 ,
                  ),
                  CustomTextField(
                    onClick: (value)
                    {
                      prenom=value;

                    },
                    hint: 'Enter your first name',
                    icon: Icons.person,
                  ),
                  SizedBox(
                    height:height*.03 ,
                  ),
                  CustomTextField(
                    onClick: (value)
                    {
                      email=value;
                    },
                    hint: 'Enter your email',
                    icon: Icons.email,
                  ),
                  SizedBox(
                    height:height*.03 ,
                  ),
                  CustomTextField(
                    onClick: (value)
                    {
                      password=value;
                    },
                    hint: 'Enter your password',
                    icon: Icons.lock,
                  ),

                  SizedBox(
                    height:height*.07 ,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 120),

                    child: Builder(
                      builder: (context)=>FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)
                          ),
                          onPressed: ()async
                          {
                            final modelhud=Provider.of<ModelHud>(context,listen: false);
                            modelhud.changeisLoading(true);
                            if(globalKey.currentState.validate())
                            {
                              globalKey.currentState.save();
                              try
                              {
                                await auth.signUp(email.trim(), password.trim());
                                modelhud.changeisLoading(false);
                                Navigator.pushNamed(context, HomePage.id);
                                  store.addUser(User(uName: nom,uPrenom :prenom,uMail: email,uMdp :password,uImage: 'images/users.png',uRole: 'user'));
                              }catch(e)
                              {
                                modelhud.changeisLoading(false);
                                Scaffold.of(context).showSnackBar(SnackBar
                                  (content: Text(
                                  e.message
                                ),
                                ));

                              }

                            }modelhud.changeisLoading(false);
                             },
                          color: Colors.black,
                          child: Text(
                            'Login',
                            style: TextStyle(
                                color: Colors.white
                            ),

                          )
                      ),
                    ),
                  ),
                  SizedBox(
                    height:height*.04 ,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Do have an account ?',
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16
                        ),
                      ),
                      SizedBox(
                        width: width * .02,
                      ),
                      GestureDetector(
                        onTap:(){ Navigator.pushNamed(context, LoginScreen.id);},
                        child: Text('Login',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16
                          ),
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
}
