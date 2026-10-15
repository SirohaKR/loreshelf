// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProjectDraft {

 String get name; String get kind; String get visibility; String get summary; int get progressPercent; String get bodyMd; int? get coverAssetId; int? get worldId; int get sortOrder; List<Genre> get genres;
/// Create a copy of ProjectDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectDraftCopyWith<ProjectDraft> get copyWith => _$ProjectDraftCopyWithImpl<ProjectDraft>(this as ProjectDraft, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectDraft&&(identical(other.name, name) || other.name == name)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.visibility, visibility) || other.visibility == visibility)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.progressPercent, progressPercent) || other.progressPercent == progressPercent)&&(identical(other.bodyMd, bodyMd) || other.bodyMd == bodyMd)&&(identical(other.coverAssetId, coverAssetId) || other.coverAssetId == coverAssetId)&&(identical(other.worldId, worldId) || other.worldId == worldId)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&const DeepCollectionEquality().equals(other.genres, genres));
}


@override
int get hashCode => Object.hash(runtimeType,name,kind,visibility,summary,progressPercent,bodyMd,coverAssetId,worldId,sortOrder,const DeepCollectionEquality().hash(genres));

@override
String toString() {
  return 'ProjectDraft(name: $name, kind: $kind, visibility: $visibility, summary: $summary, progressPercent: $progressPercent, bodyMd: $bodyMd, coverAssetId: $coverAssetId, worldId: $worldId, sortOrder: $sortOrder, genres: $genres)';
}


}

/// @nodoc
abstract mixin class $ProjectDraftCopyWith<$Res>  {
  factory $ProjectDraftCopyWith(ProjectDraft value, $Res Function(ProjectDraft) _then) = _$ProjectDraftCopyWithImpl;
@useResult
$Res call({
 String name, String kind, String visibility, String summary, int progressPercent, String bodyMd, int? coverAssetId, int? worldId, int sortOrder, List<Genre> genres
});




}
/// @nodoc
class _$ProjectDraftCopyWithImpl<$Res>
    implements $ProjectDraftCopyWith<$Res> {
  _$ProjectDraftCopyWithImpl(this._self, this._then);

  final ProjectDraft _self;
  final $Res Function(ProjectDraft) _then;

/// Create a copy of ProjectDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? kind = null,Object? visibility = null,Object? summary = null,Object? progressPercent = null,Object? bodyMd = null,Object? coverAssetId = freezed,Object? worldId = freezed,Object? sortOrder = null,Object? genres = null,}) {
  return _then(ProjectDraft(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,visibility: null == visibility ? _self.visibility : visibility // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,progressPercent: null == progressPercent ? _self.progressPercent : progressPercent // ignore: cast_nullable_to_non_nullable
as int,bodyMd: null == bodyMd ? _self.bodyMd : bodyMd // ignore: cast_nullable_to_non_nullable
as String,coverAssetId: freezed == coverAssetId ? _self.coverAssetId : coverAssetId // ignore: cast_nullable_to_non_nullable
as int?,worldId: freezed == worldId ? _self.worldId : worldId // ignore: cast_nullable_to_non_nullable
as int?,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,genres: null == genres ? _self.genres : genres // ignore: cast_nullable_to_non_nullable
as List<Genre>,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectDraft].
extension ProjectDraftPatterns on ProjectDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectDraft value)  $default,){
final _that = this;
switch (_that) {
case _ProjectDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectDraft value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String kind,  String visibility,  String summary,  int progressPercent,  String bodyMd,  int? coverAssetId,  int? worldId,  int sortOrder,  List<Genre> genres)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectDraft() when $default != null:
return $default(_that.name,_that.kind,_that.visibility,_that.summary,_that.progressPercent,_that.bodyMd,_that.coverAssetId,_that.worldId,_that.sortOrder,_that.genres);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String kind,  String visibility,  String summary,  int progressPercent,  String bodyMd,  int? coverAssetId,  int? worldId,  int sortOrder,  List<Genre> genres)  $default,) {final _that = this;
switch (_that) {
case _ProjectDraft():
return $default(_that.name,_that.kind,_that.visibility,_that.summary,_that.progressPercent,_that.bodyMd,_that.coverAssetId,_that.worldId,_that.sortOrder,_that.genres);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String kind,  String visibility,  String summary,  int progressPercent,  String bodyMd,  int? coverAssetId,  int? worldId,  int sortOrder,  List<Genre> genres)?  $default,) {final _that = this;
switch (_that) {
case _ProjectDraft() when $default != null:
return $default(_that.name,_that.kind,_that.visibility,_that.summary,_that.progressPercent,_that.bodyMd,_that.coverAssetId,_that.worldId,_that.sortOrder,_that.genres);case _:
  return null;

}
}

}

