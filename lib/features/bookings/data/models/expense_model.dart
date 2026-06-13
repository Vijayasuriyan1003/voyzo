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
    'Toll',
    'Night',
    'Parking',
    'Fuel',
    'Food',
    'Maintenance',
    'Other',
  ];

  factory ExpenseModel.fromJson(Map j) => ExpenseModel(
        id: j['name']?.toString() ?? '',
        type: j['expense_type']?.toString() ?? '',
        amount: double.tryParse(j['amount']?.toString() ?? '0') ?? 0,
        notes: j['notes']?.toString(),
        addedAt: j['creation'] != null
            ? DateTime.tryParse(j['creation'].toString()) ?? DateTime.now()
            : DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        'expense_type': type,
        'amount': amount,
        if (notes != null) 'notes': notes,
      };
}
