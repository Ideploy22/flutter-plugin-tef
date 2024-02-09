import 'package:flutter_plugin_tef_integration/domain/entities/configure_tef_entity.dart';
import 'package:flutter_plugin_tef_integration/domain/repository/tef_repository.dart';
import 'package:ideploy_package/ideploy_package.dart';

@injectable
class GetConfigurationUseCase {
  final TefRepository _repository;

  GetConfigurationUseCase({required TefRepository repository})
      : _repository = repository;

  Future<EitherOf<Failure, ConfigureTEFEntity?>> call() {
    return _repository.getConfigurationData();
  }
}
