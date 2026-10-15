// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'character.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CharacterSummary {

 int get id; String get name; String? get nameEn; String? get tagline; String? get themeColor; int? get portraitAssetId; String get visibility;@IntBool() bool get isFavorite; int? get worldId; String? get worldName; int? get projectId; String? get projectName; int? get sourceCharacterId; String? get updatedAt; List<String> get tags; String? get membership; String? get role;
/// Create a copy of CharacterSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CharacterSummaryCopyWith<CharacterSummary> get copyWith => _$CharacterSummaryCopyWithImpl<CharacterSummary>(this as CharacterSummary, _$identity);

  /// Serializes this CharacterSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CharacterSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.tagline, tagline) || other.tagline == tagline)&&(identical(other.themeColor, themeColor) || other.themeColor == themeColor)&&(identical(other.portraitAssetId, portraitAssetId) || other.portraitAssetId == portraitAssetId)&&(identical(other.visibility, visibility) || other.visibility == visibility)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite)&&(identical(other.worldId, worldId) || other.worldId == worldId)&&(identical(other.worldName, worldName) || other.worldName == worldName)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.projectName, projectName) || other.projectName == projectName)&&(identical(other.sourceCharacterId, sourceCharacterId) || other.sourceCharacterId == sourceCharacterId)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other.tags, tags)&&(identical(other.membership, membership) || other.membership == membership)&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,nameEn,tagline,themeColor,portraitAssetId,visibility,isFavorite,worldId,worldName,projectId,projectName,sourceCharacterId,updatedAt,const DeepCollectionEquality().hash(tags),membership,role);

@override
String toString() {
  return 'CharacterSummary(id: $id, name: $name, nameEn: $nameEn, tagline: $tagline, themeColor: $themeColor, portraitAssetId: $portraitAssetId, visibility: $visibility, isFavorite: $isFavorite, worldId: $worldId, worldName: $worldName, projectId: $projectId, projectName: $projectName, sourceCharacterId: $sourceCharacterId, updatedAt: $updatedAt, tags: $tags, membership: $membership, role: $role)';
}


}

