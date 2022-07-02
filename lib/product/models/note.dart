import 'dart:convert';

class Note {
  final String title;
  final String content;
  final DateTime date;
  final int colorIndex;

  Note(
    this.title,
    this.content,
    this.date,
    this.colorIndex,
  );

  Note copyWith({
    String? title,
    String? content,
    DateTime? date,
    int? colorIndex,
  }) {
    return Note(
      title ?? this.title,
      content ?? this.content,
      date ?? this.date,
      colorIndex ?? this.colorIndex,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'title': title});
    result.addAll({'content': content});
    result.addAll({'date': date.millisecondsSinceEpoch});
    result.addAll({'colorIndex': colorIndex});

    return result;
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      map['title'] ?? '',
      map['content'] ?? '',
      DateTime.fromMillisecondsSinceEpoch(map['date']),
      map['colorIndex']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Note.fromJson(String source) => Note.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Note(title: $title, content: $content, date: $date, colorIndex: $colorIndex)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Note &&
        other.title == title &&
        other.content == content &&
        other.date == date &&
        other.colorIndex == colorIndex;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        content.hashCode ^
        date.hashCode ^
        colorIndex.hashCode;
  }
}
