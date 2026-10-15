// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'character_scope.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CharacterScope {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CharacterScope);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CharacterScope()';
}


}

/// @nodoc
class $CharacterScopeCopyWith<$Res>  {
$CharacterScopeCopyWith(CharacterScope _, $Res Function(CharacterScope) __);
}


/// Adds pattern-matching-related methods to [CharacterScope].
extension CharacterScopePatterns on CharacterScope {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AllCharacters value)?  all,TResult Function( LibraryCharacters value)?  library,TResult Function( ProjectCharacters value)?  project,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AllCharacters() when all != null:
return all(_that);case LibraryCharacters() when library != null:
return library(_that);case ProjectCharacters() when project != null:
return project(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AllCharacters value)  all,required TResult Function( LibraryCharacters value)  library,required TResult Function( ProjectCharacters value)  project,}){
final _that = this;
switch (_that) {
case AllCharacters():
return all(_that);case LibraryCharacters():
return library(_that);case ProjectCharacters():
return project(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AllCharacters value)?  all,TResult? Function( LibraryCharacters value)?  library,TResult? Function( ProjectCharacters value)?  project,}){
final _that = this;
switch (_that) {
case AllCharacters() when all != null:
return all(_that);case LibraryCharacters() when library != null:
return library(_that);case ProjectCharacters() when project != null:
return project(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  all,TResult Function()?  library,TResult Function( int id,  String name)?  project,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AllCharacters() when all != null:
return all();case LibraryCharacters() when library != null:
return library();case ProjectCharacters() when project != null:
return project(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  all,required TResult Function()  library,required TResult Function( int id,  String name)  project,}) {final _that = this;
switch (_that) {
case AllCharacters():
return all();case LibraryCharacters():
return library();case ProjectCharacters():
return project(_that.id,_that.name);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  all,TResult? Function()?  library,TResult? Function( int id,  String name)?  project,}) {final _that = this;
switch (_that) {
case AllCharacters() when all != null:
return all();case LibraryCharacters() when library != null:
return library();case ProjectCharacters() when project != null:
return project(_that.id,_that.name);case _:
  return null;

}
}

}

/// @nodoc


class AllCharacters implements CharacterScope {
  const AllCharacters();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AllCharacters);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CharacterScope.all()';
}


}




/// @nodoc


class LibraryCharacters implements CharacterScope {
  const LibraryCharacters();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LibraryCharacters);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CharacterScope.library()';
}


}




/// @nodoc


class ProjectCharacters implements CharacterScope {
  const ProjectCharacters({required this.id, required this.name});
  

 final  int id;
 final  String name;

/// Create a copy of CharacterScope
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectCharactersCopyWith<ProjectCharacters> get copyWith => _$ProjectCharactersCopyWithImpl<ProjectCharacters>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectCharacters&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'CharacterScope.project(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class $ProjectCharactersCopyWith<$Res> implements $CharacterScopeCopyWith<$Res> {
  factory $ProjectCharactersCopyWith(ProjectCharacters value, $Res Function(ProjectCharacters) _then) = _$ProjectCharactersCopyWithImpl;
@useResult
$Res call({
 int id, String name
});




}
/// @nodoc
class _$ProjectCharactersCopyWithImpl<$Res>
    implements $ProjectCharactersCopyWith<$Res> {
  _$ProjectCharactersCopyWithImpl(this._self, this._then);

  final ProjectCharacters _self;
  final $Res Function(ProjectCharacters) _then;

/// Create a copy of CharacterScope
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,}) {
  return _then(ProjectCharacters(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
