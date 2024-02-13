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
      'paymentType': paymentType.name,
      'value': _getParsedRequestValue(),
      'operationType': operationType?.value,
      'installments': installments,
    });
  }

  factory PaymentDataEntity.credit({
    required int valueCents,
    int installments = 1,
    OperationType? operationType,
  }) =>
      PaymentDataEntity(
        paymentType: PaymentType.credit,
        valueCents: valueCents,
        installments: installments,
        operationType: operationType,
      );

  factory PaymentDataEntity.pix({required int valueCents}) => PaymentDataEntity(
        paymentType: PaymentType.pix,
        valueCents: valueCents,
      );

  factory PaymentDataEntity.debit({required int valueCents}) =>
      PaymentDataEntity(
        paymentType: PaymentType.debit,
        valueCents: valueCents,
      );
}
