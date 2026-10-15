// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'character_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FieldDraft {

 int get key; String get label; String get value; bool get isSecret;
/// Create a copy of FieldDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FieldDraftCopyWith<FieldDraft> get copyWith => _$FieldDraftCopyWithImpl<FieldDraft>(this as FieldDraft, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FieldDraft&&(identical(other.key, key) || other.key == key)&&(identical(other.label, label) || other.label == label)&&(identical(other.value, value) || other.value == value)&&(identical(other.isSecret, isSecret) || other.isSecret == isSecret));
}


@override
int get hashCode => Object.hash(runtimeType,key,label,value,isSecret);

@override
String toString() {
  return 'FieldDraft(key: $key, label: $label, value: $value, isSecret: $isSecret)';
}


}

/// @nodoc
abstract mixin class $FieldDraftCopyWith<$Res>  {
  factory $FieldDraftCopyWith(FieldDraft value, $Res Function(FieldDraft) _then) = _$FieldDraftCopyWithImpl;
@useResult
$Res call({
 int key, String label, String value, bool isSecret
});




}
/// @nodoc
class _$FieldDraftCopyWithImpl<$Res>
    implements $FieldDraftCopyWith<$Res> {
  _$FieldDraftCopyWithImpl(this._self, this._then);

  final FieldDraft _self;
  final $Res Function(FieldDraft) _then;

/// Create a copy of FieldDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? label = null,Object? value = null,Object? isSecret = null,}) {
  return _then(FieldDraft(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as int,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,isSecret: null == isSecret ? _self.isSecret : isSecret // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [FieldDraft].
extension FieldDraftPatterns on FieldDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FieldDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FieldDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FieldDraft value)  $default,){
final _that = this;
switch (_that) {
case _FieldDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FieldDraft value)?  $default,){
final _that = this;
switch (_that) {
case _FieldDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int key,  String label,  String value,  bool isSecret)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FieldDraft() when $default != null:
return $default(_that.key,_that.label,_that.value,_that.isSecret);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int key,  String label,  String value,  bool isSecret)  $default,) {final _that = this;
switch (_that) {
case _FieldDraft():
return $default(_that.key,_that.label,_that.value,_that.isSecret);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int key,  String label,  String value,  bool isSecret)?  $default,) {final _that = this;
switch (_that) {
case _FieldDraft() when $default != null:
return $default(_that.key,_that.label,_that.value,_that.isSecret);case _:
  return null;

}
}

}

/// @nodoc


class _FieldDraft implements FieldDraft {
  const _FieldDraft({required this.key, this.label = '', this.value = '', this.isSecret = false});
  

@override final  int key;
@override@JsonKey() final  String label;
@override@JsonKey() final  String value;
@override@JsonKey() final  bool isSecret;

/// Create a copy of FieldDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FieldDraftCopyWith<_FieldDraft> get copyWith => __$FieldDraftCopyWithImpl<_FieldDraft>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FieldDraft&&(identical(other.key, key) || other.key == key)&&(identical(other.label, label) || other.label == label)&&(identical(other.value, value) || other.value == value)&&(identical(other.isSecret, isSecret) || other.isSecret == isSecret));
}


@override
int get hashCode => Object.hash(runtimeType,key,label,value,isSecret);

@override
String toString() {
  return 'FieldDraft(key: $key, label: $label, value: $value, isSecret: $isSecret)';
}


}

