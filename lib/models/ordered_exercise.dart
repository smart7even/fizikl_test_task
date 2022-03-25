class OrderedExercise {
  final int id;
  final int order;
  final String orderPrefix;

  OrderedExercise({
    required this.id,
    required this.order,
    required this.orderPrefix,
  });

  factory OrderedExercise.fromJson(Map<String, dynamic> json) {
    return OrderedExercise(
      id: json['id'],
      order: json['order'],
      orderPrefix: json['order_prefix'],
    );
  }
}
