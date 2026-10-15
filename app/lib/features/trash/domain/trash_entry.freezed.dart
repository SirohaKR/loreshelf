// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trash_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TrashEntry {

 int get id; String get name; String get deletedAt; String? get projectName; int get ownCharacterCount;
/// Create a copy of TrashEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrashEntryCopyWith<TrashEntry> get copyWith => _$TrashEntryCopyWithImpl<TrashEntry>(this as TrashEntry, _$identity);

  /// Serializes this TrashEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrashEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.projectName, projectName) || other.projectName == projectName)&&(identical(other.ownCharacterCount, ownCharacterCount) || other.ownCharacterCount == ownCharacterCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,deletedAt,projectName,ownCharacterCount);

@override
String toString() {
  return 'TrashEntry(id: $id, name: $name, deletedAt: $deletedAt, projectName: $projectName, ownCharacterCount: $ownCharacterCount)';
}


}

/// @nodoc
abstract mixin class $TrashEntryCopyWith<$Res>  {
  factory $TrashEntryCopyWith(TrashEntry value, $Res Function(TrashEntry) _then) = _$TrashEntryCopyWithImpl;
@useResult
$Res call({
 int id, String name, String deletedAt, String? projectName, int ownCharacterCount
});




}
/// @nodoc
class _$TrashEntryCopyWithImpl<$Res>
    implements $TrashEntryCopyWith<$Res> {
  _$TrashEntryCopyWithImpl(this._self, this._then);

  final TrashEntry _self;
  final $Res Function(TrashEntry) _then;

/// Create a copy of TrashEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? deletedAt = null,Object? projectName = freezed,Object? ownCharacterCount = null,}) {
  return _then(TrashEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,deletedAt: null == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as String,projectName: freezed == projectName ? _self.projectName : projectName // ignore: cast_nullable_to_non_nullable
as String?,ownCharacterCount: null == ownCharacterCount ? _self.ownCharacterCount : ownCharacterCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TrashEntry].
extension TrashEntryPatterns on TrashEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TrashEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TrashEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TrashEntry value)  $default,){
final _that = this;
switch (_that) {
case _TrashEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TrashEntry value)?  $default,){
final _that = this;
switch (_that) {
case _TrashEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String deletedAt,  String? projectName,  int ownCharacterCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TrashEntry() when $default != null:
return $default(_that.id,_that.name,_that.deletedAt,_that.projectName,_that.ownCharacterCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String deletedAt,  String? projectName,  int ownCharacterCount)  $default,) {final _that = this;
switch (_that) {
case _TrashEntry():
return $default(_that.id,_that.name,_that.deletedAt,_that.projectName,_that.ownCharacterCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String deletedAt,  String? projectName,  int ownCharacterCount)?  $default,) {final _that = this;
switch (_that) {
case _TrashEntry() when $default != null:
return $default(_that.id,_that.name,_that.deletedAt,_that.projectName,_that.ownCharacterCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TrashEntry implements TrashEntry {
  const _TrashEntry({required this.id, required this.name, required this.deletedAt, this.projectName, this.ownCharacterCount = 0});
  factory _TrashEntry.fromJson(Map<String, dynamic> json) => _$TrashEntryFromJson(json);

@override final  int id;
@override final  String name;
@override final  String deletedAt;
@override final  String? projectName;
@override@JsonKey() final  int ownCharacterCount;

/// Create a copy of TrashEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrashEntryCopyWith<_TrashEntry> get copyWith => __$TrashEntryCopyWithImpl<_TrashEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TrashEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TrashEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.projectName, projectName) || other.projectName == projectName)&&(identical(other.ownCharacterCount, ownCharacterCount) || other.ownCharacterCount == ownCharacterCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,deletedAt,projectName,ownCharacterCount);

@override
String toString() {
  return 'TrashEntry(id: $id, name: $name, deletedAt: $deletedAt, projectName: $projectName, ownCharacterCount: $ownCharacterCount)';
}


}

/// @nodoc
abstract mixin class _$TrashEntryCopyWith<$Res> implements $TrashEntryCopyWith<$Res> {
  factory _$TrashEntryCopyWith(_TrashEntry value, $Res Function(_TrashEntry) _then) = __$TrashEntryCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String deletedAt, String? projectName, int ownCharacterCount
});




}
/// @nodoc
class __$TrashEntryCopyWithImpl<$Res>
    implements _$TrashEntryCopyWith<$Res> {
  __$TrashEntryCopyWithImpl(this._self, this._then);

  final _TrashEntry _self;
  final $Res Function(_TrashEntry) _then;

/// Create a copy of TrashEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? deletedAt = null,Object? projectName = freezed,Object? ownCharacterCount = null,}) {
  return _then(_TrashEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,deletedAt: null == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as String,projectName: freezed == projectName ? _self.projectName : projectName // ignore: cast_nullable_to_non_nullable
as String?,ownCharacterCount: null == ownCharacterCount ? _self.ownCharacterCount : ownCharacterCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$TrashLists {

 List<TrashEntry> get characters; List<TrashEntry> get worlds; List<TrashEntry> get projects;
/// Create a copy of TrashLists
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrashListsCopyWith<TrashLists> get copyWith => _$TrashListsCopyWithImpl<TrashLists>(this as TrashLists, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrashLists&&const DeepCollectionEquality().equals(other.characters, characters)&&const DeepCollectionEquality().equals(other.worlds, worlds)&&const DeepCollectionEquality().equals(other.projects, projects));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(characters),const DeepCollectionEquality().hash(worlds),const DeepCollectionEquality().hash(projects));

@override
String toString() {
  return 'TrashLists(characters: $characters, worlds: $worlds, projects: $projects)';
}


}

/// @nodoc
abstract mixin class $TrashListsCopyWith<$Res>  {
  factory $TrashListsCopyWith(TrashLists value, $Res Function(TrashLists) _then) = _$TrashListsCopyWithImpl;
@useResult
$Res call({
 List<TrashEntry> characters, List<TrashEntry> worlds, List<TrashEntry> projects
});




}
/// @nodoc
class _$TrashListsCopyWithImpl<$Res>
    implements $TrashListsCopyWith<$Res> {
  _$TrashListsCopyWithImpl(this._self, this._then);

  final TrashLists _self;
  final $Res Function(TrashLists) _then;

/// Create a copy of TrashLists
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? characters = null,Object? worlds = null,Object? projects = null,}) {
  return _then(TrashLists(
characters: null == characters ? _self.characters : characters // ignore: cast_nullable_to_non_nullable
as List<TrashEntry>,worlds: null == worlds ? _self.worlds : worlds // ignore: cast_nullable_to_non_nullable
as List<TrashEntry>,projects: null == projects ? _self.projects : projects // ignore: cast_nullable_to_non_nullable
as List<TrashEntry>,
  ));
}

}


/// Adds pattern-matching-related methods to [TrashLists].
extension TrashListsPatterns on TrashLists {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TrashLists value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TrashLists() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TrashLists value)  $default,){
final _that = this;
switch (_that) {
case _TrashLists():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TrashLists value)?  $default,){
final _that = this;
switch (_that) {
case _TrashLists() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<TrashEntry> characters,  List<TrashEntry> worlds,  List<TrashEntry> projects)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TrashLists() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<TrashEntry> characters,  List<TrashEntry> worlds,  List<TrashEntry> projects)  $default,) {final _that = this;
switch (_that) {
case _TrashLists():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<TrashEntry> characters,  List<TrashEntry> worlds,  List<TrashEntry> projects)?  $default,) {final _that = this;
switch (_that) {
case _TrashLists() when $default != null:
return $default(_that.characters,_that.worlds,_that.projects);case _:
  return null;

}
}

}

