// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AudioTimer {
  int minutes;
  int seconds;
  AudioTimer({
    required this.minutes,
    required this.seconds,
  });

  AudioTimer copyWith({
    int? minutes,
    int? seconds,
  }) {
    return AudioTimer(
      minutes: minutes ?? this.minutes,
      seconds: seconds ?? this.seconds,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'minutes': minutes,
      'seconds': seconds,
    };
  }

  factory AudioTimer.fromMap(Map<String, dynamic> map) {
    return AudioTimer(
      minutes: map['minutes'] as int,
      seconds: map['seconds'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory AudioTimer.fromJson(String source) =>
      AudioTimer.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'AudioTimer(minutes: $minutes, seconds: $seconds)';

  @override
  bool operator ==(covariant AudioTimer other) {
    if (identical(this, other)) return true;

    return other.minutes == minutes && other.seconds == seconds;
  }

  @override
  int get hashCode => minutes.hashCode ^ seconds.hashCode;
}
