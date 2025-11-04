import 'package:flutter/material.dart';
import '../../../../core/widgets/app_scaffold.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Payment',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [Text('Payment integration will be added later.')],
      ),
    );
  }
}
