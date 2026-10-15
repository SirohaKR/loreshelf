// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HomeSummary {

 User? get user; HomeCounts get counts; List<CharacterSummary> get recentCharacters; List<ProjectSummary> get projects;
/// Create a copy of HomeSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeSummaryCopyWith<HomeSummary> get copyWith => _$HomeSummaryCopyWithImpl<HomeSummary>(this as HomeSummary, _$identity);

  /// Serializes this HomeSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeSummary&&(identical(other.user, user) || other.user == user)&&(identical(other.counts, counts) || other.counts == counts)&&const DeepCollectionEquality().equals(other.recentCharacters, recentCharacters)&&const DeepCollectionEquality().equals(other.projects, projects));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,user,counts,const DeepCollectionEquality().hash(recentCharacters),const DeepCollectionEquality().hash(projects));

@override
String toString() {
  return 'HomeSummary(user: $user, counts: $counts, recentCharacters: $recentCharacters, projects: $projects)';
}


}

/// @nodoc
abstract mixin class $HomeSummaryCopyWith<$Res>  {
  factory $HomeSummaryCopyWith(HomeSummary value, $Res Function(HomeSummary) _then) = _$HomeSummaryCopyWithImpl;
@useResult
$Res call({
 User? user, HomeCounts counts, List<CharacterSummary> recentCharacters, List<ProjectSummary> projects
});


$UserCopyWith<$Res>? get user;$HomeCountsCopyWith<$Res> get counts;

}
/// @nodoc
class _$HomeSummaryCopyWithImpl<$Res>
    implements $HomeSummaryCopyWith<$Res> {
  _$HomeSummaryCopyWithImpl(this._self, this._then);

  final HomeSummary _self;
  final $Res Function(HomeSummary) _then;

/// Create a copy of HomeSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? user = freezed,Object? counts = null,Object? recentCharacters = null,Object? projects = null,}) {
  return _then(HomeSummary(
user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User?,counts: null == counts ? _self.counts : counts // ignore: cast_nullable_to_non_nullable
as HomeCounts,recentCharacters: null == recentCharacters ? _self.recentCharacters : recentCharacters // ignore: cast_nullable_to_non_nullable
as List<CharacterSummary>,projects: null == projects ? _self.projects : projects // ignore: cast_nullable_to_non_nullable
as List<ProjectSummary>,
  ));
}
/// Create a copy of HomeSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $UserCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}/// Create a copy of HomeSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HomeCountsCopyWith<$Res> get counts {
  
  return $HomeCountsCopyWith<$Res>(_self.counts, (value) {
    return _then(_self.copyWith(counts: value));
  });
}
}


