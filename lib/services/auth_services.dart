import 'package:firebase_auth/firebase_auth.dart';

class AuthService{

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  //for checking user signed in so bring directly to home or first_view

  Stream<String> get onAuthStateChanged => _firebaseAuth.onAuthStateChanged.map(
      (FirebaseUser user)=>user?.uid,
  );

  //Email& pwd signup
  Future<String> createUserWithEmailAndPassword(String email,String pwd,String uname) async{
    AuthResult currentUser = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: pwd,);
    final FirebaseUser user = currentUser.user;

    //update uname
    var userUpdateInfo = UserUpdateInfo();
    userUpdateInfo.displayName = uname;
    await user.updateProfile(userUpdateInfo);
    await user.reload();
    return user.uid;
  }

  //Email & pwd Signin
  Future<String> signInWithEmailAndPassword(String email,String pwd) async{
    AuthResult currentuser = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: pwd);
    FirebaseUser user = currentuser.user;
    return user.uid;
  }

  //SignOut
  signOut(){
    return _firebaseAuth.signOut();
  }

  //Password reset
  Future sendPasswordResetToEmail(String email) async{
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }

}

// for signin and signup form validation
class EmailValidator{
  static String validate(String val){
    if(val.isEmpty){
      return "Email field can't be empty!! ";
    }
    return null;
  }
}
class PasswordValidator{
  static String validate(String val){
    if(val.isEmpty){
      return "Please insert the password!! ";
    }
    if(val.length<8){
      return "Length of password should be more than 8 characters!!";
    }
    return null;
  }
}

class NameValidator{
  static String validate(String val){
    if(val.isEmpty){
      return "Name field can't be empty !! ";
    }
    if(val.length<2){
      return "Length of name should be more than 2 characters!!";
    }
    if(val.length>50){
      return "Length of name should be less than 50 characters!!";
    }
    return null;
  }
}