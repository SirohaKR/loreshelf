// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SearchCharacterHit {

 int get id; String get name; String? get nameEn; String? get tagline; String? get themeColor; int? get portraitAssetId; String? get projectName; String get matchedIn;
/// Create a copy of SearchCharacterHit
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchCharacterHitCopyWith<SearchCharacterHit> get copyWith => _$SearchCharacterHitCopyWithImpl<SearchCharacterHit>(this as SearchCharacterHit, _$identity);

  /// Serializes this SearchCharacterHit to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchCharacterHit&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.tagline, tagline) || other.tagline == tagline)&&(identical(other.themeColor, themeColor) || other.themeColor == themeColor)&&(identical(other.portraitAssetId, portraitAssetId) || other.portraitAssetId == portraitAssetId)&&(identical(other.projectName, projectName) || other.projectName == projectName)&&(identical(other.matchedIn, matchedIn) || other.matchedIn == matchedIn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,nameEn,tagline,themeColor,portraitAssetId,projectName,matchedIn);

@override
String toString() {
  return 'SearchCharacterHit(id: $id, name: $name, nameEn: $nameEn, tagline: $tagline, themeColor: $themeColor, portraitAssetId: $portraitAssetId, projectName: $projectName, matchedIn: $matchedIn)';
}


}

