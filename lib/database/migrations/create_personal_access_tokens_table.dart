import 'package:vania/vania.dart';

class CreatePersonalAccessTokensTable extends Migration {

   @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('personal_access_tokens', () {
      id(); // Primary key
      string('token', length: 64); // Token akses
      string('abilities'); // Kemampuan token
      dateTime('expires_at'); // Tanggal kedaluwarsa
      timeStamps(); // created_at dan updated_at
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('personal_access_tokens');
  }
}
