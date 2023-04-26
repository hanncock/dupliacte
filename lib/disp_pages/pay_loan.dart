import 'package:ezen_sacco/Pages/Home/homescreen.dart';
import 'package:ezen_sacco/routes.dart';
import 'package:ezen_sacco/services/auth.dart';
import 'package:ezen_sacco/widgets/backbtn_overide.dart';
import 'package:ezen_sacco/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PayLoan extends StatefulWidget {
  const PayLoan({Key? key}) : super(key: key);

  @override
  State<PayLoan> createState() => _PayLoanState();
}

class _PayLoanState extends State<PayLoan> {

  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isenabled = false;
  bool isVisible = false;
  String oldPassword ='';

  var accountRef = currentUserData['memberNo'].toString();
  var amount = (currentUserData['totalLoanBalance'] / 2).toString();
  var phoneNumber =  currentUserData['fixedPhone'].toString();
  var currentLoanBal;
  bool loading = false;
  bool error = false;
  var bizShortCode;
  List data = [];
  final _formKey = GlobalKey<FormState>();

  var userid = userData[1]['userId'];
  final AuthService auth = AuthService();

  getPabills()async{
    var paybills = await auth.getPaybills();
    print(paybills);
    setState(() {
      data = paybills['list'];
      print(data);
    });
  }

  @override
  void initState(){
    getPabills();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(currentUserData);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: goback(context),
        title: Text(
          "Make Loan Payment",
          style: TextStyle(
              color: Colors.white,
              fontFamily: "Muli"
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Container(
            height: height * 0.2,
            width: width,
            color: Colors.green,
            //decoration: BoxDecoration
            child: Center(
              child: Image.asset('assets/saf.png',color: Colors.white,),
            ),
            //color: Color.fromRGBO(102,255,0,0.9),
          ),
       Flexible(
         child: Padding(
           padding: const EdgeInsets.only(left: 8.0,right: 8.0),
           child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: height * 0.02),

                  TextFormField(
                    enabled: isenabled,
                    validator: (val) => val!.isEmpty ? "Account No." : null,
                    onChanged: (val){setState(() => accountRef = val);},
                    initialValue: currentUserData['memberNo'] ,//! ? '': currentUserData['memberNo'] ,
                    //initialValue: (currentUserData['memberNo'] == null ? '' : currentUserData['memberNo']),//! ? '': currentUserData['memberNo'] ,
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.account_balance_wallet_outlined,color: Colors.green,),
                      labelText: "Account Number",
                      floatingLabelAlignment: FloatingLabelAlignment.center,
                      floatingLabelStyle: TextStyle(color: Colors.green,fontFamily: "Muli"),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.redAccent),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  TextFormField(
                    enabled: isenabled,
                    validator: (val) => val!.isEmpty ? "Phone Number" : null,
                    onChanged: (val){setState(() => phoneNumber = val);},
                    initialValue: currentUserData['fixedPhone'],
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.phone_android_rounded,color: Colors.green,),
                      labelText: "Phone Number",
                      floatingLabelAlignment: FloatingLabelAlignment.center,
                      floatingLabelStyle: TextStyle(color: Colors.green,fontFamily: "Muli"),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.redAccent),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  Container(
                    width: 200,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Paybill',
                          style: TextStyle(
                            fontFamily: "Muli",
                            fontWeight: FontWeight.bold,
                          ),),
                        DropdownButton(
                          value: bizShortCode,
                          items: data.map((list){
                            return DropdownMenuItem(
                              child: Text(list['shortCode'],style: TextStyle(color: Colors.black87)),
                              value: list['shortCode'].toString(),
                            );
                          },).toList(),
                          onChanged: (value)=>setState(() {
                            bizShortCode = value.toString();
                          }),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: height * 0.02),

                  InkWell(
                    onTap: (){

                      setState(() {
                        isVisible = !isVisible;
                      });
                      print('is visible $isVisible');
                    },
                    child: Text(
                        'Pay Through Other Phone Number ... ?',style: TextStyle(
                      fontFamily: "Muli",
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green
                    )),
                  ),
                  SizedBox(height: height * 0.02),
                  isVisible ?
                  TextFormField(
                    enabled: isVisible,
                    validator: (val) => val!.isEmpty ? "Name" : null,
                    keyboardType: TextInputType.number,
                    onChanged: (val){setState(() => phoneNumber = val);},
                    initialValue: currentUserData['fixedPhone'],
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.phone,color: Colors.green,),
                      labelText: "Enter Number",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      floatingLabelStyle: TextStyle(color: Colors.green,fontFamily: "Muli"),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.redAccent),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ):
                  SizedBox(height: height * 0.02),
                  SizedBox(height: height * 0.02),
                  TextFormField(
                    enabled: isenabled,
                    validator: (val) => val!.isEmpty ? "Current Loan Balance" : null,
                    onChanged: (val){setState(() => currentLoanBal = val);},
                    initialValue: currentUserData['totalLoanBalance'].toString(),
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.request_page_outlined,color: Colors.green,),
                      labelText: "Current Loan Balance.",
                      floatingLabelAlignment: FloatingLabelAlignment.center,
                      floatingLabelStyle: TextStyle(color: Colors.green,fontFamily: "Muli"),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.redAccent),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.04),

                  TextFormField(
                   // enabled: isenabled,
                    keyboardType: TextInputType.number,
                    validator: (val) => val!.isEmpty ? "Amount to Pay " : null,
                    onChanged: (val){setState(() => amount = val);},
                    initialValue: (currentUserData['totalLoanBalance'] / 2).toString() ,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.money_off,color: Colors.green,),
                      labelText: "Amount To Pay",
                      floatingLabelAlignment: FloatingLabelAlignment.center,
                      floatingLabelStyle: TextStyle(color: Colors.green,fontFamily: "Muli"),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.redAccent),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),

                  SizedBox(height: height * 0.04),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.redAccent,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: (){
                              Navigator.push(context, customePageTransion(Home()));
                            },
                            child: Text('Cancel',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Muli",
                              ),)),
                        ElevatedButton(
                          child: Text(
                            'Make Payment',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Muli"
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () async{
                            if(bizShortCode == null){
                              Fluttertoast.showToast(
                                  msg:  'Select Paybill'.toUpperCase(),
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 3,
                                  backgroundColor: Colors.white,
                                  textColor: Colors.red,
                                  fontSize: 16.0,
                              );
                            }else{
                              if(amount != 0){
                                var result = await auth.lipaNaMpesa(bizShortCode, amount, phoneNumber, accountRef);
                                print(result);
                                //print(bizShortCode); print(amount); print(phoneNumber); print(accountRef);
                                if(result['success'] == "false" ){
                                  Fluttertoast.showToast(
                                    msg:  '${result['message']}'.toUpperCase(),
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 3,
                                    backgroundColor: Colors.white,
                                    textColor: Colors.red,
                                    fontSize: 16.0,
                                  );
                                }else{
                                  Fluttertoast.showToast(
                                    msg:  '${result['message']}'.toUpperCase(),
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 3,
                                    backgroundColor: Colors.white,
                                    textColor: Colors.red,
                                    fontSize: 16.0,
                                  );
                                }
                              }else{
                                Fluttertoast.showToast(
                                  msg:  'Amount Should be more than 0'.toUpperCase(),
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 3,
                                  backgroundColor: Colors.white,
                                  textColor: Colors.red,
                                  fontSize: 16.0,
                                );
                              }
                            }

                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      ),
         ),
       ),
        ],
      ),
    );
  }
}
