import '../../domain/entities/payment_method.dart';

class PaymentMethodModel extends PaymentMethod {
  const PaymentMethodModel({
    required super.id,
    required super.name,
    required super.type,
    super.description,
    super.iconUrl,
    super.isActive,
    super.displayOrder,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? json['methodName'] ?? '',
      type: json['type'] ?? json['paymentType'] ?? 'default',
      description: json['description'],
      iconUrl: json['iconUrl'] ?? json['icon'],
      isActive: json['isActive'] ?? json['active'] ?? true,
      displayOrder: json['displayOrder'] ?? json['order'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'description': description,
      'iconUrl': iconUrl,
      'isActive': isActive,
      'displayOrder': displayOrder,
    };
  }

  PaymentMethod toEntity() => PaymentMethod(
        id: id,
        name: name,
        type: type,
        description: description,
        iconUrl: iconUrl,
        isActive: isActive,
        displayOrder: displayOrder,
      );
}