/// Adds pattern-matching-related methods to [HomeSummary].
extension HomeSummaryPatterns on HomeSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HomeSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HomeSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HomeSummary value)  $default,){
final _that = this;
switch (_that) {
case _HomeSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HomeSummary value)?  $default,){
final _that = this;
switch (_that) {
case _HomeSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( User? user,  HomeCounts counts,  List<CharacterSummary> recentCharacters,  List<ProjectSummary> projects)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HomeSummary() when $default != null:
return $default(_that.user,_that.counts,_that.recentCharacters,_that.projects);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( User? user,  HomeCounts counts,  List<CharacterSummary> recentCharacters,  List<ProjectSummary> projects)  $default,) {final _that = this;
switch (_that) {
case _HomeSummary():
return $default(_that.user,_that.counts,_that.recentCharacters,_that.projects);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( User? user,  HomeCounts counts,  List<CharacterSummary> recentCharacters,  List<ProjectSummary> projects)?  $default,) {final _that = this;
switch (_that) {
case _HomeSummary() when $default != null:
return $default(_that.user,_that.counts,_that.recentCharacters,_that.projects);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HomeSummary implements HomeSummary {
  const _HomeSummary({this.user, required this.counts,  List<CharacterSummary> recentCharacters = const [],  List<ProjectSummary> projects = const []}): _recentCharacters = recentCharacters,_projects = projects;
  factory _HomeSummary.fromJson(Map<String, dynamic> json) => _$HomeSummaryFromJson(json);

@override final  User? user;
@override final  HomeCounts counts;
 final  List<CharacterSummary> _recentCharacters;
@override@JsonKey() List<CharacterSummary> get recentCharacters {
  if (_recentCharacters is EqualUnmodifiableListView) return _recentCharacters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recentCharacters);
}

 final  List<ProjectSummary> _projects;
@override@JsonKey() List<ProjectSummary> get projects {
  if (_projects is EqualUnmodifiableListView) return _projects;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_projects);
}


/// Create a copy of HomeSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HomeSummaryCopyWith<_HomeSummary> get copyWith => __$HomeSummaryCopyWithImpl<_HomeSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HomeSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HomeSummary&&(identical(other.user, user) || other.user == user)&&(identical(other.counts, counts) || other.counts == counts)&&const DeepCollectionEquality().equals(other._recentCharacters, _recentCharacters)&&const DeepCollectionEquality().equals(other._projects, _projects));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,user,counts,const DeepCollectionEquality().hash(_recentCharacters),const DeepCollectionEquality().hash(_projects));

@override
String toString() {
  return 'HomeSummary(user: $user, counts: $counts, recentCharacters: $recentCharacters, projects: $projects)';
}


}

/// @nodoc
abstract mixin class _$HomeSummaryCopyWith<$Res> implements $HomeSummaryCopyWith<$Res> {
  factory _$HomeSummaryCopyWith(_HomeSummary value, $Res Function(_HomeSummary) _then) = __$HomeSummaryCopyWithImpl;
@override @useResult
$Res call({
 User? user, HomeCounts counts, List<CharacterSummary> recentCharacters, List<ProjectSummary> projects
});


@override $UserCopyWith<$Res>? get user;@override $HomeCountsCopyWith<$Res> get counts;

}
/// @nodoc
class __$HomeSummaryCopyWithImpl<$Res>
    implements _$HomeSummaryCopyWith<$Res> {
  __$HomeSummaryCopyWithImpl(this._self, this._then);

  final _HomeSummary _self;
  final $Res Function(_HomeSummary) _then;

/// Create a copy of HomeSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? user = freezed,Object? counts = null,Object? recentCharacters = null,Object? projects = null,}) {
  return _then(_HomeSummary(
user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User?,counts: null == counts ? _self.counts : counts // ignore: cast_nullable_to_non_nullable
as HomeCounts,recentCharacters: null == recentCharacters ? _self._recentCharacters : recentCharacters // ignore: cast_nullable_to_non_nullable
as List<CharacterSummary>,projects: null == projects ? _self._projects : projects // ignore: cast_nullable_to_non_nullable
as List<ProjectSummary>,
  ));
}

/// Create a copy of HomeSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $UserCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}/// Create a copy of HomeSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HomeCountsCopyWith<$Res> get counts {
  
  return $HomeCountsCopyWith<$Res>(_self.counts, (value) {
    return _then(_self.copyWith(counts: value));
  });
}
}


/// @nodoc
mixin _$HomeCounts {

 int get characters; int get libraryCharacters; int get projects; int get publicItems;
/// Create a copy of HomeCounts
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeCountsCopyWith<HomeCounts> get copyWith => _$HomeCountsCopyWithImpl<HomeCounts>(this as HomeCounts, _$identity);

  /// Serializes this HomeCounts to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeCounts&&(identical(other.characters, characters) || other.characters == characters)&&(identical(other.libraryCharacters, libraryCharacters) || other.libraryCharacters == libraryCharacters)&&(identical(other.projects, projects) || other.projects == projects)&&(identical(other.publicItems, publicItems) || other.publicItems == publicItems));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,characters,libraryCharacters,projects,publicItems);

@override
String toString() {
  return 'HomeCounts(characters: $characters, libraryCharacters: $libraryCharacters, projects: $projects, publicItems: $publicItems)';
}


}

