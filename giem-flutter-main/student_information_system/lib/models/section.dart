
class Section {
  final int? id;
  final String name;
  final int yearLevel;

  const Section({this.id, required this.name, required this.yearLevel});

  factory Section.fromMap(Map<String, dynamic> map) => Section(
        id: map['id'] as int?,
        name: map['section_name'] as String,
        yearLevel: map['year_level'] as int,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'section_name': name,
        'year_level': yearLevel,
      };
}

