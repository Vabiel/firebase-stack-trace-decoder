// English locale — no overrides; all messages fall back to the source strings
// declared via `Intl.message(...)` in `lib/application/localization.dart`.

// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes, comment_references, directives_ordering
// ignore_for_file:annotate_overrides, prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  @override
  String get localeName => 'en';

  @override
  final Map<String, dynamic> messages = <String, dynamic>{};
}
