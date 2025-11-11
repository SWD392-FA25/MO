import 'package:equatable/equatable.dart';

import '../../../catalog/domain/entities/course.dart';

class Order extends Equatable {
  final String id;
  final String userId;
  final List<OrderItem> items;
  final double totalAmount;
  final String status;
  final String? paymentMethod;
  final String? paymentUrl;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? paidAt;
  final String? failureReason;

  const Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.status,
    this.paymentMethod,
    this.paymentUrl,
    required this.createdAt,
    this.updatedAt,
    this.paidAt,
    this.failureReason,
  });

  bool get isPending => status.toLowerCase() == 'pending';
  bool get isPaid => status.toLowerCase() == 'paid' || status.toLowerCase() == 'completed';
  bool get isFailed => status.toLowerCase() == 'failed' || status.toLowerCase() == 'cancelled';
  bool get canRetry => isFailed || (isPending && paymentUrl == null);

  @override
  List<Object?> get props => [
        id,
        userId,
        items,
        totalAmount,
        status,
        paymentMethod,
        paymentUrl,
        createdAt,
        updatedAt,
        paidAt,
        failureReason,
      ];
}

class OrderItem extends Equatable {
  final String courseId;
  final Course? course;
  final double price;
  final int quantity;

  const OrderItem({
    required this.courseId,
    this.course,
    required this.price,
    this.quantity = 1,
  });

  @override
  List<Object?> get props => [
        courseId,
        course,
        price,
        quantity,
      ];
}
