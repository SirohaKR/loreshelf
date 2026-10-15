// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProjectSummary {

 int get id; String get name; String get kind; String? get summary; int? get worldId; String? get worldName; int? get coverAssetId; int get progressPercent; String get visibility; String? get updatedAt; int get ownCharacterCount; int get linkedCharacterCount; List<Genre> get genres;
/// Create a copy of ProjectSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectSummaryCopyWith<ProjectSummary> get copyWith => _$ProjectSummaryCopyWithImpl<ProjectSummary>(this as ProjectSummary, _$identity);

  /// Serializes this ProjectSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.worldId, worldId) || other.worldId == worldId)&&(identical(other.worldName, worldName) || other.worldName == worldName)&&(identical(other.coverAssetId, coverAssetId) || other.coverAssetId == coverAssetId)&&(identical(other.progressPercent, progressPercent) || other.progressPercent == progressPercent)&&(identical(other.visibility, visibility) || other.visibility == visibility)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.ownCharacterCount, ownCharacterCount) || other.ownCharacterCount == ownCharacterCount)&&(identical(other.linkedCharacterCount, linkedCharacterCount) || other.linkedCharacterCount == linkedCharacterCount)&&const DeepCollectionEquality().equals(other.genres, genres));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,kind,summary,worldId,worldName,coverAssetId,progressPercent,visibility,updatedAt,ownCharacterCount,linkedCharacterCount,const DeepCollectionEquality().hash(genres));

@override
String toString() {
  return 'ProjectSummary(id: $id, name: $name, kind: $kind, summary: $summary, worldId: $worldId, worldName: $worldName, coverAssetId: $coverAssetId, progressPercent: $progressPercent, visibility: $visibility, updatedAt: $updatedAt, ownCharacterCount: $ownCharacterCount, linkedCharacterCount: $linkedCharacterCount, genres: $genres)';
}


}

