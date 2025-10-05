/*

  AUTH REPOSITORY - Outlines the possible auth operations for this app.

*/

import 'package:project_app/features/auth/domain/entities/app_user.dart';

abstract class AuthRepo{
  // These are the function that will be implemented in this.
     Future<AppUser?> loginWithEmailPassword(String email, String password);
     Future<AppUser?> registerWithEmailPassword(String name, String email, String password);
     Future<void> logout();
     Future<AppUser?> getCurrentUser();
     Future<String> sendPasswordResetEmails(String email);
     Future<void> deleteAccount();
     Future<AppUser?> signInWithGoogle();
     Future<AppUser?> signInWithApple();
}