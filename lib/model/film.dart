const String tableFilms = 'films';

class FilmFields {
  static final List<String> values = [
    id, title, coverLink, description, createdTime
  ];

  static const String id = '_id';
  static const String title = 'title';
  static const String number = 'number';
  static const String coverLink = 'coverLink';
  static const String createdTime = 'createdTime';
  static const String description = 'description';
}

class Film {
  final int? id;
  final String title;
  final int number;
  final String coverLink;
  final String description;
  final DateTime createdTime;

  const Film({
    this.id,
    required this.title,
    required this.number,
    required this.coverLink,
    required this.description,
    required this.createdTime,
  });

  Film copy({
    int? id,
    String? title,
    String? coverLink,
    int? number,
    String? description,
    DateTime? createdTime,
  }) =>
      Film(
        id: id ?? this.id,
        title: title ?? this.title,
        number: this.number,
        coverLink: coverLink ?? this.coverLink,
        description: description ?? this.description,
        createdTime: createdTime ?? this.createdTime,
      );

  static Film fromJson(Map<String, Object?> json) => Film(
    id: json[FilmFields.id] as int?,
    number: json[FilmFields.number] as int,
    title: json[FilmFields.title] as String,
    coverLink: json[FilmFields.coverLink] as String,
    description: json[FilmFields.description] as String,
    createdTime: DateTime.parse(json[FilmFields.createdTime] as String),
  );

  Map<String, Object?> toJson() => {
    FilmFields.id: id,
    FilmFields.title: title,
    FilmFields.coverLink: coverLink,
    FilmFields.description: description,
    FilmFields.createdTime: createdTime.toIso8601String(),
  };
}