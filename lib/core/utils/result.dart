/// Kleine Result-type voor service-calls zonder exceptions door te lekken.
sealed class Result<T> {
  const Result();

  R when<R>({
    required R Function(T data) success,
    required R Function(String message) failure,
  }) {
    final self = this;
    return switch (self) {
      Success<T>() => success(self.data),
      Failure<T>() => failure(self.message),
    };
  }

  T? get dataOrNull => this is Success<T> ? (this as Success<T>).data : null;
}

class Success<T> extends Result<T> {
  const Success(this.data);
  final T data;
}

class Failure<T> extends Result<T> {
  const Failure(this.message);
  final String message;
}
