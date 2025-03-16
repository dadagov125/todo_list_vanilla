import 'dart:async';

export 'pick_file_use_case.dart';

abstract class UseCase<Result, Params> {
  FutureOr<Result> execute([Params? params]);
}

abstract class UseCaseStream<Result, Params> {
  Stream<Result> execute([Params? params]);
}
