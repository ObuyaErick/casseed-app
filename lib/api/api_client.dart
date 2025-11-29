import 'dart:convert';
import 'dart:typed_data';

import 'package:casseed/api/api_response.dart';
import 'package:http/http.dart' as http;

enum ApiScope { data, token, action, media, connect }

class ApiClient {
  static String? _token;
  static String? _goAuthToken;

  static String? get token => _token;
  static String? get goAuthToken => _goAuthToken;
  static const String adminUrl = String.fromEnvironment(
    'ADMIN_URL',
    defaultValue: 'https://admin-test.bx-cloud.com',
  );
  static const String dataApiVersion = String.fromEnvironment(
    'DATA_API_VERSION',
    defaultValue: 'v1',
  );

  static String baseUrl = "$adminUrl/winp/";

  static void init() {
    _goAuthToken =
        Uri.base.queryParameters['goAuthToken'] ?? //
        "eyJhbGciOiJSUzI1NiIsImtpZCI6ImE1NzMzYmJiZDgxOGFhNWRiMTk1MTk5Y2Q1NjhlNWQ2ODUxMzJkM2YiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiIzNzQzNjg4ODE5OTQtNjMyMTkxdnY2YTMwcDc1YmRlaTdhdDY0ZTJodnA5OWkuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiIzNzQzNjg4ODE5OTQtNjMyMTkxdnY2YTMwcDc1YmRlaTdhdDY0ZTJodnA5OWkuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMTM4MTc5NTA1MzcwMTA5MjM4MzgiLCJoZCI6InJlZHV6ZXIudGVjaCIsImVtYWlsIjoiZXJpY2tAcmVkdXplci50ZWNoIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsIm5vbmNlIjoibnVsbCIsIm5iZiI6MTc2Mzk3NDE4NSwibmFtZSI6IkVyaWNrIE9idXlhIiwicGljdHVyZSI6Imh0dHBzOi8vbGgzLmdvb2dsZXVzZXJjb250ZW50LmNvbS9hL0FDZzhvY0xwOG5uR2lUM2llejFRZmJQa1h0bXI5RVhscHpBakhSUHVDaE1rSTZzZURSLWd2ak09czk2LWMiLCJnaXZlbl9uYW1lIjoiRXJpY2siLCJmYW1pbHlfbmFtZSI6Ik9idXlhIiwiaWF0IjoxNzYzOTc0NDg1LCJleHAiOjE3NjM5NzgwODUsImp0aSI6Ijg4ZDAwMTdjYjRiZGVkMzgyM2VmOWFlMWMxZDIxN2NlYzAyMTQxMDQifQ.jStyNvU5pEbZcKyHIBhEiCnnboPB5ELKtDjO4ZXM0eHqWNLtw2K6u8QFCyZX9o-Hcqgl9BdiaFJB-S9knfwEdQJ5hKnKtQAes4Qai7xYgySNJWFcOmqDXM24AAMvnytnE3keptyf__6fjtrfH2Qk-dtQwi_uB3AHtaVRlI_6Ovioh7secObA2EXIfM816NSBw0DgGc7culAPQEkdXi5bUkdunZMoqVkFlA8BHmNiFwvSDYQC8K8ZkvcCDUogiygoYx9q9Tjlu-FF9TH9h26VyDMY3IJHnjObsufLpvEKkKn_hJO5Qgf120AAo5iyQhArAHkx0DrIW9li9WLOZJhV3Q";
    _token =
        Uri.base.queryParameters['token'] ?? //
        "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJlcmlja0ByZWR1emVyLnRlY2giLCJzY29wZSI6ImFkbWluIiwicHJvamVjdCI6Indpbi1wLW1vYmlsZXVuaXZlcnNlIiwiYWNjb3VudCI6Im1vYmlsZV91bml2ZXJzZV9hcGkiLCJpc3MiOiJvcmdhbml6YXRpb25AYm94YWxpbm8uY29tIiwianRpIjoiODhkMDAxN2NiNGJkZWQzODIzZWY5YWUxYzFkMjE3Y2VjMDIxNDEwNCIsImV4cCI6MTc2Mzk3ODA4NSwiY3JlYXRlZCI6IjIwMjUtMTEtMjQgMDk6NTQ6NDgifQ.9_FwlsQUFSIrk9xRgtwXpXdotwHcHnCOC6Z-f-q2Poc";
  }

  static Map<String, String> get baseHeaders => {
    'Content-Type': 'application/json',
    if (_token != null) 'X-Winp-Token': _token!,
  };

  static String proxiedImageUri(String href) {
    return "$adminUrl/proxy/$href?winp_bart=1";
  }

  static Future<ApiResponse<R>> delete<R>(
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

  static Future<ApiResponse<R>> get<R>(
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

  static Future<ApiResponse<R>> post<R>(
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

  static Future<ApiResponse<R>> put<R>(
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

  static Future<ApiResponse<R>> fetchMedia<R>(
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
      http.MultipartFile.fromBytes('winpmedia', bytes, filename: fileName),
    );
    request.headers.addAll({...baseHeaders, ...(headers ?? {})});
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    return ApiResponse.fromJson(jsonDecode(response.body), fromJsonT);
  }
}
