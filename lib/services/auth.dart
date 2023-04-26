import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:ezen_sacco/Pages/Home/homescreen.dart';
import 'package:ezen_sacco/disp_pages/disp_loans.dart';
import 'package:ezen_sacco/disp_pages/reports_alltrnxs.dart';
import 'package:ezen_sacco/models/LoanLedger_Transactionmodel.dart';
import 'package:ezen_sacco/models/alltransactions_model.dart';
import 'package:ezen_sacco/models/loanShedule_model.dart';
import 'package:ezen_sacco/models/shareAccledger_model.dart';
import 'package:ezen_sacco/wrapper.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ezen_sacco/models/user.dart';

class AuthService {

  User? _userdata(use){
    return use != null ? User(email: use) : null ;
  }

  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  internetFunctions()async{
    // String all = 'https://online.ezenfinancials.com/live/api/sacco_loan/applications?memberId=9295777';
    // try{
    //   var response =  await get(Uri.parse(all));
    //   var jsondata = jsonDecode(response.body);
    //   return jsondata;
    // }catch(e){
    //   return e.toString();
    // }
    try {
      final checkConnection = await InternetAddress.lookup('google.com');
      if (checkConnection.isNotEmpty && checkConnection[0].rawAddress.isNotEmpty) {
        return true;
      }
    }on SocketException catch (_) {
      print('not connected');
      return false;
    }
  }


  SignIn(String email, String password, String url) async {
    String all = url.toString()+'/live/api/auth/login';
    Map data = {
      "username": email,
      "password": password
    };

    var send = jsonEncode(data);
    Response response = await http.post(Uri.parse(all), body: send, headers: headers);
    User? use = _userdata(jsonDecode(response.body));
    return use;
  }

  Future userCorouselInfo() async {
    String getInfo = userData[0].toString() +'/api/sacco_members/load/'+userData[1]['saccoMembershipId'].toString() ;
    try{
      var response =  await get(Uri.parse(getInfo));
      var jsondata = jsonDecode(response.body);
      return jsondata;
    }catch(e){
      return e.toString();
    }
  }

  Future getUserAppliedLoans() async{
    //https://online.ezenfinancials.com/live/api/sacco_loan/applications?memberId=9295777
    String gettingLoans =  userData[0]+'/api/sacco_loan/applications?memberId='+userData[1]['saccoMembershipId'].toString();
    try{
      var response =  await get(Uri.parse(gettingLoans));
      var jsondata = jsonDecode(response.body);
      return jsondata;
    }catch(e){
      return e.toString();
    }
  }

  Future getLoanRepaymentSchedule(loanId) async{
    //https://online.ezenfinancials.com/live/api/sacco_loan/repaymentschedule?loanId=950835
    String gettingLoans =  userData[0]+'/live/api/sacco_loan/repaymentschedule?loanId='+loanId.toString();
   // return gettingLoans;
    try{
      var response =  await get(Uri.parse(gettingLoans));
      var jsondata = jsonDecode(response.body);
      return jsondata;
    }catch(e){
      return e.toString();
    }
  }

   Future getUserLoans() async{
    String gettingLoans =  userData[0]+'/api/sacco_loan/applications?membershipId='+userData[1]['saccoMembershipId'].toString()+'&companyId='+userData[1]['companyId'].toString();
   try{
     var response =  await get(Uri.parse(gettingLoans));
     var jsondata = jsonDecode(response.body);
     return jsondata;
   }catch(e){
     return e.toString();
   }
  }

  Future getLoanProduct() async{
    //https://online.ezenfinancials.com/live/api/sacco_loanproducts/list?companyId=1202
    String gettingLoans =  userData[0]+'/api/sacco_loanproducts/list?companyId='+userData[1]['companyId'].toString();
    //return gettingLoans;
    try{
      var response =  await get(Uri.parse(gettingLoans));
      var jsondata = jsonDecode(response.body);
      return jsondata;
    }catch(e){
      return e.toString();
    }
  }

  Future getShares() async{
    String gettingShares = userData[0] + '/api/sacco_shares/accounts?memberId=' + userData[1]['saccoMembershipId'].toString();
    try{
      var resposne = await get(Uri.parse(gettingShares));
      var jsondata = jsonDecode(resposne.body);
      return jsondata;
    }catch(e){
      return e.toString();
    }
  }

  Future getShareDeposits() async{
    String gettingShares = userData[0] + '/live/api/sacco_shares/deposits?membershipId=' + currentUserData['id'].toString();
    try{
      var resposne = await get(Uri.parse(gettingShares));
      var jsondata = jsonDecode(resposne.body);
      return jsondata;
    }catch(e){
      return e.toString();
    }
  }

