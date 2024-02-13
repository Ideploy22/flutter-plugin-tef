// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:ideploy_package/ideploy_package.dart' as _i5;
import 'package:injectable/injectable.dart' as _i2;

import '../data/data_source/tef_data_source.dart' as _i3;
import '../data/data_source/tef_data_source_impl.dart' as _i4;
import '../data/repository/tef_repository.dart' as _i7;
import '../domain/repository/tef_repository.dart' as _i6;
import '../domain/use_case/configuration/get_configuration.dart' as _i8;
import '../domain/use_case/configuration/save_configuration.dart' as _i10;
import '../domain/use_case/payment/payment_response_from_string.dart' as _i9;
import '../presentation/controller/tef_controller.dart' as _i11;

// initializes the registration of main-scope dependencies inside of GetIt
_i1.GetIt $initGetIt(
  _i1.GetIt getIt, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i2.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  gh.factory<_i3.TefDataSource>(
      () => _i4.TefDataSourceImpl(hive: gh<_i5.HiveInterface>()));
  gh.factory<_i6.TefRepository>(
      () => _i7.TefRepositoryImpl(dataSource: gh<_i3.TefDataSource>()));
  gh.factory<_i8.GetConfigurationUseCase>(
      () => _i8.GetConfigurationUseCase(repository: gh<_i6.TefRepository>()));
  gh.factory<_i9.GetPaymentResponseFromStringUseCase>(() =>
      _i9.GetPaymentResponseFromStringUseCase(
          repository: gh<_i6.TefRepository>()));
  gh.factory<_i10.SaveConfigurationUseCase>(
      () => _i10.SaveConfigurationUseCase(repository: gh<_i6.TefRepository>()));
  gh.lazySingleton<_i11.TefController>(() => _i11.TefController(
        getConfigurationUseCase: gh<_i8.GetConfigurationUseCase>(),
        saveConfigurationUseCase: gh<_i10.SaveConfigurationUseCase>(),
        getPaymentResponseFromStringUseCase:
            gh<_i9.GetPaymentResponseFromStringUseCase>(),
      ));
  return getIt;
}
