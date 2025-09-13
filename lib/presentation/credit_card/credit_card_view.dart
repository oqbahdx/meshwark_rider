import 'package:flutter/material.dart';
import 'package:unicode_moyasar/unicode_moyasar.dart';

class MoyasserPaymentView extends StatefulWidget {
  const MoyasserPaymentView({super.key});

  @override
  State<MoyasserPaymentView> createState() => _MoyasserPaymentViewState();
}

class _MoyasserPaymentViewState extends State<MoyasserPaymentView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
        shape: const StadiumBorder(),
      ),
      body: MoyasarPayment(
        moyasarPaymentData: MoyasarPaymentData(
          appName: "UNICODE",
          secretKey: "sk_test_key",
          publishableSecretKey: "pk_test_key",
          purchaseAmount: 75.50,
          locale: PaymentLocale.en,
          paymentEnvironment: PaymentEnvironment.test,
          paymentOptions: [
            PaymentOption.card,
            PaymentOption.applepay,
            PaymentOption.stcpay,
          ],
        ),
        onPaymentSucess: (response) {
          //TODO Handle success payment response
        
        },
        onPaymentFailed: (response) {
          //TODO Handle failed payment response
         
        },
      ),
    );
  }
}