/// @nodoc
abstract mixin class $CharacterSummaryCopyWith<$Res>  {
  factory $CharacterSummaryCopyWith(CharacterSummary value, $Res Function(CharacterSummary) _then) = _$CharacterSummaryCopyWithImpl;
@useResult
$Res call({
 int id, String name, String? nameEn, String? tagline, String? themeColor, int? portraitAssetId, String visibility,@IntBool() bool isFavorite, int? worldId, String? worldName, int? projectId, String? projectName, int? sourceCharacterId, String? updatedAt, List<String> tags, String? membership, String? role
});




}
/// @nodoc
class _$CharacterSummaryCopyWithImpl<$Res>
    implements $CharacterSummaryCopyWith<$Res> {
  _$CharacterSummaryCopyWithImpl(this._self, this._then);

  final CharacterSummary _self;
  final $Res Function(CharacterSummary) _then;

/// Create a copy of CharacterSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? nameEn = freezed,Object? tagline = freezed,Object? themeColor = freezed,Object? portraitAssetId = freezed,Object? visibility = null,Object? isFavorite = null,Object? worldId = freezed,Object? worldName = freezed,Object? projectId = freezed,Object? projectName = freezed,Object? sourceCharacterId = freezed,Object? updatedAt = freezed,Object? tags = null,Object? membership = freezed,Object? role = freezed,}) {
  return _then(CharacterSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nameEn: freezed == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String?,tagline: freezed == tagline ? _self.tagline : tagline // ignore: cast_nullable_to_non_nullable
as String?,themeColor: freezed == themeColor ? _self.themeColor : themeColor // ignore: cast_nullable_to_non_nullable
as String?,portraitAssetId: freezed == portraitAssetId ? _self.portraitAssetId : portraitAssetId // ignore: cast_nullable_to_non_nullable
as int?,visibility: null == visibility ? _self.visibility : visibility // ignore: cast_nullable_to_non_nullable
as String,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,worldId: freezed == worldId ? _self.worldId : worldId // ignore: cast_nullable_to_non_nullable
as int?,worldName: freezed == worldName ? _self.worldName : worldName // ignore: cast_nullable_to_non_nullable
as String?,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as int?,projectName: freezed == projectName ? _self.projectName : projectName // ignore: cast_nullable_to_non_nullable
as String?,sourceCharacterId: freezed == sourceCharacterId ? _self.sourceCharacterId : sourceCharacterId // ignore: cast_nullable_to_non_nullable
as int?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,membership: freezed == membership ? _self.membership : membership // ignore: cast_nullable_to_non_nullable
as String?,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CharacterSummary].
extension CharacterSummaryPatterns on CharacterSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CharacterSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CharacterSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CharacterSummary value)  $default,){
final _that = this;
switch (_that) {
case _CharacterSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CharacterSummary value)?  $default,){
final _that = this;
switch (_that) {
case _CharacterSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String? nameEn,  String? tagline,  String? themeColor,  int? portraitAssetId,  String visibility, @IntBool()  bool isFavorite,  int? worldId,  String? worldName,  int? projectId,  String? projectName,  int? sourceCharacterId,  String? updatedAt,  List<String> tags,  String? membership,  String? role)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CharacterSummary() when $default != null:
return $default(_that.id,_that.name,_that.nameEn,_that.tagline,_that.themeColor,_that.portraitAssetId,_that.visibility,_that.isFavorite,_that.worldId,_that.worldName,_that.projectId,_that.projectName,_that.sourceCharacterId,_that.updatedAt,_that.tags,_that.membership,_that.role);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String? nameEn,  String? tagline,  String? themeColor,  int? portraitAssetId,  String visibility, @IntBool()  bool isFavorite,  int? worldId,  String? worldName,  int? projectId,  String? projectName,  int? sourceCharacterId,  String? updatedAt,  List<String> tags,  String? membership,  String? role)  $default,) {final _that = this;
switch (_that) {
case _CharacterSummary():
return $default(_that.id,_that.name,_that.nameEn,_that.tagline,_that.themeColor,_that.portraitAssetId,_that.visibility,_that.isFavorite,_that.worldId,_that.worldName,_that.projectId,_that.projectName,_that.sourceCharacterId,_that.updatedAt,_that.tags,_that.membership,_that.role);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String? nameEn,  String? tagline,  String? themeColor,  int? portraitAssetId,  String visibility, @IntBool()  bool isFavorite,  int? worldId,  String? worldName,  int? projectId,  String? projectName,  int? sourceCharacterId,  String? updatedAt,  List<String> tags,  String? membership,  String? role)?  $default,) {final _that = this;
switch (_that) {
case _CharacterSummary() when $default != null:
return $default(_that.id,_that.name,_that.nameEn,_that.tagline,_that.themeColor,_that.portraitAssetId,_that.visibility,_that.isFavorite,_that.worldId,_that.worldName,_that.projectId,_that.projectName,_that.sourceCharacterId,_that.updatedAt,_that.tags,_that.membership,_that.role);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CharacterSummary implements CharacterSummary {
  const _CharacterSummary({required this.id, required this.name, this.nameEn, this.tagline, this.themeColor, this.portraitAssetId, this.visibility = 'private', @IntBool() this.isFavorite = false, this.worldId, this.worldName, this.projectId, this.projectName, this.sourceCharacterId, this.updatedAt,  List<String> tags = const [], this.membership, this.role}): _tags = tags;
  factory _CharacterSummary.fromJson(Map<String, dynamic> json) => _$CharacterSummaryFromJson(json);

@override final  int id;
@override final  String name;
@override final  String? nameEn;
@override final  String? tagline;
@override final  String? themeColor;
@override final  int? portraitAssetId;
@override@JsonKey() final  String visibility;
@override@JsonKey()@IntBool() final  bool isFavorite;
@override final  int? worldId;
@override final  String? worldName;
@override final  int? projectId;
@override final  String? projectName;
@override final  int? sourceCharacterId;
@override final  String? updatedAt;
 final  List<String> _tags;
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

@override final  String? membership;
@override final  String? role;

/// Create a copy of CharacterSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CharacterSummaryCopyWith<_CharacterSummary> get copyWith => __$CharacterSummaryCopyWithImpl<_CharacterSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CharacterSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CharacterSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.tagline, tagline) || other.tagline == tagline)&&(identical(other.themeColor, themeColor) || other.themeColor == themeColor)&&(identical(other.portraitAssetId, portraitAssetId) || other.portraitAssetId == portraitAssetId)&&(identical(other.visibility, visibility) || other.visibility == visibility)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite)&&(identical(other.worldId, worldId) || other.worldId == worldId)&&(identical(other.worldName, worldName) || other.worldName == worldName)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.projectName, projectName) || other.projectName == projectName)&&(identical(other.sourceCharacterId, sourceCharacterId) || other.sourceCharacterId == sourceCharacterId)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.membership, membership) || other.membership == membership)&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,nameEn,tagline,themeColor,portraitAssetId,visibility,isFavorite,worldId,worldName,projectId,projectName,sourceCharacterId,updatedAt,const DeepCollectionEquality().hash(_tags),membership,role);

@override
String toString() {
  return 'CharacterSummary(id: $id, name: $name, nameEn: $nameEn, tagline: $tagline, themeColor: $themeColor, portraitAssetId: $portraitAssetId, visibility: $visibility, isFavorite: $isFavorite, worldId: $worldId, worldName: $worldName, projectId: $projectId, projectName: $projectName, sourceCharacterId: $sourceCharacterId, updatedAt: $updatedAt, tags: $tags, membership: $membership, role: $role)';
}


}

/// @nodoc
abstract mixin class _$CharacterSummaryCopyWith<$Res> implements $CharacterSummaryCopyWith<$Res> {
  factory _$CharacterSummaryCopyWith(_CharacterSummary value, $Res Function(_CharacterSummary) _then) = __$CharacterSummaryCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String? nameEn, String? tagline, String? themeColor, int? portraitAssetId, String visibility,@IntBool() bool isFavorite, int? worldId, String? worldName, int? projectId, String? projectName, int? sourceCharacterId, String? updatedAt, List<String> tags, String? membership, String? role
});




}
/// @nodoc
class __$CharacterSummaryCopyWithImpl<$Res>
    implements _$CharacterSummaryCopyWith<$Res> {
  __$CharacterSummaryCopyWithImpl(this._self, this._then);

  final _CharacterSummary _self;
  final $Res Function(_CharacterSummary) _then;

/// Create a copy of CharacterSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? nameEn = freezed,Object? tagline = freezed,Object? themeColor = freezed,Object? portraitAssetId = freezed,Object? visibility = null,Object? isFavorite = null,Object? worldId = freezed,Object? worldName = freezed,Object? projectId = freezed,Object? projectName = freezed,Object? sourceCharacterId = freezed,Object? updatedAt = freezed,Object? tags = null,Object? membership = freezed,Object? role = freezed,}) {
  return _then(_CharacterSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nameEn: freezed == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String?,tagline: freezed == tagline ? _self.tagline : tagline // ignore: cast_nullable_to_non_nullable
as String?,themeColor: freezed == themeColor ? _self.themeColor : themeColor // ignore: cast_nullable_to_non_nullable
as String?,portraitAssetId: freezed == portraitAssetId ? _self.portraitAssetId : portraitAssetId // ignore: cast_nullable_to_non_nullable
as int?,visibility: null == visibility ? _self.visibility : visibility // ignore: cast_nullable_to_non_nullable
as String,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,worldId: freezed == worldId ? _self.worldId : worldId // ignore: cast_nullable_to_non_nullable
as int?,worldName: freezed == worldName ? _self.worldName : worldName // ignore: cast_nullable_to_non_nullable
as String?,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as int?,projectName: freezed == projectName ? _self.projectName : projectName // ignore: cast_nullable_to_non_nullable
as String?,sourceCharacterId: freezed == sourceCharacterId ? _self.sourceCharacterId : sourceCharacterId // ignore: cast_nullable_to_non_nullable
as int?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,membership: freezed == membership ? _self.membership : membership // ignore: cast_nullable_to_non_nullable
as String?,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$CharacterDetail {

 int get id; String get name; String? get nameEn; String? get tagline; String? get quote; String? get themeColor; int? get portraitAssetId; String? get bodyMd; String get visibility;@IntBool() bool get isFavorite; int? get projectId; String? get projectName; String? get projectKind; String? get worldName; String? get sourceCharacterName; String? get updatedAt; List<CharacterField> get fields; List<Trait> get traits; List<Quote> get quotes; List<String> get tags; List<GalleryImage> get gallery; List<LinkedProject> get linkedProjects; List<Genre> get projectGenres;
/// Create a copy of CharacterDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CharacterDetailCopyWith<CharacterDetail> get copyWith => _$CharacterDetailCopyWithImpl<CharacterDetail>(this as CharacterDetail, _$identity);

  /// Serializes this CharacterDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CharacterDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.tagline, tagline) || other.tagline == tagline)&&(identical(other.quote, quote) || other.quote == quote)&&(identical(other.themeColor, themeColor) || other.themeColor == themeColor)&&(identical(other.portraitAssetId, portraitAssetId) || other.portraitAssetId == portraitAssetId)&&(identical(other.bodyMd, bodyMd) || other.bodyMd == bodyMd)&&(identical(other.visibility, visibility) || other.visibility == visibility)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.projectName, projectName) || other.projectName == projectName)&&(identical(other.projectKind, projectKind) || other.projectKind == projectKind)&&(identical(other.worldName, worldName) || other.worldName == worldName)&&(identical(other.sourceCharacterName, sourceCharacterName) || other.sourceCharacterName == sourceCharacterName)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other.fields, fields)&&const DeepCollectionEquality().equals(other.traits, traits)&&const DeepCollectionEquality().equals(other.quotes, quotes)&&const DeepCollectionEquality().equals(other.tags, tags)&&const DeepCollectionEquality().equals(other.gallery, gallery)&&const DeepCollectionEquality().equals(other.linkedProjects, linkedProjects)&&const DeepCollectionEquality().equals(other.projectGenres, projectGenres));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,name,nameEn,tagline,quote,themeColor,portraitAssetId,bodyMd,visibility,isFavorite,projectId,projectName,projectKind,worldName,sourceCharacterName,updatedAt,const DeepCollectionEquality().hash(fields),const DeepCollectionEquality().hash(traits),const DeepCollectionEquality().hash(quotes),const DeepCollectionEquality().hash(tags),const DeepCollectionEquality().hash(gallery),const DeepCollectionEquality().hash(linkedProjects),const DeepCollectionEquality().hash(projectGenres)]);

@override
String toString() {
  return 'CharacterDetail(id: $id, name: $name, nameEn: $nameEn, tagline: $tagline, quote: $quote, themeColor: $themeColor, portraitAssetId: $portraitAssetId, bodyMd: $bodyMd, visibility: $visibility, isFavorite: $isFavorite, projectId: $projectId, projectName: $projectName, projectKind: $projectKind, worldName: $worldName, sourceCharacterName: $sourceCharacterName, updatedAt: $updatedAt, fields: $fields, traits: $traits, quotes: $quotes, tags: $tags, gallery: $gallery, linkedProjects: $linkedProjects, projectGenres: $projectGenres)';
}


}

/// @nodoc
abstract mixin class $CharacterDetailCopyWith<$Res>  {
  factory $CharacterDetailCopyWith(CharacterDetail value, $Res Function(CharacterDetail) _then) = _$CharacterDetailCopyWithImpl;
@useResult
$Res call({
 int id, String name, String? nameEn, String? tagline, String? quote, String? themeColor, int? portraitAssetId, String? bodyMd, String visibility,@IntBool() bool isFavorite, int? projectId, String? projectName, String? projectKind, String? worldName, String? sourceCharacterName, String? updatedAt, List<CharacterField> fields, List<Trait> traits, List<Quote> quotes, List<String> tags, List<GalleryImage> gallery, List<LinkedProject> linkedProjects, List<Genre> projectGenres
});




}
/// @nodoc
class _$CharacterDetailCopyWithImpl<$Res>
    implements $CharacterDetailCopyWith<$Res> {
  _$CharacterDetailCopyWithImpl(this._self, this._then);

  final CharacterDetail _self;
  final $Res Function(CharacterDetail) _then;

/// Create a copy of CharacterDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? nameEn = freezed,Object? tagline = freezed,Object? quote = freezed,Object? themeColor = freezed,Object? portraitAssetId = freezed,Object? bodyMd = freezed,Object? visibility = null,Object? isFavorite = null,Object? projectId = freezed,Object? projectName = freezed,Object? projectKind = freezed,Object? worldName = freezed,Object? sourceCharacterName = freezed,Object? updatedAt = freezed,Object? fields = null,Object? traits = null,Object? quotes = null,Object? tags = null,Object? gallery = null,Object? linkedProjects = null,Object? projectGenres = null,}) {
  return _then(CharacterDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nameEn: freezed == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String?,tagline: freezed == tagline ? _self.tagline : tagline // ignore: cast_nullable_to_non_nullable
as String?,quote: freezed == quote ? _self.quote : quote // ignore: cast_nullable_to_non_nullable
as String?,themeColor: freezed == themeColor ? _self.themeColor : themeColor // ignore: cast_nullable_to_non_nullable
as String?,portraitAssetId: freezed == portraitAssetId ? _self.portraitAssetId : portraitAssetId // ignore: cast_nullable_to_non_nullable
as int?,bodyMd: freezed == bodyMd ? _self.bodyMd : bodyMd // ignore: cast_nullable_to_non_nullable
as String?,visibility: null == visibility ? _self.visibility : visibility // ignore: cast_nullable_to_non_nullable
as String,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as int?,projectName: freezed == projectName ? _self.projectName : projectName // ignore: cast_nullable_to_non_nullable
as String?,projectKind: freezed == projectKind ? _self.projectKind : projectKind // ignore: cast_nullable_to_non_nullable
as String?,worldName: freezed == worldName ? _self.worldName : worldName // ignore: cast_nullable_to_non_nullable
as String?,sourceCharacterName: freezed == sourceCharacterName ? _self.sourceCharacterName : sourceCharacterName // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,fields: null == fields ? _self.fields : fields // ignore: cast_nullable_to_non_nullable
as List<CharacterField>,traits: null == traits ? _self.traits : traits // ignore: cast_nullable_to_non_nullable
as List<Trait>,quotes: null == quotes ? _self.quotes : quotes // ignore: cast_nullable_to_non_nullable
as List<Quote>,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,gallery: null == gallery ? _self.gallery : gallery // ignore: cast_nullable_to_non_nullable
as List<GalleryImage>,linkedProjects: null == linkedProjects ? _self.linkedProjects : linkedProjects // ignore: cast_nullable_to_non_nullable
as List<LinkedProject>,projectGenres: null == projectGenres ? _self.projectGenres : projectGenres // ignore: cast_nullable_to_non_nullable
as List<Genre>,
  ));
}

}


