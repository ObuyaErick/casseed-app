import 'package:casseed/api/api_client.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: "http://localhost:4000/api/v1/", ref: ref);
});