  Future shareLedger(ledgerId) async{
   // https://online.ezenfinancials.com/live/api/sacco_shares/ledger?ledgerId=9277055&companyId=1202
    String getLedger = userData[0] + '/api/sacco_shares/ledger?ledgerId=' + ledgerId.toString()+'&companyId='+userData[1]['companyId'].toString();
    //return getLedger;
    try{
      var resposne = await get(Uri.parse(getLedger));
      var jsondata = jsonDecode(resposne.body);
      return jsondata;
    }catch(e){
      return e.toString();
    }
  }

  Future getShareProducts() async{
    //https://online.ezenfinancials.com/live/api/sacco_shareproducts/list?companyId=1202
    String gettingShares = userData[0] + '/api/sacco_shareproducts/list?companyId=' + userData[1]['companyId'].toString();
    try{
      var resposne = await get(Uri.parse(gettingShares));
      var jsondata = jsonDecode(resposne.body);
      return jsondata;
    }catch(e){
      return e.toString();
    }
  }


  Future getMonthlyContributions(yearFrom,yearTo) async{
    //https://cloud.ezenfinancials.com/live/api/members/5749/getMemberContribution/8456/2021/2022
    String gettingShares = userData[0] +'/live/api/members/'+userData[1]['companyId'].toString()+'/getMemberContribution/' +userData[1]['saccoMembershipId'].toString()+'/'+yearFrom.toString()+'/'+yearTo.toString();
    //return gettingShares;
    try{
      var resposne = await get(Uri.parse(gettingShares));
      var jsondata = jsonDecode(resposne.body);
      return jsondata;
    }catch(e){
      return e.toString();
    }
   //'/api/sacco_shareproducts/list?companyId=' + userData[1]['companyId'].toString();
  }



  Future getShareTransferOutgoing() async{
    //https://online.ezenfinancials.com/live/api/sacco_shares/transfers?membershipFromId=9295777
    String gettingShares = userData[0] + '/api/sacco_shares/transfers?membershipFromId=' + userData[1]['saccoMembershipId'].toString();
    try{
      var resposne = await get(Uri.parse(gettingShares));
      var jsondata = jsonDecode(resposne.body);
      return jsondata;
    }catch(e){
      return e.toString();
    }
  }

  Future getSavingsTransferIncoming() async{
    //https://online.ezenfinancials.com/live/api/sacco_savings/transfers?membershipToId=9295777
    String savingsTrans = userData[0] + '/api/sacco_savings/transfers?membershipToId=' + userData[1]['saccoMembershipId'].toString();
    try{
      var resposne = await get(Uri.parse(savingsTrans));
      var jsondata = jsonDecode(resposne.body);
      return jsondata;
    }catch(e){
      return e.toString();
    }
  }

  Future getSavingsTransferOutgoing() async{
    //https://online.ezenfinancials.com/live/api/sacco_savings/transfers?membershipFromId=9295777
    String savingsTrans = userData[0] + '/api/sacco_savings/transfers?membershipFromId=' + userData[1]['saccoMembershipId'].toString();
    try{
      var resposne = await get(Uri.parse(savingsTrans));
      var jsondata = jsonDecode(resposne.body);
      return jsondata;
    }catch(e){
      return e.toString();
    }
  }


  Future getShareTransferIncoming() async{
    //https://online.ezenfinancials.com/live/api/sacco_shares/transfers?membershipToId=9295777
    String gettingShares = userData[0] + '/api/sacco_shares/transfers?membershipToId=' + userData[1]['saccoMembershipId'].toString();
    try{
      var resposne = await get(Uri.parse(gettingShares));
      var jsondata = jsonDecode(resposne.body);
      return jsondata;
    }catch(e){
      return e.toString();
    }
  }

  // Future getLoanProducts() async{
  //   String gettingShares = userData[0] + '/api/sacco_shareproducts/list?companyId=' + userData[1]['companyId'].toString();
  //   try{
  //     var resposne = await get(Uri.parse(gettingShares));
  //     var jsondata = jsonDecode(resposne.body);
  //     return jsondata;
  //   }catch(e){
  //     return e.toString();
  //   }
  // }


  Future getSavings() async{
    //https://online.ezenfinancials.com/live/api/sacco_savings/accounts?memberId=9295777

    String gettingShares = userData[0] + '/api/sacco_savings/accounts?memberId=' + currentUserData['id'].toString();
    try{
      var resposne = await get(Uri.parse(gettingShares));
      var jsondata = jsonDecode(resposne.body);
      return jsondata;
    }catch(e){
      return e.toString();
    }
  }