/// @nodoc
abstract mixin class $ProjectSummaryCopyWith<$Res>  {
  factory $ProjectSummaryCopyWith(ProjectSummary value, $Res Function(ProjectSummary) _then) = _$ProjectSummaryCopyWithImpl;
@useResult
$Res call({
 int id, String name, String kind, String? summary, int? worldId, String? worldName, int? coverAssetId, int progressPercent, String visibility, String? updatedAt, int ownCharacterCount, int linkedCharacterCount, List<Genre> genres
});




}
/// @nodoc
class _$ProjectSummaryCopyWithImpl<$Res>
    implements $ProjectSummaryCopyWith<$Res> {
  _$ProjectSummaryCopyWithImpl(this._self, this._then);

  final ProjectSummary _self;
  final $Res Function(ProjectSummary) _then;

/// Create a copy of ProjectSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? kind = null,Object? summary = freezed,Object? worldId = freezed,Object? worldName = freezed,Object? coverAssetId = freezed,Object? progressPercent = null,Object? visibility = null,Object? updatedAt = freezed,Object? ownCharacterCount = null,Object? linkedCharacterCount = null,Object? genres = null,}) {
  return _then(ProjectSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String?,worldId: freezed == worldId ? _self.worldId : worldId // ignore: cast_nullable_to_non_nullable
as int?,worldName: freezed == worldName ? _self.worldName : worldName // ignore: cast_nullable_to_non_nullable
as String?,coverAssetId: freezed == coverAssetId ? _self.coverAssetId : coverAssetId // ignore: cast_nullable_to_non_nullable
as int?,progressPercent: null == progressPercent ? _self.progressPercent : progressPercent // ignore: cast_nullable_to_non_nullable
as int,visibility: null == visibility ? _self.visibility : visibility // ignore: cast_nullable_to_non_nullable
as String,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,ownCharacterCount: null == ownCharacterCount ? _self.ownCharacterCount : ownCharacterCount // ignore: cast_nullable_to_non_nullable
as int,linkedCharacterCount: null == linkedCharacterCount ? _self.linkedCharacterCount : linkedCharacterCount // ignore: cast_nullable_to_non_nullable
as int,genres: null == genres ? _self.genres : genres // ignore: cast_nullable_to_non_nullable
as List<Genre>,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectSummary].
extension ProjectSummaryPatterns on ProjectSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectSummary value)  $default,){
final _that = this;
switch (_that) {
case _ProjectSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectSummary value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String kind,  String? summary,  int? worldId,  String? worldName,  int? coverAssetId,  int progressPercent,  String visibility,  String? updatedAt,  int ownCharacterCount,  int linkedCharacterCount,  List<Genre> genres)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectSummary() when $default != null:
return $default(_that.id,_that.name,_that.kind,_that.summary,_that.worldId,_that.worldName,_that.coverAssetId,_that.progressPercent,_that.visibility,_that.updatedAt,_that.ownCharacterCount,_that.linkedCharacterCount,_that.genres);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String kind,  String? summary,  int? worldId,  String? worldName,  int? coverAssetId,  int progressPercent,  String visibility,  String? updatedAt,  int ownCharacterCount,  int linkedCharacterCount,  List<Genre> genres)  $default,) {final _that = this;
switch (_that) {
case _ProjectSummary():
return $default(_that.id,_that.name,_that.kind,_that.summary,_that.worldId,_that.worldName,_that.coverAssetId,_that.progressPercent,_that.visibility,_that.updatedAt,_that.ownCharacterCount,_that.linkedCharacterCount,_that.genres);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String kind,  String? summary,  int? worldId,  String? worldName,  int? coverAssetId,  int progressPercent,  String visibility,  String? updatedAt,  int ownCharacterCount,  int linkedCharacterCount,  List<Genre> genres)?  $default,) {final _that = this;
switch (_that) {
case _ProjectSummary() when $default != null:
return $default(_that.id,_that.name,_that.kind,_that.summary,_that.worldId,_that.worldName,_that.coverAssetId,_that.progressPercent,_that.visibility,_that.updatedAt,_that.ownCharacterCount,_that.linkedCharacterCount,_that.genres);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectSummary extends ProjectSummary {
  const _ProjectSummary({required this.id, required this.name, this.kind = 'etc', this.summary, this.worldId, this.worldName, this.coverAssetId, this.progressPercent = 0, this.visibility = 'private', this.updatedAt, this.ownCharacterCount = 0, this.linkedCharacterCount = 0,  List<Genre> genres = const []}): _genres = genres,super._();
  factory _ProjectSummary.fromJson(Map<String, dynamic> json) => _$ProjectSummaryFromJson(json);

@override final  int id;
@override final  String name;
@override@JsonKey() final  String kind;
@override final  String? summary;
@override final  int? worldId;
@override final  String? worldName;
@override final  int? coverAssetId;
@override@JsonKey() final  int progressPercent;
@override@JsonKey() final  String visibility;
@override final  String? updatedAt;
@override@JsonKey() final  int ownCharacterCount;
@override@JsonKey() final  int linkedCharacterCount;
 final  List<Genre> _genres;
@override@JsonKey() List<Genre> get genres {
  if (_genres is EqualUnmodifiableListView) return _genres;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_genres);
}


/// Create a copy of ProjectSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectSummaryCopyWith<_ProjectSummary> get copyWith => __$ProjectSummaryCopyWithImpl<_ProjectSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.worldId, worldId) || other.worldId == worldId)&&(identical(other.worldName, worldName) || other.worldName == worldName)&&(identical(other.coverAssetId, coverAssetId) || other.coverAssetId == coverAssetId)&&(identical(other.progressPercent, progressPercent) || other.progressPercent == progressPercent)&&(identical(other.visibility, visibility) || other.visibility == visibility)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.ownCharacterCount, ownCharacterCount) || other.ownCharacterCount == ownCharacterCount)&&(identical(other.linkedCharacterCount, linkedCharacterCount) || other.linkedCharacterCount == linkedCharacterCount)&&const DeepCollectionEquality().equals(other._genres, _genres));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,kind,summary,worldId,worldName,coverAssetId,progressPercent,visibility,updatedAt,ownCharacterCount,linkedCharacterCount,const DeepCollectionEquality().hash(_genres));

@override
String toString() {
  return 'ProjectSummary(id: $id, name: $name, kind: $kind, summary: $summary, worldId: $worldId, worldName: $worldName, coverAssetId: $coverAssetId, progressPercent: $progressPercent, visibility: $visibility, updatedAt: $updatedAt, ownCharacterCount: $ownCharacterCount, linkedCharacterCount: $linkedCharacterCount, genres: $genres)';
}


}

/// @nodoc
abstract mixin class _$ProjectSummaryCopyWith<$Res> implements $ProjectSummaryCopyWith<$Res> {
  factory _$ProjectSummaryCopyWith(_ProjectSummary value, $Res Function(_ProjectSummary) _then) = __$ProjectSummaryCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String kind, String? summary, int? worldId, String? worldName, int? coverAssetId, int progressPercent, String visibility, String? updatedAt, int ownCharacterCount, int linkedCharacterCount, List<Genre> genres
});




}
/// @nodoc
class __$ProjectSummaryCopyWithImpl<$Res>
    implements _$ProjectSummaryCopyWith<$Res> {
  __$ProjectSummaryCopyWithImpl(this._self, this._then);

  final _ProjectSummary _self;
  final $Res Function(_ProjectSummary) _then;

/// Create a copy of ProjectSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? kind = null,Object? summary = freezed,Object? worldId = freezed,Object? worldName = freezed,Object? coverAssetId = freezed,Object? progressPercent = null,Object? visibility = null,Object? updatedAt = freezed,Object? ownCharacterCount = null,Object? linkedCharacterCount = null,Object? genres = null,}) {
  return _then(_ProjectSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String?,worldId: freezed == worldId ? _self.worldId : worldId // ignore: cast_nullable_to_non_nullable
as int?,worldName: freezed == worldName ? _self.worldName : worldName // ignore: cast_nullable_to_non_nullable
as String?,coverAssetId: freezed == coverAssetId ? _self.coverAssetId : coverAssetId // ignore: cast_nullable_to_non_nullable
as int?,progressPercent: null == progressPercent ? _self.progressPercent : progressPercent // ignore: cast_nullable_to_non_nullable
as int,visibility: null == visibility ? _self.visibility : visibility // ignore: cast_nullable_to_non_nullable
as String,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,ownCharacterCount: null == ownCharacterCount ? _self.ownCharacterCount : ownCharacterCount // ignore: cast_nullable_to_non_nullable
as int,linkedCharacterCount: null == linkedCharacterCount ? _self.linkedCharacterCount : linkedCharacterCount // ignore: cast_nullable_to_non_nullable
as int,genres: null == genres ? _self._genres : genres // ignore: cast_nullable_to_non_nullable
as List<Genre>,
  ));
}


}


