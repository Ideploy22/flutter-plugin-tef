part of 'payment_response_model.dart';

PaymentResponseModel _$PaymentResponseModelFromEntity(
        PaymentResponseEntity entity) =>
    PaymentResponseModel(
      administratorModel: entity.administrator,
      authorizationModel: entity.authorization,
      cnpjRedeModel: entity.cnpjRede,
      dateModel: entity.date,
      messageModel: entity.message,
      nsuModel: entity.nsu,
      nsuRedeModel: entity.nsuRede,
      cardNumberModel: entity.cardNumber,
      paymentTypeModel: entity.paymentType,
      redeModel: entity.rede,
      cardTypeModel: entity.cardType,
      valueModel: entity.value,
      dueDateModel: entity.dueDate,
    );

PaymentResponseEntity _$PaymentResponseModelToEntity(
        PaymentResponseModel model) =>
    PaymentResponseEntity(
      administrator: model.administratorModel,
      authorization: model.authorizationModel,
      cnpjRede: model.cnpjRedeModel,
      date: model.dateModel,
      message: model.messageModel,
      nsu: model.nsuModel,
      nsuRede: model.nsuRedeModel,
      cardNumber: model.cardNumberModel,
      paymentType: model.paymentTypeModel,
      rede: model.redeModel,
      cardType: model.cardTypeModel,
      value: model.valueModel,
      dueDate: model.dueDateModel,
    );
