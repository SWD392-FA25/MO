import 'package:equatable/equatable.dart';

class OrderEntity extends Equatable {
  final String id;
  final String userId;
  final List<OrderItem> items;
  final double totalAmount;
  final String status;
  final String? paymentMethod;
  final String? paymentId;
  final DateTime createdAt;
  final DateTime? paidAt;

  const OrderEntity({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.status,
    this.paymentMethod,
    this.paymentId,
    required this.createdAt,
    this.paidAt,
  });

  bool get isPaid => status == 'paid' || status == 'Paid' || status == 'completed';
  bool get isPending => status == 'pending' || status == 'Pending';

  @override
  List<Object?> get props => [
        id,
        userId,
        items,
        totalAmount,
        status,
        paymentMethod,
        paymentId,
        createdAt,
        paidAt,
      ];
}

class OrderItem extends Equatable {
  final String id;
  final String itemType;
  final String itemId;
  final String itemName;
  final double price;
  final int quantity;

  const OrderItem({
    required this.id,
    required this.itemType,
    required this.itemId,
    required this.itemName,
    required this.price,
    this.quantity = 1,
  });

  @override
  List<Object?> get props => [
        id,
        itemType,
        itemId,
        itemName,
        price,
        quantity,
      ];
}
