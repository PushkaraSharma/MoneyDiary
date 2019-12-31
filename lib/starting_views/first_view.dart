import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:money_diary/widgets/custom_dialog_alert.dart';

class FirstView extends StatelessWidget {
  final primaryColor = const Color(0xFFF48FB1);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height =  MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: width,
        height: height,
        color: primaryColor,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: <Widget>[
                SizedBox(height: height*0.1,),
                Text('Welcome',style: TextStyle(fontSize: 46,fontWeight: FontWeight.bold,color: Colors.white,fontFamily: 'Cinzel'),),
                SizedBox(height: height*0.1,),
                AutoSizeText('Lets put your daily earnings',maxLines: 2,textAlign: TextAlign.center,style: TextStyle(fontSize: 38,color: Colors.white,fontFamily: 'Raleway'),),
                SizedBox(height: height*0.1,),
                RaisedButton(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(30,15,30,15),
                    child: Text('Lets Begin',style: TextStyle(color: primaryColor,fontWeight: FontWeight.w600,fontSize: 30,fontFamily: 'Cinzel'),),
                  ),
                  onPressed: (){
                    showDialog(context: context,builder: (BuildContext context)=>CustomDialog(title: 'Create free account',
                        descrip: 'With an account all your data will be saved securly,allowing you to access from multiple devices',
                        primaryButtonRoute: '/signUp', primaryButtonText: "Create My Account",
                        secondButtonText: 'Maybe Later',secondButtonRoute: "/anonmousSignIn",));
                  },
                ),
                SizedBox(height: height*0.1,),
                FlatButton(
                  child: Text('Sign In',style: TextStyle(fontSize: 25,fontFamily: 'Cinzel'),),
                  onPressed: (){
                    Navigator.of(context).pushReplacementNamed('/signIn');
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
