
import 'package:flutter_test/flutter_test.dart';
import 'package:student_information_system/utils/validators.dart';

void main() {
  test('email validator rejects invalid email', () {
    expect(Validators.email('wrong-email'), isNotNull);
  });

  test('year validator accepts 3', () {
    expect(Validators.yearLevel('3'), isNull);
  });

  test('required validator rejects blank value', () {
    expect(Validators.required(''), isNotNull);
  });
}

