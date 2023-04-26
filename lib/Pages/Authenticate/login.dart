import 'dart:convert';

import 'package:ezen_sacco/constants/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/auth.dart';
import '../../wrapper.dart';

class Login extends StatefulWidget {
  final Function toggleView;
  Login({required this.toggleView});


  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  String url = 'https://cloud.ezenfinancials.com';
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  final AuthService auth = AuthService();

  bool loading = false;
  bool togglePassword = true;
  bool showServer = false;
  var email ;
  String password = '';
  String error = '';

  TextEditingController _urlCtrl =
  new TextEditingController(text: 'https://cloud.ezenfinancials.com');

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        key: _scaffoldKey,
      body: Container(
        child: Column(

          children: [
            Padding(padding: EdgeInsets.all(30)),
           Row(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               Text(
                   'Sign In',
               textAlign: TextAlign.center,
                 style: TextStyle(
                   fontSize: 28,
                   color: Colors.redAccent,
                   fontWeight: FontWeight.bold,
                 ),
               )
             ],
           ),
            SizedBox(height: height * 0.04),
            Column(
              children: [
                Image.asset('assets/logo-k3.png')
                // Text(
                //     'Welcome Back',
                //   style: TextStyle(
                //     fontWeight: FontWeight.bold,
                //     fontSize:width * 0.1,
                //     color: Colors.black
                //   ),
                // ),
                // SizedBox(height: 10,),
                // Text(
                //     'Sign in with your username and pasword \n or contact your administrator to set you up!',
                //   textAlign: TextAlign.center,
                //   style: TextStyle(
                //     fontSize: 16,
                //    // letterSpacing: 1
                //   ),
                // )
              ],
            ),
            SizedBox(height: height * 0.1),
            Flexible(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          validator: (val) => val!.isEmpty ? "Enter  Username" : null,
                          onChanged: (val){setState(() => email = val);},
                          decoration: InputDecoration(
                            hintText: 'Username',
                            suffixIcon: Icon(Icons.account_box),
                            labelText: "Username",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.redAccent),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.04),
                        TextFormField(
                          validator: (val) => val!.isEmpty ? "Enter  Password" : null,
                          obscureText: togglePassword,
                          onChanged: (val) {setState(() => password = val);},
                          decoration: InputDecoration(
                            hintText: 'Enter Your Password',
                            labelText: "Password",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            suffixIcon: GestureDetector(
                              child: Icon(togglePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onTap: () {
                                setState(() {
                                  togglePassword = !togglePassword;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.04),
                        CheckboxListTile(
                          title: Text("Change Server Url"),
                          value: showServer,
                          onChanged: (newValue) {
                            setState(() {
                              showServer = !showServer;
                            });
                          },
                          controlAffinity: ListTileControlAffinity
                              .leading, //  <-- leading Checkbox
                        ),
                        showServer
                            ? TextFormField(
                          controller: _urlCtrl,
                          validator: (val) => val!.isEmpty ? "Enter  Url" : null,
                          onChanged: (val){setState(() => url = val);},
                          decoration: InputDecoration(
                            hintText: 'url',
                            suffixIcon: Icon(Icons.web),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: kPrimaryColor),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        )
                            : Container(),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Text(
                              //   'Forget password?',
                              //   style: TextStyle(fontSize: 12.0),
                              // ),
                              ButtonTheme(
                                minWidth: MediaQuery.of(context).size.width * 0.8,
                                child: ElevatedButton(
                                  child: Text(
                                    'Login',
                                    style: TextStyle(
                                        color: Colors.white,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.redAccent,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)),
                                  ),
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() { loading = true;});
                                      print(url);
                                      try{
                                        dynamic result = await auth.SignIn(email,password,url);
                                        if(result.email['success'] == 'false'){
                                          setState(() {
                                            loading = false;
                                            Fluttertoast.showToast(
                                                msg:  result.email['message'],
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.CENTER,
                                                timeInSecForIosWeb: 1,
                                                //backgroundColor: Colors.white,
                                                textColor: Colors.white,
                                                fontSize: 16.0
                                            );
                                          });
                                        }else{
                                          if(result.email['saccoMembershipId'] == null){
                                            Fluttertoast.showToast(
                                              msg:'Wrong Credentials ...',
                                              //msg:  'You Are Not Registered As a Member Of Any Sacco...!!!\n\n Please Contact Your Sacco Branch For More Info'.toUpperCase(),
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.CENTER,
                                                timeInSecForIosWeb: 3,
                                                backgroundColor: Colors.white,
                                                textColor: Colors.red,
                                                fontSize: 16.0
                                            );
                                          }else{
                                            setState(() async {
                                              SharedPreferences preferences = await SharedPreferences.getInstance();
                                              var alldata = [url,result.email];
                                              preferences.setString('email', jsonEncode(alldata));
                                              print(preferences);
                                              var showToast = Fluttertoast.showToast(
                                                  msg:  'Login Success',
                                                  toastLength: Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.CENTER,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Colors.white,
                                                  textColor: Colors.green,
                                                  fontSize: 16.0
                                              );
                                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Wrapper()));

                                              //print(error);
                                            });
                                          }
                                        }
                                      }catch(e){
                                        setState(() {
                                          Fluttertoast.showToast(
                                              msg: e.toString(),
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.white,
                                              textColor: Colors.red,
                                              fontSize: 16.0
                                          );
                                          print(error);
                                        });
                                        print(e.toString());

                                      }
                                    }
                                  },
                                  // onPressed: () async {
                                  //   print('LOADING ${provider.isLoading}');
                                  //   if (_formKey.currentState.validate()) {
                                  //     _formKey.currentState.save();
                                  //     // if all are valid then go to success screen
                                  //     // Navigator.pushNamed(context, LoginSuccessScreen.routeName);
                                  //     try {
                                  //       final result =
                                  //       await InternetAddress.lookup(
                                  //           'google.com');
                                  //       if (result.isNotEmpty &&
                                  //           result[0].rawAddress.isNotEmpty) {
                                  //         print('connected');
                                  //         final logging =
                                  //         await provider.doLogin(context,
                                  //             url: _urlCtrl.text,
                                  //             username: _usernameCtlr.text,
                                  //             password: _passwordCtrl.text);
                                  //         print(
                                  //             'Loading ${provider.isLoading}');
                                  //         if (!logging) {
                                  //           /*simpleToast(
                                  //                     context,
                                  //                     provider.errorMessage,
                                  //                     Colors.red,
                                  //                     TextStyle(color: Colors.white));*/
                                  //           Flushbar(
                                  //             message: provider.errorMessage,
                                  //             backgroundColor: kPrimaryColor,
                                  //             duration: Duration(seconds: 3),
                                  //           )..show(context);
                                  //         }
                                  //       }
                                  //     } catch (e) {
                                  //       Flushbar(
                                  //         message:
                                  //         "No Connection to the remote server.:: ${e.toString()}",
                                  //         backgroundColor: kPrimaryColor,
                                  //         duration: Duration(seconds: 3),
                                  //       )..show(context);
                                  //     }
                                  //   }
                                  // },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