/// @nodoc
abstract mixin class $SearchCharacterHitCopyWith<$Res>  {
  factory $SearchCharacterHitCopyWith(SearchCharacterHit value, $Res Function(SearchCharacterHit) _then) = _$SearchCharacterHitCopyWithImpl;
@useResult
$Res call({
 int id, String name, String? nameEn, String? tagline, String? themeColor, int? portraitAssetId, String? projectName, String matchedIn
});




}
/// @nodoc
class _$SearchCharacterHitCopyWithImpl<$Res>
    implements $SearchCharacterHitCopyWith<$Res> {
  _$SearchCharacterHitCopyWithImpl(this._self, this._then);

  final SearchCharacterHit _self;
  final $Res Function(SearchCharacterHit) _then;

/// Create a copy of SearchCharacterHit
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? nameEn = freezed,Object? tagline = freezed,Object? themeColor = freezed,Object? portraitAssetId = freezed,Object? projectName = freezed,Object? matchedIn = null,}) {
  return _then(SearchCharacterHit(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nameEn: freezed == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String?,tagline: freezed == tagline ? _self.tagline : tagline // ignore: cast_nullable_to_non_nullable
as String?,themeColor: freezed == themeColor ? _self.themeColor : themeColor // ignore: cast_nullable_to_non_nullable
as String?,portraitAssetId: freezed == portraitAssetId ? _self.portraitAssetId : portraitAssetId // ignore: cast_nullable_to_non_nullable
as int?,projectName: freezed == projectName ? _self.projectName : projectName // ignore: cast_nullable_to_non_nullable
as String?,matchedIn: null == matchedIn ? _self.matchedIn : matchedIn // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SearchCharacterHit].
extension SearchCharacterHitPatterns on SearchCharacterHit {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SearchCharacterHit value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SearchCharacterHit() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SearchCharacterHit value)  $default,){
final _that = this;
switch (_that) {
case _SearchCharacterHit():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SearchCharacterHit value)?  $default,){
final _that = this;
switch (_that) {
case _SearchCharacterHit() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String? nameEn,  String? tagline,  String? themeColor,  int? portraitAssetId,  String? projectName,  String matchedIn)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SearchCharacterHit() when $default != null:
return $default(_that.id,_that.name,_that.nameEn,_that.tagline,_that.themeColor,_that.portraitAssetId,_that.projectName,_that.matchedIn);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String? nameEn,  String? tagline,  String? themeColor,  int? portraitAssetId,  String? projectName,  String matchedIn)  $default,) {final _that = this;
switch (_that) {
case _SearchCharacterHit():
return $default(_that.id,_that.name,_that.nameEn,_that.tagline,_that.themeColor,_that.portraitAssetId,_that.projectName,_that.matchedIn);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String? nameEn,  String? tagline,  String? themeColor,  int? portraitAssetId,  String? projectName,  String matchedIn)?  $default,) {final _that = this;
switch (_that) {
case _SearchCharacterHit() when $default != null:
return $default(_that.id,_that.name,_that.nameEn,_that.tagline,_that.themeColor,_that.portraitAssetId,_that.projectName,_that.matchedIn);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SearchCharacterHit implements SearchCharacterHit {
  const _SearchCharacterHit({required this.id, required this.name, this.nameEn, this.tagline, this.themeColor, this.portraitAssetId, this.projectName, this.matchedIn = 'body'});
  factory _SearchCharacterHit.fromJson(Map<String, dynamic> json) => _$SearchCharacterHitFromJson(json);

@override final  int id;
@override final  String name;
@override final  String? nameEn;
@override final  String? tagline;
@override final  String? themeColor;
@override final  int? portraitAssetId;
@override final  String? projectName;
@override@JsonKey() final  String matchedIn;

/// Create a copy of SearchCharacterHit
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchCharacterHitCopyWith<_SearchCharacterHit> get copyWith => __$SearchCharacterHitCopyWithImpl<_SearchCharacterHit>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SearchCharacterHitToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchCharacterHit&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.tagline, tagline) || other.tagline == tagline)&&(identical(other.themeColor, themeColor) || other.themeColor == themeColor)&&(identical(other.portraitAssetId, portraitAssetId) || other.portraitAssetId == portraitAssetId)&&(identical(other.projectName, projectName) || other.projectName == projectName)&&(identical(other.matchedIn, matchedIn) || other.matchedIn == matchedIn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,nameEn,tagline,themeColor,portraitAssetId,projectName,matchedIn);

@override
String toString() {
  return 'SearchCharacterHit(id: $id, name: $name, nameEn: $nameEn, tagline: $tagline, themeColor: $themeColor, portraitAssetId: $portraitAssetId, projectName: $projectName, matchedIn: $matchedIn)';
}


}

/// @nodoc
abstract mixin class _$SearchCharacterHitCopyWith<$Res> implements $SearchCharacterHitCopyWith<$Res> {
  factory _$SearchCharacterHitCopyWith(_SearchCharacterHit value, $Res Function(_SearchCharacterHit) _then) = __$SearchCharacterHitCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String? nameEn, String? tagline, String? themeColor, int? portraitAssetId, String? projectName, String matchedIn
});




}
/// @nodoc
class __$SearchCharacterHitCopyWithImpl<$Res>
    implements _$SearchCharacterHitCopyWith<$Res> {
  __$SearchCharacterHitCopyWithImpl(this._self, this._then);

  final _SearchCharacterHit _self;
  final $Res Function(_SearchCharacterHit) _then;

/// Create a copy of SearchCharacterHit
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? nameEn = freezed,Object? tagline = freezed,Object? themeColor = freezed,Object? portraitAssetId = freezed,Object? projectName = freezed,Object? matchedIn = null,}) {
  return _then(_SearchCharacterHit(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nameEn: freezed == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String?,tagline: freezed == tagline ? _self.tagline : tagline // ignore: cast_nullable_to_non_nullable
as String?,themeColor: freezed == themeColor ? _self.themeColor : themeColor // ignore: cast_nullable_to_non_nullable
as String?,portraitAssetId: freezed == portraitAssetId ? _self.portraitAssetId : portraitAssetId // ignore: cast_nullable_to_non_nullable
as int?,projectName: freezed == projectName ? _self.projectName : projectName // ignore: cast_nullable_to_non_nullable
as String?,matchedIn: null == matchedIn ? _self.matchedIn : matchedIn // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$SearchWorldHit {

 int get id; String get name; String? get summary;
/// Create a copy of SearchWorldHit
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchWorldHitCopyWith<SearchWorldHit> get copyWith => _$SearchWorldHitCopyWithImpl<SearchWorldHit>(this as SearchWorldHit, _$identity);

  /// Serializes this SearchWorldHit to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchWorldHit&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.summary, summary) || other.summary == summary));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,summary);

@override
String toString() {
  return 'SearchWorldHit(id: $id, name: $name, summary: $summary)';
}


}

/// @nodoc
abstract mixin class $SearchWorldHitCopyWith<$Res>  {
  factory $SearchWorldHitCopyWith(SearchWorldHit value, $Res Function(SearchWorldHit) _then) = _$SearchWorldHitCopyWithImpl;
@useResult
$Res call({
 int id, String name, String? summary
});




}
/// @nodoc
class _$SearchWorldHitCopyWithImpl<$Res>
    implements $SearchWorldHitCopyWith<$Res> {
  _$SearchWorldHitCopyWithImpl(this._self, this._then);

  final SearchWorldHit _self;
  final $Res Function(SearchWorldHit) _then;

/// Create a copy of SearchWorldHit
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? summary = freezed,}) {
  return _then(SearchWorldHit(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SearchWorldHit].
extension SearchWorldHitPatterns on SearchWorldHit {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SearchWorldHit value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SearchWorldHit() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SearchWorldHit value)  $default,){
final _that = this;
switch (_that) {
case _SearchWorldHit():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SearchWorldHit value)?  $default,){
final _that = this;
switch (_that) {
case _SearchWorldHit() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String? summary)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SearchWorldHit() when $default != null:
return $default(_that.id,_that.name,_that.summary);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String? summary)  $default,) {final _that = this;
switch (_that) {
case _SearchWorldHit():
return $default(_that.id,_that.name,_that.summary);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String? summary)?  $default,) {final _that = this;
switch (_that) {
case _SearchWorldHit() when $default != null:
return $default(_that.id,_that.name,_that.summary);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SearchWorldHit implements SearchWorldHit {
  const _SearchWorldHit({required this.id, required this.name, this.summary});
  factory _SearchWorldHit.fromJson(Map<String, dynamic> json) => _$SearchWorldHitFromJson(json);

@override final  int id;
@override final  String name;
@override final  String? summary;

/// Create a copy of SearchWorldHit
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchWorldHitCopyWith<_SearchWorldHit> get copyWith => __$SearchWorldHitCopyWithImpl<_SearchWorldHit>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SearchWorldHitToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchWorldHit&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.summary, summary) || other.summary == summary));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,summary);

