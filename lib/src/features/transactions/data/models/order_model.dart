import '../../domain/entities/order.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    required super.id,
    required super.userId,
    required super.items,
    required super.totalAmount,
    required super.status,
    super.paymentMethod,
    super.paymentId,
    required super.createdAt,
    super.paidAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['orderId']?.toString() ?? json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? json['customerId']?.toString() ?? '',
      items: (json['items'] as List<dynamic>?)
              ?.map((item) => OrderItemModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      totalAmount: (json['totalAmount'] ?? json['total'] ?? 0).toDouble(),
      status: json['status'] ?? 'pending',
      paymentMethod: json['paymentMethod'] ?? json['paymentType'],
      paymentId: json['paymentId']?.toString(),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : json['orderDate'] != null
              ? DateTime.parse(json['orderDate'])
              : DateTime.now(),
      paidAt: json['paidAt'] != null ? DateTime.parse(json['paidAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => (item as OrderItemModel).toJson()).toList(),
      'totalAmount': totalAmount,
      'status': status,
      'paymentMethod': paymentMethod,
      'paymentId': paymentId,
      'createdAt': createdAt.toIso8601String(),
      'paidAt': paidAt?.toIso8601String(),
    };
  }

  OrderEntity toEntity() => OrderEntity(
        id: id,
        userId: userId,
        items: items,
        totalAmount: totalAmount,
        status: status,
        paymentMethod: paymentMethod,
        paymentId: paymentId,
        createdAt: createdAt,
        paidAt: paidAt,
      );
}

class OrderItemModel extends OrderItem {
  const OrderItemModel({
    required super.id,
    required super.itemType,
    required super.itemId,
    required super.itemName,
    required super.price,
    super.quantity,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id']?.toString() ?? '',
      itemType: json['itemType'] ?? json['type'] ?? 'Course',
      itemId: json['itemId']?.toString() ?? json['courseId']?.toString() ?? '',
      itemName: json['itemName'] ?? json['name'] ?? json['title'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'itemType': itemType,
      'itemId': itemId,
      'itemName': itemName,
      'price': price,
      'quantity': quantity,
    };
  }

  OrderItem toEntity() => OrderItem(
        id: id,
        itemType: itemType,
        itemId: itemId,
        itemName: itemName,
        price: price,
        quantity: quantity,
      );
}
