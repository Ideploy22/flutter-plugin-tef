class PaymentResponseEntity {
  final String administrator;
  final String authorization;
  final String cnpjRede;
  final String date;
  final String message;
  final String nsu;
  final String nsuRede;
  final String cardNumber;
  final String paymentType;
  final String rede;
  final String cardType;
  final String value;
  final String dueDate;

  PaymentResponseEntity({
    required this.administrator,
    required this.authorization,
    required this.cnpjRede,
    required this.date,
    required this.message,
    required this.nsu,
    required this.nsuRede,
    required this.cardNumber,
    required this.paymentType,
    required this.rede,
    required this.cardType,
    required this.value,
    required this.dueDate,
  });
}
