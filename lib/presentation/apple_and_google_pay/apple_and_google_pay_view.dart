import 'package:flutter/material.dart';

import 'package:pay/pay.dart';

import 'payment_configurations.dart' as payment_configurations;

const _paymentItems = [
  PaymentItem(
    label: 'Total',
    amount: '99.99',
    status: PaymentItemStatus.final_price,
  )
];

class AppleAndGooglePayView extends StatefulWidget {
  const AppleAndGooglePayView({super.key});

  @override
  State<AppleAndGooglePayView> createState() => _AppleAndGooglePayViewState();
}

class _AppleAndGooglePayViewState extends State<AppleAndGooglePayView> {
  late final Future<PaymentConfiguration> _googlePayConfigFuture;

  @override
  void initState() {
    super.initState();
    _googlePayConfigFuture =
        PaymentConfiguration.fromAsset('default_google_pay_config.json');
  }

  void onPaymentResult(paymentResult) {
 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('T-shirt Shop'),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        children: [
          _buildProductImage(),
          _buildProductDetails(),
          _buildPaymentButtons(),
        ],
      ),
    );
  }

  Widget _buildProductImage() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: const Image(
        image: AssetImage('assets/images/ts_10_11019a.jpg'),
        height: 350,
      ),
    );
  }

  Widget _buildProductDetails() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Amanda\'s Polo Shirt',
          style: TextStyle(
            fontSize: 22,
            color: Color(0xff333333),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5),
        Text(
          '\$50.20',
          style: TextStyle(
            color: Color(0xff777777),
            fontSize: 16,
          ),
        ),
        SizedBox(height: 15),
        Text(
          'Description',
          style: TextStyle(
            fontSize: 18,
            color: Color(0xff333333),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5),
        Text(
          'A versatile full-zip that you can wear all day long and even...',
          style: TextStyle(
            color: Color(0xff777777),
            fontSize: 15,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentButtons() {
    return Column(
      children: [
        FutureBuilder<PaymentConfiguration>(
          future: _googlePayConfigFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const Text('Error loading Google Pay configuration');
            } else if (snapshot.hasData) {
              return GooglePayButton(
                paymentConfiguration: snapshot.data!,
                paymentItems: _paymentItems,
                type: GooglePayButtonType.buy,
                margin: const EdgeInsets.only(top: 15.0),
                onPaymentResult: onPaymentResult,
                loadingIndicator: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
        ApplePayButton(
          paymentConfiguration: PaymentConfiguration.fromJsonString(
            payment_configurations.defaultApplePay,
          ),
          paymentItems: _paymentItems,
          style: ApplePayButtonStyle.black,
          type: ApplePayButtonType.buy,
          margin: const EdgeInsets.only(top: 15.0),
          onPaymentResult: onPaymentResult,
          loadingIndicator: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ],
    );
  }
}
