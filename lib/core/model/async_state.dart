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
    required R Function(InitialS<T>) initial,
    required R Function(LoadingS<T>) loading,
    required R Function(LoadedS<T>) loaded,
    required R Function(ErrorS<T>) error,
  }) =>
      switch (this) {
        final InitialS<T> state => initial(state),
        final LoadingS<T> state => loading(state),
        final LoadedS<T> state => loaded(state),
        final ErrorS<T> state => error(state),
      };

  R maybeMap<R>({
    required R Function() orElse,
    R Function(InitialS<T>)? initial,
    R Function(LoadingS<T>)? loading,
    R Function(LoadedS<T>)? loaded,
    R Function(ErrorS<T>)? error,
  }) =>
      switch (this) {
        final InitialS<T> state => initial?.call(state) ?? orElse(),
        final LoadingS<T> state => loading?.call(state) ?? orElse(),
        final LoadedS<T> state => loaded?.call(state) ?? orElse(),
        final ErrorS<T> state => error?.call(state) ?? orElse(),
      };

  R? mapOrNull<R>({
    R Function(InitialS<T>)? initial,
    R Function(LoadingS<T>)? loading,
    R Function(LoadedS<T>)? loaded,
    R Function(ErrorS<T>)? error,
  }) =>
      switch (this) {
        final InitialS<T> state => initial?.call(state),
        final LoadingS<T> state => loading?.call(state),
        final LoadedS<T> state => loaded?.call(state),
        final ErrorS<T> state => error?.call(state),
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
