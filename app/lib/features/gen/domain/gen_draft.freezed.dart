// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gen_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GenPresetDraft {

 String get name; Map<String, List<GenTag>> get tags; List<String> get negative; List<GenLoraUse> get loras;
/// Create a copy of GenPresetDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GenPresetDraftCopyWith<GenPresetDraft> get copyWith => _$GenPresetDraftCopyWithImpl<GenPresetDraft>(this as GenPresetDraft, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GenPresetDraft&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.tags, tags)&&const DeepCollectionEquality().equals(other.negative, negative)&&const DeepCollectionEquality().equals(other.loras, loras));
}


@override
int get hashCode => Object.hash(runtimeType,name,const DeepCollectionEquality().hash(tags),const DeepCollectionEquality().hash(negative),const DeepCollectionEquality().hash(loras));

@override
String toString() {
  return 'GenPresetDraft(name: $name, tags: $tags, negative: $negative, loras: $loras)';
}


}

/// @nodoc
abstract mixin class $GenPresetDraftCopyWith<$Res>  {
  factory $GenPresetDraftCopyWith(GenPresetDraft value, $Res Function(GenPresetDraft) _then) = _$GenPresetDraftCopyWithImpl;
@useResult
$Res call({
 String name, Map<String, List<GenTag>> tags, List<String> negative, List<GenLoraUse> loras
});




}
/// @nodoc
class _$GenPresetDraftCopyWithImpl<$Res>
    implements $GenPresetDraftCopyWith<$Res> {
  _$GenPresetDraftCopyWithImpl(this._self, this._then);

  final GenPresetDraft _self;
  final $Res Function(GenPresetDraft) _then;

/// Create a copy of GenPresetDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? tags = null,Object? negative = null,Object? loras = null,}) {
  return _then(GenPresetDraft(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as Map<String, List<GenTag>>,negative: null == negative ? _self.negative : negative // ignore: cast_nullable_to_non_nullable
as List<String>,loras: null == loras ? _self.loras : loras // ignore: cast_nullable_to_non_nullable
as List<GenLoraUse>,
  ));
}

}


/// Adds pattern-matching-related methods to [GenPresetDraft].
extension GenPresetDraftPatterns on GenPresetDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GenPresetDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GenPresetDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GenPresetDraft value)  $default,){
final _that = this;
switch (_that) {
case _GenPresetDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GenPresetDraft value)?  $default,){
final _that = this;
switch (_that) {
case _GenPresetDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  Map<String, List<GenTag>> tags,  List<String> negative,  List<GenLoraUse> loras)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GenPresetDraft() when $default != null:
return $default(_that.name,_that.tags,_that.negative,_that.loras);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  Map<String, List<GenTag>> tags,  List<String> negative,  List<GenLoraUse> loras)  $default,) {final _that = this;
switch (_that) {
case _GenPresetDraft():
return $default(_that.name,_that.tags,_that.negative,_that.loras);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  Map<String, List<GenTag>> tags,  List<String> negative,  List<GenLoraUse> loras)?  $default,) {final _that = this;
switch (_that) {
case _GenPresetDraft() when $default != null:
return $default(_that.name,_that.tags,_that.negative,_that.loras);case _:
  return null;

}
}

}

/// @nodoc


class _GenPresetDraft extends GenPresetDraft {
  const _GenPresetDraft({this.name = '',  Map<String, List<GenTag>> tags = const {},  List<String> negative = const [],  List<GenLoraUse> loras = const []}): _tags = tags,_negative = negative,_loras = loras,super._();
  

@override@JsonKey() final  String name;
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


/// Create a copy of GenPresetDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GenPresetDraftCopyWith<_GenPresetDraft> get copyWith => __$GenPresetDraftCopyWithImpl<_GenPresetDraft>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GenPresetDraft&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._tags, _tags)&&const DeepCollectionEquality().equals(other._negative, _negative)&&const DeepCollectionEquality().equals(other._loras, _loras));
}


@override
int get hashCode => Object.hash(runtimeType,name,const DeepCollectionEquality().hash(_tags),const DeepCollectionEquality().hash(_negative),const DeepCollectionEquality().hash(_loras));

@override
String toString() {
  return 'GenPresetDraft(name: $name, tags: $tags, negative: $negative, loras: $loras)';
}


}

