import 'package:ezen_sacco/disp_pages/shareAcc_deposits.dart';
import 'package:ezen_sacco/disp_pages/shareAcc_ledger.dart';
import 'package:ezen_sacco/routes.dart';
import 'package:ezen_sacco/services/auth.dart';
import 'package:ezen_sacco/utils/formatter.dart';
import 'package:ezen_sacco/widgets/backbtn_overide.dart';
import 'package:ezen_sacco/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ShareAccounts extends StatefulWidget {
  const ShareAccounts({Key? key}) : super(key: key);

  @override
  State<ShareAccounts> createState() => _ShareAccountsState();
}

var shareAccData ;
class _ShareAccountsState extends State<ShareAccounts> {

  final AuthService auth = AuthService();
  bool loading = false;
  bool shares = true;
  List memberShares = [];
  bool initial_load = true;
  //DateTime today = DateTime.fromMillisecondsSinceEpoch();
  final f = new DateFormat('yyyy-MM-dd');


  shareItems () async{
    var check_connection = await auth.internetFunctions();
    if(check_connection == true){
      var response = await auth.getShares();
      if(response['count']==null){
        initial_load = false;
        shares = false;
      }else{
        shares = false;
        initial_load = false;
        setState(() {
          memberShares = response['list'];
          shareAccData = memberShares;
          print(memberShares);
        });
      }
    }else{
      initial_load = true;
    }

  }

  @override
  void initState() {
    shareItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final styles = TextStyle(fontFamily: 'Muli',fontSize: 15,fontWeight: FontWeight.bold);
    final styles2 = TextStyle(fontFamily: 'Muli',fontSize: 14,color: Colors.black45);
    return Scaffold(
      appBar: AppBar(
        leading: goback(context),
        title: Text(
          "My Shares' Account".toUpperCase(),
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
          : Column(
        children: [
          Flexible(
            child: shares ?
            Center(
              child: Text(
                'There are no disbursed Loans',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
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
                                  memberShares[index]['product'],
                                  style: styles,
                                )
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
                                      'Date Opened',
                                      style: styles,
                                    ),
                                    Text(f.format(new DateTime.fromMillisecondsSinceEpoch(memberShares[index]['dateOpened'])),style: styles2,),
                                    //Text(f.format()),
                                  ],
                                ),

                                Divider(),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Balance',
                                      style: styles,),
                                    Text(
                                        '${formatCurrency(memberShares[index]['balance'])}',
                                      style: styles2,
                                    ),
                                  ],
                                ),

                                Divider(),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        'Shares',
                                      style: styles,
                                    ),
                                    Text( memberShares[index]['shares'].toString(),style: styles2,),
                                  ],
                                ),
                                Divider(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Minimum Required Shares',
                                        style: styles,),
                                    Text( memberShares[index]['minimumShares'].toString(),style: styles2,),
                                  ],
                                ),
                                Divider(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Price Per Share',
                                        style: styles,),
                                    Text( memberShares[index]['pricePerShare'].toString(),style: styles2,),
                                  ],
                                ),
                                Divider(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Share Type',
                                        style: styles,),
                                    Text( memberShares[index]['shareType'].toString(),style: styles2,),
                                  ],
                                ),
                                Divider(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Is Share Refundable ?',
                                      style: styles,),
                                    Text(memberShares[index]['shareRefundable'].toString(),style: styles2,),
                                  ],
                                ),
                                Divider(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Is Share Transferable ?',
                                      style: styles,),
                                    Text(memberShares[index]['shareTransferrable'].toString(),style: styles2,),
                                  ],
                                ),
                                Divider(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Share Gurantee Assignable ?',
                                      style: styles,),
                                    Text(memberShares[index]['shareGuaranteeAssignable'].toString(),style: styles2,),
                                  ],
                                ),
                                Divider(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Share collateral assignable',
                                      style: styles,),
                                    Text(memberShares[index]['shareGuaranteeAssignable'].toString(),style: styles2,),
                                  ],
                                ),
                                Divider(),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton(
                                      onPressed: (){
                                        Navigator.push(context, customePageTransion(ShareAccountDeposits()));
                                      },
                                      child: Text(
                                        'View Deposits',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
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
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.redAccent,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10)),
                                      ),
                                      onPressed: (){
                                        Navigator.push(context, customePageTransion(ShareAccLedger(shareLedgerId: memberShares[index]['ledgerId'].toString())));
                                      },
                                      child: Text(
                                        'Open Ledger',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontFamily: "Muli"
                                        ),
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
              itemCount: memberShares.length,
              scrollDirection: Axis.vertical,
            ),
          )
        ],
      ),
    );
  }
}
