import 'package:flutter_plugin_tef_integration/domain/entities/payment/payment_response.dart';
import 'package:flutter_plugin_tef_integration/domain/repository/tef_repository.dart';
import 'package:ideploy_package/ideploy_package.dart';

@injectable
class GetPaymentResponseFromStringUseCase {
  final TefRepository _repository;

  GetPaymentResponseFromStringUseCase({required TefRepository repository})
      : _repository = repository;

  EitherOf<Failure, PaymentResponseEntity> call(String data) {
    return _repository.getPaymentResponseFromString(data);
  }
}
