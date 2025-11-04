import 'package:equatable/equatable.dart';

class PaymentMethod extends Equatable {
  final String id;
  final String name;
  final String type;
  final String? description;
  final String? iconUrl;
  final bool isActive;
  final int displayOrder;

  const PaymentMethod({
    required this.id,
    required this.name,
    required this.type,
    this.description,
    this.iconUrl,
    this.isActive = true,
    this.displayOrder = 0,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        type,
        description,
        iconUrl,
        isActive,
        displayOrder,
      ];
}
