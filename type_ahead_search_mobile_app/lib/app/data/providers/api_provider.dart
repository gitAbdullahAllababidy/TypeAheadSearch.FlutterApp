import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:type_ahead_search_mobile_app/app/core/constants/api_constants.dart';
import 'package:type_ahead_search_mobile_app/app/core/errors/failure.dart';
import 'package:type_ahead_search_mobile_app/app/services/dio_service.dart';

class ApiProvider extends GetxService {
  final DioService _dioService;
  
  // Keep track of ongoing requests to cancel them if needed
  final Map<String, CancelToken> _cancelTokens = {};

  ApiProvider({required DioService dioService}) : _dioService = dioService;

  Future<Either<Failure, Map<String, dynamic>>> getEvents(String query, {
    int perPage = ApiConstants.defaultPerPage,
    int page = ApiConstants.defaultPage,
  }) async {
    // Cancel previous request for the same query if it exists
    _cancelPreviousRequest('events_$query');
    
    // Create a new cancel token
    final cancelToken = CancelToken();
    _cancelTokens['events_$query'] = cancelToken;
    
    try {
      final queryParams = {
        ApiConstants.clientIdParam: ApiConstants.clientId,
        ApiConstants.queryParam: query,
        ApiConstants.perPageParam: perPage,
        ApiConstants.pageParam: page,
      };

      final response = await _dioService.get(
        ApiConstants.eventsEndpoint,
        queryParameters: queryParams,
        cancelToken: cancelToken,
      );
      
      // Remove the cancel token after completion
      _cancelTokens.remove('events_$query');
      
      return Right(response);
    } catch (e) {
      _cancelTokens.remove('events_$query');
      
      // Handle cancellation separately
      if (e is DioException && e.type == DioExceptionType.cancel) {
        return const Left(ServerFailure('Request was cancelled'));
      }
      
      return Left(ServerFailure(e.toString()));
    }
  }
  
  void _cancelPreviousRequest(String key) {
    if (_cancelTokens.containsKey(key)) {
      _cancelTokens[key]?.cancel('Cancelled due to new request');
      _cancelTokens.remove(key);
    }
  }
  
  @override
  void onClose() {
    // Cancel all ongoing requests when the service is closed
    for (final token in _cancelTokens.values) {
      token.cancel('Provider closed');
    }
    _cancelTokens.clear();
    super.onClose();
  }
}


