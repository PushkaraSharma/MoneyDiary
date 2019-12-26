import 'package:flutter/material.dart';
import 'package:money_diary/services/auth_services.dart';
import 'package:money_diary/starting_views/first_view.dart';
import 'package:money_diary/home.dart';
import 'package:money_diary/starting_views/signup_view.dart';
import 'package:money_diary/widgets/provider_widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider(
      auth: AuthService(),
      child: MaterialApp(
        title: "Money Diary",
        theme: ThemeData(
          primarySwatch: Colors.lightBlue,
        ),
        home: Home_Control(),
        routes: <String,WidgetBuilder>{
          '/home':(BuildContext context)=>Home_Control(),
          '/signUp':(BuildContext context)=>Signup_view(authFormType: AuthFormType.signUp,),
          '/signIn':(BuildContext context)=>Signup_view(authFormType: AuthFormType.signIn,),
          '/anonmousSignIn':(BuildContext context)=>Signup_view(authFormType: AuthFormType.anonmous,),
          '/convertUser':(BuildContext context)=>Signup_view(authFormType: AuthFormType.convertuser,),
        }
      ),
    );
  }
}

class Home_Control extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthService auth = Provider.of(context).auth;
    return StreamBuilder(
      stream: auth.onAuthStateChanged,
      builder: (context,AsyncSnapshot<String> snapshot){
        if(snapshot.connectionState == ConnectionState.active){
          final bool signIn = snapshot.hasData;
          return signIn ? Home():FirstView();
        }
        return CircularProgressIndicator();
      },
    );
  }
}

