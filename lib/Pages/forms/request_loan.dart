import 'dart:io';
import 'package:ezen_sacco/Pages/Home/homescreen.dart';
import 'package:ezen_sacco/utils/formatter.dart';
import 'package:ezen_sacco/widgets/backbtn_overide.dart';
import 'package:ezen_sacco/widgets/spin_loader.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../services/auth.dart';

class LoanRequestForm extends StatefulWidget {
  const LoanRequestForm({Key? key, required this.productId}) : super(key: key);
  final  productId;
  @override
  _LoanRequestFormState createState() => _LoanRequestFormState();
}

class _LoanRequestFormState extends State<LoanRequestForm> {

  final AuthService auth = AuthService();
  var loanLimit =0.0;
  var selectedAmount = 0.0;
  var data;
  var values ;
  var interstRate ;
  var numInstal;
  var intType;
  var intFreq;
  var repayFreq;
 // feesAsPrincipal, instalAmnt, intType, intFreq, repayFreq);



  void refresh(){
    setState((){});
  }

  loansAmount () async{
      var response = await auth.getLoanLimit(widget.productId);
      print(response);
      if(response==null){
        // initial_load = false;
        // nodata = true;
      }else{
        setState(() {
           data = response;
          loanLimit = double.parse(response['maxAllowedLoanAt'].toString());
          selectedAmount = double.parse(response['maxAllowedLoanAt'].toString());
          values = response['projection']['schedules'];
           interstRate = data['interestRate'];
          numInstal = data['numberOfInstallments'];
          intType = data['loanType'];
           intFreq = data['interestFrequency'];
           repayFreq = data['repaymentFrequency'];
          print(loanLimit);
          refresh();
        });
      }
  }

