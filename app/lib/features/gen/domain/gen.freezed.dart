// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GenTag {

 String get tag; double get weight;
/// Create a copy of GenTag
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GenTagCopyWith<GenTag> get copyWith => _$GenTagCopyWithImpl<GenTag>(this as GenTag, _$identity);

  /// Serializes this GenTag to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GenTag&&(identical(other.tag, tag) || other.tag == tag)&&(identical(other.weight, weight) || other.weight == weight));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tag,weight);

@override
String toString() {
  return 'GenTag(tag: $tag, weight: $weight)';
}


}

/// @nodoc
abstract mixin class $GenTagCopyWith<$Res>  {
  factory $GenTagCopyWith(GenTag value, $Res Function(GenTag) _then) = _$GenTagCopyWithImpl;
@useResult
$Res call({
 String tag, double weight
});




}
/// @nodoc
class _$GenTagCopyWithImpl<$Res>
    implements $GenTagCopyWith<$Res> {
  _$GenTagCopyWithImpl(this._self, this._then);

  final GenTag _self;
  final $Res Function(GenTag) _then;

/// Create a copy of GenTag
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tag = null,Object? weight = null,}) {
  return _then(GenTag(
tag: null == tag ? _self.tag : tag // ignore: cast_nullable_to_non_nullable
as String,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [GenTag].
extension GenTagPatterns on GenTag {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GenTag value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GenTag() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GenTag value)  $default,){
final _that = this;
switch (_that) {
case _GenTag():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GenTag value)?  $default,){
final _that = this;
switch (_that) {
case _GenTag() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String tag,  double weight)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GenTag() when $default != null:
return $default(_that.tag,_that.weight);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String tag,  double weight)  $default,) {final _that = this;
switch (_that) {
case _GenTag():
return $default(_that.tag,_that.weight);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String tag,  double weight)?  $default,) {final _that = this;
switch (_that) {
case _GenTag() when $default != null:
return $default(_that.tag,_that.weight);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GenTag implements GenTag {
  const _GenTag({required this.tag, this.weight = 1.0});
  factory _GenTag.fromJson(Map<String, dynamic> json) => _$GenTagFromJson(json);

@override final  String tag;
@override@JsonKey() final  double weight;

/// Create a copy of GenTag
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GenTagCopyWith<_GenTag> get copyWith => __$GenTagCopyWithImpl<_GenTag>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GenTagToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GenTag&&(identical(other.tag, tag) || other.tag == tag)&&(identical(other.weight, weight) || other.weight == weight));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tag,weight);

@override
String toString() {
  return 'GenTag(tag: $tag, weight: $weight)';
}


}

/// @nodoc
abstract mixin class _$GenTagCopyWith<$Res> implements $GenTagCopyWith<$Res> {
  factory _$GenTagCopyWith(_GenTag value, $Res Function(_GenTag) _then) = __$GenTagCopyWithImpl;
@override @useResult
$Res call({
 String tag, double weight
});




}
/// @nodoc
class __$GenTagCopyWithImpl<$Res>
    implements _$GenTagCopyWith<$Res> {
  __$GenTagCopyWithImpl(this._self, this._then);

  final _GenTag _self;
  final $Res Function(_GenTag) _then;

/// Create a copy of GenTag
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tag = null,Object? weight = null,}) {
  return _then(_GenTag(
tag: null == tag ? _self.tag : tag // ignore: cast_nullable_to_non_nullable
as String,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$GenLoraUse {

 int? get genLoraId; String get name; double get weight;
/// Create a copy of GenLoraUse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GenLoraUseCopyWith<GenLoraUse> get copyWith => _$GenLoraUseCopyWithImpl<GenLoraUse>(this as GenLoraUse, _$identity);

  /// Serializes this GenLoraUse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GenLoraUse&&(identical(other.genLoraId, genLoraId) || other.genLoraId == genLoraId)&&(identical(other.name, name) || other.name == name)&&(identical(other.weight, weight) || other.weight == weight));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,genLoraId,name,weight);

@override
String toString() {
  return 'GenLoraUse(genLoraId: $genLoraId, name: $name, weight: $weight)';
}


}

/// @nodoc
abstract mixin class $GenLoraUseCopyWith<$Res>  {
  factory $GenLoraUseCopyWith(GenLoraUse value, $Res Function(GenLoraUse) _then) = _$GenLoraUseCopyWithImpl;
@useResult
$Res call({
 int? genLoraId, String name, double weight
});




}
/// @nodoc
class _$GenLoraUseCopyWithImpl<$Res>
    implements $GenLoraUseCopyWith<$Res> {
  _$GenLoraUseCopyWithImpl(this._self, this._then);

  final GenLoraUse _self;
  final $Res Function(GenLoraUse) _then;

/// Create a copy of GenLoraUse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? genLoraId = freezed,Object? name = null,Object? weight = null,}) {
  return _then(GenLoraUse(
genLoraId: freezed == genLoraId ? _self.genLoraId : genLoraId // ignore: cast_nullable_to_non_nullable
as int?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [GenLoraUse].
extension GenLoraUsePatterns on GenLoraUse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GenLoraUse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GenLoraUse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GenLoraUse value)  $default,){
final _that = this;
switch (_that) {
case _GenLoraUse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GenLoraUse value)?  $default,){
final _that = this;
switch (_that) {
case _GenLoraUse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? genLoraId,  String name,  double weight)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GenLoraUse() when $default != null:
return $default(_that.genLoraId,_that.name,_that.weight);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? genLoraId,  String name,  double weight)  $default,) {final _that = this;
switch (_that) {
case _GenLoraUse():
return $default(_that.genLoraId,_that.name,_that.weight);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? genLoraId,  String name,  double weight)?  $default,) {final _that = this;
switch (_that) {
case _GenLoraUse() when $default != null:
return $default(_that.genLoraId,_that.name,_that.weight);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GenLoraUse implements GenLoraUse {
  const _GenLoraUse({this.genLoraId, required this.name, this.weight = 1.0});
  factory _GenLoraUse.fromJson(Map<String, dynamic> json) => _$GenLoraUseFromJson(json);

@override final  int? genLoraId;
@override final  String name;
@override@JsonKey() final  double weight;

/// Create a copy of GenLoraUse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GenLoraUseCopyWith<_GenLoraUse> get copyWith => __$GenLoraUseCopyWithImpl<_GenLoraUse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GenLoraUseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GenLoraUse&&(identical(other.genLoraId, genLoraId) || other.genLoraId == genLoraId)&&(identical(other.name, name) || other.name == name)&&(identical(other.weight, weight) || other.weight == weight));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,genLoraId,name,weight);

@override
String toString() {
  return 'GenLoraUse(genLoraId: $genLoraId, name: $name, weight: $weight)';
}


}

/// @nodoc
abstract mixin class _$GenLoraUseCopyWith<$Res> implements $GenLoraUseCopyWith<$Res> {
  factory _$GenLoraUseCopyWith(_GenLoraUse value, $Res Function(_GenLoraUse) _then) = __$GenLoraUseCopyWithImpl;
@override @useResult
$Res call({
 int? genLoraId, String name, double weight
});




}
/// @nodoc
class __$GenLoraUseCopyWithImpl<$Res>
    implements _$GenLoraUseCopyWith<$Res> {
  __$GenLoraUseCopyWithImpl(this._self, this._then);

  final _GenLoraUse _self;
  final $Res Function(_GenLoraUse) _then;

/// Create a copy of GenLoraUse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? genLoraId = freezed,Object? name = null,Object? weight = null,}) {
  return _then(_GenLoraUse(
genLoraId: freezed == genLoraId ? _self.genLoraId : genLoraId // ignore: cast_nullable_to_non_nullable
as int?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$GenPreset {

 int get id; String get name; Map<String, List<GenTag>> get tags; List<String> get negative; List<GenLoraUse> get loras;
/// Create a copy of GenPreset
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GenPresetCopyWith<GenPreset> get copyWith => _$GenPresetCopyWithImpl<GenPreset>(this as GenPreset, _$identity);

  /// Serializes this GenPreset to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GenPreset&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.tags, tags)&&const DeepCollectionEquality().equals(other.negative, negative)&&const DeepCollectionEquality().equals(other.loras, loras));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(tags),const DeepCollectionEquality().hash(negative),const DeepCollectionEquality().hash(loras));

@override
String toString() {
  return 'GenPreset(id: $id, name: $name, tags: $tags, negative: $negative, loras: $loras)';
}


}

/// @nodoc
abstract mixin class $GenPresetCopyWith<$Res>  {
  factory $GenPresetCopyWith(GenPreset value, $Res Function(GenPreset) _then) = _$GenPresetCopyWithImpl;
@useResult
$Res call({
 int id, String name, Map<String, List<GenTag>> tags, List<String> negative, List<GenLoraUse> loras
});




}
/// @nodoc
class _$GenPresetCopyWithImpl<$Res>
    implements $GenPresetCopyWith<$Res> {
  _$GenPresetCopyWithImpl(this._self, this._then);

  final GenPreset _self;
  final $Res Function(GenPreset) _then;

/// Create a copy of GenPreset
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? tags = null,Object? negative = null,Object? loras = null,}) {
  return _then(GenPreset(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as Map<String, List<GenTag>>,negative: null == negative ? _self.negative : negative // ignore: cast_nullable_to_non_nullable
as List<String>,loras: null == loras ? _self.loras : loras // ignore: cast_nullable_to_non_nullable
as List<GenLoraUse>,
  ));
}

}


/// Adds pattern-matching-related methods to [GenPreset].
extension GenPresetPatterns on GenPreset {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GenPreset value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GenPreset() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GenPreset value)  $default,){
final _that = this;
switch (_that) {
case _GenPreset():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GenPreset value)?  $default,){
final _that = this;
switch (_that) {
case _GenPreset() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  Map<String, List<GenTag>> tags,  List<String> negative,  List<GenLoraUse> loras)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GenPreset() when $default != null:
return $default(_that.id,_that.name,_that.tags,_that.negative,_that.loras);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  Map<String, List<GenTag>> tags,  List<String> negative,  List<GenLoraUse> loras)  $default,) {final _that = this;
switch (_that) {
case _GenPreset():
return $default(_that.id,_that.name,_that.tags,_that.negative,_that.loras);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  Map<String, List<GenTag>> tags,  List<String> negative,  List<GenLoraUse> loras)?  $default,) {final _that = this;
switch (_that) {
case _GenPreset() when $default != null:
return $default(_that.id,_that.name,_that.tags,_that.negative,_that.loras);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GenPreset extends GenPreset {
  const _GenPreset({required this.id, required this.name,  Map<String, List<GenTag>> tags = const {},  List<String> negative = const [],  List<GenLoraUse> loras = const []}): _tags = tags,_negative = negative,_loras = loras,super._();
  factory _GenPreset.fromJson(Map<String, dynamic> json) => _$GenPresetFromJson(json);

@override final  int id;
@override final  String name;
 final  Map<String, List<GenTag>> _tags;
@override@JsonKey() Map<String, List<GenTag>> get tags {
  if (_tags is EqualUnmodifiableMapView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_tags);
}

 final  List<String> _negative;
@override@JsonKey() List<String> get negative {
  if (_negative is EqualUnmodifiableListView) return _negative;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_negative);
}

 final  List<GenLoraUse> _loras;
@override@JsonKey() List<GenLoraUse> get loras {
  if (_loras is EqualUnmodifiableListView) return _loras;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_loras);
}


/// Create a copy of GenPreset
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GenPresetCopyWith<_GenPreset> get copyWith => __$GenPresetCopyWithImpl<_GenPreset>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GenPresetToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GenPreset&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._tags, _tags)&&const DeepCollectionEquality().equals(other._negative, _negative)&&const DeepCollectionEquality().equals(other._loras, _loras));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(_tags),const DeepCollectionEquality().hash(_negative),const DeepCollectionEquality().hash(_loras));

@override
String toString() {
  return 'GenPreset(id: $id, name: $name, tags: $tags, negative: $negative, loras: $loras)';
}


}

/// @nodoc
abstract mixin class _$GenPresetCopyWith<$Res> implements $GenPresetCopyWith<$Res> {
  factory _$GenPresetCopyWith(_GenPreset value, $Res Function(_GenPreset) _then) = __$GenPresetCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, Map<String, List<GenTag>> tags, List<String> negative, List<GenLoraUse> loras
});




}
/// @nodoc
class __$GenPresetCopyWithImpl<$Res>
    implements _$GenPresetCopyWith<$Res> {
  __$GenPresetCopyWithImpl(this._self, this._then);

  final _GenPreset _self;
  final $Res Function(_GenPreset) _then;

/// Create a copy of GenPreset
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? tags = null,Object? negative = null,Object? loras = null,}) {
  return _then(_GenPreset(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as Map<String, List<GenTag>>,negative: null == negative ? _self._negative : negative // ignore: cast_nullable_to_non_nullable
as List<String>,loras: null == loras ? _self._loras : loras // ignore: cast_nullable_to_non_nullable
as List<GenLoraUse>,
  ));
}


}


