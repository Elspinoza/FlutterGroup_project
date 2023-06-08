import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:furniture_app/Auth/register.dart';
import 'package:furniture_app/screens/home/home_screen.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController email = TextEditingController();
    TextEditingController password = TextEditingController();
    bool loading = false;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Form(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 30),
                      child: const Center(
                        child: Image(
                          image: AssetImage("assets/images/iconeapp.png"),
                          width: 200,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        'Login to your Account',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: customFormFeild(
                        labelText: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        obscureText: false,
                        controller: email,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: customFormFeild(
                        controller: password,
                        labelText: 'Password',
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: StatefulBuilder(
                        builder: (BuildContext context, setState) {

                          return loading
                              ? MaterialButton(
                                  onPressed: () async {
                                    if (email.text.isNotEmpty) {
                                      if (password.text.isNotEmpty) {
                                        setState(() {
                                          loading = !loading;
                                        });
                                      } else {
                                        newSnackBar(context,
                                            title:
                                                'Email and Password Required!');
                                      }
                                    } else {
                                      newSnackBar(context,
                                          title: 'Email Required!');
                                    }

                                    try {
                                      await FirebaseAuth.instance
                                          .signInWithEmailAndPassword(
                                              email: email.text,
                                              password: password.text)
                                          .then((value) {
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                HomeScreen(),
                                          ),
                                        );

                                        setState(() {
                                          loading = !loading;
                                        });
                                      });
                                    } on FirebaseAuthException catch (e) {
                                      if (e.code == 'user-not-found') {
                                        newSnackBar(context,
                                            title:
                                                'No user found for that email.');
                                        setState(() {
                                          loading = !loading;
                                        });
                                      } else if (e.code == 'wrong-password') {
                                        newSnackBar(context,
                                            title:
                                                'Wrong password provided for that user.');
                                        setState(() {
                                          loading = !loading;
                                        });
                                      }
                                    }
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  color: Colors.blue,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 15, 0, 15),
                                        child: Text(
                                          'Sign In',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ))
                              : Center(
                                  child: MaterialButton(
                                    onPressed: () {},
                                    shape: const CircleBorder(),
                                    color: Colors.blue,
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account? ",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const UserRegister(),
                        ),
                      );
                    },
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  customFormFeild({
    controller,
    labelText,
    keyboardType,
    textInputAction,
    obscureText,
  }) {
    return Material(
      elevation: 2,
      shadowColor: Colors.black,
      color: Colors.white,
      borderRadius: BorderRadius.circular(5.0),
      child: TextFormField(
        autofocus: false,
        textInputAction: textInputAction,
        keyboardType: keyboardType,
        controller: controller,
        cursorColor: Colors.black,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.black),
          contentPadding: const EdgeInsets.all(8),
          border: InputBorder.none,
        ),
      ),
    );
  }

   void newSnackBar(BuildContext context, {required String title}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(title),
      ),
    );
  }
}
