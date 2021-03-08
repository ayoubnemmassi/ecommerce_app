import 'package:flutter/material.dart';
import 'package:e_commerce/Constants.dart';
class CustomTextField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final Function onClick;
  final String initialvalue;
  // ignore: missing_return
  String errorMessage(String str)
  {
    switch(str)
    {
      case 'Enter your name': return 'Name is empty';
      case 'Enter your email': return 'email is empty';
      case 'Enter your password': return 'password is empty';
    }
  }
  CustomTextField({@required this.onClick ,@required this.icon,@required this.hint, this.initialvalue});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: TextFormField(
        initialValue: initialvalue,
        // ignore: missing_return
        validator:(value)
        {
          if(value.isEmpty)
            {

              return errorMessage(hint);

            }

        } ,
        onSaved:onClick,
        obscureText: hint=='Enter your password'?true:false,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(
            icon,
            color: Colors.black,
          ),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                  color: Colors.grey
              )
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                  color: Colors.grey
              )
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                  color: Colors.white
              )
          ),
        ),
      ),
    );
  }
}
