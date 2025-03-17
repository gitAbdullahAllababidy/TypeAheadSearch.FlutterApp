import 'package:type_ahead_search_mobile_app/app/core/errors/failure.dart';

class ApiConstants {
  static const String baseUrl = 'https://api.seatgeek.com/2';
  static const String clientId = ''; 
  static const String eventsEndpoint = '/events';
  
  // Query parameters
  static const String clientIdParam = 'client_id';
  static const String queryParam = 'q';
  static const String perPageParam = 'per_page';
  static const String pageParam = 'page';
  
  // Default values
  static const int defaultPerPage = 25;
  static const int defaultPage = 1;
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class ConnectionFailure extends Failure {
  const ConnectionFailure(super.message);
}