/// Adds pattern-matching-related methods to [CharacterDetail].
extension CharacterDetailPatterns on CharacterDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CharacterDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CharacterDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CharacterDetail value)  $default,){
final _that = this;
switch (_that) {
case _CharacterDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CharacterDetail value)?  $default,){
final _that = this;
switch (_that) {
case _CharacterDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String? nameEn,  String? tagline,  String? quote,  String? themeColor,  int? portraitAssetId,  String? bodyMd,  String visibility, @IntBool()  bool isFavorite,  int? projectId,  String? projectName,  String? projectKind,  String? worldName,  String? sourceCharacterName,  String? updatedAt,  List<CharacterField> fields,  List<Trait> traits,  List<Quote> quotes,  List<String> tags,  List<GalleryImage> gallery,  List<LinkedProject> linkedProjects,  List<Genre> projectGenres)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CharacterDetail() when $default != null:
return $default(_that.id,_that.name,_that.nameEn,_that.tagline,_that.quote,_that.themeColor,_that.portraitAssetId,_that.bodyMd,_that.visibility,_that.isFavorite,_that.projectId,_that.projectName,_that.projectKind,_that.worldName,_that.sourceCharacterName,_that.updatedAt,_that.fields,_that.traits,_that.quotes,_that.tags,_that.gallery,_that.linkedProjects,_that.projectGenres);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String? nameEn,  String? tagline,  String? quote,  String? themeColor,  int? portraitAssetId,  String? bodyMd,  String visibility, @IntBool()  bool isFavorite,  int? projectId,  String? projectName,  String? projectKind,  String? worldName,  String? sourceCharacterName,  String? updatedAt,  List<CharacterField> fields,  List<Trait> traits,  List<Quote> quotes,  List<String> tags,  List<GalleryImage> gallery,  List<LinkedProject> linkedProjects,  List<Genre> projectGenres)  $default,) {final _that = this;
switch (_that) {
case _CharacterDetail():
return $default(_that.id,_that.name,_that.nameEn,_that.tagline,_that.quote,_that.themeColor,_that.portraitAssetId,_that.bodyMd,_that.visibility,_that.isFavorite,_that.projectId,_that.projectName,_that.projectKind,_that.worldName,_that.sourceCharacterName,_that.updatedAt,_that.fields,_that.traits,_that.quotes,_that.tags,_that.gallery,_that.linkedProjects,_that.projectGenres);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String? nameEn,  String? tagline,  String? quote,  String? themeColor,  int? portraitAssetId,  String? bodyMd,  String visibility, @IntBool()  bool isFavorite,  int? projectId,  String? projectName,  String? projectKind,  String? worldName,  String? sourceCharacterName,  String? updatedAt,  List<CharacterField> fields,  List<Trait> traits,  List<Quote> quotes,  List<String> tags,  List<GalleryImage> gallery,  List<LinkedProject> linkedProjects,  List<Genre> projectGenres)?  $default,) {final _that = this;
switch (_that) {
case _CharacterDetail() when $default != null:
return $default(_that.id,_that.name,_that.nameEn,_that.tagline,_that.quote,_that.themeColor,_that.portraitAssetId,_that.bodyMd,_that.visibility,_that.isFavorite,_that.projectId,_that.projectName,_that.projectKind,_that.worldName,_that.sourceCharacterName,_that.updatedAt,_that.fields,_that.traits,_that.quotes,_that.tags,_that.gallery,_that.linkedProjects,_that.projectGenres);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CharacterDetail extends CharacterDetail {
  const _CharacterDetail({required this.id, required this.name, this.nameEn, this.tagline, this.quote, this.themeColor, this.portraitAssetId, this.bodyMd, this.visibility = 'private', @IntBool() this.isFavorite = false, this.projectId, this.projectName, this.projectKind, this.worldName, this.sourceCharacterName, this.updatedAt,  List<CharacterField> fields = const [],  List<Trait> traits = const [],  List<Quote> quotes = const [],  List<String> tags = const [],  List<GalleryImage> gallery = const [],  List<LinkedProject> linkedProjects = const [],  List<Genre> projectGenres = const []}): _fields = fields,_traits = traits,_quotes = quotes,_tags = tags,_gallery = gallery,_linkedProjects = linkedProjects,_projectGenres = projectGenres,super._();
  factory _CharacterDetail.fromJson(Map<String, dynamic> json) => _$CharacterDetailFromJson(json);

@override final  int id;
@override final  String name;
@override final  String? nameEn;
@override final  String? tagline;
@override final  String? quote;
@override final  String? themeColor;
@override final  int? portraitAssetId;
@override final  String? bodyMd;
@override@JsonKey() final  String visibility;
@override@JsonKey()@IntBool() final  bool isFavorite;
@override final  int? projectId;
@override final  String? projectName;
@override final  String? projectKind;
@override final  String? worldName;
@override final  String? sourceCharacterName;
@override final  String? updatedAt;
 final  List<CharacterField> _fields;
@override@JsonKey() List<CharacterField> get fields {
  if (_fields is EqualUnmodifiableListView) return _fields;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_fields);
}

 final  List<Trait> _traits;
@override@JsonKey() List<Trait> get traits {
  if (_traits is EqualUnmodifiableListView) return _traits;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_traits);
}

 final  List<Quote> _quotes;
@override@JsonKey() List<Quote> get quotes {
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

 final  List<GalleryImage> _gallery;
@override@JsonKey() List<GalleryImage> get gallery {
  if (_gallery is EqualUnmodifiableListView) return _gallery;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_gallery);
}

 final  List<LinkedProject> _linkedProjects;
@override@JsonKey() List<LinkedProject> get linkedProjects {
  if (_linkedProjects is EqualUnmodifiableListView) return _linkedProjects;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_linkedProjects);
}

 final  List<Genre> _projectGenres;
