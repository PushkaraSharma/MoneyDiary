
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:money_diary/services/auth_services.dart';
import 'package:money_diary/widgets/loading_widget.dart';
import 'package:money_diary/widgets/provider_widget.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';

final primaryColor = const Color(0xFFFFAB91);
enum AuthFormType{signIn,signUp,passwordReset,anonmous,convertuser}

class Signup_view extends StatefulWidget {

  final AuthFormType authFormType;
  Signup_view({Key key,@required this.authFormType}):super(key:key);

  @override
  _Signup_viewState createState() => _Signup_viewState(authFormType: this.authFormType);
}

class _Signup_viewState extends State<Signup_view> {


  AuthFormType authFormType;
  _Signup_viewState({this.authFormType});
  bool loading = false;

  final formkey = GlobalKey<FormState>();
  String email, password,name,warning;

  void switchFromState(String state){
    formkey.currentState.reset();
    if(state =='SignUp'){
      setState(()=>authFormType = AuthFormType.signUp);
    }
    else if(state =='home'){
      Navigator.of(context).pop(); //pop up the current view and back to home as anonmous user
    }
    else{
      setState(()=> authFormType = AuthFormType.signIn);
    }
  }
  bool validate(){
    final form = formkey.currentState;
    if(authFormType == AuthFormType.anonmous){return true;}
    form.save();
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
        final auth = Provider.of(context).auth;
        loading = true;
        switch(authFormType){

          case AuthFormType.signIn:
            String uid = await auth.signInWithEmailAndPassword(email, password);
            print('Sign In $uid');
            Navigator.of(context).pushReplacementNamed('/home');
            break;
          case AuthFormType.signUp:
            loading = true;
            String uid = await auth.createUserWithEmailAndPassword(email, password, name);
            print('Created account for $uid');
            Navigator.of(context).pushReplacementNamed('/home');
            break;

          case AuthFormType.passwordReset:
            await auth.sendPasswordResetToEmail(email);
            print('Password Email sent');
            warning = 'Password reset link has been sent to your email $email';
            setState(() =>authFormType = AuthFormType.signIn);
            break;

          case AuthFormType.anonmous:
            await auth.signInAnon();
            Navigator.of(context).pushReplacementNamed('/home');
            break;
          case AuthFormType.convertuser:
            print('Convert user');
            await auth.convertUserWithEmail(email, password, name);
            Navigator.of(context).pop();
            break;
        }
      }catch (e) {
        setState(() =>warning = e.message);
        print(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    if(authFormType ==AuthFormType.anonmous){
      submitForm();

      //directly goes to home by just showing loading
      return Scaffold(
        backgroundColor: primaryColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SpinKitWave(color: Colors.white,),
            Text('Loading',style: TextStyle(color: Colors.white,fontFamily: 'Raleway'),)
          ],
        ),
      );
    }else
      {
        return loading?Loading():Scaffold(
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
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
  }

  Widget showAlertFromFirebase(){
    if(warning!=null){
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
            Expanded(child: AutoSizeText(warning,maxLines: 2,),),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(icon: Icon(Icons.clear),
              onPressed: (){
                setState(()=>warning = null);
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
    if(authFormType == AuthFormType.signIn){headerText = 'Sign In';}
    else if(authFormType == AuthFormType.passwordReset){headerText = 'Reset Password';}
    else{headerText = 'Create New Account';}
    return AutoSizeText(headerText, maxLines: 1,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 40, color: Colors.white,fontFamily: 'Cinzel'),);
  }

  List<Widget> inputforms() {
    List<Widget> textfields = [];
    //if password reset page is there only add email form and then return so that no more form is added
    if(authFormType ==AuthFormType.passwordReset)
    {
      textfields.add(TextFormField(
        validator: EmailValidator.validate,
        style: TextStyle(fontSize: 20),
        decoration: buildinputDecoration('Email'),
        onSaved: (value)=> email =value,
      ),
      );
      textfields.add(SizedBox(height: 24,));
      return textfields;
    }

    // If signup page so add name also
    if(authFormType == AuthFormType.signUp || authFormType == AuthFormType.convertuser){
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
    bool showForgetPassword = false;
    bool SocialSignInButtons = true;

    if(authFormType ==AuthFormType.signIn){
      switchButtonsText = 'Dont have an account then CREATE NOW';
      newFormState = 'SignUp';
      submitButtonText = 'SignIn';
      showForgetPassword = true;
    }
    else if(authFormType == AuthFormType.passwordReset){
      switchButtonsText = 'Go back to Sign in';
      newFormState = 'SignIn';
      submitButtonText = 'Reset';
      SocialSignInButtons = false;
    }
    else if(authFormType ==AuthFormType.convertuser){
      switchButtonsText = 'Cancel';
      newFormState = 'home';
      submitButtonText = 'SignUp';
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
            child: Text(submitButtonText,style: TextStyle(fontSize: 20.0,fontWeight:FontWeight.w300,fontFamily: 'Raleway'),),
          )
        ),
      ),
      SizedBox(height: 10,),
      showForgetPasswordButton(showForgetPassword),
      FlatButton(
      child: Text(switchButtonsText,style: TextStyle(color: Colors.white,fontFamily: 'Raleway'),),
      onPressed: (){
        switchFromState(newFormState);
      },),
      buildSocialSignInButtons(SocialSignInButtons),
    ];
  }
  Widget showForgetPasswordButton(bool visible){
    return Visibility(
      visible: visible,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
        child: FlatButton(
          child: Text('Forgot Password?',style: TextStyle(color: Colors.white,fontFamily: 'Raleway'),),
          onPressed: (){
            setState(() => authFormType = AuthFormType.passwordReset);
          },
        ),
      ),
    );
  }
   Widget buildSocialSignInButtons(visible){
    final auth = Provider.of(context).auth;
    return Visibility(child:
       Column(children: <Widget>[
        Divider(color: Colors.white,),
        SizedBox(height: 20,),
        GoogleSignInButton(
          borderRadius: 20.0,
          onPressed: ()async{
            try{
              if(authFormType == AuthFormType.convertuser){
                await auth.convertUserWithGoogle();
                Navigator.of(context).pop();
              }
              await auth.signInwithGoogle();
              Navigator.of(context).pushReplacementNamed('/home');

            }catch(e){
              setState(()=>warning = e.message);
            }
          },
        ),
       // SizedBox(height: 20.0,),
        //FacebookSignInButton(onPressed: (){},)
      ],
      ),
      visible: visible,
    );

   }

}


