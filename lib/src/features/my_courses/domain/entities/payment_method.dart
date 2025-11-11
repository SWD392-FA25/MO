import 'package:equatable/equatable.dart';

class PaymentMethod extends Equatable {
  final String id;
  final String name;
  final String type;
  final String? iconPath;
  final String? provider;
  final bool isActive;
  final String? country;
  final String currency;

  const PaymentMethod({
    required this.id,
    required this.name,
    this.type = 'card',
    this.iconPath,
    this.provider,
    this.isActive = false,
    this.country,
    this.currency = 'USD',
  });

  @override
  List<Object?> get props => [
        id,
        name,
        type,
        iconPath,
        provider,
        isActive,
        country,
        currency,
      ];

  String get displayName => '$currency $name';

  String get displayText => type.toUpperCase();

  bool get isApplePay => provider == 'apple-pay';

  bool get isGooglePay => provider == 'google-pay';

  bool get isCardPay => provider == 'card-pay' || provider == 'credit-card';
  
  bool get isEnabled => isActive && (isApplePay || isGooglePay || isCardPay);
}

class Receipt extends Equatable {
  final String id;
  final String orderId;
  final String userId;
  final List<ReceiptItem> items;
  final double totalAmount;
  final double taxAmount;
  final double shippingAmount;
  final double finalAmount;
  final String status;
  final String? paymentUrl;
  final DateTime createdAt;
  final DateTime? paidAt;
  final String? notes;

  const Receipt({
    required this.id,
    required this.orderId,
    required this.userId,
    required this.items,
    required this.totalAmount,
    this.taxAmount = 0.0,
    this.shippingAmount = 0.0,
    this.finalAmount = 0.0,
    this.status = 'pending',
    this.paymentUrl,
    required this.createdAt,
    this.paidAt,
    this.notes,
  });

  bool get isPaid => status.toLowerCase() == 'paid' || status.toLowerCase() == 'completed';

  String formattedTotalAmount() => '\$${finalAmount.toStringAsFixed(2)}';

  @override
  List<Object?> get props => [
        id,
        orderId,
        userId,
        items,
        totalAmount,
        taxAmount,
        shippingAmount,
        finalAmount,
        status,
        paymentUrl,
        createdAt,
        paidAt,
        notes,
      ];
}

class ReceiptItem extends Equatable {
  final String productId;
  final String? productName;
  final String? productImageUrl;
  final double price;
  final int quantity;
  final double discount;

  const ReceiptItem({
    required this.productId,
    this.productName,
    this.productImageUrl,
    required this.price,
    required this.quantity,
    this.discount = 0.0,
  });

  @override
  List<Object?> get props => [
        productId,
        productName,
        productImageUrl,
        price,
        quantity,
        discount,
      ];
}