/// @nodoc
abstract mixin class _$FieldDraftCopyWith<$Res> implements $FieldDraftCopyWith<$Res> {
  factory _$FieldDraftCopyWith(_FieldDraft value, $Res Function(_FieldDraft) _then) = __$FieldDraftCopyWithImpl;
@override @useResult
$Res call({
 int key, String label, String value, bool isSecret
});




}
/// @nodoc
class __$FieldDraftCopyWithImpl<$Res>
    implements _$FieldDraftCopyWith<$Res> {
  __$FieldDraftCopyWithImpl(this._self, this._then);

  final _FieldDraft _self;
  final $Res Function(_FieldDraft) _then;

/// Create a copy of FieldDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? label = null,Object? value = null,Object? isSecret = null,}) {
  return _then(_FieldDraft(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as int,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,isSecret: null == isSecret ? _self.isSecret : isSecret // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$TraitDraft {

 int get key; String get leftLabel; String get rightLabel; int get valuePercent;
/// Create a copy of TraitDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TraitDraftCopyWith<TraitDraft> get copyWith => _$TraitDraftCopyWithImpl<TraitDraft>(this as TraitDraft, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TraitDraft&&(identical(other.key, key) || other.key == key)&&(identical(other.leftLabel, leftLabel) || other.leftLabel == leftLabel)&&(identical(other.rightLabel, rightLabel) || other.rightLabel == rightLabel)&&(identical(other.valuePercent, valuePercent) || other.valuePercent == valuePercent));
}


@override
int get hashCode => Object.hash(runtimeType,key,leftLabel,rightLabel,valuePercent);

@override
String toString() {
  return 'TraitDraft(key: $key, leftLabel: $leftLabel, rightLabel: $rightLabel, valuePercent: $valuePercent)';
}


}

/// @nodoc
abstract mixin class $TraitDraftCopyWith<$Res>  {
  factory $TraitDraftCopyWith(TraitDraft value, $Res Function(TraitDraft) _then) = _$TraitDraftCopyWithImpl;
@useResult
$Res call({
 int key, String leftLabel, String rightLabel, int valuePercent
});




}
/// @nodoc
class _$TraitDraftCopyWithImpl<$Res>
    implements $TraitDraftCopyWith<$Res> {
  _$TraitDraftCopyWithImpl(this._self, this._then);

  final TraitDraft _self;
  final $Res Function(TraitDraft) _then;

/// Create a copy of TraitDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? leftLabel = null,Object? rightLabel = null,Object? valuePercent = null,}) {
  return _then(TraitDraft(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as int,leftLabel: null == leftLabel ? _self.leftLabel : leftLabel // ignore: cast_nullable_to_non_nullable
as String,rightLabel: null == rightLabel ? _self.rightLabel : rightLabel // ignore: cast_nullable_to_non_nullable
as String,valuePercent: null == valuePercent ? _self.valuePercent : valuePercent // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TraitDraft].
extension TraitDraftPatterns on TraitDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TraitDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TraitDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TraitDraft value)  $default,){
final _that = this;
switch (_that) {
case _TraitDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TraitDraft value)?  $default,){
final _that = this;
switch (_that) {
case _TraitDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int key,  String leftLabel,  String rightLabel,  int valuePercent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TraitDraft() when $default != null:
return $default(_that.key,_that.leftLabel,_that.rightLabel,_that.valuePercent);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int key,  String leftLabel,  String rightLabel,  int valuePercent)  $default,) {final _that = this;
switch (_that) {
case _TraitDraft():
return $default(_that.key,_that.leftLabel,_that.rightLabel,_that.valuePercent);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int key,  String leftLabel,  String rightLabel,  int valuePercent)?  $default,) {final _that = this;
switch (_that) {
case _TraitDraft() when $default != null:
return $default(_that.key,_that.leftLabel,_that.rightLabel,_that.valuePercent);case _:
  return null;

}
}

}

/// @nodoc


class _TraitDraft implements TraitDraft {
  const _TraitDraft({required this.key, this.leftLabel = '', this.rightLabel = '', this.valuePercent = 50});
  

@override final  int key;
@override@JsonKey() final  String leftLabel;
@override@JsonKey() final  String rightLabel;
@override@JsonKey() final  int valuePercent;

/// Create a copy of TraitDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TraitDraftCopyWith<_TraitDraft> get copyWith => __$TraitDraftCopyWithImpl<_TraitDraft>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TraitDraft&&(identical(other.key, key) || other.key == key)&&(identical(other.leftLabel, leftLabel) || other.leftLabel == leftLabel)&&(identical(other.rightLabel, rightLabel) || other.rightLabel == rightLabel)&&(identical(other.valuePercent, valuePercent) || other.valuePercent == valuePercent));
}


@override
int get hashCode => Object.hash(runtimeType,key,leftLabel,rightLabel,valuePercent);

@override
String toString() {
  return 'TraitDraft(key: $key, leftLabel: $leftLabel, rightLabel: $rightLabel, valuePercent: $valuePercent)';
}


}

