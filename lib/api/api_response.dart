class ApiResponse<P> {
  String status;
  int code;
  List<P> data;
  List<String> errors;
  String? scope;
  bool success;
  String tm;

  ApiResponse({
    required this.status,
    required this.code,
    required this.data,
    required this.errors,
    required this.scope,
    required this.success,
    required this.tm,
  });

  bool get hasError => code != 200;
  bool get isSuccessful => code == 200;
  bool get hasData => data.isNotEmpty;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    P Function(Object? json) fromJsonT,
  ) {
    final status = json['status'] as String;
    final code = json['code'] as int;
    final scope = json['scope'] as String?;
    final success = json['success'] as bool;
    final tm = json['tm'] as String;

    final dynamicData = json['data'] is List
        ? json['data'] as List<dynamic>
        : <dynamic>[];
    final dynamicErrors = json['errors'] is List
        ? json['errors'] as List<dynamic>
        : <dynamic>[];

    final List<P> data = dynamicData.map((json) => fromJsonT(json)).toList();

    final errors = List<String>.from(dynamicErrors);

    return ApiResponse(
      status: status,
      code: code,
      data: data,
      errors: errors,
      scope: scope,
      success: success,
      tm: tm,
    );
  }
}
