sealed class AppState<T> {}

class Loading<T> extends AppState<T> {}

class Success<T> extends AppState<T> {
  final T data;
  Success(this.data);
}

class Error<T> extends AppState<T> {
  final String message;
  Error(this.message);
}
