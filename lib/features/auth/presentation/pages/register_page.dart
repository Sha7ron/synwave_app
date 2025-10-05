import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../components/my_button.dart';
import '../components/my_textfield.dart';
import '../components/square_tile.dart';
import '../cubits/auth_cubit.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? togglePages;
  const RegisterPage({
    super.key,
    required this.togglePages,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text editing controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final pwController = TextEditingController();
  final confirmPwController = TextEditingController();

  // register button pressed
  void register() {
    // prepare info
    final String name = nameController.text;
    final String email = emailController.text;
    final String pw = pwController.text;
    final String confirmPw = confirmPwController.text;

    // auth cubit
    final authCubit = context.read<AuthCubit>();

    // ensure fields aren't empty
    if (email.isNotEmpty && 
        name.isNotEmpty &&
        pw.isNotEmpty &&
        confirmPw.isNotEmpty){
      if (pw == confirmPw) {
        authCubit.register(name, email, pw);
      }

      // pw doesn't match
      else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Passwords do not match!")));
      }
    }
    
    // fields are empty -> display error
    else{
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please complete all fields")));
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    pwController.dispose();
    confirmPwController.dispose();
    super.dispose();
  }

  // BUILD UI
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),

              //logo
              Image(
                image: AssetImage('assets/images/app_logo.png'),
                width: 100,
                height: 100,
              ),
              SizedBox(height: 20),

              //welcome back
              Text(
                "Let's create an account for you",
                style: TextStyle(
                    fontFamily: 'Doto',
                    fontSize: 23,
                    fontWeight: FontWeight.bold
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 10),

              //name text field
              MyTextfield(
                controller: nameController,
                hintText: 'Name', //placeholder
                obscureText: false, // decides on visibility of input
              ),

              SizedBox(height: 10),

              //username text field
              MyTextfield(
                controller: emailController,
                hintText: 'Email', //placeholder
                obscureText: false, // decides on visibility of input
              ),

              SizedBox(height: 10),
              //password text field
               MyTextfield(
                controller: pwController,
                hintText: 'Password', //placeholder
                obscureText: true, // decides on visibility of input
              ),

              SizedBox(height: 10),
              // confirm password text field
              MyTextfield(
                controller: confirmPwController,
                hintText: 'Confirm Password', //placeholder
                obscureText: true, // decides on visibility of input
              ),

              SizedBox(height: 10),
              //forgot password
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 10),
              // register btn
              MyButton(
                onTap: register,
                text: 'SIGN UP',
              ),

              SizedBox(height: 20),
              // oath sign in later.. (google + apple)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.blueAccent[400],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Text(
                        'or continue with',
                        style: TextStyle(
                            color: Colors.blueAccent[400]
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.blueAccent[400],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 50),
              //google + apple sign in button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/sample');
                    },
                    child: SquareTile(imagePath: 'assets/images/google.png'),
                  ),
                  SizedBox(width: 30),
                  SquareTile(imagePath: 'assets/images/apple-logo.png')
                ],
              ),

              SizedBox(height: 20),
              // already have an account? login now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                  SizedBox(width: 5),
                  GestureDetector(
                    onTap: widget.togglePages,
                    child: Text(
                      'Login now',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
