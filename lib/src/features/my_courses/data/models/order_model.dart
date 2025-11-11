import 'package:equatable/equatable.dart';

import '../../../catalog/domain/entities/course.dart';
import '../../domain/entities/order.dart';

class OrderModel extends Equatable {
  final String id;
  final String userId;
  final List<OrderItemModel> items;
  final double totalAmount;
  final String status;
  final String? paymentMethod;
  final String? paymentUrl;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? paidAt;
  final String? failureReason;

  const OrderModel({
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

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? json['user_id'] as String? ?? '',
      items: (json['items'] as List<dynamic>?)
              ?.map((item) => OrderItemModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? (json['total_amount'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] as String? ?? '',
      paymentMethod: json['paymentMethod'] as String? ?? json['payment_method'] as String?,
      paymentUrl: json['paymentUrl'] as String? ?? json['payment_url'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : json['updated_at'] != null
              ? DateTime.parse(json['updated_at'] as String)
              : null,
      paidAt: json['paidAt'] != null
          ? DateTime.parse(json['paidAt'] as String)
          : json['paid_at'] != null
              ? DateTime.parse(json['paid_at'] as String)
              : null,
      failureReason: json['failureReason'] as String? ?? json['failure_reason'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => item.toJson()).toList(),
      'totalAmount': totalAmount,
      'status': status,
      if (paymentMethod != null) 'paymentMethod': paymentMethod,
      if (paymentUrl != null) 'paymentUrl': paymentUrl,
      'createdAt': createdAt.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
      if (paidAt != null) 'paidAt': paidAt!.toIso8601String(),
      if (failureReason != null) 'failureReason': failureReason,
    };
  }

  Order toEntity() {
    return Order(
      id: id,
      userId: userId,
      items: items.map((item) => item.toEntity()).toList(),
      totalAmount: totalAmount,
      status: status,
      paymentMethod: paymentMethod,
      paymentUrl: paymentUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
      paidAt: paidAt,
      failureReason: failureReason,
    );
  }

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

class OrderItemModel extends Equatable {
  final String courseId;
  final Course? course;
  final double price;
  final int quantity;

  const OrderItemModel({
    required this.courseId,
    this.course,
    required this.price,
    this.quantity = 1,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      courseId: json['courseId'] as String? ?? json['course_id'] as String? ?? '',
      // course: json['course'] != null ? Course.fromJson(json['course'] as Map<String, dynamic>) : null,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      quantity: json['quantity'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'courseId': courseId,
      if (course != null) 'course': course.toString(), // Simplified
      'price': price,
      'quantity': quantity,
    };
  }

  OrderItem toEntity() {
    return OrderItem(
      courseId: courseId,
      course: course,
      price: price,
      quantity: quantity,
    );
  }

  @override
  List<Object?> get props => [
        courseId,
        course,
        price,
        quantity,
      ];
}
