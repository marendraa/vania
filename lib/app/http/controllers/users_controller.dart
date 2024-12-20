import 'package:vania/vania.dart';
import 'package:vania_app/app/models/users.dart';

class UsersController extends Controller {
  /// Fetch users details
  Future<Response> index() async {
    Map<String, dynamic>? details =
        await Users().query().where('id', '=', Auth().id()).first();

    return Response.json(details);
  }

  /// Update curent users details
  Future<Response> update(Request request) async {
    request.validate({
      'username': 'required|max_length:20',
      'email': 'required|email',
    }, {
      'username.required': 'The first name is required',
      'email.required': 'The email is required',
      'email.email': 'The email is not valid',
    });

    await Users().query().where('id', '=', Auth().id()).update({
      'username': request.input('username'),
      'email': request.input('email'),
    });

    return Response.json({'message': 'Users berhasil diupdate'});
  }
}

final UsersController usersController = UsersController();

