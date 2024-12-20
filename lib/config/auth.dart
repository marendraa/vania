import 'package:vania_app/app/models/users.dart';

Map<String, dynamic> authConfig = {
  'guards': {
    'default': {
      'provider': Users(),
    }
  }
};