/// @nodoc
mixin _$GenRecord {

 int get id; String? get title; int? get assetId; int? get genPlatformId; int? get genModelId; int? get genPresetId; String? get platformName; String? get modelName; String? get presetName; String? get promptRaw; Map<String, List<GenTag>> get tags; List<String> get negative; List<GenLoraUse> get loras; int? get seed; String? get sampler; int? get steps; double? get cfgScale; int? get width; int? get height; String? get note;@IntBool() bool get isCover; Map<String, Object?> get extra; String? get createdAt;
/// Create a copy of GenRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GenRecordCopyWith<GenRecord> get copyWith => _$GenRecordCopyWithImpl<GenRecord>(this as GenRecord, _$identity);

  /// Serializes this GenRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GenRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.assetId, assetId) || other.assetId == assetId)&&(identical(other.genPlatformId, genPlatformId) || other.genPlatformId == genPlatformId)&&(identical(other.genModelId, genModelId) || other.genModelId == genModelId)&&(identical(other.genPresetId, genPresetId) || other.genPresetId == genPresetId)&&(identical(other.platformName, platformName) || other.platformName == platformName)&&(identical(other.modelName, modelName) || other.modelName == modelName)&&(identical(other.presetName, presetName) || other.presetName == presetName)&&(identical(other.promptRaw, promptRaw) || other.promptRaw == promptRaw)&&const DeepCollectionEquality().equals(other.tags, tags)&&const DeepCollectionEquality().equals(other.negative, negative)&&const DeepCollectionEquality().equals(other.loras, loras)&&(identical(other.seed, seed) || other.seed == seed)&&(identical(other.sampler, sampler) || other.sampler == sampler)&&(identical(other.steps, steps) || other.steps == steps)&&(identical(other.cfgScale, cfgScale) || other.cfgScale == cfgScale)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.note, note) || other.note == note)&&(identical(other.isCover, isCover) || other.isCover == isCover)&&const DeepCollectionEquality().equals(other.extra, extra)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,title,assetId,genPlatformId,genModelId,genPresetId,platformName,modelName,presetName,promptRaw,const DeepCollectionEquality().hash(tags),const DeepCollectionEquality().hash(negative),const DeepCollectionEquality().hash(loras),seed,sampler,steps,cfgScale,width,height,note,isCover,const DeepCollectionEquality().hash(extra),createdAt]);

@override
String toString() {
  return 'GenRecord(id: $id, title: $title, assetId: $assetId, genPlatformId: $genPlatformId, genModelId: $genModelId, genPresetId: $genPresetId, platformName: $platformName, modelName: $modelName, presetName: $presetName, promptRaw: $promptRaw, tags: $tags, negative: $negative, loras: $loras, seed: $seed, sampler: $sampler, steps: $steps, cfgScale: $cfgScale, width: $width, height: $height, note: $note, isCover: $isCover, extra: $extra, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $GenRecordCopyWith<$Res>  {
  factory $GenRecordCopyWith(GenRecord value, $Res Function(GenRecord) _then) = _$GenRecordCopyWithImpl;
@useResult
$Res call({
 int id, String? title, int? assetId, int? genPlatformId, int? genModelId, int? genPresetId, String? platformName, String? modelName, String? presetName, String? promptRaw, Map<String, List<GenTag>> tags, List<String> negative, List<GenLoraUse> loras, int? seed, String? sampler, int? steps, double? cfgScale, int? width, int? height, String? note,@IntBool() bool isCover, Map<String, Object?> extra, String? createdAt
});




}
/// @nodoc
class _$GenRecordCopyWithImpl<$Res>
    implements $GenRecordCopyWith<$Res> {
  _$GenRecordCopyWithImpl(this._self, this._then);

  final GenRecord _self;
  final $Res Function(GenRecord) _then;

/// Create a copy of GenRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = freezed,Object? assetId = freezed,Object? genPlatformId = freezed,Object? genModelId = freezed,Object? genPresetId = freezed,Object? platformName = freezed,Object? modelName = freezed,Object? presetName = freezed,Object? promptRaw = freezed,Object? tags = null,Object? negative = null,Object? loras = null,Object? seed = freezed,Object? sampler = freezed,Object? steps = freezed,Object? cfgScale = freezed,Object? width = freezed,Object? height = freezed,Object? note = freezed,Object? isCover = null,Object? extra = null,Object? createdAt = freezed,}) {
  return _then(GenRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,assetId: freezed == assetId ? _self.assetId : assetId // ignore: cast_nullable_to_non_nullable
as int?,genPlatformId: freezed == genPlatformId ? _self.genPlatformId : genPlatformId // ignore: cast_nullable_to_non_nullable
as int?,genModelId: freezed == genModelId ? _self.genModelId : genModelId // ignore: cast_nullable_to_non_nullable
as int?,genPresetId: freezed == genPresetId ? _self.genPresetId : genPresetId // ignore: cast_nullable_to_non_nullable
as int?,platformName: freezed == platformName ? _self.platformName : platformName // ignore: cast_nullable_to_non_nullable
as String?,modelName: freezed == modelName ? _self.modelName : modelName // ignore: cast_nullable_to_non_nullable
as String?,presetName: freezed == presetName ? _self.presetName : presetName // ignore: cast_nullable_to_non_nullable
as String?,promptRaw: freezed == promptRaw ? _self.promptRaw : promptRaw // ignore: cast_nullable_to_non_nullable
as String?,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as Map<String, List<GenTag>>,negative: null == negative ? _self.negative : negative // ignore: cast_nullable_to_non_nullable
as List<String>,loras: null == loras ? _self.loras : loras // ignore: cast_nullable_to_non_nullable
as List<GenLoraUse>,seed: freezed == seed ? _self.seed : seed // ignore: cast_nullable_to_non_nullable
as int?,sampler: freezed == sampler ? _self.sampler : sampler // ignore: cast_nullable_to_non_nullable
as String?,steps: freezed == steps ? _self.steps : steps // ignore: cast_nullable_to_non_nullable
as int?,cfgScale: freezed == cfgScale ? _self.cfgScale : cfgScale // ignore: cast_nullable_to_non_nullable
as double?,width: freezed == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int?,height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,isCover: null == isCover ? _self.isCover : isCover // ignore: cast_nullable_to_non_nullable
as bool,extra: null == extra ? _self.extra : extra // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [GenRecord].
extension GenRecordPatterns on GenRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GenRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GenRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GenRecord value)  $default,){
final _that = this;
switch (_that) {
case _GenRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GenRecord value)?  $default,){
final _that = this;
switch (_that) {
case _GenRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String? title,  int? assetId,  int? genPlatformId,  int? genModelId,  int? genPresetId,  String? platformName,  String? modelName,  String? presetName,  String? promptRaw,  Map<String, List<GenTag>> tags,  List<String> negative,  List<GenLoraUse> loras,  int? seed,  String? sampler,  int? steps,  double? cfgScale,  int? width,  int? height,  String? note, @IntBool()  bool isCover,  Map<String, Object?> extra,  String? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GenRecord() when $default != null:
return $default(_that.id,_that.title,_that.assetId,_that.genPlatformId,_that.genModelId,_that.genPresetId,_that.platformName,_that.modelName,_that.presetName,_that.promptRaw,_that.tags,_that.negative,_that.loras,_that.seed,_that.sampler,_that.steps,_that.cfgScale,_that.width,_that.height,_that.note,_that.isCover,_that.extra,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String? title,  int? assetId,  int? genPlatformId,  int? genModelId,  int? genPresetId,  String? platformName,  String? modelName,  String? presetName,  String? promptRaw,  Map<String, List<GenTag>> tags,  List<String> negative,  List<GenLoraUse> loras,  int? seed,  String? sampler,  int? steps,  double? cfgScale,  int? width,  int? height,  String? note, @IntBool()  bool isCover,  Map<String, Object?> extra,  String? createdAt)  $default,) {final _that = this;
switch (_that) {
case _GenRecord():
return $default(_that.id,_that.title,_that.assetId,_that.genPlatformId,_that.genModelId,_that.genPresetId,_that.platformName,_that.modelName,_that.presetName,_that.promptRaw,_that.tags,_that.negative,_that.loras,_that.seed,_that.sampler,_that.steps,_that.cfgScale,_that.width,_that.height,_that.note,_that.isCover,_that.extra,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String? title,  int? assetId,  int? genPlatformId,  int? genModelId,  int? genPresetId,  String? platformName,  String? modelName,  String? presetName,  String? promptRaw,  Map<String, List<GenTag>> tags,  List<String> negative,  List<GenLoraUse> loras,  int? seed,  String? sampler,  int? steps,  double? cfgScale,  int? width,  int? height,  String? note, @IntBool()  bool isCover,  Map<String, Object?> extra,  String? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _GenRecord() when $default != null:
return $default(_that.id,_that.title,_that.assetId,_that.genPlatformId,_that.genModelId,_that.genPresetId,_that.platformName,_that.modelName,_that.presetName,_that.promptRaw,_that.tags,_that.negative,_that.loras,_that.seed,_that.sampler,_that.steps,_that.cfgScale,_that.width,_that.height,_that.note,_that.isCover,_that.extra,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GenRecord extends GenRecord {
  const _GenRecord({required this.id, this.title, this.assetId, this.genPlatformId, this.genModelId, this.genPresetId, this.platformName, this.modelName, this.presetName, this.promptRaw,  Map<String, List<GenTag>> tags = const {},  List<String> negative = const [],  List<GenLoraUse> loras = const [], this.seed, this.sampler, this.steps, this.cfgScale, this.width, this.height, this.note, @IntBool() this.isCover = false,  Map<String, Object?> extra = const {}, this.createdAt}): _tags = tags,_negative = negative,_loras = loras,_extra = extra,super._();
  factory _GenRecord.fromJson(Map<String, dynamic> json) => _$GenRecordFromJson(json);

@override final  int id;
@override final  String? title;
@override final  int? assetId;
@override final  int? genPlatformId;
@override final  int? genModelId;
@override final  int? genPresetId;
@override final  String? platformName;
@override final  String? modelName;
@override final  String? presetName;
@override final  String? promptRaw;
 final  Map<String, List<GenTag>> _tags;
@override@JsonKey() Map<String, List<GenTag>> get tags {
  if (_tags is EqualUnmodifiableMapView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_tags);
}

 final  List<String> _negative;
@override@JsonKey() List<String> get negative {
  if (_negative is EqualUnmodifiableListView) return _negative;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_negative);
}

 final  List<GenLoraUse> _loras;
@override@JsonKey() List<GenLoraUse> get loras {
  if (_loras is EqualUnmodifiableListView) return _loras;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_loras);
}

@override final  int? seed;
@override final  String? sampler;
@override final  int? steps;
@override final  double? cfgScale;
@override final  int? width;
@override final  int? height;
@override final  String? note;
@override@JsonKey()@IntBool() final  bool isCover;
 final  Map<String, Object?> _extra;
@override@JsonKey() Map<String, Object?> get extra {
  if (_extra is EqualUnmodifiableMapView) return _extra;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_extra);
}

@override final  String? createdAt;

/// Create a copy of GenRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GenRecordCopyWith<_GenRecord> get copyWith => __$GenRecordCopyWithImpl<_GenRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GenRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GenRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.assetId, assetId) || other.assetId == assetId)&&(identical(other.genPlatformId, genPlatformId) || other.genPlatformId == genPlatformId)&&(identical(other.genModelId, genModelId) || other.genModelId == genModelId)&&(identical(other.genPresetId, genPresetId) || other.genPresetId == genPresetId)&&(identical(other.platformName, platformName) || other.platformName == platformName)&&(identical(other.modelName, modelName) || other.modelName == modelName)&&(identical(other.presetName, presetName) || other.presetName == presetName)&&(identical(other.promptRaw, promptRaw) || other.promptRaw == promptRaw)&&const DeepCollectionEquality().equals(other._tags, _tags)&&const DeepCollectionEquality().equals(other._negative, _negative)&&const DeepCollectionEquality().equals(other._loras, _loras)&&(identical(other.seed, seed) || other.seed == seed)&&(identical(other.sampler, sampler) || other.sampler == sampler)&&(identical(other.steps, steps) || other.steps == steps)&&(identical(other.cfgScale, cfgScale) || other.cfgScale == cfgScale)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.note, note) || other.note == note)&&(identical(other.isCover, isCover) || other.isCover == isCover)&&const DeepCollectionEquality().equals(other._extra, _extra)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,title,assetId,genPlatformId,genModelId,genPresetId,platformName,modelName,presetName,promptRaw,const DeepCollectionEquality().hash(_tags),const DeepCollectionEquality().hash(_negative),const DeepCollectionEquality().hash(_loras),seed,sampler,steps,cfgScale,width,height,note,isCover,const DeepCollectionEquality().hash(_extra),createdAt]);

@override
String toString() {
  return 'GenRecord(id: $id, title: $title, assetId: $assetId, genPlatformId: $genPlatformId, genModelId: $genModelId, genPresetId: $genPresetId, platformName: $platformName, modelName: $modelName, presetName: $presetName, promptRaw: $promptRaw, tags: $tags, negative: $negative, loras: $loras, seed: $seed, sampler: $sampler, steps: $steps, cfgScale: $cfgScale, width: $width, height: $height, note: $note, isCover: $isCover, extra: $extra, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$GenRecordCopyWith<$Res> implements $GenRecordCopyWith<$Res> {
  factory _$GenRecordCopyWith(_GenRecord value, $Res Function(_GenRecord) _then) = __$GenRecordCopyWithImpl;
@override @useResult
$Res call({
 int id, String? title, int? assetId, int? genPlatformId, int? genModelId, int? genPresetId, String? platformName, String? modelName, String? presetName, String? promptRaw, Map<String, List<GenTag>> tags, List<String> negative, List<GenLoraUse> loras, int? seed, String? sampler, int? steps, double? cfgScale, int? width, int? height, String? note,@IntBool() bool isCover, Map<String, Object?> extra, String? createdAt
});




}
/// @nodoc
class __$GenRecordCopyWithImpl<$Res>
    implements _$GenRecordCopyWith<$Res> {
  __$GenRecordCopyWithImpl(this._self, this._then);

  final _GenRecord _self;
  final $Res Function(_GenRecord) _then;

/// Create a copy of GenRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = freezed,Object? assetId = freezed,Object? genPlatformId = freezed,Object? genModelId = freezed,Object? genPresetId = freezed,Object? platformName = freezed,Object? modelName = freezed,Object? presetName = freezed,Object? promptRaw = freezed,Object? tags = null,Object? negative = null,Object? loras = null,Object? seed = freezed,Object? sampler = freezed,Object? steps = freezed,Object? cfgScale = freezed,Object? width = freezed,Object? height = freezed,Object? note = freezed,Object? isCover = null,Object? extra = null,Object? createdAt = freezed,}) {
  return _then(_GenRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,assetId: freezed == assetId ? _self.assetId : assetId // ignore: cast_nullable_to_non_nullable
as int?,genPlatformId: freezed == genPlatformId ? _self.genPlatformId : genPlatformId // ignore: cast_nullable_to_non_nullable
as int?,genModelId: freezed == genModelId ? _self.genModelId : genModelId // ignore: cast_nullable_to_non_nullable
as int?,genPresetId: freezed == genPresetId ? _self.genPresetId : genPresetId // ignore: cast_nullable_to_non_nullable
as int?,platformName: freezed == platformName ? _self.platformName : platformName // ignore: cast_nullable_to_non_nullable
as String?,modelName: freezed == modelName ? _self.modelName : modelName // ignore: cast_nullable_to_non_nullable
as String?,presetName: freezed == presetName ? _self.presetName : presetName // ignore: cast_nullable_to_non_nullable
as String?,promptRaw: freezed == promptRaw ? _self.promptRaw : promptRaw // ignore: cast_nullable_to_non_nullable
as String?,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as Map<String, List<GenTag>>,negative: null == negative ? _self._negative : negative // ignore: cast_nullable_to_non_nullable
as List<String>,loras: null == loras ? _self._loras : loras // ignore: cast_nullable_to_non_nullable
as List<GenLoraUse>,seed: freezed == seed ? _self.seed : seed // ignore: cast_nullable_to_non_nullable
as int?,sampler: freezed == sampler ? _self.sampler : sampler // ignore: cast_nullable_to_non_nullable
as String?,steps: freezed == steps ? _self.steps : steps // ignore: cast_nullable_to_non_nullable
as int?,cfgScale: freezed == cfgScale ? _self.cfgScale : cfgScale // ignore: cast_nullable_to_non_nullable
as double?,width: freezed == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int?,height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,isCover: null == isCover ? _self.isCover : isCover // ignore: cast_nullable_to_non_nullable
as bool,extra: null == extra ? _self._extra : extra // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$GenLora {

 int get id; String get name; String? get fileName; String? get baseModel; String? get triggerWords; double get defaultWeight; String? get sourceUrl; String? get note; int get useCount;
/// Create a copy of GenLora
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GenLoraCopyWith<GenLora> get copyWith => _$GenLoraCopyWithImpl<GenLora>(this as GenLora, _$identity);

  /// Serializes this GenLora to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GenLora&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.baseModel, baseModel) || other.baseModel == baseModel)&&(identical(other.triggerWords, triggerWords) || other.triggerWords == triggerWords)&&(identical(other.defaultWeight, defaultWeight) || other.defaultWeight == defaultWeight)&&(identical(other.sourceUrl, sourceUrl) || other.sourceUrl == sourceUrl)&&(identical(other.note, note) || other.note == note)&&(identical(other.useCount, useCount) || other.useCount == useCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,fileName,baseModel,triggerWords,defaultWeight,sourceUrl,note,useCount);

@override
String toString() {
  return 'GenLora(id: $id, name: $name, fileName: $fileName, baseModel: $baseModel, triggerWords: $triggerWords, defaultWeight: $defaultWeight, sourceUrl: $sourceUrl, note: $note, useCount: $useCount)';
}


}

/// @nodoc
abstract mixin class $GenLoraCopyWith<$Res>  {
  factory $GenLoraCopyWith(GenLora value, $Res Function(GenLora) _then) = _$GenLoraCopyWithImpl;
@useResult
$Res call({
 int id, String name, String? fileName, String? baseModel, String? triggerWords, double defaultWeight, String? sourceUrl, String? note, int useCount
});




}
/// @nodoc
class _$GenLoraCopyWithImpl<$Res>
    implements $GenLoraCopyWith<$Res> {
  _$GenLoraCopyWithImpl(this._self, this._then);

  final GenLora _self;
  final $Res Function(GenLora) _then;

/// Create a copy of GenLora
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? fileName = freezed,Object? baseModel = freezed,Object? triggerWords = freezed,Object? defaultWeight = null,Object? sourceUrl = freezed,Object? note = freezed,Object? useCount = null,}) {
  return _then(GenLora(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,fileName: freezed == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String?,baseModel: freezed == baseModel ? _self.baseModel : baseModel // ignore: cast_nullable_to_non_nullable
as String?,triggerWords: freezed == triggerWords ? _self.triggerWords : triggerWords // ignore: cast_nullable_to_non_nullable
as String?,defaultWeight: null == defaultWeight ? _self.defaultWeight : defaultWeight // ignore: cast_nullable_to_non_nullable
as double,sourceUrl: freezed == sourceUrl ? _self.sourceUrl : sourceUrl // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,useCount: null == useCount ? _self.useCount : useCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [GenLora].
extension GenLoraPatterns on GenLora {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GenLora value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GenLora() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GenLora value)  $default,){
final _that = this;
switch (_that) {
case _GenLora():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GenLora value)?  $default,){
final _that = this;
switch (_that) {
case _GenLora() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String? fileName,  String? baseModel,  String? triggerWords,  double defaultWeight,  String? sourceUrl,  String? note,  int useCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GenLora() when $default != null:
return $default(_that.id,_that.name,_that.fileName,_that.baseModel,_that.triggerWords,_that.defaultWeight,_that.sourceUrl,_that.note,_that.useCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String? fileName,  String? baseModel,  String? triggerWords,  double defaultWeight,  String? sourceUrl,  String? note,  int useCount)  $default,) {final _that = this;
switch (_that) {
case _GenLora():
return $default(_that.id,_that.name,_that.fileName,_that.baseModel,_that.triggerWords,_that.defaultWeight,_that.sourceUrl,_that.note,_that.useCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String? fileName,  String? baseModel,  String? triggerWords,  double defaultWeight,  String? sourceUrl,  String? note,  int useCount)?  $default,) {final _that = this;
switch (_that) {
case _GenLora() when $default != null:
return $default(_that.id,_that.name,_that.fileName,_that.baseModel,_that.triggerWords,_that.defaultWeight,_that.sourceUrl,_that.note,_that.useCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GenLora implements GenLora {
  const _GenLora({required this.id, required this.name, this.fileName, this.baseModel, this.triggerWords, this.defaultWeight = 1.0, this.sourceUrl, this.note, this.useCount = 0});
  factory _GenLora.fromJson(Map<String, dynamic> json) => _$GenLoraFromJson(json);

@override final  int id;
@override final  String name;
@override final  String? fileName;
@override final  String? baseModel;
@override final  String? triggerWords;
@override@JsonKey() final  double defaultWeight;
@override final  String? sourceUrl;
@override final  String? note;
@override@JsonKey() final  int useCount;

/// Create a copy of GenLora
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GenLoraCopyWith<_GenLora> get copyWith => __$GenLoraCopyWithImpl<_GenLora>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GenLoraToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GenLora&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.baseModel, baseModel) || other.baseModel == baseModel)&&(identical(other.triggerWords, triggerWords) || other.triggerWords == triggerWords)&&(identical(other.defaultWeight, defaultWeight) || other.defaultWeight == defaultWeight)&&(identical(other.sourceUrl, sourceUrl) || other.sourceUrl == sourceUrl)&&(identical(other.note, note) || other.note == note)&&(identical(other.useCount, useCount) || other.useCount == useCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,fileName,baseModel,triggerWords,defaultWeight,sourceUrl,note,useCount);

@override
String toString() {
  return 'GenLora(id: $id, name: $name, fileName: $fileName, baseModel: $baseModel, triggerWords: $triggerWords, defaultWeight: $defaultWeight, sourceUrl: $sourceUrl, note: $note, useCount: $useCount)';
}


}

/// @nodoc
abstract mixin class _$GenLoraCopyWith<$Res> implements $GenLoraCopyWith<$Res> {
  factory _$GenLoraCopyWith(_GenLora value, $Res Function(_GenLora) _then) = __$GenLoraCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String? fileName, String? baseModel, String? triggerWords, double defaultWeight, String? sourceUrl, String? note, int useCount
});




}
/// @nodoc
class __$GenLoraCopyWithImpl<$Res>
    implements _$GenLoraCopyWith<$Res> {
  __$GenLoraCopyWithImpl(this._self, this._then);

  final _GenLora _self;
  final $Res Function(_GenLora) _then;

/// Create a copy of GenLora
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? fileName = freezed,Object? baseModel = freezed,Object? triggerWords = freezed,Object? defaultWeight = null,Object? sourceUrl = freezed,Object? note = freezed,Object? useCount = null,}) {
  return _then(_GenLora(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,fileName: freezed == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String?,baseModel: freezed == baseModel ? _self.baseModel : baseModel // ignore: cast_nullable_to_non_nullable
as String?,triggerWords: freezed == triggerWords ? _self.triggerWords : triggerWords // ignore: cast_nullable_to_non_nullable
as String?,defaultWeight: null == defaultWeight ? _self.defaultWeight : defaultWeight // ignore: cast_nullable_to_non_nullable
as double,sourceUrl: freezed == sourceUrl ? _self.sourceUrl : sourceUrl // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,useCount: null == useCount ? _self.useCount : useCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
