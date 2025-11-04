import 'package:equatable/equatable.dart';

class Payment extends Equatable {
  final String orderId;
  final String paymentMethod;
  final double amount;
  final String? paymentUrl;
  final String? transactionId;
  final String status;
  final DateTime createdAt;

  const Payment({
    required this.orderId,
    required this.paymentMethod,
    required this.amount,
    this.paymentUrl,
    this.transactionId,
    required this.status,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        orderId,
        paymentMethod,
        amount,
        paymentUrl,
        transactionId,
        status,
        createdAt,
      ];
}

class VnPayCallback extends Equatable {
  final bool success;
  final String? orderId;
  final String? transactionId;
  final String message;

  const VnPayCallback({
    required this.success,
    this.orderId,
    this.transactionId,
    required this.message,
  });

  @override
  List<Object?> get props => [success, orderId, transactionId, message];
}
