import 'package:ezen_sacco/services/auth.dart';
import 'package:ezen_sacco/widgets/backbtn_overide.dart';
import 'package:ezen_sacco/wrapper.dart';
import 'package:flutter/material.dart';

import '../Pages/forms/request_loan.dart';
import '../routes.dart';

class LoanProduct extends StatefulWidget {
  const LoanProduct({Key? key}) : super(key: key);

  @override
  State<LoanProduct> createState() => _LoanProductState();
}

class _LoanProductState extends State<LoanProduct> {

  final AuthService auth = AuthService();
  var loanProducts ;
  bool initial_load = true;
  bool nodata = false;


  loanproduct () async{
      var response = await auth.getLoanProduct();
      if(response==null){
        initial_load = false;
         nodata = true;
      }else{
        setState(() {
          loanProducts = response['list'];
          print(loanProducts);
          print(userData[0]);
          initial_load = false;
        });
      }
  }

  @override
  void initState() {
    loanproduct();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final styles = TextStyle(fontFamily: 'Muli',fontWeight: FontWeight.bold);
    final styles2 = TextStyle(fontFamily: 'Muli',color: Colors.black45);
    return Scaffold(
        appBar: AppBar(
          leading: goback(context),
          title: Text(
            "Available Loan Products",
            style: TextStyle(
                color: Colors.black45,
                fontFamily: "Muli"
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: initial_load?
        Center(
          child: CircularProgressIndicator(
            color: Colors.redAccent,
          ),
        )
            : SingleChildScrollView(
                    child: Column(
                      children: [
                        ListView.builder(
                          scrollDirection: Axis.vertical,
                          physics: ClampingScrollPhysics(),
                          shrinkWrap: true,
                            itemBuilder:  (context, index){
                              return Card(
                                shadowColor: Colors.black,
                                child: Padding(
                                  padding: const EdgeInsets.all(14.0),
                                  child: Column(
                                    children: [
                                      Text('${loanProducts[index]['name']}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: height * 0.018,fontFamily: 'Muli')),
                                      SizedBox(height: height * 0.02,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Max. Repayment Period(Months)',style: styles,),
                                          Text('${loanProducts[index]['maxRepPeriod'] ?? 0}',style: styles2,)
                                        ],
                                      ),
                                      SizedBox(height: height * 0.02,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Min. Interest Rate',style: styles,),
                                          Text('${loanProducts[index]['minInterestRate']}',style: styles2,)
                                        ],
                                      ),
                                      SizedBox(height: height * 0.02,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Max. Interest Rate',style: styles,),
                                          Text('${loanProducts[index]['maxInterestRate']}',style: styles2,)
                                        ],
                                      ),
                                      SizedBox(height: height * 0.02,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Grace Period (Months)',style: styles,),
                                          Column(children: [
                                            Row(
                                              children: [
                                                Text("Min.",style: styles,),
                                                Text('${loanProducts[index]['gracePeriodMin']}',style: styles2,)
                                              ],
                                            ),
                                            SizedBox(height: height * 0.01,),
                                            Row(
                                              children: [
                                                Text("Max.",style: styles,),
                                                Text('${loanProducts[index]['gracePeriodMax']}',style: styles2,)
                                              ],
                                            )
                                          ],),
                                        ],
                                      ),
                                      SizedBox(height: height * 0.02,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Arrears Tolerance Amount',style: styles,),
                                          Text('${loanProducts[index]['arrearsToleranceAmt']}',style: styles2,)
                                        ],
                                      ),
                                      SizedBox(height: height * 0.02,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Code',style: styles,),
                                          Text('${loanProducts[index]['code']}',style: styles2,)
                                        ],
                                      ),
                                      SizedBox(height: height * 0.02,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Min. Amount',style: styles,),
                                          Text('${loanProducts[index]['minAmount'] ?? 0}',style: styles2,)
                                        ],
                                      ),
                                      SizedBox(height: height * 0.02,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Max. Amount',style: styles,),
                                          Text('${loanProducts[index]['maxAmount'] ?? 0}',style: styles2,)
                                        ],
                                      ),
                                      SizedBox(height: height * 0.02,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Can Use guarantors?',style: styles,),
                                          Text('${loanProducts[index]['useGuarantors']}',style: styles2,)
                                        ],
                                      ),
                                      SizedBox(height: height * 0.02,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Can Use Collateral?',style: styles,),
                                          Text('${loanProducts[index]['useCollaterals']}',style: styles2,)
                                        ],
                                      ),
                                      SizedBox(height: height * 0.02,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Loan Status',style: styles2,),
                                          Text('${loanProducts[index]['status']}',style: styles2,)
                                        ],
                                      ),
                                      SizedBox(height: height * 0.02,),
                                      Divider(),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          ElevatedButton(
                                            onPressed: (){},
                                            child: Text(
                                              'Check Eligibility',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.redAccent,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10)),
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: (){
                                              Navigator.push(context, customePageTransion(LoanRequestForm(productId: loanProducts[index]['id'],)));
                                            },
                                            child: Text(
                                              'Request Loan',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.redAccent,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10)),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          itemCount: loanProducts.length,
                          // shrinkWrap: true,
                          // scrollDirection: Axis.vertical,
                        ),
                      ],
                    )
                  )


    );
  }
}
