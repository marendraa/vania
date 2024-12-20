import 'package:vania_app/app/models/users.dart';
import 'package:vania/vania.dart';
import 'package:bcrypt/bcrypt.dart';

class AuthController extends Controller {
  Future<Response> login(Request request) async {
    
    request.validate({
      'email': 'required|email',
      'password': 'required',
    }, {
      'email.required': 'The email is required',
      'email.email': 'The email is not valid',
      'password.required': 'The password is required'
    });

    
    String email = request.input('email');
    String password = request.input('password').toString();

    
    final users = await Users().query().where('email', email).first();
    if (users == null) {
      return Response.json({'message': 'User not found'},
          404);
    }

    
    if (!BCrypt.checkpw(password, users['password'])) {
      return Response.json({
        'message': 'Password is incorrect',
      }, 401);
    }

    
    Map<String, dynamic> token = await Auth()
        .login(
            users)
        .createToken(expiresIn: Duration(hours: 24), withRefreshToken: true);

    
    return Response.json({
      'message': 'Login successful',
      'data': {
        'token': token,
        'users': {
          'id': users[
              'id'], 
          'email': users['email'],
          'username': users['username'] ?? 'No Username',
        },
      },
    });
  }

  
  Future<Response> signUp(Request request) async {
    try {
      // Validasi input dengan rules yang diperbarui
      request.validate({
        'username': 'required',
        'email': 'required|email',
        'password': 'required',
      }, {
        'username.required': 'Username wajib diisi',
        'email.required': 'Email wajib diisi',
        'email.email': 'Format email tidak valid',
        'password.required': 'Password wajib diisi',
      });

      final username = request.input('username')?.toString();
      final email = request.input('email')?.toString();
      final password = request.input('password')?.toString();

      // Validasi manual untuk panjang password
      if (password == null || password.length < 6) {
        return Response.json({
          'error': true,
          'message': 'Password harus minimal 6 karakter'
        }, 400);
      }

      // Validasi data tidak boleh kosong
      if (username == null || username.isEmpty || 
          email == null || email.isEmpty) {
        return Response.json({
          'error': true,
          'message': 'Semua field harus diisi'
        }, 400);
      }

      // Cek email yang sudah ada
      final existingUser = await Users().query()
          .where('email', '=', email)
          .first();

      if (existingUser != null) {
        return Response.json({
          'error': true,
          'message': 'Email sudah terdaftar'
        }, 400);
      }

      // Hash password
      final hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

      try {
        // Insert user baru
        await Users().query().insert({
          'username': username,
          'email': email,
          'password': hashedPassword,
          'created_at': DateTime.now().toIso8601String(),
        });

        // Ambil data user yang baru dibuat berdasarkan email
        final newUser = await Users().query()
            .where('email', '=', email)
            .first();

        if (newUser == null) {
          return Response.json({
            'error': true,
            'message': 'Gagal membuat user'
          }, 500);
        }

        // Buat token
        final token = await Auth()
            .login(newUser)
            .createToken(expiresIn: Duration(hours: 24), withRefreshToken: true);

        return Response.json({
          'error': false,
          'message': 'Registrasi berhasil',
          'data': {
            'token': token,
            'user': {
              'id': newUser['id'],
              'username': newUser['username'],
              'email': newUser['email'],
            },
          },
        });
      } catch (dbError) {
        print('Database error: $dbError');
        return Response.json({
          'error': true,
          'message': 'Gagal menyimpan data user'
        }, 500);
      }

    } catch (e, stackTrace) {
      print('Error: $e');
      print('Stack trace: $stackTrace');
      return Response.json({
        'error': true,
        'message': 'Terjadi kesalahan pada server'
      }, 500);
    }
  }
}
final AuthController authController = AuthController();