/// @nodoc
mixin _$ProjectDetail {

 int get id; String get name; String get kind; String? get summary; String? get bodyMd; String? get worldName; int? get coverAssetId; int get progressPercent; String get visibility; String? get updatedAt; List<Genre> get genres; List<CharacterSummary> get characters;
/// Create a copy of ProjectDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectDetailCopyWith<ProjectDetail> get copyWith => _$ProjectDetailCopyWithImpl<ProjectDetail>(this as ProjectDetail, _$identity);

  /// Serializes this ProjectDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.bodyMd, bodyMd) || other.bodyMd == bodyMd)&&(identical(other.worldName, worldName) || other.worldName == worldName)&&(identical(other.coverAssetId, coverAssetId) || other.coverAssetId == coverAssetId)&&(identical(other.progressPercent, progressPercent) || other.progressPercent == progressPercent)&&(identical(other.visibility, visibility) || other.visibility == visibility)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other.genres, genres)&&const DeepCollectionEquality().equals(other.characters, characters));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,kind,summary,bodyMd,worldName,coverAssetId,progressPercent,visibility,updatedAt,const DeepCollectionEquality().hash(genres),const DeepCollectionEquality().hash(characters));

@override
String toString() {
  return 'ProjectDetail(id: $id, name: $name, kind: $kind, summary: $summary, bodyMd: $bodyMd, worldName: $worldName, coverAssetId: $coverAssetId, progressPercent: $progressPercent, visibility: $visibility, updatedAt: $updatedAt, genres: $genres, characters: $characters)';
}


}

