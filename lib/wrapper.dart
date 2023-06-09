import 'dart:async';
import 'dart:convert';
import 'package:ezen_sacco/Pages/Authenticate/authenticate.dart';
import 'package:ezen_sacco/Pages/Home/homescreen.dart';
import 'package:ezen_sacco/Pages/intro_pages/intro101.dart';
import 'package:ezen_sacco/Pages/intro_pages/intropage1.dart';
import 'package:ezen_sacco/Pages/intro_pages/intropage2.dart';
import 'package:ezen_sacco/Pages/intro_pages/intropage3.dart';
import 'package:ezen_sacco/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  _WrapperState createState() => _WrapperState();
}

var userData;
class _WrapperState extends State<Wrapper> {

  PageController _controller = PageController();
  bool onLastPage = false;
  int activeIndex = 0;
  bool loggedin = true;
  bool connected = true;
  final AuthService auth = AuthService();
  var currentUserDat;

  void initState() {
    checkConnection().whenComplete(() async{
      getValidationData();
      getValidationData().whenComplete(() async{
        Timer(const Duration(seconds: 5), () {if(userData == null){
          setState(() {
            loggedin != loggedin;
          });
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Authenticate()));
        }else{
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));

        }});
      });
    }
    );

    super.initState();
  }

  checkConnection() async{
    var check_connection = await auth.internetFunctions();
    if (check_connection == 'connected') {
      // carouselInfo();
      setState(() {
        connected = true;
      });
    }else{
      setState(() {
        connected = false;
      });
    }
  }


  Future getValidationData() async{
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var obtainedEmail= sharedPreferences.getString('email');
    setState(() {
      var multidata = jsonDecode(obtainedEmail!);
      multidata.add(currentUserDat);
      userData = multidata;
    });
  }

  @override
  Widget build(BuildContext context) {

      return Scaffold(
        body: Container(
          color: Colors.deepPurple.withOpacity(0.05),

          child: loggedin ? Into101() :  Stack(
            children: [
              PageView(
                controller: _controller,
                onPageChanged: (index) {
                  setState(() {
                    onLastPage = (index == 2);
                  });
                },
                children: [
                  IntroPage1(),
                  IntroPage2(),
                  IntroPage3(),
                ],
              ),
            ],
          ),
        ),
      );
  //  }
  }
  buildIndicator() => AnimatedSmoothIndicator(
      activeIndex: activeIndex,
      count:3,
      effect: JumpingDotEffect(
        dotHeight: 10,
        dotWidth: 10,
        dotColor: Colors.grey,
        activeDotColor: Colors.redAccent,
       )
  );
}