/// @nodoc
abstract mixin class _$TraitDraftCopyWith<$Res> implements $TraitDraftCopyWith<$Res> {
  factory _$TraitDraftCopyWith(_TraitDraft value, $Res Function(_TraitDraft) _then) = __$TraitDraftCopyWithImpl;
@override @useResult
$Res call({
 int key, String leftLabel, String rightLabel, int valuePercent
});




}
/// @nodoc
class __$TraitDraftCopyWithImpl<$Res>
    implements _$TraitDraftCopyWith<$Res> {
  __$TraitDraftCopyWithImpl(this._self, this._then);

  final _TraitDraft _self;
  final $Res Function(_TraitDraft) _then;

/// Create a copy of TraitDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? leftLabel = null,Object? rightLabel = null,Object? valuePercent = null,}) {
  return _then(_TraitDraft(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as int,leftLabel: null == leftLabel ? _self.leftLabel : leftLabel // ignore: cast_nullable_to_non_nullable
as String,rightLabel: null == rightLabel ? _self.rightLabel : rightLabel // ignore: cast_nullable_to_non_nullable
as String,valuePercent: null == valuePercent ? _self.valuePercent : valuePercent // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$QuoteDraft {

 int get key; String get body; String get situation; bool get isSecret;
/// Create a copy of QuoteDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuoteDraftCopyWith<QuoteDraft> get copyWith => _$QuoteDraftCopyWithImpl<QuoteDraft>(this as QuoteDraft, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuoteDraft&&(identical(other.key, key) || other.key == key)&&(identical(other.body, body) || other.body == body)&&(identical(other.situation, situation) || other.situation == situation)&&(identical(other.isSecret, isSecret) || other.isSecret == isSecret));
}


@override
int get hashCode => Object.hash(runtimeType,key,body,situation,isSecret);

@override
String toString() {
  return 'QuoteDraft(key: $key, body: $body, situation: $situation, isSecret: $isSecret)';
}


}

/// @nodoc
abstract mixin class $QuoteDraftCopyWith<$Res>  {
  factory $QuoteDraftCopyWith(QuoteDraft value, $Res Function(QuoteDraft) _then) = _$QuoteDraftCopyWithImpl;
@useResult
$Res call({
 int key, String body, String situation, bool isSecret
});




}
/// @nodoc
class _$QuoteDraftCopyWithImpl<$Res>
    implements $QuoteDraftCopyWith<$Res> {
  _$QuoteDraftCopyWithImpl(this._self, this._then);

  final QuoteDraft _self;
  final $Res Function(QuoteDraft) _then;

/// Create a copy of QuoteDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? body = null,Object? situation = null,Object? isSecret = null,}) {
  return _then(QuoteDraft(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as int,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,situation: null == situation ? _self.situation : situation // ignore: cast_nullable_to_non_nullable
as String,isSecret: null == isSecret ? _self.isSecret : isSecret // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [QuoteDraft].
extension QuoteDraftPatterns on QuoteDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuoteDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuoteDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuoteDraft value)  $default,){
final _that = this;
switch (_that) {
case _QuoteDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuoteDraft value)?  $default,){
final _that = this;
switch (_that) {
case _QuoteDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int key,  String body,  String situation,  bool isSecret)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuoteDraft() when $default != null:
return $default(_that.key,_that.body,_that.situation,_that.isSecret);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int key,  String body,  String situation,  bool isSecret)  $default,) {final _that = this;
switch (_that) {
case _QuoteDraft():
return $default(_that.key,_that.body,_that.situation,_that.isSecret);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int key,  String body,  String situation,  bool isSecret)?  $default,) {final _that = this;
switch (_that) {
case _QuoteDraft() when $default != null:
return $default(_that.key,_that.body,_that.situation,_that.isSecret);case _:
  return null;

}
}

}

/// @nodoc