@override
String toString() {
  return 'SearchWorldHit(id: $id, name: $name, summary: $summary)';
}


}

/// @nodoc
abstract mixin class _$SearchWorldHitCopyWith<$Res> implements $SearchWorldHitCopyWith<$Res> {
  factory _$SearchWorldHitCopyWith(_SearchWorldHit value, $Res Function(_SearchWorldHit) _then) = __$SearchWorldHitCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String? summary
});




}
/// @nodoc
class __$SearchWorldHitCopyWithImpl<$Res>
    implements _$SearchWorldHitCopyWith<$Res> {
  __$SearchWorldHitCopyWithImpl(this._self, this._then);

  final _SearchWorldHit _self;
  final $Res Function(_SearchWorldHit) _then;

/// Create a copy of SearchWorldHit
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? summary = freezed,}) {
  return _then(_SearchWorldHit(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$SearchProjectHit {

 int get id; String get name; String get kind; String? get summary;
/// Create a copy of SearchProjectHit
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchProjectHitCopyWith<SearchProjectHit> get copyWith => _$SearchProjectHitCopyWithImpl<SearchProjectHit>(this as SearchProjectHit, _$identity);

  /// Serializes this SearchProjectHit to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchProjectHit&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.summary, summary) || other.summary == summary));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,kind,summary);

@override
String toString() {
  return 'SearchProjectHit(id: $id, name: $name, kind: $kind, summary: $summary)';
}


}

/// @nodoc
abstract mixin class $SearchProjectHitCopyWith<$Res>  {
  factory $SearchProjectHitCopyWith(SearchProjectHit value, $Res Function(SearchProjectHit) _then) = _$SearchProjectHitCopyWithImpl;
@useResult
$Res call({
 int id, String name, String kind, String? summary
});




}
/// @nodoc
class _$SearchProjectHitCopyWithImpl<$Res>
    implements $SearchProjectHitCopyWith<$Res> {
  _$SearchProjectHitCopyWithImpl(this._self, this._then);

  final SearchProjectHit _self;
  final $Res Function(SearchProjectHit) _then;

/// Create a copy of SearchProjectHit
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? kind = null,Object? summary = freezed,}) {
  return _then(SearchProjectHit(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SearchProjectHit].
extension SearchProjectHitPatterns on SearchProjectHit {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SearchProjectHit value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SearchProjectHit() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SearchProjectHit value)  $default,){
final _that = this;
switch (_that) {
case _SearchProjectHit():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SearchProjectHit value)?  $default,){
final _that = this;
switch (_that) {
case _SearchProjectHit() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String kind,  String? summary)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SearchProjectHit() when $default != null:
return $default(_that.id,_that.name,_that.kind,_that.summary);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String kind,  String? summary)  $default,) {final _that = this;
switch (_that) {
case _SearchProjectHit():
return $default(_that.id,_that.name,_that.kind,_that.summary);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String kind,  String? summary)?  $default,) {final _that = this;
switch (_that) {
case _SearchProjectHit() when $default != null:
return $default(_that.id,_that.name,_that.kind,_that.summary);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SearchProjectHit implements SearchProjectHit {
  const _SearchProjectHit({required this.id, required this.name, this.kind = 'etc', this.summary});
  factory _SearchProjectHit.fromJson(Map<String, dynamic> json) => _$SearchProjectHitFromJson(json);

@override final  int id;
@override final  String name;
@override@JsonKey() final  String kind;
@override final  String? summary;

/// Create a copy of SearchProjectHit
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchProjectHitCopyWith<_SearchProjectHit> get copyWith => __$SearchProjectHitCopyWithImpl<_SearchProjectHit>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SearchProjectHitToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchProjectHit&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.summary, summary) || other.summary == summary));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,kind,summary);

@override
String toString() {
  return 'SearchProjectHit(id: $id, name: $name, kind: $kind, summary: $summary)';
}


}