  @override
  void initState() {
    loansAmount();
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  TextEditingController _messageCtrl = new TextEditingController(text: '');
  TextEditingController _fileCtrl = new TextEditingController(text: '');
  final style1 = TextStyle(fontWeight: FontWeight.bold);
 // String email;
 // String password;
  bool remember = false;
  final List<String> errors = [];

  bool isHidden = true;
  List<Map<String, dynamic>> categoryList = [
    {'value': 'Claims', 'display': 'Claims'},
    {'value': 'Statement Request', 'display': 'Statement Request'},
    {'value': 'Amendment Request', 'display': 'Amendment Request'},
    {'value': 'Enquiries', 'display': 'Enquiries'},
    {'value': 'Billing', 'display': 'Billing'},
    {'value': 'Other', 'display': 'Other'}
  ];
  var selectedCategory;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: goback(context),
        title: Text(
          'Request New Loan',
          style: TextStyle(
            color: Colors.redAccent,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Card(
                child: Column(
                  children: [
                    Text('${formatCurrency(selectedAmount)}',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: width * 0.1
                      ),),
                    SizedBox(height: height * 0.02,),
                    // Slider(
                    //   value: double.parse(selectedAmount.ceil().toString()),
                    //   min: 0.0,
                    //   max: double.parse(loanLimit.toString()),
                    //   // divisions: 4,
                    //   label: "${selectedAmount}",
                    //   activeColor: Colors.redAccent,
                    //
                    //   onChanged: (double value) {
                    //     setState((){
                    //       selectedAmount = value;
                    //       refresh;
                    //     });
                    //
                    //   },
                    // ),
                    SizedBox(height: height * 0.0,),
                    TextFormField(
                      // enabled: isenabled,
                      keyboardType: TextInputType.number,
                      validator: (val) => val!.isEmpty ? "Amount to Pay " : null,
                      onChanged: (val){setState((){
                        selectedAmount = double.parse(val);
                        if(selectedAmount > loanLimit){
                          Fluttertoast.showToast(
                              msg:  'Cannot Request Higher Amounts than Available Account Limit Please contact your Sacco for more info',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              //backgroundColor: Colors.white,
                              textColor: Colors.redAccent,
                              fontSize: 16.0
                          );
                          selectedAmount = loanLimit;
                        }
                        if(selectedAmount == 0){
                          selectedAmount = loanLimit;
                        }
                        // refresh;
                      });},
                      onEditingComplete: (()async{
                        var res = await auth.loanProjections(selectedAmount, 0 ,interstRate, numInstal, 0, intType, intFreq, repayFreq);
                        print(res);
                        setState((){
                          // data = res;
                        });
                      }),
                      // onEditingComplete: () => (setState(()async{
                      //   var res = await auth.loanProjections(selectedAmount, 0 ,interstRate, numInstal, 0, intType, intFreq, repayFreq);
                      //   print(res);
                      //   // data = res;
                      // })),
                      initialValue: selectedAmount.toString() ,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.money_off,color: Colors.green,),
                        labelText: "Loan Amount",
                        floatingLabelAlignment: FloatingLabelAlignment.center,
                        floatingLabelStyle: TextStyle(color: Colors.green,fontFamily: "Muli"),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.redAccent),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.02,),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                          // shape: RoundedRectangleBorder(
                          //     borderRadius: BorderRadius.circular(10)),
                        ),

                        onPressed: ((){

                        }),
                        child: Container(
                          width: width * 0.5,
                          height: height * 0.05,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(Icons.money_off,color: Colors.white,),
                              Text('Request Loan',style: TextStyle(
                                color: Colors.white
                              ),),
                              Icon(Icons.money_off,color: Colors.white,),
                            ],
                          ),
                        )
                    ),
                    SizedBox(height: height * 0.01,),
                  ],
                ),
              ),
              Container(
                color: Colors.grey[200],
                width: width,
                height: height * 0.7,
                child: Column(
                  children: [
                    // Text('Projections',style: style1,),

                    // SizedBox(height: height * 0.02,),
                    data == null ? LoadingSpinCircle() : Card(
                      color: Colors.grey[200],
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Text('Loan Type:',style: style1,),
                                    SizedBox(height: height * 0.01,),
                                    Text('${data['loanType'] ?? '-'}'),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text('Interest Freq:',style: style1,),
                                    SizedBox(height: height * 0.01,),
                                    Text('${data['interestFrequency'] ?? 0}')
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text('Repayment Freq:',style: style1,),
                                    SizedBox(height: height * 0.01,),
                                    Text('${data['repaymentFreq'] ?? '-'}'),
                                  ],
                                ),

                              ],
                            ),
                            SizedBox(height: height * 0.02,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Text('No. of Installments:',style: style1,),
                                    SizedBox(height: height * 0.01,),
                                    Text('${data['numberOfInstallments'] ?? 0}'),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text('Interest Frequency:',style: style1,),
                                    SizedBox(height: height * 0.01,),
                                    Text('')
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text('Interest Rate:',style: style1,),
                                    SizedBox(height: height * 0.01,),
                                    Text('${data['interestRate'] ?? 0.0}'),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: height * 0.02,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Text('Monthly Payments',style: style1,),
                                    SizedBox(height: height * 0.01,),
                                    Text('${formatCurrency(data['projection']['monthlyPayment'].ceil())?? 0.0}'),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text('Repayment Frequency:',style: style1,),
                                    SizedBox(height: height * 0.01,),
                                    Text('${data['projection']['totalInterest'].ceil()??0.0}'),
                                  ],
                                ),
                                // Column(
                                //   children: [
                                //     Text('Projections',style: style1,),
                                //     SizedBox(height: height * 0.01,),
                                //     Text('${data['projection']['totalInterest'].ceil() ?? 0.0}'),
                                //   ],
                                // ),
                              ],
                            ),
                          ],
                        ),
                      ),

                    ),

                    SizedBox(height: height * 0.02,),


                    data == null ? Center(child: LoadingSpinCircle()):Flexible(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ListView.builder(
                              itemCount: data['projection']['schedules'].length,
                                scrollDirection: Axis.vertical,
                                physics: ClampingScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder:  (context, index){
                                  return Card(
                                    color: Colors.grey[200],
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              Text('Interest Payment:',style: style1,),
                                              SizedBox(width: width * 0.05,),
                                              Text('${formatCurrency(values[index]['interestPayment'].ceil())}'),
                                              // SizedBox(width: width * 0.05,)
                                            ],
                                          ),
                                          SizedBox(height: height * 0.01,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              Text('Cummulative Interest:',style: style1,),
                                              SizedBox(width: width * 0.05,),
                                              Text('${formatCurrency(values[index]['cumulativeInterest'].ceil())}'),
                                            ],
                                          ),
                                          SizedBox(height: height * 0.01,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              Text('Principal Payment:',style: style1,),
                                              SizedBox(width: width * 0.05,),
                                              Text('${formatCurrency(values[index]['principalPayment'].ceil())}'),
                                            ],
                                          ),
                                          SizedBox(height: height * 0.01,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              Text('Total Payment :',style: style1,),
                                              SizedBox(width: width * 0.05,),
                                              Text('${formatCurrency(values[index]['totalPayment'].ceil())}'),
                                            ],
                                          ),
                                          SizedBox(height: height * 0.01,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              Text('Principal Applied:',style: style1,),
                                              SizedBox(width: width * 0.05,),
                                              Text('${formatCurrency(values[index]['principalApplied'].ceil())}'),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),

      ),
    );
  }

  TextFormField buildAttachmentField() {
    return TextFormField(
      //  obscureText: isHidden,
      controller: _fileCtrl,
      //  onSaved: (newValue) => _passwordCtrl.text = newValue,
      onTap: () async {
        FocusScope.of(context).requestFocus(FocusNode());
        FilePickerResult? result = await FilePicker.platform.pickFiles();
        //FocusScope.of(context).unfocus();
        if (result != null) {
          //File file = File(result.files.single.path);
          //File file = File(result.files.last);//result.file.single.path);

          setState(() {
           // _fileCtrl.text = file.path;
          });
        }
      },
      decoration: InputDecoration(
       // labelText: "Attachment",
        hintText: "Pick File",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        //floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }



  TextFormField sendTextFormField() {
    return TextFormField(
      keyboardType: TextInputType.multiline,
      controller: _messageCtrl,
      maxLines: 5,
      onSaved: (newValue) => _messageCtrl.text = newValue!,
      validator: (value) {
        if (value!.isEmpty && !errors.contains('')) {
          setState(() {
            errors.add("Enter the Message!");
          });
          return "";
        }
        /*else if (!emailValidatorRegExp.hasMatch(value) &&
            !errors.contains(kInvalidEmailError)) {
          setState(() {
            errors.add(kInvalidEmailError);
          });
          return "";
        }*/
        return null;
      },
      decoration: InputDecoration(
        //labelText: "Message",
        hintText: "Enter Message",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        //  suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }
}