// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'character_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CharacterListState {

 CharacterScope get scope; String get text;
/// Create a copy of CharacterListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CharacterListStateCopyWith<CharacterListState> get copyWith => _$CharacterListStateCopyWithImpl<CharacterListState>(this as CharacterListState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CharacterListState&&(identical(other.scope, scope) || other.scope == scope)&&(identical(other.text, text) || other.text == text));
}


@override
int get hashCode => Object.hash(runtimeType,scope,text);

@override
String toString() {
  return 'CharacterListState(scope: $scope, text: $text)';
}


}

/// @nodoc
abstract mixin class $CharacterListStateCopyWith<$Res>  {
  factory $CharacterListStateCopyWith(CharacterListState value, $Res Function(CharacterListState) _then) = _$CharacterListStateCopyWithImpl;
@useResult
$Res call({
 CharacterScope scope, String text
});


$CharacterScopeCopyWith<$Res> get scope;

}
/// @nodoc
class _$CharacterListStateCopyWithImpl<$Res>
    implements $CharacterListStateCopyWith<$Res> {
  _$CharacterListStateCopyWithImpl(this._self, this._then);

  final CharacterListState _self;
  final $Res Function(CharacterListState) _then;

/// Create a copy of CharacterListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? scope = null,Object? text = null,}) {
  return _then(CharacterListState(
scope: null == scope ? _self.scope : scope // ignore: cast_nullable_to_non_nullable
as CharacterScope,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of CharacterListState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CharacterScopeCopyWith<$Res> get scope {
  
  return $CharacterScopeCopyWith<$Res>(_self.scope, (value) {
    return _then(_self.copyWith(scope: value));
  });
}
}


/// Adds pattern-matching-related methods to [CharacterListState].
extension CharacterListStatePatterns on CharacterListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CharacterListState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CharacterListState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CharacterListState value)  $default,){
final _that = this;
switch (_that) {
case _CharacterListState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CharacterListState value)?  $default,){
final _that = this;
switch (_that) {
case _CharacterListState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CharacterScope scope,  String text)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CharacterListState() when $default != null:
return $default(_that.scope,_that.text);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CharacterScope scope,  String text)  $default,) {final _that = this;
switch (_that) {
case _CharacterListState():
return $default(_that.scope,_that.text);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CharacterScope scope,  String text)?  $default,) {final _that = this;
switch (_that) {
case _CharacterListState() when $default != null:
return $default(_that.scope,_that.text);case _:
  return null;

}
}

}

/// @nodoc


class _CharacterListState implements CharacterListState {
  const _CharacterListState({this.scope = const CharacterScope.all(), this.text = ''});
  

@override@JsonKey() final  CharacterScope scope;
@override@JsonKey() final  String text;

/// Create a copy of CharacterListState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CharacterListStateCopyWith<_CharacterListState> get copyWith => __$CharacterListStateCopyWithImpl<_CharacterListState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CharacterListState&&(identical(other.scope, scope) || other.scope == scope)&&(identical(other.text, text) || other.text == text));
}


@override
int get hashCode => Object.hash(runtimeType,scope,text);

@override
String toString() {
  return 'CharacterListState(scope: $scope, text: $text)';
}


}

/// @nodoc
abstract mixin class _$CharacterListStateCopyWith<$Res> implements $CharacterListStateCopyWith<$Res> {
  factory _$CharacterListStateCopyWith(_CharacterListState value, $Res Function(_CharacterListState) _then) = __$CharacterListStateCopyWithImpl;
@override @useResult
$Res call({
 CharacterScope scope, String text
});


@override $CharacterScopeCopyWith<$Res> get scope;

}
/// @nodoc
class __$CharacterListStateCopyWithImpl<$Res>
    implements _$CharacterListStateCopyWith<$Res> {
  __$CharacterListStateCopyWithImpl(this._self, this._then);

  final _CharacterListState _self;
  final $Res Function(_CharacterListState) _then;

/// Create a copy of CharacterListState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? scope = null,Object? text = null,}) {
  return _then(_CharacterListState(
scope: null == scope ? _self.scope : scope // ignore: cast_nullable_to_non_nullable
as CharacterScope,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of CharacterListState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CharacterScopeCopyWith<$Res> get scope {
  
  return $CharacterScopeCopyWith<$Res>(_self.scope, (value) {
    return _then(_self.copyWith(scope: value));
  });
}
}

// dart format on