/// @nodoc
abstract mixin class _$SearchProjectHitCopyWith<$Res> implements $SearchProjectHitCopyWith<$Res> {
  factory _$SearchProjectHitCopyWith(_SearchProjectHit value, $Res Function(_SearchProjectHit) _then) = __$SearchProjectHitCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String kind, String? summary
});




}
/// @nodoc
class __$SearchProjectHitCopyWithImpl<$Res>
    implements _$SearchProjectHitCopyWith<$Res> {
  __$SearchProjectHitCopyWithImpl(this._self, this._then);

  final _SearchProjectHit _self;
  final $Res Function(_SearchProjectHit) _then;

/// Create a copy of SearchProjectHit
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? kind = null,Object? summary = freezed,}) {
  return _then(_SearchProjectHit(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$SearchResults {

 List<SearchCharacterHit> get characters; List<SearchWorldHit> get worlds; List<SearchProjectHit> get projects;
/// Create a copy of SearchResults
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchResultsCopyWith<SearchResults> get copyWith => _$SearchResultsCopyWithImpl<SearchResults>(this as SearchResults, _$identity);

  /// Serializes this SearchResults to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchResults&&const DeepCollectionEquality().equals(other.characters, characters)&&const DeepCollectionEquality().equals(other.worlds, worlds)&&const DeepCollectionEquality().equals(other.projects, projects));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(characters),const DeepCollectionEquality().hash(worlds),const DeepCollectionEquality().hash(projects));

@override
String toString() {
  return 'SearchResults(characters: $characters, worlds: $worlds, projects: $projects)';
}


}

/// @nodoc
abstract mixin class $SearchResultsCopyWith<$Res>  {
  factory $SearchResultsCopyWith(SearchResults value, $Res Function(SearchResults) _then) = _$SearchResultsCopyWithImpl;
@useResult
$Res call({
 List<SearchCharacterHit> characters, List<SearchWorldHit> worlds, List<SearchProjectHit> projects
});




}
/// @nodoc
class _$SearchResultsCopyWithImpl<$Res>
    implements $SearchResultsCopyWith<$Res> {
  _$SearchResultsCopyWithImpl(this._self, this._then);

  final SearchResults _self;
  final $Res Function(SearchResults) _then;

/// Create a copy of SearchResults
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? characters = null,Object? worlds = null,Object? projects = null,}) {
  return _then(SearchResults(
characters: null == characters ? _self.characters : characters // ignore: cast_nullable_to_non_nullable
as List<SearchCharacterHit>,worlds: null == worlds ? _self.worlds : worlds // ignore: cast_nullable_to_non_nullable
as List<SearchWorldHit>,projects: null == projects ? _self.projects : projects // ignore: cast_nullable_to_non_nullable
as List<SearchProjectHit>,
  ));
}

}


/// Adds pattern-matching-related methods to [SearchResults].
extension SearchResultsPatterns on SearchResults {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SearchResults value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SearchResults() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SearchResults value)  $default,){
final _that = this;
switch (_that) {
case _SearchResults():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SearchResults value)?  $default,){
final _that = this;
switch (_that) {
case _SearchResults() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<SearchCharacterHit> characters,  List<SearchWorldHit> worlds,  List<SearchProjectHit> projects)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SearchResults() when $default != null:
return $default(_that.characters,_that.worlds,_that.projects);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<SearchCharacterHit> characters,  List<SearchWorldHit> worlds,  List<SearchProjectHit> projects)  $default,) {final _that = this;
switch (_that) {
case _SearchResults():
return $default(_that.characters,_that.worlds,_that.projects);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<SearchCharacterHit> characters,  List<SearchWorldHit> worlds,  List<SearchProjectHit> projects)?  $default,) {final _that = this;
switch (_that) {
case _SearchResults() when $default != null:
return $default(_that.characters,_that.worlds,_that.projects);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SearchResults extends SearchResults {
  const _SearchResults({ List<SearchCharacterHit> characters = const [],  List<SearchWorldHit> worlds = const [],  List<SearchProjectHit> projects = const []}): _characters = characters,_worlds = worlds,_projects = projects,super._();
  factory _SearchResults.fromJson(Map<String, dynamic> json) => _$SearchResultsFromJson(json);

 final  List<SearchCharacterHit> _characters;
@override@JsonKey() List<SearchCharacterHit> get characters {
  if (_characters is EqualUnmodifiableListView) return _characters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_characters);
}

 final  List<SearchWorldHit> _worlds;
@override@JsonKey() List<SearchWorldHit> get worlds {
  if (_worlds is EqualUnmodifiableListView) return _worlds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_worlds);
}

 final  List<SearchProjectHit> _projects;
@override@JsonKey() List<SearchProjectHit> get projects {
  if (_projects is EqualUnmodifiableListView) return _projects;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_projects);
}


