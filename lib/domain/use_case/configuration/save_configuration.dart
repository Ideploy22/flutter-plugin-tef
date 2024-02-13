import 'package:flutter_plugin_tef_integration/domain/entities/configure/configure_tef_entity.dart';
import 'package:flutter_plugin_tef_integration/domain/repository/tef_repository.dart';
import 'package:ideploy_package/ideploy_package.dart';

@injectable
class SaveConfigurationUseCase {
  final TefRepository _repository;

  SaveConfigurationUseCase({required TefRepository repository})
      : _repository = repository;

  Future<EitherOf<Failure, VoidSuccess>> call(ConfigureTEFEntity data) {
    return _repository.saveConfigurationData(data);
  }
}
