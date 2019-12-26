import 'package:flutter/material.dart';
import 'package:money_diary/widgets/provider_widget.dart';
import 'package:money_diary/services/auth_services.dart';


class Home extends StatelessWidget {
  final primaryColor = const Color(0xFFF48FB1);
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height =  MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(title: Text('Home',),
      backgroundColor: Colors.lightBlue[300],
      actions: <Widget>[
        IconButton(icon: Icon(Icons.undo),
          onPressed: () async{
          try{
            AuthService auth  = Provider.of(context).auth;
            await auth.signOut();
            print('Signed Out');
          }catch(e)
          {print(e.toString());}
        }
        ),
    IconButton(icon: Icon(Icons.account_circle),
    onPressed: (){
      Navigator.of(context).pushNamed('/convertUser');
      }
    )


      ],
      ),
      body: Container(
        height: height,width: width,
        color: primaryColor,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              children: <Widget>[
                SizedBox(height: height*0.2,),
                Text('Home Ideas',style: TextStyle(fontSize: 40),)
              ],
            ),
          ),
        ),
      ),

    );
  }
}
