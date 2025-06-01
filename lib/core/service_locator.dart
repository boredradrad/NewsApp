import 'package:get_it/get_it.dart';
import 'package:news_app/core/datasource/remote_data/api_service.dart';
import 'package:news_app/core/datasource/remote_data/base_api_service.dart';

import '../features/home/repositories/base_news_api_repository.dart';
import '../features/home/repositories/news_api_repository.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton<BaseApiService>(ApiService());


  locator.registerSingleton<BaseNewsApiRepository>(
    NewsApiRepositoryImpl(locator<BaseApiService>()),
  );
}
