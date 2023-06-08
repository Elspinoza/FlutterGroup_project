import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../screens/home/home_screen.dart';

class UserRegister extends StatelessWidget {
  const UserRegister({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController email = TextEditingController();
    TextEditingController name = TextEditingController();
    TextEditingController password = TextEditingController();
    bool loading = false;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.blue,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(25),
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 30),
                  child: const Center(
                    child: Image(
                      image: AssetImage("assets/images/meuble.jpg"),
                      width: 200,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    'Create your Account',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: customFormField(
                    labelText: 'Name',
                    keyboardType: TextInputType.text,
                    obscureText: false,
                    controller: name,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: customFormField(
                    labelText: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    obscureText: false,
                    controller: email,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: customFormField(
                    controller: password,
                    labelText: 'Password',
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: StatefulBuilder(
                    builder: (BuildContext context, setState) {
                      return loading
                          ? Center(
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
                            )
                          : MaterialButton(
                              onPressed: () async {
                                if (name.text.isNotEmpty) {
                                  if (email.text.isNotEmpty) {
                                    if (password.text.isNotEmpty) {
                                      setState(() {
                                        loading = true;
                                      });

                                      // Appel de l'API Flask pour l'inscription
                                      final url =
                                          'http://127.0.0.1:5000/signup';
                                      final response = await http.post(
                                        Uri.parse(url),
                                          headers: {
                                            'Content-Type': 'application/json'
                                          },
                                          body: jsonEncode({
                                          'name': name.text,
                                          'email': email.text,
                                          'password': password.text,
                                        }),
                                      );

                                      if (response.statusCode == 200) {
                                        // Inscription réussie
                                        email.clear();
                                        name.clear();
                                        password.clear();
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                            builder: (context) => HomeScreen(),
                                          ),
                                        );
                                      } else {
                                        // Échec de l'inscription
                                        newSnackBar(context,
                                            title: 'Échec de l\'inscription');
                                      }

                                      setState(() {
                                        loading = false;
                                      });
                                    } else {
                                      newSnackBar(context,
                                          title: 'Mot de passe requis !');
                                    }
                                  } else {
                                    newSnackBar(context,
                                        title: 'Email requis !');
                                  }
                                } else {
                                  newSnackBar(context, title: 'Nom requis !');
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
                                    padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                                    child: Text(
                                      'Sign Up',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget customFormField({
    required TextEditingController controller,
    required String labelText,
    required TextInputType keyboardType,
    required TextInputAction textInputAction,
    required bool obscureText,
  }) {
    return Material(
      elevation: 2.0,
      shadowColor: Colors.black,
      borderRadius: BorderRadius.circular(5.0),
      color: Colors.white,
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
