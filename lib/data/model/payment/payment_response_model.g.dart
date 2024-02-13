// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentResponseModel _$PaymentResponseModelFromJson(Map json) =>
    PaymentResponseModel(
      administratorModel: json['administradora'] as String,
      authorizationModel: json['autorizacao'] as String,
      cnpjRedeModel: json['cnpjRede'] as String,
      dateModel: json['data'] as String,
      messageModel: json['mensagem'] as String,
      nsuModel: json['nsu'] as String,
      nsuRedeModel: json['nsuRede'] as String,
      cardNumberModel: json['numeroCartao'] as String,
      paymentTypeModel: json['pagamento'] as String,
      redeModel: json['rede'] as String,
      cardTypeModel: json['tipoCartao'] as String,
      valueModel: json['valor'] as String,
      dueDateModel: json['vencimento'] as String,
    );

Map<String, dynamic> _$PaymentResponseModelToJson(
        PaymentResponseModel instance) =>
    <String, dynamic>{
      'administradora': instance.administratorModel,
      'autorizacao': instance.authorizationModel,
      'cnpjRede': instance.cnpjRedeModel,
      'data': instance.dateModel,
      'mensagem': instance.messageModel,
      'nsu': instance.nsuModel,
      'nsuRede': instance.nsuRedeModel,
      'numeroCartao': instance.cardNumberModel,
      'pagamento': instance.paymentTypeModel,
      'rede': instance.redeModel,
      'tipoCartao': instance.cardTypeModel,
      'valor': instance.valueModel,
      'vencimento': instance.dueDateModel,
    };
