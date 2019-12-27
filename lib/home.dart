import 'package:flutter/material.dart';
import 'package:money_diary/widgets/provider_widget.dart';
import 'package:money_diary/services/auth_services.dart';
import 'package:floating_search_bar/floating_search_bar.dart';

final primaryColor = const Color(0xFFF48FB1);

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

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
      body: ListView(
        children: <Widget>[

          SizedBox(height: 25.0),
          Padding(
            padding: EdgeInsets.only(left: 40.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text('WELCOME',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25.0)),
                    SizedBox(width: 10.0),
                    Text('BACK', style: TextStyle(color: Colors.white, fontSize: 25.0))
                  ],
                ),
                SizedBox(height:10.0),
                Text('PUSHKARA', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 40.0))
              ],
            ),
          ),
          SizedBox(height: 40.0),
          Container(
            height: MediaQuery.of(context).size.height - 185.0,
            decoration: BoxDecoration(color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(75.0)),
            ),
            child: ListView(
              primary: false,
              padding: EdgeInsets.only(left: 25.0, right: 20.0),
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(top: 45.0),
                    child: Container(
                        height: MediaQuery.of(context).size.height - 30.0,
                        child: ListView(children: [
                          _builddate('21/12/2019', 'Description', '2400'),
                          _builddate('21/12/2019', 'Description', '2400'),
                          _builddate('21/12/2019', 'Description', '2400'),
                          _builddate('21/12/2019', 'Description', '2400'),
                          _builddate('21/12/2019', 'Description', '2400'),
                          _builddate('21/12/2019', 'Description', '2400'),
                          _builddate('21/12/2019', 'Description', '2400'),
                          _builddate('21/12/2019', 'Description', '2400'),
                          _builddate('21/12/2019', 'Description', '2400'),
                          _builddate('21/12/2019', 'Description', '2400'),
                          _builddate('21/12/2019', 'Description', '2400'),
                          _builddate('21/12/2019', 'Description', '2400'),
                          _builddate('21/12/2019', 'Description', '2400'),
                          _builddate('21/12/2019', 'Description', '2400'),



                        ]))),
              ],
            ),
          )
        ],
      ),
    );
  }



  Widget _builddate(String date, String desription, String earned) {
    return Padding(
        padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
        child: InkWell(
            onTap: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                    child: Row(
                        children: [
                         Text('Date'),
                          SizedBox(width: 10.0),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:[
                                Text(desription, style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold)),
                                Text(desription, style: TextStyle(fontSize: 15.0, color: Colors.grey))
                              ]
                          )]
                    )
                ),
                IconButton(
                    icon: Icon(Icons.edit),
                    color: Colors.black,
                    onPressed: () {}
                    )
              ],
            )
        ));
  }

}