/// @nodoc
abstract mixin class _$GenPresetDraftCopyWith<$Res> implements $GenPresetDraftCopyWith<$Res> {
  factory _$GenPresetDraftCopyWith(_GenPresetDraft value, $Res Function(_GenPresetDraft) _then) = __$GenPresetDraftCopyWithImpl;
@override @useResult
$Res call({
 String name, Map<String, List<GenTag>> tags, List<String> negative, List<GenLoraUse> loras
});




}
/// @nodoc
class __$GenPresetDraftCopyWithImpl<$Res>
    implements _$GenPresetDraftCopyWith<$Res> {
  __$GenPresetDraftCopyWithImpl(this._self, this._then);

  final _GenPresetDraft _self;
  final $Res Function(_GenPresetDraft) _then;

/// Create a copy of GenPresetDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? tags = null,Object? negative = null,Object? loras = null,}) {
  return _then(_GenPresetDraft(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as Map<String, List<GenTag>>,negative: null == negative ? _self._negative : negative // ignore: cast_nullable_to_non_nullable
as List<String>,loras: null == loras ? _self._loras : loras // ignore: cast_nullable_to_non_nullable
as List<GenLoraUse>,
  ));
}


}

/// @nodoc
mixin _$GenRecordDraft {

 int? get assetId; String? get platform; String? get model; int? get genPresetId; String get title; String get promptRaw; Map<String, List<GenTag>> get tags; List<String> get negative; List<GenLoraUse> get loras; int? get seed; String? get sampler; int? get steps; double? get cfgScale; int? get width; int? get height; String get note; bool get isCover; Map<String, Object?> get extra;
/// Create a copy of GenRecordDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GenRecordDraftCopyWith<GenRecordDraft> get copyWith => _$GenRecordDraftCopyWithImpl<GenRecordDraft>(this as GenRecordDraft, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GenRecordDraft&&(identical(other.assetId, assetId) || other.assetId == assetId)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.model, model) || other.model == model)&&(identical(other.genPresetId, genPresetId) || other.genPresetId == genPresetId)&&(identical(other.title, title) || other.title == title)&&(identical(other.promptRaw, promptRaw) || other.promptRaw == promptRaw)&&const DeepCollectionEquality().equals(other.tags, tags)&&const DeepCollectionEquality().equals(other.negative, negative)&&const DeepCollectionEquality().equals(other.loras, loras)&&(identical(other.seed, seed) || other.seed == seed)&&(identical(other.sampler, sampler) || other.sampler == sampler)&&(identical(other.steps, steps) || other.steps == steps)&&(identical(other.cfgScale, cfgScale) || other.cfgScale == cfgScale)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.note, note) || other.note == note)&&(identical(other.isCover, isCover) || other.isCover == isCover)&&const DeepCollectionEquality().equals(other.extra, extra));
}


@override
int get hashCode => Object.hash(runtimeType,assetId,platform,model,genPresetId,title,promptRaw,const DeepCollectionEquality().hash(tags),const DeepCollectionEquality().hash(negative),const DeepCollectionEquality().hash(loras),seed,sampler,steps,cfgScale,width,height,note,isCover,const DeepCollectionEquality().hash(extra));

@override
String toString() {
  return 'GenRecordDraft(assetId: $assetId, platform: $platform, model: $model, genPresetId: $genPresetId, title: $title, promptRaw: $promptRaw, tags: $tags, negative: $negative, loras: $loras, seed: $seed, sampler: $sampler, steps: $steps, cfgScale: $cfgScale, width: $width, height: $height, note: $note, isCover: $isCover, extra: $extra)';
}


}

