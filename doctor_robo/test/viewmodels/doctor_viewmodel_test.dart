import 'package:flutter_test/flutter_test.dart';
import 'package:doctor_robo/app/app.locator.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('DoctorViewModel Tests -', () {
    setUp(() => registerServices());
    tearDown(() => locator.reset());
  });
}
