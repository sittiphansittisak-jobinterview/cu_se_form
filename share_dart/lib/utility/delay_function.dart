Future<T> delayedFunction<T>({required T Function() function, int milliseconds = 500}) async {
  final startTime = DateTime.now().millisecondsSinceEpoch;
  final result = function();
  final elapsedTime = DateTime.now().millisecondsSinceEpoch - startTime;
  if (elapsedTime < milliseconds) await Future.delayed(Duration(milliseconds: milliseconds - elapsedTime));
  return result;
}