@override@JsonKey() List<Genre> get projectGenres {
  if (_projectGenres is EqualUnmodifiableListView) return _projectGenres;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_projectGenres);
}


/// Create a copy of CharacterDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CharacterDetailCopyWith<_CharacterDetail> get copyWith => __$CharacterDetailCopyWithImpl<_CharacterDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CharacterDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CharacterDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.tagline, tagline) || other.tagline == tagline)&&(identical(other.quote, quote) || other.quote == quote)&&(identical(other.themeColor, themeColor) || other.themeColor == themeColor)&&(identical(other.portraitAssetId, portraitAssetId) || other.portraitAssetId == portraitAssetId)&&(identical(other.bodyMd, bodyMd) || other.bodyMd == bodyMd)&&(identical(other.visibility, visibility) || other.visibility == visibility)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.projectName, projectName) || other.projectName == projectName)&&(identical(other.projectKind, projectKind) || other.projectKind == projectKind)&&(identical(other.worldName, worldName) || other.worldName == worldName)&&(identical(other.sourceCharacterName, sourceCharacterName) || other.sourceCharacterName == sourceCharacterName)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other._fields, _fields)&&const DeepCollectionEquality().equals(other._traits, _traits)&&const DeepCollectionEquality().equals(other._quotes, _quotes)&&const DeepCollectionEquality().equals(other._tags, _tags)&&const DeepCollectionEquality().equals(other._gallery, _gallery)&&const DeepCollectionEquality().equals(other._linkedProjects, _linkedProjects)&&const DeepCollectionEquality().equals(other._projectGenres, _projectGenres));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,name,nameEn,tagline,quote,themeColor,portraitAssetId,bodyMd,visibility,isFavorite,projectId,projectName,projectKind,worldName,sourceCharacterName,updatedAt,const DeepCollectionEquality().hash(_fields),const DeepCollectionEquality().hash(_traits),const DeepCollectionEquality().hash(_quotes),const DeepCollectionEquality().hash(_tags),const DeepCollectionEquality().hash(_gallery),const DeepCollectionEquality().hash(_linkedProjects),const DeepCollectionEquality().hash(_projectGenres)]);

