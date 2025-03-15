sealed class AsyncS<T> {
  AsyncS({
    this.data,
    this.error,
  });

  factory AsyncS.initial(T? data, {Object? error}) =>
      InitialS(data: data, error: error);

  factory AsyncS.loading(AsyncS<T> prevState, {isReloading = false}) =>
      LoadingS(
        data: prevState.data,
        error: prevState.error,
        isReloading: isReloading,
      );

  factory AsyncS.loaded(T data, {Object? error}) =>
      LoadedS(data: data, error: error);

  factory AsyncS.error(Object error, {T? data}) =>
      ErrorS(error: error, data: data);

  final T? data;
  final Object? error;

  bool get isInitial => this is InitialS<T>;

  bool get isLoading => this is LoadingS<T>;

  bool get isLoaded => this is LoadedS<T>;

  bool get isError => this is ErrorS<T>;

  R map<R>({
    required R Function(InitialS<R>) initial,
    required R Function(LoadingS<R>) loading,
    required R Function(LoadedS<R>) loaded,
    required R Function(ErrorS<R>) error,
  }) =>
      switch (this) {
        final InitialS<R> state => initial(state),
        final LoadingS<R> state => loading(state),
        final LoadedS<R> state => loaded(state),
        final ErrorS<R> state => error(state),
        _ => throw UnimplementedError(),
      };

  R maybeMap<R>({
    required R Function(InitialS<R>)? initial,
    required R Function(LoadingS<R>)? loading,
    required R Function(LoadedS<R>)? loaded,
    required R Function(ErrorS<R>)? error,
    required R Function() orElse,
  }) =>
      switch (this) {
        final InitialS<R> state => initial?.call(state) ?? orElse(),
        final LoadingS<R> state => loading?.call(state) ?? orElse(),
        final LoadedS<R> state => loaded?.call(state) ?? orElse(),
        final ErrorS<R> state => error?.call(state) ?? orElse(),
        _ => orElse(),
      };

  R? mapOrNull<R>({
    R Function(InitialS<R>)? initial,
    R Function(LoadingS<R>)? loading,
    R Function(LoadedS<R>)? loaded,
    R Function(ErrorS<R>)? error,
  }) =>
      switch (this) {
        final InitialS<R> state => initial?.call(state),
        final LoadingS<R> state => loading?.call(state),
        final LoadedS<R> state => loaded?.call(state),
        final ErrorS<R> state => error?.call(state),
        _ => null,
      };
}

final class InitialS<T> extends AsyncS<T> {
  InitialS({super.data, super.error});
}

final class LoadingS<T> extends AsyncS<T> {
  LoadingS({
    super.data,
    super.error,
    this.isReloading = false,
  });

  final bool isReloading;
}

final class LoadedS<T> extends AsyncS<T> {
  LoadedS({
    required super.data,
    super.error,
  });

  @override
  T get data => super.data!;
}

final class ErrorS<T> extends AsyncS<T> {
  ErrorS({
    required super.error,
    super.data,
  });

  @override
  Object get error => super.error!;
}
