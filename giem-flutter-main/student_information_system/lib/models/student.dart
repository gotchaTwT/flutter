
class Student {
  final int? id;
  final String studentId;
  final String firstName;
  final String middleName;
  final String lastName;
  final String gender;
  final String birthDate;
  final String email;
  final String phone;
  final String address;
  final int courseId;
  final int yearLevel;
  final int sectionId;
  final String status;
  final String dateEnrolled;
  final String createdAt;
  final String updatedAt;

  const Student({
    this.id,
    required this.studentId,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.gender,
    required this.birthDate,
    required this.email,
    required this.phone,
    required this.address,
    required this.courseId,
    required this.yearLevel,
    required this.sectionId,
    required this.status,
    required this.dateEnrolled,
    required this.createdAt,
    required this.updatedAt,
  });

  String get fullName =>
      '$firstName $middleName $lastName'.replaceAll(RegExp(r'\s+'), ' ').trim();

  factory Student.fromMap(Map<String, dynamic> map) => Student(
        id: map['id'] as int?,
        studentId: map['student_id'] as String,
        firstName: map['first_name'] as String,
        middleName: (map['middle_name'] ?? '') as String,
        lastName: map['last_name'] as String,
        gender: map['gender'] as String,
        birthDate: map['birth_date'] as String,
        email: map['email'] as String,
        phone: map['phone'] as String,
        address: map['address'] as String,
        courseId: map['course_id'] as int,
        yearLevel: map['year_level'] as int,
        sectionId: map['section_id'] as int,
        status: map['status'] as String,
        dateEnrolled: map['date_enrolled'] as String,
        createdAt: map['created_at'] as String,
        updatedAt: map['updated_at'] as String,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'student_id': studentId,
        'first_name': firstName,
        'middle_name': middleName,
        'last_name': lastName,
        'gender': gender,
        'birth_date': birthDate,
        'email': email,
        'phone': phone,
        'address': address,
        'course_id': courseId,
        'year_level': yearLevel,
        'section_id': sectionId,
        'status': status,
        'date_enrolled': dateEnrolled,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}