/// @nodoc


class _TrashLists extends TrashLists {
  const _TrashLists({ List<TrashEntry> characters = const [],  List<TrashEntry> worlds = const [],  List<TrashEntry> projects = const []}): _characters = characters,_worlds = worlds,_projects = projects,super._();
  

 final  List<TrashEntry> _characters;
@override@JsonKey() List<TrashEntry> get characters {
  if (_characters is EqualUnmodifiableListView) return _characters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_characters);
}

 final  List<TrashEntry> _worlds;
@override@JsonKey() List<TrashEntry> get worlds {
  if (_worlds is EqualUnmodifiableListView) return _worlds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_worlds);
}

 final  List<TrashEntry> _projects;
@override@JsonKey() List<TrashEntry> get projects {
  if (_projects is EqualUnmodifiableListView) return _projects;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_projects);
}


/// Create a copy of TrashLists
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrashListsCopyWith<_TrashLists> get copyWith => __$TrashListsCopyWithImpl<_TrashLists>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TrashLists&&const DeepCollectionEquality().equals(other._characters, _characters)&&const DeepCollectionEquality().equals(other._worlds, _worlds)&&const DeepCollectionEquality().equals(other._projects, _projects));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_characters),const DeepCollectionEquality().hash(_worlds),const DeepCollectionEquality().hash(_projects));

@override
String toString() {
  return 'TrashLists(characters: $characters, worlds: $worlds, projects: $projects)';
}


}

/// @nodoc
abstract mixin class _$TrashListsCopyWith<$Res> implements $TrashListsCopyWith<$Res> {
  factory _$TrashListsCopyWith(_TrashLists value, $Res Function(_TrashLists) _then) = __$TrashListsCopyWithImpl;
@override @useResult
$Res call({
 List<TrashEntry> characters, List<TrashEntry> worlds, List<TrashEntry> projects
});




}
/// @nodoc
class __$TrashListsCopyWithImpl<$Res>
    implements _$TrashListsCopyWith<$Res> {
  __$TrashListsCopyWithImpl(this._self, this._then);

  final _TrashLists _self;
  final $Res Function(_TrashLists) _then;

/// Create a copy of TrashLists
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? characters = null,Object? worlds = null,Object? projects = null,}) {
  return _then(_TrashLists(
characters: null == characters ? _self._characters : characters // ignore: cast_nullable_to_non_nullable
as List<TrashEntry>,worlds: null == worlds ? _self._worlds : worlds // ignore: cast_nullable_to_non_nullable
as List<TrashEntry>,projects: null == projects ? _self._projects : projects // ignore: cast_nullable_to_non_nullable
as List<TrashEntry>,
  ));
}


}

// dart format on
