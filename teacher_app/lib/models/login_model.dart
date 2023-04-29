import 'package:attendease_t/database/db.dart';
import 'package:pocketbase/pocketbase.dart';

class LoginModel {
  static Future<RecordAuth> getCredentials(
      String email, String password) async {
    return await PbDb.pb
        .collection('teachers')
        .authWithPassword(email, password);
  }
}
