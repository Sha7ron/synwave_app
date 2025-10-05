/*

FIREBASE IS OUR BACKEND - You can swap out any backend here..

*/

import 'package:google_sign_in/google_sign_in.dart';
import 'package:project_app/features/auth/domain/entities/app_user.dart';
import 'package:project_app/features/auth/domain/repos/auth_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class FirebaseAuthRepo implements AuthRepo {

  //  access to firebase
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // LOGIN: Email & Password
  @override
  Future<AppUser?> loginWithEmailPassword(String email, String password) async {
    try {
      // attempt to sign in
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(
          email: email,
          password: password
      );

      //create user
      AppUser user = AppUser(
          uid: userCredential.user!.uid,
          email: email
      );

      //return user
      return user;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  // REGISTER: Email & Password
  @override
  Future<AppUser?> registerWithEmailPassword(String name, String email,
      String password) async {
    try {
      //attempt sign up
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(
          email: email,
          password: password
      );

      //create user
      AppUser user = AppUser(
          uid: userCredential.user!.uid,
          email: email
      );

      //return user
      return user;
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  // DELETE ACCOUNT
  @override
  Future<void> deleteAccount() async {
    try {
      //get current user
      final user = firebaseAuth.currentUser;

      //check if there is a logged in user
      if (user == null) throw Exception('No User logged in.');

      //logout
      await user.delete();
    } catch (e) {
      throw Exception('Failed to delete account: $e');
    }
  }

  // GET CURRENT USER
  @override
  Future<AppUser?> getCurrentUser() async {
    //get current logged in user from firebase
    final firebaseUser = firebaseAuth.currentUser;

    // no logged in user
    if (firebaseUser == null) return null;

    // logged in user exits
    return AppUser(uid: firebaseUser.uid, email: firebaseUser.email!);
  }

  // LOGOUT
  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }

  // RESET PASSWORD
  @override
  Future<String> sendPasswordResetEmails(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      return "Password reset email sent! Check your inbox.";
    } catch (e) {
      return "An error occurred: $e";
    }
  }

  @override
  Future<AppUser?> signInWithApple() async {
    try {
      // request Apple ID credentials
      final appleCredentials = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ]);

      // create an OAuth credential
      final oAuthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredentials.identityToken,
        accessToken: appleCredentials.authorizationCode,
      );

      // sign in with credential
      UserCredential userCredential =
      await firebaseAuth.signInWithCredential(oAuthCredential);

      // firebase user
      final firebaseUser = userCredential.user;

      // user cancelled the sign-in process
      if (firebaseUser == null) return null;

      AppUser appUser = AppUser(
        uid: firebaseUser.uid,
        email: firebaseUser.email ?? '',
      );

      return appUser;
    }
    catch (e) {
      print("Error signing in with apple: $e");
      return null;
    }
  }

  // GOOGLE SIGN IN
  @override
  Future<AppUser?> signInWithGoogle() async {
    try {
      // begin the interactive sign-in process
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

      // user cancelled sign-in
      if (gUser == null) return null;

      // obtain auth details from request
      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      // create a credential for the user
      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      // sign in with these credentials
      UserCredential userCredential =
      await firebaseAuth.signInWithCredential(credential);

      // firebase user
      final firebaseUser = userCredential.user;

      // user cancelled sign-in process
      if (firebaseUser == null) return null;

      AppUser appUser = AppUser(
        uid: firebaseUser.uid,
        email: firebaseUser.email ?? '',
      );

      return appUser;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