  Future<List> fetchAllTransactions() async {
    //Uri url = Uri.parse("https://online.ezenfinancials.com/live/api/sacco_loan/applications?memberId=8456");
    //final response = await http.get(url);
    // final response = await http.get(url);
    // return employeesFromJson(response.body);
    String allTransactions = userData[0]+'/api/sacco_members/ledger_txns?membershipId='+userData[1]['saccoMembershipId'].toString()+'&companyId='+userData[1]['companyId'].toString();
    final response = await http.get(Uri.parse(allTransactions));
    var jsonData= jsonDecode(response.body);
    var returnData = jsonEncode(jsonData['list']);
    return allTransactionsFromJson(returnData);
  }

  Future<List> fetchLoanLedger(ledgerId) async {
    String loanledgers = userData[0] + '/api/sacco_loan/ledger?ledgerId=' + ledgerId.toString()+'&companyId='+userData[1]['companyId'].toString();
    final response = await http.get(Uri.parse(loanledgers));
    var jsonData= jsonDecode(response.body);
    var returnData = jsonEncode(jsonData['list']);
    return loanLedgerFromJson(returnData);
  }
  Future<List> fetchLoanRepaymentSchedule(loanId) async {
    String gettingLoans =  userData[0]+'/live/api/sacco_loan/repaymentschedule?loanId='+loanId.toString();
    final response = await http.get(Uri.parse(gettingLoans));
    var jsonData= jsonDecode(response.body);
    var returnData = jsonEncode(jsonData['list']);
    return loanScheduleFromJson(returnData);
  }
  Future<List> fetchShareLedger(ledgerId) async {
    String getLedger = userData[0] + '/api/sacco_shares/ledger?ledgerId=' + ledgerId.toString()+'&companyId='+userData[1]['companyId'].toString();
    final response = await http.get(Uri.parse(getLedger));
    var jsonData= jsonDecode(response.body);
    var returnData = jsonEncode(jsonData['list']);
    return shareLedgerFromJson(returnData);
  }

  Future getInterestEarned() async{
    String interstEarned = userData[0]+'/live/api/sacco_savings/interests?membershipFromId='+userData[1]['saccoMembershipId'].toString();
    //return interstEarned;
    try{
      var resposne = await get(Uri.parse(interstEarned));
      var jsondata = jsonDecode(resposne.body);
      return jsondata;
    }catch(e){
      return e.toString();
    }
  }

  Future savingsProduct() async{
    //https://online.ezenfinancials.com/live/api/sacco_savingproducts/list?companyId=1202
    String savingsProduct = userData[0]+'/api/sacco_savingproducts/list?companyId='+userData[1]['companyId'].toString();
    try{
      var resposne = await get(Uri.parse(savingsProduct));
      var jsondata = jsonDecode(resposne.body);
      return jsondata;
    }catch(e){
      return e.toString();
    }
  }

  Future getSavingsDeposits() async{
    //https://online.ezenfinancials.com/live/api/sacco_savings/deposits?membershipId=9295777
    https://online.ezenfinancials.com/live/api/sacco_savings/deposits?membershipId=8456
    String savingsProduct = userData[0]+'/live/api/sacco_savings/deposits?membershipId='+currentUserData['id'].toString();
    try{
      var resposne = await get(Uri.parse(savingsProduct));
      var jsondata = jsonDecode(resposne.body);
      return jsondata;
    }catch(e){
      return e.toString();
    }
  }

  Future getSavingsLedger(ledgerId) async{
    String getSavingsLedger = userData[0] + '/api/sacco_savings/ledger?ledgerId=' + ledgerId.toString()+'&companyId='+userData[1]['companyId'].toString();
    try{
      var resposne = await get(Uri.parse(getSavingsLedger));
      var jsondata = jsonDecode(resposne.body);
      return jsondata;
    }catch(e){
      return e.toString();
    }
  }


  getLoanLimit(loanprodId) async{
    String loanLimit = userData[0] + '/api/sacco_loan/loandefaults?membershipId='+userData[1]['saccoMembershipId'].toString()+'&loanProductId='+loanprodId.toString();
    // return loanLimit;
    try{
      var resposne = await get(Uri.parse(loanLimit));
      var jsondata = jsonDecode(resposne.body);
      return jsondata;
    }catch(e){
      return e.toString();
    }
  }

  loanProjections(loanAmount,feesAsPrincipal,interstRate,numInstal,instalAmnt,intType,intFreq,repayFreq) async{

    var all = userData[0] + '/live/api/sacco_loan/projection';

    Map data = {
    "loanAmount":loanAmount,
    "feeAsPrincipal": feesAsPrincipal,
    "interestRate": interstRate,
    "numberOfInstallments": numInstal,
    "installmentAmount": instalAmnt,
    "interestType": intType,
    "interestFrequency": intFreq,
    "repaymentFrequency": repayFreq
    };

    // return data;
    var send = jsonEncode(data);
    Response response = await http.post(Uri.parse(all), body: send, headers: headers);
    var use = jsonDecode(response.body);
    return use;
  }



