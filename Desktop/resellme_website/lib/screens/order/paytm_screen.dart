import 'package:flutter/material.dart';


import 'dart:convert';
import 'package:http/http.dart' as http;

class PaytmPaymentScreen extends StatelessWidget {
  const PaytmPaymentScreen({super.key});

  Future<void> processPayment() async {
    const String backendUrl = "https://ResellMe.tech/OrderEngine/PaytmStartTxnServlet";

    final response = await http.post(
      Uri.parse(backendUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "orderId": "ORDER123",
        "amount": "100.00",
        "callbackUrl": "https://yourcallbackurl.com"
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String txnToken = data['body']['txnToken'];
      String mid = "your_merchant_id";
      String orderId = "ORDER123";
      String amount = "100.00";

      // initiatePaytmPayment(txnToken, orderId, mid, amount);
    } else {
      print("Failed to get txnToken");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Paytm Payment")),
      body: Center(
        child: ElevatedButton(
          onPressed: processPayment,
          child: Text("Pay Now"),
        ),
      ),
    );
  }
}


// void initiatePaytmPayment(String txnToken, String orderId, String mid, String amount) {
//   final form = html.FormElement();
//   form.action = "https://securegw-stage.paytm.in/theia/api/v1/showPaymentPage?mid=$mid&orderId=$orderId";
//   form.method = "POST";
//
//   form.append(html.InputElement()
//     ..type = "hidden"
//     ..name = "mid"
//     ..value = mid);
//
//   form.append(html.InputElement()
//     ..type = "hidden"
//     ..name = "orderId"
//     ..value = orderId);
//
//   form.append(html.InputElement()
//     ..type = "hidden"
//     ..name = "txnToken"
//     ..value = txnToken);
//
//   form.append(html.InputElement()
//     ..type = "hidden"
//     ..name = "txnAmount"
//     ..value = amount);
//
//   html.document.body!.append(form);
//   form.submit();
// }