/// @nodoc
abstract mixin class $ProjectDetailCopyWith<$Res>  {
  factory $ProjectDetailCopyWith(ProjectDetail value, $Res Function(ProjectDetail) _then) = _$ProjectDetailCopyWithImpl;
@useResult
$Res call({
 int id, String name, String kind, String? summary, String? bodyMd, String? worldName, int? coverAssetId, int progressPercent, String visibility, String? updatedAt, List<Genre> genres, List<CharacterSummary> characters
});




}
/// @nodoc
class _$ProjectDetailCopyWithImpl<$Res>
    implements $ProjectDetailCopyWith<$Res> {
  _$ProjectDetailCopyWithImpl(this._self, this._then);

  final ProjectDetail _self;
  final $Res Function(ProjectDetail) _then;

/// Create a copy of ProjectDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? kind = null,Object? summary = freezed,Object? bodyMd = freezed,Object? worldName = freezed,Object? coverAssetId = freezed,Object? progressPercent = null,Object? visibility = null,Object? updatedAt = freezed,Object? genres = null,Object? characters = null,}) {
  return _then(ProjectDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String?,bodyMd: freezed == bodyMd ? _self.bodyMd : bodyMd // ignore: cast_nullable_to_non_nullable
as String?,worldName: freezed == worldName ? _self.worldName : worldName // ignore: cast_nullable_to_non_nullable
as String?,coverAssetId: freezed == coverAssetId ? _self.coverAssetId : coverAssetId // ignore: cast_nullable_to_non_nullable
as int?,progressPercent: null == progressPercent ? _self.progressPercent : progressPercent // ignore: cast_nullable_to_non_nullable
as int,visibility: null == visibility ? _self.visibility : visibility // ignore: cast_nullable_to_non_nullable
as String,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,genres: null == genres ? _self.genres : genres // ignore: cast_nullable_to_non_nullable
as List<Genre>,characters: null == characters ? _self.characters : characters // ignore: cast_nullable_to_non_nullable
as List<CharacterSummary>,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectDetail].
extension ProjectDetailPatterns on ProjectDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectDetail value)  $default,){
final _that = this;
switch (_that) {
case _ProjectDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectDetail value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String kind,  String? summary,  String? bodyMd,  String? worldName,  int? coverAssetId,  int progressPercent,  String visibility,  String? updatedAt,  List<Genre> genres,  List<CharacterSummary> characters)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectDetail() when $default != null:
return $default(_that.id,_that.name,_that.kind,_that.summary,_that.bodyMd,_that.worldName,_that.coverAssetId,_that.progressPercent,_that.visibility,_that.updatedAt,_that.genres,_that.characters);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String kind,  String? summary,  String? bodyMd,  String? worldName,  int? coverAssetId,  int progressPercent,  String visibility,  String? updatedAt,  List<Genre> genres,  List<CharacterSummary> characters)  $default,) {final _that = this;
switch (_that) {
case _ProjectDetail():
return $default(_that.id,_that.name,_that.kind,_that.summary,_that.bodyMd,_that.worldName,_that.coverAssetId,_that.progressPercent,_that.visibility,_that.updatedAt,_that.genres,_that.characters);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String kind,  String? summary,  String? bodyMd,  String? worldName,  int? coverAssetId,  int progressPercent,  String visibility,  String? updatedAt,  List<Genre> genres,  List<CharacterSummary> characters)?  $default,) {final _that = this;
switch (_that) {
case _ProjectDetail() when $default != null:
return $default(_that.id,_that.name,_that.kind,_that.summary,_that.bodyMd,_that.worldName,_that.coverAssetId,_that.progressPercent,_that.visibility,_that.updatedAt,_that.genres,_that.characters);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectDetail extends ProjectDetail {
  const _ProjectDetail({required this.id, required this.name, this.kind = 'etc', this.summary, this.bodyMd, this.worldName, this.coverAssetId, this.progressPercent = 0, this.visibility = 'private', this.updatedAt,  List<Genre> genres = const [],  List<CharacterSummary> characters = const []}): _genres = genres,_characters = characters,super._();
  factory _ProjectDetail.fromJson(Map<String, dynamic> json) => _$ProjectDetailFromJson(json);

@override final  int id;
@override final  String name;
@override@JsonKey() final  String kind;
@override final  String? summary;
@override final  String? bodyMd;
@override final  String? worldName;
@override final  int? coverAssetId;
@override@JsonKey() final  int progressPercent;
@override@JsonKey() final  String visibility;
@override final  String? updatedAt;
 final  List<Genre> _genres;
@override@JsonKey() List<Genre> get genres {
  if (_genres is EqualUnmodifiableListView) return _genres;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_genres);
}

 final  List<CharacterSummary> _characters;
@override@JsonKey() List<CharacterSummary> get characters {
  if (_characters is EqualUnmodifiableListView) return _characters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_characters);
}


/// Create a copy of ProjectDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectDetailCopyWith<_ProjectDetail> get copyWith => __$ProjectDetailCopyWithImpl<_ProjectDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.bodyMd, bodyMd) || other.bodyMd == bodyMd)&&(identical(other.worldName, worldName) || other.worldName == worldName)&&(identical(other.coverAssetId, coverAssetId) || other.coverAssetId == coverAssetId)&&(identical(other.progressPercent, progressPercent) || other.progressPercent == progressPercent)&&(identical(other.visibility, visibility) || other.visibility == visibility)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other._genres, _genres)&&const DeepCollectionEquality().equals(other._characters, _characters));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,kind,summary,bodyMd,worldName,coverAssetId,progressPercent,visibility,updatedAt,const DeepCollectionEquality().hash(_genres),const DeepCollectionEquality().hash(_characters));

@override
String toString() {
  return 'ProjectDetail(id: $id, name: $name, kind: $kind, summary: $summary, bodyMd: $bodyMd, worldName: $worldName, coverAssetId: $coverAssetId, progressPercent: $progressPercent, visibility: $visibility, updatedAt: $updatedAt, genres: $genres, characters: $characters)';
}


}

