class PaymentResponseEntity {
  final String? administrator;
  final String? authorization;
  final String? cnpjRede;
  final String? date;
  final String message;
  final String? nsu;
  final String? nsuRede;
  final String? cardNumber;
  final String? paymentType;
  final String? rede;
  final String? cardType;
  final String? value;
  final String? dueDate;

  PaymentResponseEntity({
    this.administrator,
    this.authorization,
    this.cnpjRede,
    this.date,
    required this.message,
    this.nsu,
    this.nsuRede,
    this.cardNumber,
    this.paymentType,
    this.rede,
    this.cardType,
    this.value,
    this.dueDate,
  });
}