@override
String toString() {
  return 'CharacterDetail(id: $id, name: $name, nameEn: $nameEn, tagline: $tagline, quote: $quote, themeColor: $themeColor, portraitAssetId: $portraitAssetId, bodyMd: $bodyMd, visibility: $visibility, isFavorite: $isFavorite, projectId: $projectId, projectName: $projectName, projectKind: $projectKind, worldName: $worldName, sourceCharacterName: $sourceCharacterName, updatedAt: $updatedAt, fields: $fields, traits: $traits, quotes: $quotes, tags: $tags, gallery: $gallery, linkedProjects: $linkedProjects, projectGenres: $projectGenres)';
}


}

/// @nodoc
abstract mixin class _$CharacterDetailCopyWith<$Res> implements $CharacterDetailCopyWith<$Res> {
  factory _$CharacterDetailCopyWith(_CharacterDetail value, $Res Function(_CharacterDetail) _then) = __$CharacterDetailCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String? nameEn, String? tagline, String? quote, String? themeColor, int? portraitAssetId, String? bodyMd, String visibility,@IntBool() bool isFavorite, int? projectId, String? projectName, String? projectKind, String? worldName, String? sourceCharacterName, String? updatedAt, List<CharacterField> fields, List<Trait> traits, List<Quote> quotes, List<String> tags, List<GalleryImage> gallery, List<LinkedProject> linkedProjects, List<Genre> projectGenres
});




}
/// @nodoc
class __$CharacterDetailCopyWithImpl<$Res>
    implements _$CharacterDetailCopyWith<$Res> {
  __$CharacterDetailCopyWithImpl(this._self, this._then);

  final _CharacterDetail _self;
  final $Res Function(_CharacterDetail) _then;

/// Create a copy of CharacterDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? nameEn = freezed,Object? tagline = freezed,Object? quote = freezed,Object? themeColor = freezed,Object? portraitAssetId = freezed,Object? bodyMd = freezed,Object? visibility = null,Object? isFavorite = null,Object? projectId = freezed,Object? projectName = freezed,Object? projectKind = freezed,Object? worldName = freezed,Object? sourceCharacterName = freezed,Object? updatedAt = freezed,Object? fields = null,Object? traits = null,Object? quotes = null,Object? tags = null,Object? gallery = null,Object? linkedProjects = null,Object? projectGenres = null,}) {
  return _then(_CharacterDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nameEn: freezed == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String?,tagline: freezed == tagline ? _self.tagline : tagline // ignore: cast_nullable_to_non_nullable
as String?,quote: freezed == quote ? _self.quote : quote // ignore: cast_nullable_to_non_nullable
as String?,themeColor: freezed == themeColor ? _self.themeColor : themeColor // ignore: cast_nullable_to_non_nullable
as String?,portraitAssetId: freezed == portraitAssetId ? _self.portraitAssetId : portraitAssetId // ignore: cast_nullable_to_non_nullable
as int?,bodyMd: freezed == bodyMd ? _self.bodyMd : bodyMd // ignore: cast_nullable_to_non_nullable
as String?,visibility: null == visibility ? _self.visibility : visibility // ignore: cast_nullable_to_non_nullable
as String,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as int?,projectName: freezed == projectName ? _self.projectName : projectName // ignore: cast_nullable_to_non_nullable
as String?,projectKind: freezed == projectKind ? _self.projectKind : projectKind // ignore: cast_nullable_to_non_nullable
as String?,worldName: freezed == worldName ? _self.worldName : worldName // ignore: cast_nullable_to_non_nullable
as String?,sourceCharacterName: freezed == sourceCharacterName ? _self.sourceCharacterName : sourceCharacterName // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,fields: null == fields ? _self._fields : fields // ignore: cast_nullable_to_non_nullable
as List<CharacterField>,traits: null == traits ? _self._traits : traits // ignore: cast_nullable_to_non_nullable
as List<Trait>,quotes: null == quotes ? _self._quotes : quotes // ignore: cast_nullable_to_non_nullable
as List<Quote>,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,gallery: null == gallery ? _self._gallery : gallery // ignore: cast_nullable_to_non_nullable
as List<GalleryImage>,linkedProjects: null == linkedProjects ? _self._linkedProjects : linkedProjects // ignore: cast_nullable_to_non_nullable
as List<LinkedProject>,projectGenres: null == projectGenres ? _self._projectGenres : projectGenres // ignore: cast_nullable_to_non_nullable
as List<Genre>,
  ));
}


}


/// @nodoc
mixin _$CharacterField {

 int get id; String get label; String get value;@IntBool() bool get isSecret;
/// Create a copy of CharacterField
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CharacterFieldCopyWith<CharacterField> get copyWith => _$CharacterFieldCopyWithImpl<CharacterField>(this as CharacterField, _$identity);

  /// Serializes this CharacterField to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CharacterField&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.value, value) || other.value == value)&&(identical(other.isSecret, isSecret) || other.isSecret == isSecret));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,label,value,isSecret);

@override
String toString() {
  return 'CharacterField(id: $id, label: $label, value: $value, isSecret: $isSecret)';
}


}

