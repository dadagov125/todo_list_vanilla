import 'dart:async';

abstract class UseCase<Result, Params> {
  FutureOr<Result> execute([Params? params]);
}

abstract class UseCaseStream<Result, Params> {
  Stream<Result> execute([Params? params]);
}
