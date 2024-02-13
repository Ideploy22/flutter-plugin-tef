import 'package:flutter_plugin_tef_integration/domain/entities/payment/payment_response.dart';
import 'package:ideploy_package/ideploy_package.dart';

part 'payment_response_model.g.dart';
part 'payment_response_model.mapper.dart';

@JsonSerializable(anyMap: true)
class PaymentResponseModel extends PaymentResponseEntity {
  @JsonKey(name: 'administradora')
  final String administratorModel;

  @JsonKey(name: 'autorizacao')
  final String authorizationModel;

  @JsonKey(name: 'cnpjRede')
  final String cnpjRedeModel;

  @JsonKey(name: 'data')
  final String dateModel;

  @JsonKey(name: 'mensagem')
  final String messageModel;

  @JsonKey(name: 'nsu')
  final String nsuModel;

  @JsonKey(name: 'nsuRede')
  final String nsuRedeModel;

  @JsonKey(name: 'numeroCartao')
  final String cardNumberModel;

  @JsonKey(name: 'pagamento')
  final String paymentTypeModel;

  @JsonKey(name: 'rede')
  final String redeModel;

  @JsonKey(name: 'tipoCartao')
  final String cardTypeModel;

  @JsonKey(name: 'valor')
  final String valueModel;

  @JsonKey(name: 'vencimento')
  final String dueDateModel;

  PaymentResponseModel({
    required this.administratorModel,
    required this.authorizationModel,
    required this.cnpjRedeModel,
    required this.dateModel,
    required this.messageModel,
    required this.nsuModel,
    required this.nsuRedeModel,
    required this.cardNumberModel,
    required this.paymentTypeModel,
    required this.redeModel,
    required this.cardTypeModel,
    required this.valueModel,
    required this.dueDateModel,
  }) : super(
          administrator: administratorModel,
          authorization: authorizationModel,
          cnpjRede: cnpjRedeModel,
          date: dateModel,
          message: messageModel,
          nsu: nsuModel,
          nsuRede: nsuRedeModel,
          cardNumber: cardNumberModel,
          paymentType: paymentTypeModel,
          rede: redeModel,
          cardType: cardTypeModel,
          value: valueModel,
          dueDate: dueDateModel,
        );

  factory PaymentResponseModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentResponseModelToJson(this);

  factory PaymentResponseModel.fromEntity(PaymentResponseEntity entity) =>
      _$PaymentResponseModelFromEntity(entity);

  PaymentResponseEntity toEntity() => _$PaymentResponseModelToEntity(this);
}
