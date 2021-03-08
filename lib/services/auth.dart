import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/Constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
class Auth
{
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final auth=FirebaseAuth.instance;
   Future<UserCredential> signUp(String email,String password) async
  {
    final authResult= await auth.createUserWithEmailAndPassword(email: email, password: password);
    return authResult;
  }
  Future<UserCredential> signIn(String email,String password) async
  {
    final authResult= await auth.signInWithEmailAndPassword(email: email, password: password);
    return authResult;
  }
  Future<void> signOut() async
  {
    auth.signOut();
  }
  Future<void> delete() async
  {
   auth.currentUser.delete();
  }

  Future<String> inputData() async {
    final User user = await auth.currentUser;

    return   user.email;

    // here you write the codes to input the data into firestore
  }
}