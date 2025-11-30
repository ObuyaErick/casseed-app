// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'verify_email_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$VerifyEmailDto {

 String get token;
/// Create a copy of VerifyEmailDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VerifyEmailDtoCopyWith<VerifyEmailDto> get copyWith => _$VerifyEmailDtoCopyWithImpl<VerifyEmailDto>(this as VerifyEmailDto, _$identity);

  /// Serializes this VerifyEmailDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VerifyEmailDto&&(identical(other.token, token) || other.token == token));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,token);

@override
String toString() {
  return 'VerifyEmailDto(token: $token)';
}


}

/// @nodoc
abstract mixin class $VerifyEmailDtoCopyWith<$Res>  {
  factory $VerifyEmailDtoCopyWith(VerifyEmailDto value, $Res Function(VerifyEmailDto) _then) = _$VerifyEmailDtoCopyWithImpl;
@useResult
$Res call({
 String token
});




}
/// @nodoc
class _$VerifyEmailDtoCopyWithImpl<$Res>
    implements $VerifyEmailDtoCopyWith<$Res> {
  _$VerifyEmailDtoCopyWithImpl(this._self, this._then);

  final VerifyEmailDto _self;
  final $Res Function(VerifyEmailDto) _then;

/// Create a copy of VerifyEmailDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? token = null,}) {
  return _then(_self.copyWith(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [VerifyEmailDto].
extension VerifyEmailDtoPatterns on VerifyEmailDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VerifyEmailDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VerifyEmailDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VerifyEmailDto value)  $default,){
final _that = this;
switch (_that) {
case _VerifyEmailDto():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VerifyEmailDto value)?  $default,){
final _that = this;
switch (_that) {
case _VerifyEmailDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String token)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VerifyEmailDto() when $default != null:
return $default(_that.token);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String token)  $default,) {final _that = this;
switch (_that) {
case _VerifyEmailDto():
return $default(_that.token);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String token)?  $default,) {final _that = this;
switch (_that) {
case _VerifyEmailDto() when $default != null:
return $default(_that.token);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable(createFactory: false)

class _VerifyEmailDto implements VerifyEmailDto {
  const _VerifyEmailDto({required this.token});
  

@override final  String token;

/// Create a copy of VerifyEmailDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VerifyEmailDtoCopyWith<_VerifyEmailDto> get copyWith => __$VerifyEmailDtoCopyWithImpl<_VerifyEmailDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VerifyEmailDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VerifyEmailDto&&(identical(other.token, token) || other.token == token));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,token);

@override
String toString() {
  return 'VerifyEmailDto(token: $token)';
}


}

/// @nodoc
abstract mixin class _$VerifyEmailDtoCopyWith<$Res> implements $VerifyEmailDtoCopyWith<$Res> {
  factory _$VerifyEmailDtoCopyWith(_VerifyEmailDto value, $Res Function(_VerifyEmailDto) _then) = __$VerifyEmailDtoCopyWithImpl;
@override @useResult
$Res call({
 String token
});




}
/// @nodoc
class __$VerifyEmailDtoCopyWithImpl<$Res>
    implements _$VerifyEmailDtoCopyWith<$Res> {
  __$VerifyEmailDtoCopyWithImpl(this._self, this._then);

  final _VerifyEmailDto _self;
  final $Res Function(_VerifyEmailDto) _then;

/// Create a copy of VerifyEmailDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? token = null,}) {
  return _then(_VerifyEmailDto(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