/// Create a copy of SearchResults
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchResultsCopyWith<_SearchResults> get copyWith => __$SearchResultsCopyWithImpl<_SearchResults>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SearchResultsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchResults&&const DeepCollectionEquality().equals(other._characters, _characters)&&const DeepCollectionEquality().equals(other._worlds, _worlds)&&const DeepCollectionEquality().equals(other._projects, _projects));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_characters),const DeepCollectionEquality().hash(_worlds),const DeepCollectionEquality().hash(_projects));

@override
String toString() {
  return 'SearchResults(characters: $characters, worlds: $worlds, projects: $projects)';
}


}

/// @nodoc
abstract mixin class _$SearchResultsCopyWith<$Res> implements $SearchResultsCopyWith<$Res> {
  factory _$SearchResultsCopyWith(_SearchResults value, $Res Function(_SearchResults) _then) = __$SearchResultsCopyWithImpl;
@override @useResult
$Res call({
 List<SearchCharacterHit> characters, List<SearchWorldHit> worlds, List<SearchProjectHit> projects
});




}
/// @nodoc
class __$SearchResultsCopyWithImpl<$Res>
    implements _$SearchResultsCopyWith<$Res> {
  __$SearchResultsCopyWithImpl(this._self, this._then);

  final _SearchResults _self;
  final $Res Function(_SearchResults) _then;

/// Create a copy of SearchResults
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? characters = null,Object? worlds = null,Object? projects = null,}) {
  return _then(_SearchResults(
characters: null == characters ? _self._characters : characters // ignore: cast_nullable_to_non_nullable
as List<SearchCharacterHit>,worlds: null == worlds ? _self._worlds : worlds // ignore: cast_nullable_to_non_nullable
as List<SearchWorldHit>,projects: null == projects ? _self._projects : projects // ignore: cast_nullable_to_non_nullable
as List<SearchProjectHit>,
  ));
}


}

// dart format on
