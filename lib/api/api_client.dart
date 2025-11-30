import 'dart:convert';
import 'dart:typed_data';

import 'package:casseed/api/api_response.dart';
import 'package:casseed/providers/auth_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;

enum ApiScope { data, auth, action, media }

class ApiClient {
  final String baseUrl;
  final Ref ref;

  ApiClient({required this.baseUrl, required this.ref});

  Map<String, String> get baseHeaders {
    final accessToken = ref.read(accessTokenProvider);
    return {
      'Content-Type': 'application/json',
      if (accessToken != null) 'Authorization': 'Bearer $accessToken',
    };
  }

  Future<ApiResponse<R>> delete<R>(
    String path, {
    ApiScope scope = ApiScope.data,
    Map<String, String>? headers,
    Map<String, Iterable<String>>? queryParameters,
    Object? body,
    required R Function(Object? json) fromJsonT,
  }) async {
    final response = await http.delete(
      Uri.parse(
        "$baseUrl${scope.name}/",
      ).resolve(path).replace(queryParameters: queryParameters),
      headers: {...baseHeaders, ...(headers ?? {})},
      body: json.encode(body),
    );
    return ApiResponse.fromJson(jsonDecode(response.body), fromJsonT);
  }

  Future<ApiResponse<R>> get<R>(
    String path, {
    ApiScope scope = ApiScope.data,
    Map<String, String>? headers,
    Map<String, Iterable<String>>? queryParameters,
    Object? body,
    required R Function(Object? json) fromJsonT,
  }) async {
    final response = await http.get(
      Uri.parse(
        "$baseUrl${scope.name}/",
      ).resolve(path).replace(queryParameters: queryParameters),
      headers: {...baseHeaders, ...(headers ?? {})},
    );
    return ApiResponse.fromJson(jsonDecode(response.body), fromJsonT);
  }

  Future<ApiResponse<R>> post<R>(
    String path, {
    ApiScope scope = ApiScope.data,
    Map<String, String>? headers,
    Map<String, Iterable<String>>? queryParameters,
    bool raw = false,
    Object? rawBody,
    Object? body,
    required R Function(Object? json) fromJsonT,
  }) async {
    final response = await http.post(
      Uri.parse(
        "$baseUrl${scope.name}/",
      ).resolve(path).replace(queryParameters: queryParameters),
      headers: {...baseHeaders, ...(headers ?? {})},
      body: raw ? rawBody : json.encode(body),
    );
    return ApiResponse.fromJson(jsonDecode(response.body), fromJsonT);
  }

  Future<ApiResponse<R>> put<R>(
    String path, {
    ApiScope scope = ApiScope.data,
    Map<String, String>? headers,
    Map<String, Iterable<String>>? queryParameters,
    bool raw = false,
    Object? rawBody,
    Object? body,
    required R Function(Object? json) fromJsonT,
  }) async {
    final response = await http.put(
      Uri.parse(
        "$baseUrl${scope.name}/",
      ).resolve(path).replace(queryParameters: queryParameters),
      headers: {...baseHeaders, ...(headers ?? {})},
      body: raw ? rawBody : json.encode(body),
    );
    return ApiResponse.fromJson(jsonDecode(response.body), fromJsonT);
  }

  Future<ApiResponse<R>> fetchMedia<R>(
    String path, {
    String httpMethod = "POST",
    ApiScope scope = ApiScope.media,
    Map<String, String>? headers,
    Map<String, Iterable<String>>? queryParameters,
    required Uint8List bytes,
    required String fileName,
    required R Function(Object? json) fromJsonT,
  }) async {
    final uri = Uri.parse(
      "$baseUrl${scope.name}/",
    ).resolve(path).replace(queryParameters: queryParameters);
    final request = http.MultipartRequest(httpMethod, uri);
    request.files.add(
      http.MultipartFile.fromBytes('casseedmedia', bytes, filename: fileName),
    );
    request.headers.addAll({...baseHeaders, ...(headers ?? {})});
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    return ApiResponse.fromJson(jsonDecode(response.body), fromJsonT);
  }
}