class _QuoteDraft implements QuoteDraft {
  const _QuoteDraft({required this.key, this.body = '', this.situation = '', this.isSecret = false});
  

@override final  int key;
@override@JsonKey() final  String body;
@override@JsonKey() final  String situation;
@override@JsonKey() final  bool isSecret;

/// Create a copy of QuoteDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuoteDraftCopyWith<_QuoteDraft> get copyWith => __$QuoteDraftCopyWithImpl<_QuoteDraft>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuoteDraft&&(identical(other.key, key) || other.key == key)&&(identical(other.body, body) || other.body == body)&&(identical(other.situation, situation) || other.situation == situation)&&(identical(other.isSecret, isSecret) || other.isSecret == isSecret));
}


@override
int get hashCode => Object.hash(runtimeType,key,body,situation,isSecret);

@override
String toString() {
  return 'QuoteDraft(key: $key, body: $body, situation: $situation, isSecret: $isSecret)';
}


}

/// @nodoc
abstract mixin class _$QuoteDraftCopyWith<$Res> implements $QuoteDraftCopyWith<$Res> {
  factory _$QuoteDraftCopyWith(_QuoteDraft value, $Res Function(_QuoteDraft) _then) = __$QuoteDraftCopyWithImpl;
@override @useResult
$Res call({
 int key, String body, String situation, bool isSecret
});




}
/// @nodoc
class __$QuoteDraftCopyWithImpl<$Res>
    implements _$QuoteDraftCopyWith<$Res> {
  __$QuoteDraftCopyWithImpl(this._self, this._then);

  final _QuoteDraft _self;
  final $Res Function(_QuoteDraft) _then;

/// Create a copy of QuoteDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? body = null,Object? situation = null,Object? isSecret = null,}) {
  return _then(_QuoteDraft(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as int,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,situation: null == situation ? _self.situation : situation // ignore: cast_nullable_to_non_nullable
as String,isSecret: null == isSecret ? _self.isSecret : isSecret // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$CharacterDraft {

 String get name; String get nameEn; String get tagline; String get quote;/// null = 공용 서재
 int? get projectId; int? get worldId; String get visibility;/// null = 색 안 씀
 String? get themeColor; int? get portraitAssetId; bool get isFavorite; bool get isCardDownloadable; int get sortOrder; List<FieldDraft> get fields; List<TraitDraft> get traits; List<QuoteDraft> get quotes; List<String> get tags; String get bodyMd;
/// Create a copy of CharacterDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CharacterDraftCopyWith<CharacterDraft> get copyWith => _$CharacterDraftCopyWithImpl<CharacterDraft>(this as CharacterDraft, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CharacterDraft&&(identical(other.name, name) || other.name == name)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.tagline, tagline) || other.tagline == tagline)&&(identical(other.quote, quote) || other.quote == quote)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.worldId, worldId) || other.worldId == worldId)&&(identical(other.visibility, visibility) || other.visibility == visibility)&&(identical(other.themeColor, themeColor) || other.themeColor == themeColor)&&(identical(other.portraitAssetId, portraitAssetId) || other.portraitAssetId == portraitAssetId)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite)&&(identical(other.isCardDownloadable, isCardDownloadable) || other.isCardDownloadable == isCardDownloadable)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&const DeepCollectionEquality().equals(other.fields, fields)&&const DeepCollectionEquality().equals(other.traits, traits)&&const DeepCollectionEquality().equals(other.quotes, quotes)&&const DeepCollectionEquality().equals(other.tags, tags)&&(identical(other.bodyMd, bodyMd) || other.bodyMd == bodyMd));
}


@override
int get hashCode => Object.hash(runtimeType,name,nameEn,tagline,quote,projectId,worldId,visibility,themeColor,portraitAssetId,isFavorite,isCardDownloadable,sortOrder,const DeepCollectionEquality().hash(fields),const DeepCollectionEquality().hash(traits),const DeepCollectionEquality().hash(quotes),const DeepCollectionEquality().hash(tags),bodyMd);

@override
String toString() {
  return 'CharacterDraft(name: $name, nameEn: $nameEn, tagline: $tagline, quote: $quote, projectId: $projectId, worldId: $worldId, visibility: $visibility, themeColor: $themeColor, portraitAssetId: $portraitAssetId, isFavorite: $isFavorite, isCardDownloadable: $isCardDownloadable, sortOrder: $sortOrder, fields: $fields, traits: $traits, quotes: $quotes, tags: $tags, bodyMd: $bodyMd)';
}


}

/// @nodoc
abstract mixin class $CharacterDraftCopyWith<$Res>  {
  factory $CharacterDraftCopyWith(CharacterDraft value, $Res Function(CharacterDraft) _then) = _$CharacterDraftCopyWithImpl;
@useResult
$Res call({
 String name, String nameEn, String tagline, String quote, int? projectId, int? worldId, String visibility, String? themeColor, int? portraitAssetId, bool isFavorite, bool isCardDownloadable, int sortOrder, List<FieldDraft> fields, List<TraitDraft> traits, List<QuoteDraft> quotes, List<String> tags, String bodyMd
});




}
/// @nodoc
class _$CharacterDraftCopyWithImpl<$Res>
    implements $CharacterDraftCopyWith<$Res> {
  _$CharacterDraftCopyWithImpl(this._self, this._then);

  final CharacterDraft _self;
  final $Res Function(CharacterDraft) _then;

/// Create a copy of CharacterDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? nameEn = null,Object? tagline = null,Object? quote = null,Object? projectId = freezed,Object? worldId = freezed,Object? visibility = null,Object? themeColor = freezed,Object? portraitAssetId = freezed,Object? isFavorite = null,Object? isCardDownloadable = null,Object? sortOrder = null,Object? fields = null,Object? traits = null,Object? quotes = null,Object? tags = null,Object? bodyMd = null,}) {
  return _then(CharacterDraft(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nameEn: null == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String,tagline: null == tagline ? _self.tagline : tagline // ignore: cast_nullable_to_non_nullable
as String,quote: null == quote ? _self.quote : quote // ignore: cast_nullable_to_non_nullable
as String,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as int?,worldId: freezed == worldId ? _self.worldId : worldId // ignore: cast_nullable_to_non_nullable
as int?,visibility: null == visibility ? _self.visibility : visibility // ignore: cast_nullable_to_non_nullable
as String,themeColor: freezed == themeColor ? _self.themeColor : themeColor // ignore: cast_nullable_to_non_nullable
as String?,portraitAssetId: freezed == portraitAssetId ? _self.portraitAssetId : portraitAssetId // ignore: cast_nullable_to_non_nullable
as int?,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,isCardDownloadable: null == isCardDownloadable ? _self.isCardDownloadable : isCardDownloadable // ignore: cast_nullable_to_non_nullable
as bool,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,fields: null == fields ? _self.fields : fields // ignore: cast_nullable_to_non_nullable
as List<FieldDraft>,traits: null == traits ? _self.traits : traits // ignore: cast_nullable_to_non_nullable
as List<TraitDraft>,quotes: null == quotes ? _self.quotes : quotes // ignore: cast_nullable_to_non_nullable
as List<QuoteDraft>,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,bodyMd: null == bodyMd ? _self.bodyMd : bodyMd // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CharacterDraft].
extension CharacterDraftPatterns on CharacterDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CharacterDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CharacterDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CharacterDraft value)  $default,){
final _that = this;
switch (_that) {
case _CharacterDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CharacterDraft value)?  $default,){
final _that = this;
switch (_that) {
case _CharacterDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String nameEn,  String tagline,  String quote,  int? projectId,  int? worldId,  String visibility,  String? themeColor,  int? portraitAssetId,  bool isFavorite,  bool isCardDownloadable,  int sortOrder,  List<FieldDraft> fields,  List<TraitDraft> traits,  List<QuoteDraft> quotes,  List<String> tags,  String bodyMd)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CharacterDraft() when $default != null:
return $default(_that.name,_that.nameEn,_that.tagline,_that.quote,_that.projectId,_that.worldId,_that.visibility,_that.themeColor,_that.portraitAssetId,_that.isFavorite,_that.isCardDownloadable,_that.sortOrder,_that.fields,_that.traits,_that.quotes,_that.tags,_that.bodyMd);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String nameEn,  String tagline,  String quote,  int? projectId,  int? worldId,  String visibility,  String? themeColor,  int? portraitAssetId,  bool isFavorite,  bool isCardDownloadable,  int sortOrder,  List<FieldDraft> fields,  List<TraitDraft> traits,  List<QuoteDraft> quotes,  List<String> tags,  String bodyMd)  $default,) {final _that = this;
switch (_that) {
case _CharacterDraft():
return $default(_that.name,_that.nameEn,_that.tagline,_that.quote,_that.projectId,_that.worldId,_that.visibility,_that.themeColor,_that.portraitAssetId,_that.isFavorite,_that.isCardDownloadable,_that.sortOrder,_that.fields,_that.traits,_that.quotes,_that.tags,_that.bodyMd);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String nameEn,  String tagline,  String quote,  int? projectId,  int? worldId,  String visibility,  String? themeColor,  int? portraitAssetId,  bool isFavorite,  bool isCardDownloadable,  int sortOrder,  List<FieldDraft> fields,  List<TraitDraft> traits,  List<QuoteDraft> quotes,  List<String> tags,  String bodyMd)?  $default,) {final _that = this;
switch (_that) {
case _CharacterDraft() when $default != null:
return $default(_that.name,_that.nameEn,_that.tagline,_that.quote,_that.projectId,_that.worldId,_that.visibility,_that.themeColor,_that.portraitAssetId,_that.isFavorite,_that.isCardDownloadable,_that.sortOrder,_that.fields,_that.traits,_that.quotes,_that.tags,_that.bodyMd);case _:
  return null;

}
}

}

