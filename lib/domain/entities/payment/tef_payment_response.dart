import 'package:flutter_plugin_tef_integration/domain/entities/common/tef_response.dart';
import 'package:flutter_plugin_tef_integration/domain/entities/payment/payment_response.dart';

class TEFPaymentResponseEntity extends TEFResponseEntity {
  final PaymentResponseEntity? receipt;

  TEFPaymentResponseEntity({
    required super.type,
    required super.message,
    this.receipt,
  });

  bool get doneWithPaymentSuccess => receipt?.authorization != null;

  bool get doneWithPaymentError =>
      ((type == TefResponseType.finish || type == TefResponseType.done) &&
          message.toLowerCase().contains('cancelada')) ||
      (receipt != null && receipt!.authorization == null);
}
