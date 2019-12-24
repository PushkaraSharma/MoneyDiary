import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class CustomDialog extends StatelessWidget {
  final String title,descrip,primaryButtonText,primaryButtonRoute,secondButtonText,secondButtonRoute;
  final primaryColor = const Color(0xFFF48FB1);
  CustomDialog({
    @required this.title,
    @required this.descrip,
    @required this.primaryButtonRoute,
    @required this.primaryButtonText,
    this.secondButtonRoute,this.secondButtonText
});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Stack(children: <Widget>[
        Container(
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 20
              )
            ]
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 20,),
              AutoSizeText(
                title,maxLines: 2,textAlign: TextAlign.center,style: TextStyle(color: primaryColor,fontSize: 28.0,fontWeight:FontWeight.w600),
              ),
              SizedBox(height: 15,),
              AutoSizeText(
                descrip,maxLines: 4,textAlign: TextAlign.center,style: TextStyle(color:Colors.grey,fontSize: 18.0),
              ),
              SizedBox(height: 20,),
              RaisedButton(
                color: primaryColor,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10,5,10,5),
                  child: AutoSizeText(primaryButtonText,maxLines:1,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                ),
                onPressed: (){
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacementNamed(primaryButtonRoute);
                },
              ),
              SizedBox(height: 10,),
              showSecondButton(context)
            ],
          ),
        )
      ],),
    );
  }

   showSecondButton(BuildContext context) {
    if(secondButtonRoute!=null && secondButtonText!=null){
    return FlatButton(
              child: AutoSizeText(secondButtonText,maxLines: 1,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w400),),
              onPressed: (){
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed(secondButtonRoute );
              },
            );
  }
  else{return SizedBox(height: 10.0,);}
  }
}