/// @nodoc


class _CharacterDraft extends CharacterDraft {
  const _CharacterDraft({this.name = '', this.nameEn = '', this.tagline = '', this.quote = '', this.projectId, this.worldId, this.visibility = 'private', this.themeColor, this.portraitAssetId, this.isFavorite = false, this.isCardDownloadable = false, this.sortOrder = 0,  List<FieldDraft> fields = const [],  List<TraitDraft> traits = const [],  List<QuoteDraft> quotes = const [],  List<String> tags = const [], this.bodyMd = ''}): _fields = fields,_traits = traits,_quotes = quotes,_tags = tags,super._();
  

@override@JsonKey() final  String name;
@override@JsonKey() final  String nameEn;
@override@JsonKey() final  String tagline;
@override@JsonKey() final  String quote;
/// null = 공용 서재
@override final  int? projectId;
@override final  int? worldId;
@override@JsonKey() final  String visibility;
/// null = 색 안 씀
@override final  String? themeColor;
@override final  int? portraitAssetId;
@override@JsonKey() final  bool isFavorite;
@override@JsonKey() final  bool isCardDownloadable;
@override@JsonKey() final  int sortOrder;
 final  List<FieldDraft> _fields;
@override@JsonKey() List<FieldDraft> get fields {
  if (_fields is EqualUnmodifiableListView) return _fields;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_fields);
}

 final  List<TraitDraft> _traits;