/// @nodoc


class _ProjectDraft extends ProjectDraft {
  const _ProjectDraft({this.name = '', this.kind = 'game', this.visibility = 'private', this.summary = '', this.progressPercent = 0, this.bodyMd = '', this.coverAssetId, this.worldId, this.sortOrder = 0,  List<Genre> genres = const []}): _genres = genres,super._();
  

@override@JsonKey() final  String name;
@override@JsonKey() final  String kind;
@override@JsonKey() final  String visibility;
@override@JsonKey() final  String summary;
@override@JsonKey() final  int progressPercent;
@override@JsonKey() final  String bodyMd;
@override final  int? coverAssetId;
@override final  int? worldId;
@override@JsonKey() final  int sortOrder;
 final  List<Genre> _genres;
@override@JsonKey() List<Genre> get genres {
  if (_genres is EqualUnmodifiableListView) return _genres;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_genres);
}


/// Create a copy of ProjectDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectDraftCopyWith<_ProjectDraft> get copyWith => __$ProjectDraftCopyWithImpl<_ProjectDraft>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectDraft&&(identical(other.name, name) || other.name == name)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.visibility, visibility) || other.visibility == visibility)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.progressPercent, progressPercent) || other.progressPercent == progressPercent)&&(identical(other.bodyMd, bodyMd) || other.bodyMd == bodyMd)&&(identical(other.coverAssetId, coverAssetId) || other.coverAssetId == coverAssetId)&&(identical(other.worldId, worldId) || other.worldId == worldId)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&const DeepCollectionEquality().equals(other._genres, _genres));
}


@override
int get hashCode => Object.hash(runtimeType,name,kind,visibility,summary,progressPercent,bodyMd,coverAssetId,worldId,sortOrder,const DeepCollectionEquality().hash(_genres));

@override
String toString() {
  return 'ProjectDraft(name: $name, kind: $kind, visibility: $visibility, summary: $summary, progressPercent: $progressPercent, bodyMd: $bodyMd, coverAssetId: $coverAssetId, worldId: $worldId, sortOrder: $sortOrder, genres: $genres)';
}


}

/// @nodoc
abstract mixin class _$ProjectDraftCopyWith<$Res> implements $ProjectDraftCopyWith<$Res> {
  factory _$ProjectDraftCopyWith(_ProjectDraft value, $Res Function(_ProjectDraft) _then) = __$ProjectDraftCopyWithImpl;
@override @useResult
$Res call({
 String name, String kind, String visibility, String summary, int progressPercent, String bodyMd, int? coverAssetId, int? worldId, int sortOrder, List<Genre> genres
});




}
/// @nodoc
class __$ProjectDraftCopyWithImpl<$Res>
    implements _$ProjectDraftCopyWith<$Res> {
  __$ProjectDraftCopyWithImpl(this._self, this._then);

  final _ProjectDraft _self;
  final $Res Function(_ProjectDraft) _then;

/// Create a copy of ProjectDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? kind = null,Object? visibility = null,Object? summary = null,Object? progressPercent = null,Object? bodyMd = null,Object? coverAssetId = freezed,Object? worldId = freezed,Object? sortOrder = null,Object? genres = null,}) {
  return _then(_ProjectDraft(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,visibility: null == visibility ? _self.visibility : visibility // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,progressPercent: null == progressPercent ? _self.progressPercent : progressPercent // ignore: cast_nullable_to_non_nullable
as int,bodyMd: null == bodyMd ? _self.bodyMd : bodyMd // ignore: cast_nullable_to_non_nullable
as String,coverAssetId: freezed == coverAssetId ? _self.coverAssetId : coverAssetId // ignore: cast_nullable_to_non_nullable
as int?,worldId: freezed == worldId ? _self.worldId : worldId // ignore: cast_nullable_to_non_nullable
as int?,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,genres: null == genres ? _self._genres : genres // ignore: cast_nullable_to_non_nullable
as List<Genre>,
  ));
}


}

// dart format on