/// @nodoc
abstract mixin class $HomeCountsCopyWith<$Res>  {
  factory $HomeCountsCopyWith(HomeCounts value, $Res Function(HomeCounts) _then) = _$HomeCountsCopyWithImpl;
@useResult
$Res call({
 int characters, int libraryCharacters, int projects, int publicItems
});




}
/// @nodoc
class _$HomeCountsCopyWithImpl<$Res>
    implements $HomeCountsCopyWith<$Res> {
  _$HomeCountsCopyWithImpl(this._self, this._then);

  final HomeCounts _self;
  final $Res Function(HomeCounts) _then;

/// Create a copy of HomeCounts
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? characters = null,Object? libraryCharacters = null,Object? projects = null,Object? publicItems = null,}) {
  return _then(HomeCounts(
characters: null == characters ? _self.characters : characters // ignore: cast_nullable_to_non_nullable
as int,libraryCharacters: null == libraryCharacters ? _self.libraryCharacters : libraryCharacters // ignore: cast_nullable_to_non_nullable
as int,projects: null == projects ? _self.projects : projects // ignore: cast_nullable_to_non_nullable
as int,publicItems: null == publicItems ? _self.publicItems : publicItems // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [HomeCounts].
extension HomeCountsPatterns on HomeCounts {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HomeCounts value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HomeCounts() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HomeCounts value)  $default,){
final _that = this;
switch (_that) {
case _HomeCounts():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HomeCounts value)?  $default,){
final _that = this;
switch (_that) {
case _HomeCounts() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int characters,  int libraryCharacters,  int projects,  int publicItems)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HomeCounts() when $default != null:
return $default(_that.characters,_that.libraryCharacters,_that.projects,_that.publicItems);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int characters,  int libraryCharacters,  int projects,  int publicItems)  $default,) {final _that = this;
switch (_that) {
case _HomeCounts():
return $default(_that.characters,_that.libraryCharacters,_that.projects,_that.publicItems);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int characters,  int libraryCharacters,  int projects,  int publicItems)?  $default,) {final _that = this;
switch (_that) {
case _HomeCounts() when $default != null:
return $default(_that.characters,_that.libraryCharacters,_that.projects,_that.publicItems);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HomeCounts implements HomeCounts {
  const _HomeCounts({this.characters = 0, this.libraryCharacters = 0, this.projects = 0, this.publicItems = 0});
  factory _HomeCounts.fromJson(Map<String, dynamic> json) => _$HomeCountsFromJson(json);

@override@JsonKey() final  int characters;
@override@JsonKey() final  int libraryCharacters;
@override@JsonKey() final  int projects;
@override@JsonKey() final  int publicItems;

/// Create a copy of HomeCounts
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HomeCountsCopyWith<_HomeCounts> get copyWith => __$HomeCountsCopyWithImpl<_HomeCounts>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HomeCountsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HomeCounts&&(identical(other.characters, characters) || other.characters == characters)&&(identical(other.libraryCharacters, libraryCharacters) || other.libraryCharacters == libraryCharacters)&&(identical(other.projects, projects) || other.projects == projects)&&(identical(other.publicItems, publicItems) || other.publicItems == publicItems));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,characters,libraryCharacters,projects,publicItems);

@override
String toString() {
  return 'HomeCounts(characters: $characters, libraryCharacters: $libraryCharacters, projects: $projects, publicItems: $publicItems)';
}


}

/// @nodoc
abstract mixin class _$HomeCountsCopyWith<$Res> implements $HomeCountsCopyWith<$Res> {
  factory _$HomeCountsCopyWith(_HomeCounts value, $Res Function(_HomeCounts) _then) = __$HomeCountsCopyWithImpl;
@override @useResult
$Res call({
 int characters, int libraryCharacters, int projects, int publicItems
});




}
/// @nodoc
class __$HomeCountsCopyWithImpl<$Res>
    implements _$HomeCountsCopyWith<$Res> {
  __$HomeCountsCopyWithImpl(this._self, this._then);

  final _HomeCounts _self;
  final $Res Function(_HomeCounts) _then;

/// Create a copy of HomeCounts
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? characters = null,Object? libraryCharacters = null,Object? projects = null,Object? publicItems = null,}) {
  return _then(_HomeCounts(
characters: null == characters ? _self.characters : characters // ignore: cast_nullable_to_non_nullable
as int,libraryCharacters: null == libraryCharacters ? _self.libraryCharacters : libraryCharacters // ignore: cast_nullable_to_non_nullable
as int,projects: null == projects ? _self.projects : projects // ignore: cast_nullable_to_non_nullable
as int,publicItems: null == publicItems ? _self.publicItems : publicItems // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