  // /api/sacco_loan/loandefaults?membershipId={membershipId}&loanProductId={loanProductId}

  // Future getLoanLedger(ledgerId) async{
  //   //https://online.ezenfinancials.com/live/api/sacco_loan/ledger?ledgerId=958912&companyId=5749
  //   String loanledgers = userData[0] + '/api/sacco_loan/ledger?ledgerId=' + ledgerId.toString()+'&companyId='+userData[1]['companyId'].toString();
  //  // return loanledgers;
  //
  //   try{
  //     var resposne = await get(Uri.parse(loanledgers));
  //     var jsondata = jsonDecode(resposne.body);
  //     return jsondata;
  //   }catch(e){
  //     return e.toString();
  //   }
  // }

  // Future<List> getLoanLedger(ledgerId) async {
  //   //Uri url = Uri.parse("https://online.ezenfinancials.com/live/api/sacco_loan/applications?memberId=8456");
  //   //final response = await http.get(url);
  //   String loanledgers = userData[0] + '/api/sacco_loan/ledger?ledgerId=' + ledgerId.toString()+'&companyId='+userData[1]['companyId'].toString();
  //   final response = await http.get(Uri.parse(loanledgers));
  //   var jsonData= jsonDecode(response.body);
  //   var returnData = jsonEncode(jsonData['list']);
  //   return loanLedgerFromJson(returnData);
  // }


  Future getDividents() async{
   // https://online.ezenfinancials.com/live/api/sacco_shares/dividends?memberId=9295777
    String getDividents = userData[0] + '/api/sacco_shares/dividends?memberId=' + userData[1]['saccoMembershipId'].toString();
    try{
      var resposne = await get(Uri.parse(getDividents));
      var jsondata = jsonDecode(resposne.body);
      return jsondata;
    }catch(e){
      return e.toString();
    }
  }

  Future transferShares() async{
    //https://online.ezenfinancials.com/live/api/sacco_shares/transfers?membershipFromId=9295777
    String shareTransfer = userData[0] + '/api/sacco_shares/transfers?membershipFromId=' + userData[1]['saccoMembershipId'].toString();
    try{
      var resposne = await get(Uri.parse(shareTransfer));
      var jsondata = jsonDecode(resposne.body);
      return jsondata;
    }catch(e){
      return e.toString();
    }
  }

  Future getPaybills()async{
    //https://cloud.ezenfinancials.com/live/api/lipanampesa/list?companyId=6621
    String getPaybills = userData[0] + '/live/api/lipanampesa/list?companyId=' + userData[1]['companyId'].toString();
    try{
      var resposne = await get(Uri.parse(getPaybills));
      var jsondata = jsonDecode(resposne.body);
      return jsondata;
    }catch(e){
      return e.toString();
    }
  }


  Future changePassword(int userId, String oldPassword, String newPassword, String confirmPassword,) async{
    String all = userData[0] + '/live/api/auth/changepwd';
    Map credentials = {
      "userId": userId,
      "oldPassword": oldPassword,
      "newPassword": newPassword,
      "confirmPassword": confirmPassword,
    };
    var sendCredentials = jsonEncode(credentials);
    Response response = await http.post(Uri.parse(all), body: sendCredentials, headers: headers);
    var changed = jsonDecode(response.body);
    return changed;
  }

  Future lipaNaMpesa(bizShortCode, amount, phoneNo, accountRef) async{
    Map paymentDetails = {
      "bizShortCode" : bizShortCode,
      "amount": amount,
      "phoneNo" : phoneNo,
      "accountRef" : accountRef,
    };
    var paymentPayload = jsonEncode(paymentDetails);
    String url = userData[0].toString() + '/api/lipanampesa/stkpush';//+ paymentPayload.toString() + headers.toString();
   // return url;
    try{
      var payment = await http.post(Uri.parse(url), body: paymentPayload, headers: headers);
      // print(payment);
      // return payment;
      var jsondata = jsonDecode(payment.body);
      return jsondata;
    }catch(e){
      return e.toString();
    }
  }

 Future registerWithEmailAndPassword(String email, String password) async{

    try{
      Response response = await get(Uri.parse("http://worldtimeapi.org/api/timezone/Europe/London"));
      Map data = jsonDecode(response.body);
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString(email, data['name']);
    }
    catch(e){
      return e.toString();
   }
 }

}