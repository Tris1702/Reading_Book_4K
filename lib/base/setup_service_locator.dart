import 'package:get_it/get_it.dart';
import 'package:reading_book_4k/services/app_shared_preference.dart';
import 'package:reading_book_4k/services/database_service.dart';
import 'package:reading_book_4k/services/navigator_service.dart';

void setUpServiceLocator() {
  GetIt getIt = GetIt.I;
  getIt.registerLazySingleton<NavigatorService>(() => NavigatorService());
  getIt.registerLazySingleton<AppSharedPreference>(() => AppSharedPreference());
  getIt.registerLazySingleton<DatabaseService>(() => DatabaseService());
}
