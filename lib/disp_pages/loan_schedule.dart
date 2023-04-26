// import 'package:ezen_sacco/constants.dart';
// import 'package:ezen_sacco/disp_pages/disp_loans.dart';
// import 'package:ezen_sacco/services/auth.dart';
// import 'package:ezen_sacco/widgets/backbtn_overide.dart';
// import 'package:ezen_sacco/widgets/spin_loader.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// class Loanschedule extends StatefulWidget {
//   const Loanschedule({Key? key, required this.loanId}) : super(key: key);
//   final loanId;
//   @override
//   State<Loanschedule> createState() => _LoanscheduleState();
// }
//
// class _LoanscheduleState extends State<Loanschedule> {
//   final AuthService auth = AuthService();
//   bool initial_load = false;
//   bool nodata = false;
//   //late List loanSchedule = [];
//   final f = new DateFormat('yyyy-MM-dd');
//
//   //var name = shareAccData['accountNo'];
//
//   // getLoanSchedule() async {
//   //   var check_connection = await auth.internetFunctions();
//   //   if (check_connection == true) {
//   //     var response = await auth.getLoanRepaymentSchedule('${widget.loanId}'.toString());
//   //     print(response);
//   //     if (response['count'] == 0) {
//   //       setState(() {
//   //         initial_load = false;
//   //         nodata = true;
//   //       });
//   //     } else {
//   //       setState(() {
//   //         nodata = false;
//   //         initial_load = false;
//   //         loanSchedule = response['list'];
//   //         print(loanSchedule);
//   //       });
//   //     }
//   //   } else {
//   //     initial_load = true;
//   //   }
//   // }
//
//   @override
//   void initState() {
//     //getLoanSchedule();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
//     final styles = TextStyle(
//         fontFamily: 'Muli', fontSize: 14, color: Colors.redAccent,fontWeight: FontWeight.bold);
//     final styles2 = TextStyle(fontFamily: 'Muli', fontSize: 16);
//     ScrollController _controller = new ScrollController();
//     double width = MediaQuery.of(context).size.width;
//     return Scaffold(
//       appBar: AppBar(
//         leading: goback(context),
//         title: Text(
//           'Loans Schedule Breakdown',
//           style: TextStyle(
//               color: Colors.black45,
//               fontFamily: "Muli"
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         actions: <Widget>[
//           IconButton(
//             icon: Icon(
//               Icons.refresh,
//               color: Colors.redAccent,
//             ),
//             onPressed: () {
//               setState(() {
//                 print('Reload init');
//                 // provider.getStatements(context, mounted, reload: true);
//                 // _data = ApiService().getDividends(true);
//               });
//             },
//           ),
//         ],
//       ),
//       body: initial_load ?
//       LoadingSpinCircle()
//           :
//       nodata ?
//       Center(
//         child: Text(
//           'Sorry !\n\nNo Ledgers to Display',
//           textAlign: TextAlign.center,
//           style: TextStyle(
//               color: Colors.blue,
//               fontSize: 20,
//               fontFamily: "Muli"
//           ),
//         ),) :
//       // Column(
//       //   children: [
//       //     Text(shareledger['product'].toString())
//       //   ],
//       // ),
//       Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text('Ledger Entries', style: TextStyle(
//                 fontSize: 20,
//                 fontFamily: "Muli",
//                 color: Colors.black
//             ),),
//           ),
//           Container(
//
//             child: SingleChildScrollView(
//               child: PaginatedDataTable(
//                 source: RowSource(),
//                 showCheckboxColumn: false,
//                 showFirstLastButtons: true,
//                 rowsPerPage: rowsPerPage,
//                 availableRowsPerPage: [10, 20],
//
//                 onRowsPerPageChanged: (newRowsPerPage){
//                   if(newRowsPerPage != null){
//                     setState(() {
//                       rowsPerPage = newRowsPerPage;
//                     });
//                   }
//                 },
//                 columns: [
//                   DataColumn(label: Text('Installment',style: styles)),
//                   DataColumn(label: Text('Loan Balance',style: styles)),
//                   DataColumn(label: Text('Principle',style: styles)),
//                   DataColumn(label: Text('Interest',style: styles)),
//                   DataColumn(label: Text('Scheduled Payment',style: styles)),
//                   DataColumn(label: Text('Cumulative Interest',style: styles)),
//                   DataColumn(label: Text('Due Date',style: styles)),
//                 ],
//               ),
//             ),
//           )
//           // Flexible(
//           //   child: Container(
//           //     width: width,
//           //     //height: height,
//           //     child: Scrollbar(
//           //       child: ListView.builder(
//           //         itemCount: loanSchedule.length,
//           //        shrinkWrap: true,
//           //         //physics: const AlwaysScrollableScrollPhysics(),
//           //         scrollDirection: Axis.horizontal,
//           //         itemBuilder: (c, i) =>
//           //             DataTable(
//           //               columns: <DataColumn>[
//           //                 DataColumn(
//           //                     label: Text('Installment'.toUpperCase(), style: styles,),
//           //                     numeric: false,
//           //                     onSort: (i, b) {},
//           //                     tooltip: "Transaction Date"
//           //                 ),
//           //
//           //                 DataColumn(
//           //                     label: Text(
//           //                       'Loan Balance'.toUpperCase(), style: styles,),
//           //                     numeric: false,
//           //                     onSort: (i, b) {},
//           //                     tooltip: "trxn Desc"
//           //                 ),
//           //                 DataColumn(
//           //                     label: Text('Principle'.toUpperCase(), style: styles,),
//           //                     numeric: false,
//           //                     onSort: (i, b) {},
//           //                     tooltip: "All Debits"
//           //                 ),
//           //                 DataColumn(
//           //                     label: Text('Interest'.toUpperCase(), style: styles,),
//           //                     numeric: false,
//           //                     onSort: (i, b) {},
//           //                     tooltip: "All Credits"
//           //                 ),
//           //                 DataColumn(
//           //                     label: Text(
//           //                       'Schedule \nRepayment'.toUpperCase(), style: styles,),
//           //                     numeric: false,
//           //                     onSort: (i, b) {},
//           //                     tooltip: "Acc Balance"
//           //                 ),
//           //                 DataColumn(
//           //                     label: Text(
//           //                       'Cummulative \nnterest'.toUpperCase(), style: styles,),
//           //                     numeric: false,
//           //                     onSort: (i, b) {},
//           //                     tooltip: "Acc Balance"
//           //                 ),
//           //                 DataColumn(
//           //                     label: Text('Due Date'.toUpperCase(), style: styles,),
//           //                     numeric: false,
//           //                     onSort: (i, b) {},
//           //                     tooltip: "Transaction Date"
//           //                 ),
//           //               ],
//           //
//           //               rows: loanSchedule.map((prop) =>
//           //                   DataRow(
//           //                       cells: [
//           //                         DataCell(Text(prop['installmentNo'].toString() == null ? '' : prop['installmentNo'].toString())),
//           //
//           //                         DataCell(Text(
//           //                           prop['principalApplied'].toString() == null ? '---' : prop['principalApplied'].toString()
//           //                               .toString(), style: styles2,)),
//           //                         DataCell(Text(
//           //                           prop['principalPayment'].toString() == null ? '---' : prop['principalPayment'].toString()
//           //                               .toString(), style: styles2,)),
//           //                         DataCell(Text(
//           //                           prop['interestPayment'].toString() == null ? '---' : prop['interestPayment'].toString()
//           //                               .toString(), style: styles2,)),
//           //                         DataCell(Text(
//           //                           prop['principalApplied'].toString() == null ? '---' : prop['principalApplied'].toString()
//           //                               .toString(), style: styles2,)),
//           //                         DataCell(Text(
//           //                           prop['cumulativeInterest'].toString() == null ? '---' : prop['cumulativeInterest'].toString()
//           //                               .toString(), style: styles2,)),
//           //                        // totalPayment
//           //                        //  DataCell(Text(
//           //                        //    prop['dueDate'].toString() == null ? '' : prop['dueDate'].toString()
//           //                        //        .toString(), style: styles2,)),
//           //                         DataCell(Text(f.format(
//           //                             new DateTime.fromMillisecondsSinceEpoch(
//           //                                 prop['dueDate'])), style: styles2,),),
//           //                       ]
//           //                   )).toList(),
//           //             ),
//           //       ),
//           //     ),
//           //   ),
//           // ),
//         ],
//       ),
//     );
//   }
// }
// class RowSource extends DataTableSource {
//
//   final _rowCount = loanLedger.length;
//   final styler2 = TextStyle(fontFamily: "Muli");
//
//   @override
//   //Future <DataTableSource<RowData>>
//
//
//   @override
//   DataRow? getRow(int index){
//     if(index <_rowCount){
//       return /*loanLedger.map((prop)=>*/DataRow(
//           cells: [
//             DataCell(Text('${loanLedger[index]['installmentNo']}')),
//             DataCell(Text('${loanLedger[index]['principalApplied']}',style: styler2,overflow: TextOverflow.fade,
//                 softWrap: true)),
//             DataCell(Text('${loanLedger[index]['principalPayment']}',style: styler2,)),
//             DataCell(Text('${loanLedger[index]['interestPayment']}')),
//             DataCell(Text('${loanLedger[index]['principalApplied']}')),
//             DataCell(Text('${loanLedger[index]['cumulativeInterest']}')),
//             DataCell(Text(f.format(
//                 new DateTime.fromMillisecondsSinceEpoch(
//                     loanLedger[index]['dueDate'])), style: styler2,),),
//
//           ]
//       );
//     }else{
//       return null;
//     }
//   }
//   @override
//   bool get isRowCountApproximate => false;
//
//   @override
//   int get rowCount => _rowCount;
//
//   @override
//   int get selectedRowCount => 0;
// }
import 'package:ezen_sacco/constants.dart';
import 'package:ezen_sacco/disp_pages/disp_loans.dart';
import 'package:ezen_sacco/models/LoanLedger_Transactionmodel.dart';
import 'package:ezen_sacco/models/loanShedule_model.dart';
import 'package:ezen_sacco/services/auth.dart';
import 'package:ezen_sacco/utils/formatter.dart';
import 'package:ezen_sacco/widgets/backbtn_overide.dart';
import 'package:ezen_sacco/widgets/spin_loader.dart';
import 'package:flutter/material.dart';


class LoanSchedule extends StatefulWidget {
  const LoanSchedule({Key? key, required this.loanId}) : super(key: key);
  final loanId;
  @override
  _LoanScheduleState createState() => _LoanScheduleState();
}

class _LoanScheduleState extends State<LoanSchedule> {
  final AuthService auth = AuthService();
  var rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  final stylehead = TextStyle(fontWeight: FontWeight.bold, fontFamily: "Muli",color: Colors.redAccent);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: goback(context),
        title: Text(
          'Loan Schdule',
          style: TextStyle(
              color: Colors.black45,
              fontFamily: "Muli"
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: Colors.redAccent,
            ),
            onPressed: () {
              setState(() {
                print('Reload init');
                // provider.getStatements(context, mounted, reload: true);
                // _data = ApiService().getDividends(true);
              });
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: auth.fetchLoanRepaymentSchedule('${widget.loanId}'),
        builder: (BuildContext ctx, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: PaginatedDataTable(
                source: dataSource(snapshot.data),
                //header: const Text('Employees'),
                columns: const [

                  DataColumn(label: Text('Installment',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontFamily: "Muli",color: Colors.redAccent),
                  )),
                  DataColumn(label: Text('Loan Balance',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontFamily: "Muli",color: Colors.redAccent),
                  )),
                  DataColumn(label: Text('Principle',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontFamily: "Muli",color: Colors.redAccent),
                  )),
                  DataColumn(label: Text('Interest',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontFamily: "Muli",color: Colors.redAccent),
                  )),
                  DataColumn(label: Text('Scheduled Payment',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontFamily: "Muli",color: Colors.redAccent),
                  )),
                  DataColumn(label: Text('Cummulative Interest',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontFamily: "Muli",color: Colors.redAccent),
                  )),
                  DataColumn(label: Text('Date',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontFamily: "Muli",color: Colors.redAccent),
                  )),
                ],
                showCheckboxColumn: false,
                showFirstLastButtons: true,
                rowsPerPage: rowsPerPage,
                availableRowsPerPage: [10, 20],
                columnSpacing: 20,

                onRowsPerPageChanged: (newRowsPerPage){
                  if(newRowsPerPage != null){
                    setState(() {
                      rowsPerPage = newRowsPerPage;
                    });
                  }
                },
              ),
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }else if (snapshot == null){
            Center(
              child: Text('There is No Loan Data to Show',
                style: TextStyle(
                  fontFamily: "Muli",
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              )
              ,);
          }

          // By default, show a loading spinner.
          return Center(child: const LoadingSpinCircle());
        },
      ),
    );
  }

  DataTableSource dataSource(List<LoanSchedules> LoanSchedulesList) =>
      MyData(dataList: LoanSchedulesList);
}

class MyData extends DataTableSource {
  MyData({required this.dataList});
  final List<LoanSchedules> dataList;
  final styled = TextStyle(fontFamily: "Muli");
  // Generate some made-up data

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => dataList.length;
  @override
  int get selectedRowCount => 0;
  @override
  DataRow getRow(int index) {
    return DataRow(
      cells: [
        DataCell(
          Text(dataList[index].installment.toString(),style: styled,),
        ),
        DataCell(
          Text('${formatCurrency(dataList[index].loanBalance)}',style: styled,),
        ),
        DataCell(
          Text('${formatCurrency(dataList[index].principle)}',style: styled,),
        ),
        DataCell(
          Text('${formatCurrency(dataList[index].interest)}',style: styled,),
        ),
        DataCell(
          Text('${formatCurrency(dataList[index].schedulePayment)}',style: styled,),
        ),
        DataCell(
          Text('${formatCurrency(dataList[index].cummulativeInterest)}',style: styled,),
        ),
        DataCell(
            Text(f.format(new DateTime.fromMillisecondsSinceEpoch(dataList[index].date)),style: styled,)
        ),
      ],
    );
  }
}