import 'dart:developer';

Future<T> handleError<T>(Object obj) {
  log(obj.toString());
  log(obj.runtimeType.toString());
  throw Exception();
}