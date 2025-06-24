class RecentSale {
  final String customerName;
  final String amount;
  final int pieces;
  final DateTime dateTime;
  final String paymentMethod;

  RecentSale({
    required this.customerName,
    required this.amount,
    required this.pieces,
    required this.dateTime,
    required this.paymentMethod,
  });
}
