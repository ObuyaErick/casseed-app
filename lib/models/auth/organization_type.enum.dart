import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum()
enum OrganizationType {
  @JsonValue("farmer")
  farmer,
  @JsonValue("supplier")
  supplier,
  @JsonValue("processor")
  processor,
  @JsonValue("distributor")
  distributor,
  @JsonValue("retailer")
  retailer,
  @JsonValue("other")
  other,
}