@override@JsonKey() List<TraitDraft> get traits {
  if (_traits is EqualUnmodifiableListView) return _traits;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_traits);
}

 final  List<QuoteDraft> _quotes;
@override@JsonKey() List<QuoteDraft> get quotes {
  if (_quotes is EqualUnmodifiableListView) return _quotes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_quotes);
}

 final  List<String> _tags;
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

@override@JsonKey() final  String bodyMd;

/// Create a copy of CharacterDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CharacterDraftCopyWith<_CharacterDraft> get copyWith => __$CharacterDraftCopyWithImpl<_CharacterDraft>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CharacterDraft&&(identical(other.name, name) || other.name == name)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.tagline, tagline) || other.tagline == tagline)&&(identical(other.quote, quote) || other.quote == quote)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.worldId, worldId) || other.worldId == worldId)&&(identical(other.visibility, visibility) || other.visibility == visibility)&&(identical(other.themeColor, themeColor) || other.themeColor == themeColor)&&(identical(other.portraitAssetId, portraitAssetId) || other.portraitAssetId == portraitAssetId)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite)&&(identical(other.isCardDownloadable, isCardDownloadable) || other.isCardDownloadable == isCardDownloadable)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&const DeepCollectionEquality().equals(other._fields, _fields)&&const DeepCollectionEquality().equals(other._traits, _traits)&&const DeepCollectionEquality().equals(other._quotes, _quotes)&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.bodyMd, bodyMd) || other.bodyMd == bodyMd));
}


