import '../../domain/entities/payment.dart';

class PaymentModel extends Payment {
  const PaymentModel({
    required super.orderId,
    required super.paymentMethod,
    required super.amount,
    super.paymentUrl,
    super.transactionId,
    required super.status,
    required super.createdAt,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      orderId: json['orderId']?.toString() ?? '',
      paymentMethod: json['paymentMethod'] ?? 'VnPay',
      amount: (json['amount'] ?? 0).toDouble(),
      paymentUrl: json['paymentUrl'] ?? json['url'] ?? json['checkoutUrl'],
      transactionId: json['transactionId']?.toString() ?? json['txnRef']?.toString(),
      status: json['status'] ?? 'pending',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'paymentMethod': paymentMethod,
      'amount': amount,
      'paymentUrl': paymentUrl,
      'transactionId': transactionId,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Payment toEntity() => Payment(
        orderId: orderId,
        paymentMethod: paymentMethod,
        amount: amount,
        paymentUrl: paymentUrl,
        transactionId: transactionId,
        status: status,
        createdAt: createdAt,
      );
}

class VnPayCallbackModel extends VnPayCallback {
  const VnPayCallbackModel({
    required super.success,
    super.orderId,
    super.transactionId,
    required super.message,
  });

  factory VnPayCallbackModel.fromJson(Map<String, dynamic> json) {
    return VnPayCallbackModel(
      success: json['success'] ?? json['isSuccess'] ?? false,
      orderId: json['orderId']?.toString(),
      transactionId: json['transactionId']?.toString() ?? json['vnp_TxnRef']?.toString(),
      message: json['message'] ?? json['msg'] ?? 'Transaction processed',
    );
  }

  VnPayCallback toEntity() => VnPayCallback(
        success: success,
        orderId: orderId,
        transactionId: transactionId,
        message: message,
      );
}
