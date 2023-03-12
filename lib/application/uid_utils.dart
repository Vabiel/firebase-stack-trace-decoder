import 'package:uuid/uuid.dart';

class UidUtils {
  static const _uuid = Uuid();

  static String get v4 => _uuid.v4();
}