/// @nodoc
abstract mixin class $GenRecordDraftCopyWith<$Res>  {
  factory $GenRecordDraftCopyWith(GenRecordDraft value, $Res Function(GenRecordDraft) _then) = _$GenRecordDraftCopyWithImpl;
@useResult
$Res call({
 int? assetId, String? platform, String? model, int? genPresetId, String title, String promptRaw, Map<String, List<GenTag>> tags, List<String> negative, List<GenLoraUse> loras, int? seed, String? sampler, int? steps, double? cfgScale, int? width, int? height, String note, bool isCover, Map<String, Object?> extra
});




}
/// @nodoc
class _$GenRecordDraftCopyWithImpl<$Res>
    implements $GenRecordDraftCopyWith<$Res> {
  _$GenRecordDraftCopyWithImpl(this._self, this._then);

  final GenRecordDraft _self;
  final $Res Function(GenRecordDraft) _then;

/// Create a copy of GenRecordDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? assetId = freezed,Object? platform = freezed,Object? model = freezed,Object? genPresetId = freezed,Object? title = null,Object? promptRaw = null,Object? tags = null,Object? negative = null,Object? loras = null,Object? seed = freezed,Object? sampler = freezed,Object? steps = freezed,Object? cfgScale = freezed,Object? width = freezed,Object? height = freezed,Object? note = null,Object? isCover = null,Object? extra = null,}) {
  return _then(GenRecordDraft(
assetId: freezed == assetId ? _self.assetId : assetId // ignore: cast_nullable_to_non_nullable
as int?,platform: freezed == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String?,model: freezed == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String?,genPresetId: freezed == genPresetId ? _self.genPresetId : genPresetId // ignore: cast_nullable_to_non_nullable
as int?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,promptRaw: null == promptRaw ? _self.promptRaw : promptRaw // ignore: cast_nullable_to_non_nullable
as String,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as Map<String, List<GenTag>>,negative: null == negative ? _self.negative : negative // ignore: cast_nullable_to_non_nullable
as List<String>,loras: null == loras ? _self.loras : loras // ignore: cast_nullable_to_non_nullable
as List<GenLoraUse>,seed: freezed == seed ? _self.seed : seed // ignore: cast_nullable_to_non_nullable
as int?,sampler: freezed == sampler ? _self.sampler : sampler // ignore: cast_nullable_to_non_nullable
as String?,steps: freezed == steps ? _self.steps : steps // ignore: cast_nullable_to_non_nullable
as int?,cfgScale: freezed == cfgScale ? _self.cfgScale : cfgScale // ignore: cast_nullable_to_non_nullable
as double?,width: freezed == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int?,height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int?,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,isCover: null == isCover ? _self.isCover : isCover // ignore: cast_nullable_to_non_nullable
as bool,extra: null == extra ? _self.extra : extra // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}

}


/// Adds pattern-matching-related methods to [GenRecordDraft].
extension GenRecordDraftPatterns on GenRecordDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GenRecordDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GenRecordDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GenRecordDraft value)  $default,){
final _that = this;
switch (_that) {
case _GenRecordDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GenRecordDraft value)?  $default,){
final _that = this;
switch (_that) {
case _GenRecordDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? assetId,  String? platform,  String? model,  int? genPresetId,  String title,  String promptRaw,  Map<String, List<GenTag>> tags,  List<String> negative,  List<GenLoraUse> loras,  int? seed,  String? sampler,  int? steps,  double? cfgScale,  int? width,  int? height,  String note,  bool isCover,  Map<String, Object?> extra)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GenRecordDraft() when $default != null:
return $default(_that.assetId,_that.platform,_that.model,_that.genPresetId,_that.title,_that.promptRaw,_that.tags,_that.negative,_that.loras,_that.seed,_that.sampler,_that.steps,_that.cfgScale,_that.width,_that.height,_that.note,_that.isCover,_that.extra);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? assetId,  String? platform,  String? model,  int? genPresetId,  String title,  String promptRaw,  Map<String, List<GenTag>> tags,  List<String> negative,  List<GenLoraUse> loras,  int? seed,  String? sampler,  int? steps,  double? cfgScale,  int? width,  int? height,  String note,  bool isCover,  Map<String, Object?> extra)  $default,) {final _that = this;
switch (_that) {
case _GenRecordDraft():
return $default(_that.assetId,_that.platform,_that.model,_that.genPresetId,_that.title,_that.promptRaw,_that.tags,_that.negative,_that.loras,_that.seed,_that.sampler,_that.steps,_that.cfgScale,_that.width,_that.height,_that.note,_that.isCover,_that.extra);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? assetId,  String? platform,  String? model,  int? genPresetId,  String title,  String promptRaw,  Map<String, List<GenTag>> tags,  List<String> negative,  List<GenLoraUse> loras,  int? seed,  String? sampler,  int? steps,  double? cfgScale,  int? width,  int? height,  String note,  bool isCover,  Map<String, Object?> extra)?  $default,) {final _that = this;
switch (_that) {
case _GenRecordDraft() when $default != null:
return $default(_that.assetId,_that.platform,_that.model,_that.genPresetId,_that.title,_that.promptRaw,_that.tags,_that.negative,_that.loras,_that.seed,_that.sampler,_that.steps,_that.cfgScale,_that.width,_that.height,_that.note,_that.isCover,_that.extra);case _:
  return null;

}
}

}

/// @nodoc


class _GenRecordDraft extends GenRecordDraft {
  const _GenRecordDraft({this.assetId, this.platform, this.model, this.genPresetId, this.title = '', this.promptRaw = '',  Map<String, List<GenTag>> tags = const {},  List<String> negative = const [],  List<GenLoraUse> loras = const [], this.seed, this.sampler, this.steps, this.cfgScale, this.width, this.height, this.note = '', this.isCover = false,  Map<String, Object?> extra = const {}}): _tags = tags,_negative = negative,_loras = loras,_extra = extra,super._();
  

@override final  int? assetId;
@override final  String? platform;
@override final  String? model;
@override final  int? genPresetId;
@override@JsonKey() final  String title;
@override@JsonKey() final  String promptRaw;
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
@override@JsonKey() final  String note;
@override@JsonKey() final  bool isCover;
 final  Map<String, Object?> _extra;
@override@JsonKey() Map<String, Object?> get extra {
  if (_extra is EqualUnmodifiableMapView) return _extra;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_extra);
}