@override
int get hashCode => Object.hash(runtimeType,name,nameEn,tagline,quote,projectId,worldId,visibility,themeColor,portraitAssetId,isFavorite,isCardDownloadable,sortOrder,const DeepCollectionEquality().hash(_fields),const DeepCollectionEquality().hash(_traits),const DeepCollectionEquality().hash(_quotes),const DeepCollectionEquality().hash(_tags),bodyMd);

@override
String toString() {
  return 'CharacterDraft(name: $name, nameEn: $nameEn, tagline: $tagline, quote: $quote, projectId: $projectId, worldId: $worldId, visibility: $visibility, themeColor: $themeColor, portraitAssetId: $portraitAssetId, isFavorite: $isFavorite, isCardDownloadable: $isCardDownloadable, sortOrder: $sortOrder, fields: $fields, traits: $traits, quotes: $quotes, tags: $tags, bodyMd: $bodyMd)';
}


}

/// @nodoc
abstract mixin class _$CharacterDraftCopyWith<$Res> implements $CharacterDraftCopyWith<$Res> {
  factory _$CharacterDraftCopyWith(_CharacterDraft value, $Res Function(_CharacterDraft) _then) = __$CharacterDraftCopyWithImpl;
@override @useResult
$Res call({
 String name, String nameEn, String tagline, String quote, int? projectId, int? worldId, String visibility, String? themeColor, int? portraitAssetId, bool isFavorite, bool isCardDownloadable, int sortOrder, List<FieldDraft> fields, List<TraitDraft> traits, List<QuoteDraft> quotes, List<String> tags, String bodyMd
});




}
/// @nodoc
class __$CharacterDraftCopyWithImpl<$Res>
    implements _$CharacterDraftCopyWith<$Res> {
  __$CharacterDraftCopyWithImpl(this._self, this._then);

  final _CharacterDraft _self;
  final $Res Function(_CharacterDraft) _then;

/// Create a copy of CharacterDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? nameEn = null,Object? tagline = null,Object? quote = null,Object? projectId = freezed,Object? worldId = freezed,Object? visibility = null,Object? themeColor = freezed,Object? portraitAssetId = freezed,Object? isFavorite = null,Object? isCardDownloadable = null,Object? sortOrder = null,Object? fields = null,Object? traits = null,Object? quotes = null,Object? tags = null,Object? bodyMd = null,}) {
  return _then(_CharacterDraft(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nameEn: null == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String,tagline: null == tagline ? _self.tagline : tagline // ignore: cast_nullable_to_non_nullable
as String,quote: null == quote ? _self.quote : quote // ignore: cast_nullable_to_non_nullable
as String,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as int?,worldId: freezed == worldId ? _self.worldId : worldId // ignore: cast_nullable_to_non_nullable
as int?,visibility: null == visibility ? _self.visibility : visibility // ignore: cast_nullable_to_non_nullable
as String,themeColor: freezed == themeColor ? _self.themeColor : themeColor // ignore: cast_nullable_to_non_nullable
as String?,portraitAssetId: freezed == portraitAssetId ? _self.portraitAssetId : portraitAssetId // ignore: cast_nullable_to_non_nullable
as int?,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,isCardDownloadable: null == isCardDownloadable ? _self.isCardDownloadable : isCardDownloadable // ignore: cast_nullable_to_non_nullable
as bool,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,fields: null == fields ? _self._fields : fields // ignore: cast_nullable_to_non_nullable
as List<FieldDraft>,traits: null == traits ? _self._traits : traits // ignore: cast_nullable_to_non_nullable
as List<TraitDraft>,quotes: null == quotes ? _self._quotes : quotes // ignore: cast_nullable_to_non_nullable
as List<QuoteDraft>,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,bodyMd: null == bodyMd ? _self.bodyMd : bodyMd // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
