class ApiResponse<P> {
  String status;
  int code;
  List<P> payload;
  List<String> errors;
  String? scope;
  bool success;
  String tm;

  ApiResponse({
    required this.status,
    required this.code,
    required this.payload,
    required this.errors,
    required this.scope,
    required this.success,
    required this.tm,
  });

  bool get hasError => code != 200;
  bool get isSuccessful => code == 200;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    P Function(Object? json) fromJsonT,
  ) {
    final status = json['status'] as String;
    final code = json['code'] as int;
    final scope = json['scope'] as String?;
    final success = json['success'] as bool;
    final tm = json['tm'] as String;

    final dynamicPayload = json['payload'] as List<dynamic>;
    final dynamicErrors = json['errors'] as List<dynamic>;

    final List<P> payload =
        dynamicPayload.map((json) => fromJsonT(json)).toList();

    final errors = List<String>.from(dynamicErrors);

    return ApiResponse(
      status: status,
      code: code,
      payload: payload,
      errors: errors,
      scope: scope,
      success: success,
      tm: tm,
    );
  }
}
