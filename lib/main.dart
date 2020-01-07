import 'package:flutter/material.dart';
import 'package:money_diary/services/auth_services.dart';
import 'package:money_diary/starting_views/first_view.dart';
import 'package:money_diary/inner_views/home.dart';
import 'package:money_diary/starting_views/signup_view.dart';
import 'package:money_diary/widgets/provider_widget.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  @override
  void initState(){
    super.initState();
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid = new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: onSelectNotification);
    _showNotification();
  }
  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => new AlertDialog(
        title: new Text("Add Today's Earning"),
        content: new Text('Adding daliy earning will help to manage easy.'),
        actions: [
          FlatButton(
            child: new Text('Ok'),
            onPressed: ()  {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }
  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    await Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new Home_Control()),
    );
  }
  void _showNotification() async {
    var time = new Time(00, 36, 0);
    var androidPlatformChannelSpecifics =
    new AndroidNotificationDetails('repeatDailyAtTime channel id',
        'repeatDailyAtTime channel name', 'repeatDailyAtTime description',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics =
    new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        0,
        "Add Today's Earning",
        'Adding daliy earning will help to manage easy.',
        time,
        platformChannelSpecifics);
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      auth: AuthService(),
      child: MaterialApp(
        title: "Money Diary",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color(0xFFFFAB91),

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