/// @nodoc
abstract mixin class $CharacterFieldCopyWith<$Res>  {
  factory $CharacterFieldCopyWith(CharacterField value, $Res Function(CharacterField) _then) = _$CharacterFieldCopyWithImpl;
@useResult
$Res call({
 int id, String label, String value,@IntBool() bool isSecret
});




}
/// @nodoc
class _$CharacterFieldCopyWithImpl<$Res>
    implements $CharacterFieldCopyWith<$Res> {
  _$CharacterFieldCopyWithImpl(this._self, this._then);

  final CharacterField _self;
  final $Res Function(CharacterField) _then;

/// Create a copy of CharacterField
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? label = null,Object? value = null,Object? isSecret = null,}) {
  return _then(CharacterField(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,isSecret: null == isSecret ? _self.isSecret : isSecret // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CharacterField].
extension CharacterFieldPatterns on CharacterField {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CharacterField value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CharacterField() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CharacterField value)  $default,){
final _that = this;
switch (_that) {
case _CharacterField():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CharacterField value)?  $default,){
final _that = this;
switch (_that) {
case _CharacterField() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String label,  String value, @IntBool()  bool isSecret)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CharacterField() when $default != null:
return $default(_that.id,_that.label,_that.value,_that.isSecret);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String label,  String value, @IntBool()  bool isSecret)  $default,) {final _that = this;
switch (_that) {
case _CharacterField():
return $default(_that.id,_that.label,_that.value,_that.isSecret);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String label,  String value, @IntBool()  bool isSecret)?  $default,) {final _that = this;
switch (_that) {
case _CharacterField() when $default != null:
return $default(_that.id,_that.label,_that.value,_that.isSecret);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CharacterField implements CharacterField {
  const _CharacterField({required this.id, required this.label, this.value = '', @IntBool() this.isSecret = false});
  factory _CharacterField.fromJson(Map<String, dynamic> json) => _$CharacterFieldFromJson(json);

@override final  int id;
@override final  String label;
@override@JsonKey() final  String value;
@override@JsonKey()@IntBool() final  bool isSecret;

/// Create a copy of CharacterField
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CharacterFieldCopyWith<_CharacterField> get copyWith => __$CharacterFieldCopyWithImpl<_CharacterField>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CharacterFieldToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CharacterField&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.value, value) || other.value == value)&&(identical(other.isSecret, isSecret) || other.isSecret == isSecret));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,label,value,isSecret);

@override
String toString() {
  return 'CharacterField(id: $id, label: $label, value: $value, isSecret: $isSecret)';
}


}

