// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'fresh.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$Fresh<T> {
  T get entity => throw _privateConstructorUsedError;
  bool? get isNextPageAvailable => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T entity, bool? isNextPageAvailable) yes,
    required TResult Function(T entity, bool? isNextPageAvailable) no,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(T entity, bool? isNextPageAvailable)? yes,
    TResult Function(T entity, bool? isNextPageAvailable)? no,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T entity, bool? isNextPageAvailable)? yes,
    TResult Function(T entity, bool? isNextPageAvailable)? no,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Yes<T> value) yes,
    required TResult Function(_No<T> value) no,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_Yes<T> value)? yes,
    TResult Function(_No<T> value)? no,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Yes<T> value)? yes,
    TResult Function(_No<T> value)? no,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $FreshCopyWith<T, Fresh<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FreshCopyWith<T, $Res> {
  factory $FreshCopyWith(Fresh<T> value, $Res Function(Fresh<T>) then) =
      _$FreshCopyWithImpl<T, $Res>;
  $Res call({T entity, bool? isNextPageAvailable});
}

/// @nodoc
class _$FreshCopyWithImpl<T, $Res> implements $FreshCopyWith<T, $Res> {
  _$FreshCopyWithImpl(this._value, this._then);

  final Fresh<T> _value;
  // ignore: unused_field
  final $Res Function(Fresh<T>) _then;

  @override
  $Res call({
    Object? entity = freezed,
    Object? isNextPageAvailable = freezed,
  }) {
    return _then(_value.copyWith(
      entity: entity == freezed
          ? _value.entity
          : entity // ignore: cast_nullable_to_non_nullable
              as T,
      isNextPageAvailable: isNextPageAvailable == freezed
          ? _value.isNextPageAvailable
          : isNextPageAvailable // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
abstract class _$YesCopyWith<T, $Res> implements $FreshCopyWith<T, $Res> {
  factory _$YesCopyWith(_Yes<T> value, $Res Function(_Yes<T>) then) =
      __$YesCopyWithImpl<T, $Res>;
  @override
  $Res call({T entity, bool? isNextPageAvailable});
}

/// @nodoc
class __$YesCopyWithImpl<T, $Res> extends _$FreshCopyWithImpl<T, $Res>
    implements _$YesCopyWith<T, $Res> {
  __$YesCopyWithImpl(_Yes<T> _value, $Res Function(_Yes<T>) _then)
      : super(_value, (v) => _then(v as _Yes<T>));

  @override
  _Yes<T> get _value => super._value as _Yes<T>;

  @override
  $Res call({
    Object? entity = freezed,
    Object? isNextPageAvailable = freezed,
  }) {
    return _then(_Yes<T>(
      entity == freezed
          ? _value.entity
          : entity // ignore: cast_nullable_to_non_nullable
              as T,
      isNextPageAvailable: isNextPageAvailable == freezed
          ? _value.isNextPageAvailable
          : isNextPageAvailable // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc

class _$_Yes<T> implements _Yes<T> {
  const _$_Yes(this.entity, {this.isNextPageAvailable});

  @override
  final T entity;
  @override
  final bool? isNextPageAvailable;

  @override
  String toString() {
    return 'Fresh<$T>.yes(entity: $entity, isNextPageAvailable: $isNextPageAvailable)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Yes<T> &&
            const DeepCollectionEquality().equals(other.entity, entity) &&
            const DeepCollectionEquality()
                .equals(other.isNextPageAvailable, isNextPageAvailable));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(entity),
      const DeepCollectionEquality().hash(isNextPageAvailable));

  @JsonKey(ignore: true)
  @override
  _$YesCopyWith<T, _Yes<T>> get copyWith =>
      __$YesCopyWithImpl<T, _Yes<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T entity, bool? isNextPageAvailable) yes,
    required TResult Function(T entity, bool? isNextPageAvailable) no,
  }) {
    return yes(entity, isNextPageAvailable);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(T entity, bool? isNextPageAvailable)? yes,
    TResult Function(T entity, bool? isNextPageAvailable)? no,
  }) {
    return yes?.call(entity, isNextPageAvailable);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T entity, bool? isNextPageAvailable)? yes,
    TResult Function(T entity, bool? isNextPageAvailable)? no,
    required TResult orElse(),
  }) {
    if (yes != null) {
      return yes(entity, isNextPageAvailable);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Yes<T> value) yes,
    required TResult Function(_No<T> value) no,
  }) {
    return yes(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_Yes<T> value)? yes,
    TResult Function(_No<T> value)? no,
  }) {
    return yes?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Yes<T> value)? yes,
    TResult Function(_No<T> value)? no,
    required TResult orElse(),
  }) {
    if (yes != null) {
      return yes(this);
    }
    return orElse();
  }
}

