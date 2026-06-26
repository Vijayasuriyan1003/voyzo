class ExpenseModel {
  final String id;
  final String type;
  final double amount;
  final String? notes;
  final DateTime addedAt;

  const ExpenseModel({
    required this.id,
    required this.type,
    required this.amount,
    this.notes,
    required this.addedAt,
  });

  static const List<String> expenseTypes = [
    'Toll / Parking',
    'Night/driver',
    'Per Hour',
    'Per KM',
    'Food',
    'Maintenance',
    'Other',
  ];
}
