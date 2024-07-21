class AppFailure {
  final String message;

  AppFailure(
      [this.message =
          "Sorry, an unexpected error occurred. Please try again later."]);

  @override
  String toString() => message;
}
