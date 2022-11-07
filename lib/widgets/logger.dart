import 'dart:developer';

void logger({
  required Object? error,
  required StackTrace? st,
  String masasge = 'Something went wrong',
  String name = 'log',
}) {
  return log(
    masasge,
    name: name,
    error: error ?? 'unknown',
    stackTrace: st ?? StackTrace.current,
  );
}