/// @nodoc
abstract mixin class _$CharacterFieldCopyWith<$Res> implements $CharacterFieldCopyWith<$Res> {
  factory _$CharacterFieldCopyWith(_CharacterField value, $Res Function(_CharacterField) _then) = __$CharacterFieldCopyWithImpl;
@override @useResult
$Res call({
 int id, String label, String value,@IntBool() bool isSecret
});




}
/// @nodoc
class __$CharacterFieldCopyWithImpl<$Res>
    implements _$CharacterFieldCopyWith<$Res> {
  __$CharacterFieldCopyWithImpl(this._self, this._then);

  final _CharacterField _self;
  final $Res Function(_CharacterField) _then;

/// Create a copy of CharacterField
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? label = null,Object? value = null,Object? isSecret = null,}) {
  return _then(_CharacterField(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,isSecret: null == isSecret ? _self.isSecret : isSecret // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$Trait {

 int get id; String get leftLabel; String get rightLabel; int get valuePercent;
/// Create a copy of Trait
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TraitCopyWith<Trait> get copyWith => _$TraitCopyWithImpl<Trait>(this as Trait, _$identity);

  /// Serializes this Trait to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Trait&&(identical(other.id, id) || other.id == id)&&(identical(other.leftLabel, leftLabel) || other.leftLabel == leftLabel)&&(identical(other.rightLabel, rightLabel) || other.rightLabel == rightLabel)&&(identical(other.valuePercent, valuePercent) || other.valuePercent == valuePercent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,leftLabel,rightLabel,valuePercent);

@override
String toString() {
  return 'Trait(id: $id, leftLabel: $leftLabel, rightLabel: $rightLabel, valuePercent: $valuePercent)';
}


}

/// @nodoc
abstract mixin class $TraitCopyWith<$Res>  {
  factory $TraitCopyWith(Trait value, $Res Function(Trait) _then) = _$TraitCopyWithImpl;
@useResult
$Res call({
 int id, String leftLabel, String rightLabel, int valuePercent
});




}
/// @nodoc
class _$TraitCopyWithImpl<$Res>
    implements $TraitCopyWith<$Res> {
  _$TraitCopyWithImpl(this._self, this._then);

  final Trait _self;
  final $Res Function(Trait) _then;

/// Create a copy of Trait
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? leftLabel = null,Object? rightLabel = null,Object? valuePercent = null,}) {
  return _then(Trait(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,leftLabel: null == leftLabel ? _self.leftLabel : leftLabel // ignore: cast_nullable_to_non_nullable
as String,rightLabel: null == rightLabel ? _self.rightLabel : rightLabel // ignore: cast_nullable_to_non_nullable
as String,valuePercent: null == valuePercent ? _self.valuePercent : valuePercent // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Trait].
extension TraitPatterns on Trait {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Trait value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Trait() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Trait value)  $default,){
final _that = this;
switch (_that) {
case _Trait():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Trait value)?  $default,){
final _that = this;
switch (_that) {
case _Trait() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String leftLabel,  String rightLabel,  int valuePercent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Trait() when $default != null:
return $default(_that.id,_that.leftLabel,_that.rightLabel,_that.valuePercent);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String leftLabel,  String rightLabel,  int valuePercent)  $default,) {final _that = this;
switch (_that) {
case _Trait():
return $default(_that.id,_that.leftLabel,_that.rightLabel,_that.valuePercent);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String leftLabel,  String rightLabel,  int valuePercent)?  $default,) {final _that = this;
switch (_that) {
case _Trait() when $default != null:
return $default(_that.id,_that.leftLabel,_that.rightLabel,_that.valuePercent);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Trait implements Trait {
  const _Trait({required this.id, required this.leftLabel, required this.rightLabel, this.valuePercent = 50});
  factory _Trait.fromJson(Map<String, dynamic> json) => _$TraitFromJson(json);

@override final  int id;
@override final  String leftLabel;
@override final  String rightLabel;
@override@JsonKey() final  int valuePercent;

/// Create a copy of Trait
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TraitCopyWith<_Trait> get copyWith => __$TraitCopyWithImpl<_Trait>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TraitToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Trait&&(identical(other.id, id) || other.id == id)&&(identical(other.leftLabel, leftLabel) || other.leftLabel == leftLabel)&&(identical(other.rightLabel, rightLabel) || other.rightLabel == rightLabel)&&(identical(other.valuePercent, valuePercent) || other.valuePercent == valuePercent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,leftLabel,rightLabel,valuePercent);

@override
String toString() {
  return 'Trait(id: $id, leftLabel: $leftLabel, rightLabel: $rightLabel, valuePercent: $valuePercent)';
}


}

/// @nodoc
abstract mixin class _$TraitCopyWith<$Res> implements $TraitCopyWith<$Res> {
  factory _$TraitCopyWith(_Trait value, $Res Function(_Trait) _then) = __$TraitCopyWithImpl;
@override @useResult
$Res call({
 int id, String leftLabel, String rightLabel, int valuePercent
});




}
/// @nodoc
class __$TraitCopyWithImpl<$Res>
    implements _$TraitCopyWith<$Res> {
  __$TraitCopyWithImpl(this._self, this._then);

  final _Trait _self;
  final $Res Function(_Trait) _then;

/// Create a copy of Trait
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? leftLabel = null,Object? rightLabel = null,Object? valuePercent = null,}) {
  return _then(_Trait(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,leftLabel: null == leftLabel ? _self.leftLabel : leftLabel // ignore: cast_nullable_to_non_nullable
as String,rightLabel: null == rightLabel ? _self.rightLabel : rightLabel // ignore: cast_nullable_to_non_nullable
as String,valuePercent: null == valuePercent ? _self.valuePercent : valuePercent // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$Quote {

 int get id; String get body; String? get situation;@IntBool() bool get isSecret;
/// Create a copy of Quote
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuoteCopyWith<Quote> get copyWith => _$QuoteCopyWithImpl<Quote>(this as Quote, _$identity);

  /// Serializes this Quote to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Quote&&(identical(other.id, id) || other.id == id)&&(identical(other.body, body) || other.body == body)&&(identical(other.situation, situation) || other.situation == situation)&&(identical(other.isSecret, isSecret) || other.isSecret == isSecret));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,body,situation,isSecret);

@override
String toString() {
  return 'Quote(id: $id, body: $body, situation: $situation, isSecret: $isSecret)';
}


}

/// @nodoc
abstract mixin class $QuoteCopyWith<$Res>  {
  factory $QuoteCopyWith(Quote value, $Res Function(Quote) _then) = _$QuoteCopyWithImpl;
@useResult
$Res call({
 int id, String body, String? situation,@IntBool() bool isSecret
});




}
/// @nodoc
class _$QuoteCopyWithImpl<$Res>
    implements $QuoteCopyWith<$Res> {
  _$QuoteCopyWithImpl(this._self, this._then);

  final Quote _self;
  final $Res Function(Quote) _then;

/// Create a copy of Quote
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? body = null,Object? situation = freezed,Object? isSecret = null,}) {
  return _then(Quote(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,situation: freezed == situation ? _self.situation : situation // ignore: cast_nullable_to_non_nullable
as String?,isSecret: null == isSecret ? _self.isSecret : isSecret // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Quote].
extension QuotePatterns on Quote {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Quote value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Quote() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Quote value)  $default,){
final _that = this;
switch (_that) {
case _Quote():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Quote value)?  $default,){
final _that = this;
switch (_that) {
case _Quote() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String body,  String? situation, @IntBool()  bool isSecret)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Quote() when $default != null:
return $default(_that.id,_that.body,_that.situation,_that.isSecret);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String body,  String? situation, @IntBool()  bool isSecret)  $default,) {final _that = this;
switch (_that) {
case _Quote():
return $default(_that.id,_that.body,_that.situation,_that.isSecret);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String body,  String? situation, @IntBool()  bool isSecret)?  $default,) {final _that = this;
switch (_that) {
case _Quote() when $default != null:
return $default(_that.id,_that.body,_that.situation,_that.isSecret);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Quote implements Quote {
  const _Quote({required this.id, required this.body, this.situation, @IntBool() this.isSecret = false});
  factory _Quote.fromJson(Map<String, dynamic> json) => _$QuoteFromJson(json);

@override final  int id;
@override final  String body;
@override final  String? situation;
@override@JsonKey()@IntBool() final  bool isSecret;

/// Create a copy of Quote
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuoteCopyWith<_Quote> get copyWith => __$QuoteCopyWithImpl<_Quote>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuoteToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Quote&&(identical(other.id, id) || other.id == id)&&(identical(other.body, body) || other.body == body)&&(identical(other.situation, situation) || other.situation == situation)&&(identical(other.isSecret, isSecret) || other.isSecret == isSecret));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,body,situation,isSecret);

@override
String toString() {
  return 'Quote(id: $id, body: $body, situation: $situation, isSecret: $isSecret)';
}


}

/// @nodoc
abstract mixin class _$QuoteCopyWith<$Res> implements $QuoteCopyWith<$Res> {
  factory _$QuoteCopyWith(_Quote value, $Res Function(_Quote) _then) = __$QuoteCopyWithImpl;
@override @useResult
$Res call({
 int id, String body, String? situation,@IntBool() bool isSecret
});




}
/// @nodoc
class __$QuoteCopyWithImpl<$Res>
    implements _$QuoteCopyWith<$Res> {
  __$QuoteCopyWithImpl(this._self, this._then);

  final _Quote _self;
  final $Res Function(_Quote) _then;

/// Create a copy of Quote
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? body = null,Object? situation = freezed,Object? isSecret = null,}) {
  return _then(_Quote(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,situation: freezed == situation ? _self.situation : situation // ignore: cast_nullable_to_non_nullable
as String?,isSecret: null == isSecret ? _self.isSecret : isSecret // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$GalleryImage {

 int get id; int? get width; int? get height; String? get caption; String? get originalName;
/// Create a copy of GalleryImage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GalleryImageCopyWith<GalleryImage> get copyWith => _$GalleryImageCopyWithImpl<GalleryImage>(this as GalleryImage, _$identity);

  /// Serializes this GalleryImage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GalleryImage&&(identical(other.id, id) || other.id == id)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.caption, caption) || other.caption == caption)&&(identical(other.originalName, originalName) || other.originalName == originalName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,width,height,caption,originalName);

@override
String toString() {
  return 'GalleryImage(id: $id, width: $width, height: $height, caption: $caption, originalName: $originalName)';
}


}

/// @nodoc
abstract mixin class $GalleryImageCopyWith<$Res>  {
  factory $GalleryImageCopyWith(GalleryImage value, $Res Function(GalleryImage) _then) = _$GalleryImageCopyWithImpl;
@useResult
$Res call({
 int id, int? width, int? height, String? caption, String? originalName
});




}
/// @nodoc
class _$GalleryImageCopyWithImpl<$Res>
    implements $GalleryImageCopyWith<$Res> {
  _$GalleryImageCopyWithImpl(this._self, this._then);

  final GalleryImage _self;
  final $Res Function(GalleryImage) _then;

/// Create a copy of GalleryImage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? width = freezed,Object? height = freezed,Object? caption = freezed,Object? originalName = freezed,}) {
  return _then(GalleryImage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,width: freezed == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int?,height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int?,caption: freezed == caption ? _self.caption : caption // ignore: cast_nullable_to_non_nullable
as String?,originalName: freezed == originalName ? _self.originalName : originalName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [GalleryImage].
extension GalleryImagePatterns on GalleryImage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GalleryImage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GalleryImage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GalleryImage value)  $default,){
final _that = this;
switch (_that) {
case _GalleryImage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GalleryImage value)?  $default,){
final _that = this;
switch (_that) {
case _GalleryImage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int? width,  int? height,  String? caption,  String? originalName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GalleryImage() when $default != null:
return $default(_that.id,_that.width,_that.height,_that.caption,_that.originalName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int? width,  int? height,  String? caption,  String? originalName)  $default,) {final _that = this;
switch (_that) {
case _GalleryImage():
return $default(_that.id,_that.width,_that.height,_that.caption,_that.originalName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int? width,  int? height,  String? caption,  String? originalName)?  $default,) {final _that = this;
switch (_that) {
case _GalleryImage() when $default != null:
return $default(_that.id,_that.width,_that.height,_that.caption,_that.originalName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GalleryImage implements GalleryImage {
  const _GalleryImage({required this.id, this.width, this.height, this.caption, this.originalName});
  factory _GalleryImage.fromJson(Map<String, dynamic> json) => _$GalleryImageFromJson(json);

@override final  int id;
@override final  int? width;
@override final  int? height;
@override final  String? caption;
@override final  String? originalName;

/// Create a copy of GalleryImage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GalleryImageCopyWith<_GalleryImage> get copyWith => __$GalleryImageCopyWithImpl<_GalleryImage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GalleryImageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GalleryImage&&(identical(other.id, id) || other.id == id)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.caption, caption) || other.caption == caption)&&(identical(other.originalName, originalName) || other.originalName == originalName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,width,height,caption,originalName);

@override
String toString() {
  return 'GalleryImage(id: $id, width: $width, height: $height, caption: $caption, originalName: $originalName)';
}


}

/// @nodoc
abstract mixin class _$GalleryImageCopyWith<$Res> implements $GalleryImageCopyWith<$Res> {
  factory _$GalleryImageCopyWith(_GalleryImage value, $Res Function(_GalleryImage) _then) = __$GalleryImageCopyWithImpl;
@override @useResult
$Res call({
 int id, int? width, int? height, String? caption, String? originalName
});




}
/// @nodoc
class __$GalleryImageCopyWithImpl<$Res>
    implements _$GalleryImageCopyWith<$Res> {
  __$GalleryImageCopyWithImpl(this._self, this._then);

  final _GalleryImage _self;
  final $Res Function(_GalleryImage) _then;

/// Create a copy of GalleryImage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? width = freezed,Object? height = freezed,Object? caption = freezed,Object? originalName = freezed,}) {
  return _then(_GalleryImage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,width: freezed == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int?,height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int?,caption: freezed == caption ? _self.caption : caption // ignore: cast_nullable_to_non_nullable
as String?,originalName: freezed == originalName ? _self.originalName : originalName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$LinkedProject {

 int get id; String get name; String get kind; String? get role;
/// Create a copy of LinkedProject
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LinkedProjectCopyWith<LinkedProject> get copyWith => _$LinkedProjectCopyWithImpl<LinkedProject>(this as LinkedProject, _$identity);

  /// Serializes this LinkedProject to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LinkedProject&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,kind,role);

@override
String toString() {
  return 'LinkedProject(id: $id, name: $name, kind: $kind, role: $role)';
}


}

/// @nodoc
abstract mixin class $LinkedProjectCopyWith<$Res>  {
  factory $LinkedProjectCopyWith(LinkedProject value, $Res Function(LinkedProject) _then) = _$LinkedProjectCopyWithImpl;
@useResult
$Res call({
 int id, String name, String kind, String? role
});




}
/// @nodoc
class _$LinkedProjectCopyWithImpl<$Res>
    implements $LinkedProjectCopyWith<$Res> {
  _$LinkedProjectCopyWithImpl(this._self, this._then);

  final LinkedProject _self;
  final $Res Function(LinkedProject) _then;

/// Create a copy of LinkedProject
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? kind = null,Object? role = freezed,}) {
  return _then(LinkedProject(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [LinkedProject].
extension LinkedProjectPatterns on LinkedProject {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LinkedProject value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LinkedProject() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LinkedProject value)  $default,){
final _that = this;
switch (_that) {
case _LinkedProject():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LinkedProject value)?  $default,){
final _that = this;
switch (_that) {
case _LinkedProject() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String kind,  String? role)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LinkedProject() when $default != null:
return $default(_that.id,_that.name,_that.kind,_that.role);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String kind,  String? role)  $default,) {final _that = this;
switch (_that) {
case _LinkedProject():
return $default(_that.id,_that.name,_that.kind,_that.role);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String kind,  String? role)?  $default,) {final _that = this;
switch (_that) {
case _LinkedProject() when $default != null:
return $default(_that.id,_that.name,_that.kind,_that.role);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LinkedProject implements LinkedProject {
  const _LinkedProject({required this.id, required this.name, this.kind = 'etc', this.role});
  factory _LinkedProject.fromJson(Map<String, dynamic> json) => _$LinkedProjectFromJson(json);

@override final  int id;
@override final  String name;
@override@JsonKey() final  String kind;
@override final  String? role;

/// Create a copy of LinkedProject
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LinkedProjectCopyWith<_LinkedProject> get copyWith => __$LinkedProjectCopyWithImpl<_LinkedProject>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LinkedProjectToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LinkedProject&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,kind,role);

@override
String toString() {
  return 'LinkedProject(id: $id, name: $name, kind: $kind, role: $role)';
}


}

/// @nodoc
abstract mixin class _$LinkedProjectCopyWith<$Res> implements $LinkedProjectCopyWith<$Res> {
  factory _$LinkedProjectCopyWith(_LinkedProject value, $Res Function(_LinkedProject) _then) = __$LinkedProjectCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String kind, String? role
});




}
/// @nodoc
class __$LinkedProjectCopyWithImpl<$Res>
    implements _$LinkedProjectCopyWith<$Res> {
  __$LinkedProjectCopyWithImpl(this._self, this._then);

  final _LinkedProject _self;
  final $Res Function(_LinkedProject) _then;

/// Create a copy of LinkedProject
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? kind = null,Object? role = freezed,}) {
  return _then(_LinkedProject(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