/// Create a copy of GenRecordDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GenRecordDraftCopyWith<_GenRecordDraft> get copyWith => __$GenRecordDraftCopyWithImpl<_GenRecordDraft>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GenRecordDraft&&(identical(other.assetId, assetId) || other.assetId == assetId)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.model, model) || other.model == model)&&(identical(other.genPresetId, genPresetId) || other.genPresetId == genPresetId)&&(identical(other.title, title) || other.title == title)&&(identical(other.promptRaw, promptRaw) || other.promptRaw == promptRaw)&&const DeepCollectionEquality().equals(other._tags, _tags)&&const DeepCollectionEquality().equals(other._negative, _negative)&&const DeepCollectionEquality().equals(other._loras, _loras)&&(identical(other.seed, seed) || other.seed == seed)&&(identical(other.sampler, sampler) || other.sampler == sampler)&&(identical(other.steps, steps) || other.steps == steps)&&(identical(other.cfgScale, cfgScale) || other.cfgScale == cfgScale)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.note, note) || other.note == note)&&(identical(other.isCover, isCover) || other.isCover == isCover)&&const DeepCollectionEquality().equals(other._extra, _extra));
}


@override
int get hashCode => Object.hash(runtimeType,assetId,platform,model,genPresetId,title,promptRaw,const DeepCollectionEquality().hash(_tags),const DeepCollectionEquality().hash(_negative),const DeepCollectionEquality().hash(_loras),seed,sampler,steps,cfgScale,width,height,note,isCover,const DeepCollectionEquality().hash(_extra));

@override
String toString() {
  return 'GenRecordDraft(assetId: $assetId, platform: $platform, model: $model, genPresetId: $genPresetId, title: $title, promptRaw: $promptRaw, tags: $tags, negative: $negative, loras: $loras, seed: $seed, sampler: $sampler, steps: $steps, cfgScale: $cfgScale, width: $width, height: $height, note: $note, isCover: $isCover, extra: $extra)';
}


}

/// @nodoc
abstract mixin class _$GenRecordDraftCopyWith<$Res> implements $GenRecordDraftCopyWith<$Res> {
  factory _$GenRecordDraftCopyWith(_GenRecordDraft value, $Res Function(_GenRecordDraft) _then) = __$GenRecordDraftCopyWithImpl;
@override @useResult
$Res call({
 int? assetId, String? platform, String? model, int? genPresetId, String title, String promptRaw, Map<String, List<GenTag>> tags, List<String> negative, List<GenLoraUse> loras, int? seed, String? sampler, int? steps, double? cfgScale, int? width, int? height, String note, bool isCover, Map<String, Object?> extra
});




}
/// @nodoc
class __$GenRecordDraftCopyWithImpl<$Res>
    implements _$GenRecordDraftCopyWith<$Res> {
  __$GenRecordDraftCopyWithImpl(this._self, this._then);

  final _GenRecordDraft _self;
  final $Res Function(_GenRecordDraft) _then;

/// Create a copy of GenRecordDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? assetId = freezed,Object? platform = freezed,Object? model = freezed,Object? genPresetId = freezed,Object? title = null,Object? promptRaw = null,Object? tags = null,Object? negative = null,Object? loras = null,Object? seed = freezed,Object? sampler = freezed,Object? steps = freezed,Object? cfgScale = freezed,Object? width = freezed,Object? height = freezed,Object? note = null,Object? isCover = null,Object? extra = null,}) {
  return _then(_GenRecordDraft(
assetId: freezed == assetId ? _self.assetId : assetId // ignore: cast_nullable_to_non_nullable
as int?,platform: freezed == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String?,model: freezed == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String?,genPresetId: freezed == genPresetId ? _self.genPresetId : genPresetId // ignore: cast_nullable_to_non_nullable
as int?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,promptRaw: null == promptRaw ? _self.promptRaw : promptRaw // ignore: cast_nullable_to_non_nullable
as String,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as Map<String, List<GenTag>>,negative: null == negative ? _self._negative : negative // ignore: cast_nullable_to_non_nullable
as List<String>,loras: null == loras ? _self._loras : loras // ignore: cast_nullable_to_non_nullable
as List<GenLoraUse>,seed: freezed == seed ? _self.seed : seed // ignore: cast_nullable_to_non_nullable
as int?,sampler: freezed == sampler ? _self.sampler : sampler // ignore: cast_nullable_to_non_nullable
as String?,steps: freezed == steps ? _self.steps : steps // ignore: cast_nullable_to_non_nullable
as int?,cfgScale: freezed == cfgScale ? _self.cfgScale : cfgScale // ignore: cast_nullable_to_non_nullable
as double?,width: freezed == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int?,height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int?,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,isCover: null == isCover ? _self.isCover : isCover // ignore: cast_nullable_to_non_nullable
as bool,extra: null == extra ? _self._extra : extra // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}


}

// dart format on
