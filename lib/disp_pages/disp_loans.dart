import 'package:ezen_sacco/constants.dart';
import 'package:ezen_sacco/disp_pages/loan_ledger.dart';
import 'package:ezen_sacco/disp_pages/loan_schedule.dart';
import 'package:ezen_sacco/routes.dart';
import 'package:ezen_sacco/services/auth.dart';
import 'package:ezen_sacco/utils/formatter.dart';
import 'package:ezen_sacco/widgets/backbtn_overide.dart';
import 'package:ezen_sacco/widgets/spin_loader.dart';
import 'package:flutter/material.dart';

class Loans extends StatefulWidget {
  const Loans({Key? key}) : super(key: key);
  @override
  State<Loans> createState() => _LoansState();
}

var loanLedger;
class _LoansState extends State<Loans> {

  final AuthService auth = AuthService();
  bool loading = false;
  bool noLoans = true;
  var dispensedLoans ;
  bool initial_load = true;
  //DateTime today = DateTime.fromMillisecondsSinceEpoch();

  loansItem () async{
    var check_connection = await auth.internetFunctions();
    if(check_connection == true){
      var response = await auth.getUserAppliedLoans();
      if(response['count']==null){
        initial_load = false;
        noLoans = false;
      }else{
        noLoans = false;
        initial_load = false;
        setState(() {
          dispensedLoans = response['list'];
          print(dispensedLoans);
        });
      }
    }else{
      initial_load = true;
    }


}

  @override
  void initState() {
    loansItem();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final styles = TextStyle(fontFamily: 'Muli',fontWeight: FontWeight.bold);
    final styles2 = TextStyle(fontFamily: 'Muli',color: Colors.black45);
    return Scaffold(
      appBar: AppBar(
        leading: goback(context),
        title: Text(
          'My Loans',
          style: TextStyle(
            color: Colors.redAccent,
            fontFamily: "Muli"
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: initial_load?
          LoadingSpinCircle()
      : Column(
        children: [
          Flexible(
              child: noLoans ?
                  Center(
                    child: Text(
                      'There are no disbursed Loans',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                        fontFamily: "Muli"
                      ),
                    ),
                  ): ListView.builder(
                itemBuilder: (context, index){
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    'Loan Type',
                                  style: styles2,
                                  ),
                                  Text(
                                    dispensedLoans[index]['product'].toString(),
                                    style: styles,
                                  )
                                ],
                              ),

                              SizedBox(width: width * 0.1,),
                              Column(
                                children: [
                                  Text(
                                    ' Amount',
                                    style: styles2,
                                  ),
                                  Text(
                                    '${formatCurrency(dispensedLoans[index]['loanAmount'])}',
                                    style: styles,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Card(
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Divider(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Date Applied',
                                        style: styles,
                                      ),
                                      Text(f.format(new DateTime.fromMillisecondsSinceEpoch(dispensedLoans[index]['dateOfApplication'])),style: styles2,),
                                    ],
                                  ),

                                  Divider(),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          'Loan Type',
                                          style: styles,
                                      ),
                                      Text(
                                          dispensedLoans[index]['loanType'].toString(),style: styles2,
                                      ),
                                    ],
                                  ),

                                  Divider(),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          'Loan ID/No',
                                        style:styles,
                                      ),
                                      Text( dispensedLoans[index]['loanNumber'].toString(),style: styles2,),
                                    ],
                                  ),
                                  Divider(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Loan Principle',
                                        style: styles,),
                                      Text('${formatCurrency(dispensedLoans[index]['amountAppliedFor'])}' , style: styles2,),
                                    ],
                                  ),
                                  Divider(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Amount Applied',
                                        style: styles,),
                                      Text('${formatCurrency(dispensedLoans[index]['amountAppliedFor'])}',style: styles2,),
                                    ],
                                  ),
                                  Divider(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Disbursed Amount',
                                        style: styles,),
                                      Text( '${formatCurrency(dispensedLoans[index]['loanAmount'])}',style: styles2,),
                                    ],
                                  ),
                                  Divider(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Loan Period(Months)',
                                        style: styles,),
                                      Text( dispensedLoans[index]['numberOfInstallments'].toString(),style: styles2,),
                                    ],
                                  ),
                                  Divider(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Interest Rate',
                                        style: styles),
                                      Text(dispensedLoans[index]['interestRate'].toString(),style: styles2,),
                                    ],
                                  ),
                                  Divider(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Total Fees',
                                        style: styles,),
                                      Text(dispensedLoans[index]['totalLoanFee'].toString(),style: styles2,),
                                    ],
                                  ),
                                  Divider(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Installment Amount',
                                        style: styles),
                                      Text( '${formatCurrency(dispensedLoans[index]['installmentAmount'])}',style: styles2,),
                                    ],
                                  ),
                                  Divider(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Grace Period',
                                        style: styles,),
                                      Text(dispensedLoans[index]['gracePeriodMonths'].toString(),style: styles2,),
                                    ],
                                  ),
                                  Divider(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Repayment Frequency',
                                        style: styles,),
                                      Text( dispensedLoans[index]['repaymentFreq'].toString(),style: styles2,),
                                    ],
                                  ),
                                  Divider(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Repayment Start Date',
                                        style: styles),
                                      Text(f.format(new DateTime.fromMillisecondsSinceEpoch(dispensedLoans[index]['dateOfApplication'])),style: styles2,),
                                    ],
                                  ),
                                  Divider(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Loan Balance',
                                        style: styles,),
                                      Text('${formatCurrency(dispensedLoans[index]['loanBalance'])}' ,style: styles2,),
                                    ],
                                  ),
                                  Divider(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Loan Status',
                                        style:styles,),
                                      Text(
                                        dispensedLoans[index]['status'],
                                        style: TextStyle(color: Colors.green),
                                      ),
                                    ],
                                  ),
                                  Divider(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      ElevatedButton(
                                        onPressed: (){
                                           Navigator.push(context, customePageTransion(LoanSchedule(loanId: dispensedLoans[index]['id'].toString())));
                                        },
                                        child: Text(
                                          'View Schedules',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: "Muli"
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.redAccent,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10)),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          Navigator.push(context, customePageTransion(LoanLedger(LoanLedgerId: dispensedLoans[index]['ledgerId'].toString(),)));
                                        },
                                        child: Text(
                                          'Open Ledger',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: "Muli"
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.redAccent,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10)),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                shrinkWrap: true,
                itemCount: dispensedLoans.length,
                scrollDirection: Axis.vertical,
              ),
          )
        ],
      ),
    );
  }
}
