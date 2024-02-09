import 'dart:convert';

enum PaymentType { credit, debit, pix }

enum OperationType {
  inCash('1'),
  issuerInstallments('2'),
  establishmentInstallments('3');

  final String value;

  const OperationType(this.value);
}

class PaymentDataEntity {
  final PaymentType paymentType;
  final int valueCents;
  final OperationType? operationType;
  final int? installments;

  PaymentDataEntity({
    required this.paymentType,
    required this.valueCents,
    this.operationType,
    this.installments,
  });

  String _getParsedRequestValue() {
    if (paymentType == PaymentType.pix) {
      return valueCents.toString();
    }

    return (valueCents / 100).toStringAsFixed(2);
  }

  String toRequest() {
    return jsonEncode({
      'paymentType': paymentType,
      'value': _getParsedRequestValue(),
      'operationType': operationType?.name,
      'installments': installments,
    });
  }
}
