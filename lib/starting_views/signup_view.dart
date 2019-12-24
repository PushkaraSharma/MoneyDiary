
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:money_diary/services/auth_services.dart';
import 'package:money_diary/widgets/provider_widget.dart';


final primaryColor = const Color(0xFFF48FB1);
enum AuthFormType{signIn,signUp}

class Signup_view extends StatefulWidget {

  final AuthFormType authFormType;
  Signup_view({Key key,@required this.authFormType}):super(key:key);

  @override
  _Signup_viewState createState() => _Signup_viewState(authFormType: this.authFormType);
}

class _Signup_viewState extends State<Signup_view> {


  AuthFormType authFormType;
  _Signup_viewState({this.authFormType});

  final formkey = GlobalKey<FormState>();
  String email, password,name,error;

  void switchFromState(String state){
    formkey.currentState.reset();
    if(state =='SignUp'){
      setState(()=>authFormType = AuthFormType.signUp);
    }
    else{
      setState(()=> authFormType = AuthFormType.signIn);
    }
  }
  bool validate(){
    final form = formkey.currentState;
    //form.save();
    if(form.validate()){
      form.save();
      return true;
    }
    return false;
  }
  void submitForm() async{
    if(validate()) {
      try {
        //ask provider for authservice as it is highest
        final auth = Provider
            .of(context)
            .auth;

        if (authFormType == AuthFormType.signIn) {
          String uid = await auth.signInWithEmailAndPassword(email, password);
          print('Sign In $uid');
          Navigator.of(context).pushReplacementNamed('/home');
        }
        else {
          String uid = await auth.createUserWithEmailAndPassword(
              email, password, name);
          print('Created account for $uid');
          Navigator.of(context).pushReplacementNamed('/home');
        }
      } catch (e) {
        setState(() =>error = e.message);
        print(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;


    return Scaffold(
      body: Container(
        color: primaryColor,
        height: height,
        width: width,
        
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: height * 0.025,),
                showAlertFromFirebase(),
                SizedBox(height: height * 0.025,),
                buildHeader(),
                SizedBox(height: height * 0.04,),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formkey,
                    child: Column(
                      children: inputforms()+buildSwitchButtons(),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget showAlertFromFirebase(){
    if(error!=null){
      return Container(
        color: Colors.red[300],
        width: double.infinity, //whole width of screen
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(Icons.error_outline),
            ),
            Expanded(child: AutoSizeText(error,maxLines: 2,),),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(icon: Icon(Icons.clear),
              onPressed: (){
                setState(()=>error = null);
              },),
            )
          ],
        ),
      );
    }
    return SizedBox(height: 0.0,);
  }
  AutoSizeText buildHeader() {
    String headerText;
    if(authFormType == AuthFormType.signUp){headerText = 'Create New Account';}
    else{headerText = 'Sign In';}
    return AutoSizeText(headerText, maxLines: 1,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 40, color: Colors.white),);
  }

  List<Widget> inputforms() {
    List<Widget> textfields = [];
    // If signup page so add name also
    if(authFormType == AuthFormType.signUp){
      textfields.add(TextFormField(
        validator: NameValidator.validate,
        style: TextStyle(fontSize: 20),
        decoration: buildinputDecoration('Name'),
        onSaved: (value)=> name =value,
      ),
      );
      textfields.add(SizedBox(height: 24,)
      );
    }

    //add email and password
    textfields.add(
      TextFormField(
        validator: EmailValidator.validate,
        style: TextStyle(fontSize: 20),
        decoration: buildinputDecoration('Email'),
        onSaved: (value)=> email=value,
      ),
    );
    textfields.add(
      SizedBox(height: 24,)
    );
    textfields.add(
        TextFormField(
          validator: PasswordValidator.validate,
          obscureText: true,
          style: TextStyle(fontSize: 20),
          decoration: buildinputDecoration('Password'),
          onSaved: (value)=> password=value,
        ),
    );

    return textfields;
  }

  InputDecoration buildinputDecoration(String hint) {
    return InputDecoration(
        hintText: hint,filled: true,fillColor: Colors.white,focusColor: Colors.white,
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white,width: 0.0) ),
        contentPadding: const EdgeInsets.fromLTRB(15,10,15,10)
      );
  }

  List<Widget>buildSwitchButtons(){
    String switchButtonsText,newFormState,submitButtonText;
    if(authFormType ==AuthFormType.signIn){
      switchButtonsText = 'Dont have an account,Create One';
      newFormState = 'SignUp';
      submitButtonText = 'SignIn';
    }
    else{
      switchButtonsText = 'Have an account? Sign In';
      newFormState = 'SignIn';
      submitButtonText = 'SignUp';
    }
    return[
      SizedBox(height: 20,),
      Container(
        width: MediaQuery.of(context).size.width*0.6,
        child: RaisedButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
          color: Colors.white,
          textColor: primaryColor,
          onPressed: (){
            submitForm();
          },
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(submitButtonText,style: TextStyle(fontSize: 20.0,fontWeight:FontWeight.w300 ),),
          )
        ),
      ),
      SizedBox(height: 10,),
      FlatButton(
      child: Text(switchButtonsText,style: TextStyle(color: Colors.white),),
      onPressed: (){
        switchFromState(newFormState);
      },
    )];
  }

}