/// @nodoc
abstract mixin class _$ProjectDetailCopyWith<$Res> implements $ProjectDetailCopyWith<$Res> {
  factory _$ProjectDetailCopyWith(_ProjectDetail value, $Res Function(_ProjectDetail) _then) = __$ProjectDetailCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String kind, String? summary, String? bodyMd, String? worldName, int? coverAssetId, int progressPercent, String visibility, String? updatedAt, List<Genre> genres, List<CharacterSummary> characters
});




}
/// @nodoc
class __$ProjectDetailCopyWithImpl<$Res>
    implements _$ProjectDetailCopyWith<$Res> {
  __$ProjectDetailCopyWithImpl(this._self, this._then);

  final _ProjectDetail _self;
  final $Res Function(_ProjectDetail) _then;

/// Create a copy of ProjectDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? kind = null,Object? summary = freezed,Object? bodyMd = freezed,Object? worldName = freezed,Object? coverAssetId = freezed,Object? progressPercent = null,Object? visibility = null,Object? updatedAt = freezed,Object? genres = null,Object? characters = null,}) {
  return _then(_ProjectDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String?,bodyMd: freezed == bodyMd ? _self.bodyMd : bodyMd // ignore: cast_nullable_to_non_nullable
as String?,worldName: freezed == worldName ? _self.worldName : worldName // ignore: cast_nullable_to_non_nullable
as String?,coverAssetId: freezed == coverAssetId ? _self.coverAssetId : coverAssetId // ignore: cast_nullable_to_non_nullable
as int?,progressPercent: null == progressPercent ? _self.progressPercent : progressPercent // ignore: cast_nullable_to_non_nullable
as int,visibility: null == visibility ? _self.visibility : visibility // ignore: cast_nullable_to_non_nullable
as String,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,genres: null == genres ? _self._genres : genres // ignore: cast_nullable_to_non_nullable
as List<Genre>,characters: null == characters ? _self._characters : characters // ignore: cast_nullable_to_non_nullable
as List<CharacterSummary>,
  ));
}


}

// dart format on
