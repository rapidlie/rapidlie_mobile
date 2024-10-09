import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:rapidlie/features/contacts/repository/telephone_numbers_repository.dart';
import 'package:rapidlie/features/events/repository/event_respository.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<Dio>(() => Dio());
  locator.registerLazySingleton<EventRepository>(
      () => EventRepositoryImpl(locator<Dio>()));

  locator.registerLazySingleton<TelephoneNumbersRepository>(
      () => TelephoneNumbersRepositoryImpl(locator<Dio>()));
}
