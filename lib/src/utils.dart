class Utils {
  Utils._();

  static String formatTime(Duration duration) {
    String milliseconds =
        toDigits(duration.inMilliseconds.remainder(100).abs());
    String seconds = toDigits(duration.inSeconds.remainder(60).abs());
    String minutes = toDigits(duration.inMinutes);
    return "$minutes:$seconds:$milliseconds";
  }

  static String toDigits(num number, {int qtdDigits = 2}) {
    return number.toString().padLeft(qtdDigits, "0");
  }
}
