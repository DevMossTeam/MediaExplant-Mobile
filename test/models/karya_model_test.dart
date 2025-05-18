import 'package:flutter_test/flutter_test.dart';
import 'package:karya_app/models/karya.dart';

void main() {
  group('Karya Model', () {
    test('should parse from JSON correctly', () {
      final json = {
        'id': 'karya001',
        'user': {'id': 'u01', 'namaLengkap': 'Alice'},
        'likeCount': 10,
      };

      final karya = Karya.fromJson(json);

      expect(karya.id, 'karya001');
      expect(karya.user.namaLengkap, 'Alice');
      expect(karya.likeCount, 10);
    });
  });
}
