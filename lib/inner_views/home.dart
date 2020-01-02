import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_diary/widgets/provider_widget.dart';
import 'package:money_diary/services/auth_services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:money_diary/inner_views/homePage.dart';
import 'package:money_diary/inner_views/Page2.dart';
import 'package:firebase_auth/firebase_auth.dart';

  final primaryColor = const Color(0xFFFFAB91);


class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseUser user;
  bool useranon;
  @override
  void initState(){
    super.initState();
    initUser();
  }
  initUser()async{
    user = await auth.currentUser();
    useranon = user.isAnonymous;
    setState(() {});
  }

  int _currentIndex = 0;
  final List<Widget> _children = [
    HomePage(),Page2(),Page3(),
  ];

  @override
  Widget build(BuildContext context) {
    return user==null?CircularProgressIndicator():Scaffold(
      drawer: new Drawer(
          child: new ListView(
            children: <Widget>[
              new UserAccountsDrawerHeader(accountName: Text(
                  '${(user?.displayName == null) ? 'User' : user
                      ?.displayName}'),
                  accountEmail: Text(
                      '${(user?.email == null) ? 'user email' : user?.email}'),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.blue[200],
                    backgroundImage: NetworkImage('${(user?.photoUrl == null)
                        ? 'https://www.nicepng.com/png/detail/933-9332131_profile-picture-default-png.png'
                        : user?.photoUrl}'),),
                  decoration: BoxDecoration(color: primaryColor)),
              new ListTile(title: Text('Logout'), leading: Icon(FontAwesomeIcons.signOutAlt),trailing: Icon(Icons.arrow_forward_ios),
                onTap: () async {
                  try {
                    AuthService auth = Provider.of(context).auth;
                    await auth.signOut();
                    print('Signed Out');
                  } catch (e) {
                    print(e.toString());
                  }
                },),
              showbutton(context),

              ListTile(title: Text('Settings'),
                leading: Icon(Icons.settings),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {},),
              /*ListTile(title: Text("Dark Mode"),
                trailing: Switch(value: false,
                  onChanged: (changeTheme){},),)
*/
            ],
          )),

      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        brightness: Brightness.dark,
        elevation: 0.0,
        title: Text('Home'),centerTitle: true,
        actions: <Widget>[
         // IconButton(icon: Icon(Icons.search), onPressed: () {},)
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTapTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
              icon: new Icon(Icons.home), title: new Text('Home')),
          BottomNavigationBarItem(
              icon: new Icon(Icons.explore), title: new Text('Explore')),
          BottomNavigationBarItem(
              icon: new Icon(FontAwesomeIcons.chartBar), title: new Text('Stats')),
        ],
      ),
      body: _children[_currentIndex],
    );

  }
  showbutton(BuildContext context){
    if(useranon) {
      return
        ListTile(title: Text('Convert User'),
          leading: Icon(Icons.verified_user),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: () async {
            final auth = Provider.of(context).auth;
            bool val = await auth.checkAnonUser();
            if (val) {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed('/convertUser');
            }
            else {}
          },);
        }
    else{return SizedBox(height: 0.0,);}
       }

  void onTapTapped(int index){
    setState(() =>_currentIndex = index);
  }


}





