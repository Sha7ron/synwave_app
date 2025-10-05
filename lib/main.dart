import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_app/features/auth/presentation/components/loading.dart';
import 'package:project_app/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:project_app/features/auth/presentation/cubits/auth_states.dart';
import 'package:project_app/features/auth/presentation/pages/auth_page.dart';
import 'package:project_app/features/auth/presentation/pages/login_page.dart';
import 'package:project_app/features/auth/presentation/pages/register_page.dart';
import 'package:project_app/firebase_options.dart';
import 'package:project_app/themes/dark_mode.dart';
import 'package:project_app/themes/light_mode.dart';

import 'features/auth/data/firebase_auth_repo.dart';
import 'features/home/presentation/pages/home_page.dart';

void main() async {
  // firebase setup
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  //run app
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  
  // auth repo
  final firebaseAuthRepo = FirebaseAuthRepo();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        // provide cubits to app
        providers: [
          // auth cubit
          BlocProvider<AuthCubit>(
              create: (context) => AuthCubit(authRepo: firebaseAuthRepo)..checkAuth(),
          )
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,

          /*

          BLOC CONSUMER - Auth

          */

          home: BlocConsumer<AuthCubit, AuthState>(
              builder: (context, state){
                print(state);

                // unauthenticated -> auth page (login/register)
                if (state is Unauthenticated){
                  return const AuthPage();
                }

                // authenticated -> home page
                if (state is Authenticated) {
                  return const HomePage();
                }

                // loading..
                else{
                  return const LoadingScreen();
                }
              },
              // listen for state changes
              listener: (context, state) {
                if (state is AuthError) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
          ),
          theme: lightMode,
          darkTheme: darkMode,
        ),
    );
  }
}
