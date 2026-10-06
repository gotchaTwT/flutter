
class Course {
  final int? id;
  final String code;
  final String name;

  const Course({this.id, required this.code, required this.name});

  factory Course.fromMap(Map<String, dynamic> map) => Course(
        id: map['id'] as int?,
        code: map['course_code'] as String,
        name: map['course_name'] as String,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'course_code': code,
        'course_name': name,
      };
}

