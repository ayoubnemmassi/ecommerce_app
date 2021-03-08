import 'package:flutter/material.dart';
class CustomLogoWidget extends StatelessWidget {
  const CustomLogoWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
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
              child: Stack(
                children: [Text(
                  ' Shop it',
                  style: TextStyle(
                      fontFamily: 'lobster',
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 2
                        ..color = Colors.black,
                      fontSize: 25,


                  ),
                ),
                  Text(
                    ' Shop it',
                    style: TextStyle(
                        fontFamily: 'lobster',
                        fontSize: 25,
                        color: Colors.white

                    ),
                  ),
                ]
              ),

            )
          ],
        ),
      ),
    );
  }
}

