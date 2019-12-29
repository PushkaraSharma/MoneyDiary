import 'package:flutter/material.dart';
import 'package:money_diary/widgets/provider_widget.dart';
import 'package:money_diary/services/auth_services.dart';
import 'package:floating_search_bar/floating_search_bar.dart';
import 'package:money_diary/inner_views/homePage.dart';
import 'package:money_diary/inner_views/Page2.dart';

final primaryColor = const Color(0xFFF48FB1);

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int _currentIndex = 0;
  final List<Widget> _children = [
    HomePage(),Page2(),Page3(),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(accountName: Text('User'), accountEmail: Text('user@gmail.com'),
                decoration: BoxDecoration(color: primaryColor)),
            new ListTile(title: Text('Logout'), leading: Icon(Icons.person),
              onTap: () async {
                try {
                  AuthService auth = Provider.of(context).auth;
                  await auth.signOut();
                  print('Signed Out');
                } catch (e) {
                  print(e.toString());}
              },),
            ListTile(title: Text('Convert User'),leading: Icon(Icons.verified_user),trailing: Icon(Icons.arrow_forward_ios),
              onTap: () async {
                final auth = Provider.of(context).auth;
                bool val = await auth.checkAnonUser();
                if (val) {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed('/convertUser');
                }
                else {
                }
              },),
            ListTile(title: Text('Settings'),leading: Icon(Icons.settings),trailing: Icon(Icons.arrow_forward_ios),onTap: () {},),

          ],
        )),

      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0.0,
        title: Text('Home'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search),onPressed: (){},)
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTapTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(icon: new Icon(Icons.home),title: new Text('Home')),
          BottomNavigationBarItem(icon: new Icon(Icons.explore),title: new Text('Explore')),
          BottomNavigationBarItem(icon: new Icon(Icons.graphic_eq),title: new Text('Stats')),
        ],
      ),
      body: _children[_currentIndex],
    );
  }

  void onTapTapped(int index){
    setState(() =>_currentIndex = index);
  }


}