abstract class _Yes<T> implements Fresh<T> {
  const factory _Yes(final T entity, {final bool? isNextPageAvailable}) =
      _$_Yes<T>;

  @override
  T get entity => throw _privateConstructorUsedError;
  @override
  bool? get isNextPageAvailable => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$YesCopyWith<T, _Yes<T>> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$NoCopyWith<T, $Res> implements $FreshCopyWith<T, $Res> {
  factory _$NoCopyWith(_No<T> value, $Res Function(_No<T>) then) =
      __$NoCopyWithImpl<T, $Res>;
  @override
  $Res call({T entity, bool? isNextPageAvailable});
}

/// @nodoc
class __$NoCopyWithImpl<T, $Res> extends _$FreshCopyWithImpl<T, $Res>
    implements _$NoCopyWith<T, $Res> {
  __$NoCopyWithImpl(_No<T> _value, $Res Function(_No<T>) _then)
      : super(_value, (v) => _then(v as _No<T>));

  @override
  _No<T> get _value => super._value as _No<T>;

  @override
  $Res call({
    Object? entity = freezed,
    Object? isNextPageAvailable = freezed,
  }) {
    return _then(_No<T>(
      entity == freezed
          ? _value.entity
          : entity // ignore: cast_nullable_to_non_nullable
              as T,
      isNextPageAvailable: isNextPageAvailable == freezed
          ? _value.isNextPageAvailable
          : isNextPageAvailable // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc

class _$_No<T> implements _No<T> {
  const _$_No(this.entity, {this.isNextPageAvailable});

  @override
  final T entity;
  @override
  final bool? isNextPageAvailable;

  @override
  String toString() {
    return 'Fresh<$T>.no(entity: $entity, isNextPageAvailable: $isNextPageAvailable)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _No<T> &&
            const DeepCollectionEquality().equals(other.entity, entity) &&
            const DeepCollectionEquality()
                .equals(other.isNextPageAvailable, isNextPageAvailable));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(entity),
      const DeepCollectionEquality().hash(isNextPageAvailable));

  @JsonKey(ignore: true)
  @override
  _$NoCopyWith<T, _No<T>> get copyWith =>
      __$NoCopyWithImpl<T, _No<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T entity, bool? isNextPageAvailable) yes,
    required TResult Function(T entity, bool? isNextPageAvailable) no,
  }) {
    return no(entity, isNextPageAvailable);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(T entity, bool? isNextPageAvailable)? yes,
    TResult Function(T entity, bool? isNextPageAvailable)? no,
  }) {
    return no?.call(entity, isNextPageAvailable);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T entity, bool? isNextPageAvailable)? yes,
    TResult Function(T entity, bool? isNextPageAvailable)? no,
    required TResult orElse(),
  }) {
    if (no != null) {
      return no(entity, isNextPageAvailable);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Yes<T> value) yes,
    required TResult Function(_No<T> value) no,
  }) {
    return no(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_Yes<T> value)? yes,
    TResult Function(_No<T> value)? no,
  }) {
    return no?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Yes<T> value)? yes,
    TResult Function(_No<T> value)? no,
    required TResult orElse(),
  }) {
    if (no != null) {
      return no(this);
    }
    return orElse();
  }
}

abstract class _No<T> implements Fresh<T> {
  const factory _No(final T entity, {final bool? isNextPageAvailable}) =
      _$_No<T>;

  @override
  T get entity => throw _privateConstructorUsedError;
  @override
  bool? get isNextPageAvailable => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$NoCopyWith<T, _No<T>> get copyWith => throw _privateConstructorUsedError;
}
