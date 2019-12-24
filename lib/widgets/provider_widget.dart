import 'package:flutter/material.dart';
import 'package:money_diary/services/auth_services.dart';

class Provider extends InheritedWidget{
  final AuthService auth;
  Provider({Key key,Widget child,this.auth}):super(key:key,child:child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget){
    return true;
  }

  static Provider of(BuildContext context)=>(context.inheritFromWidgetOfExactType(Provider)as Provider);
}