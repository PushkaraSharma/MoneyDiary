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

}