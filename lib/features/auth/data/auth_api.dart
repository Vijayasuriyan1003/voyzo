import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';

class AuthApi {
  Future<Response> register({
    required String name,
    required String number,
    required String email,
    required String password,
  }) {
    return DioClient.dio.post(
      '/users',
      data: {
        'name': name,
        'mobile no': number,
        'email': email,
        'password': password,
      },
    );
  }

  Future<bool> login({required String email, required String password}) async {
    final response = await DioClient.dio.get('/users');

    final users = response.data as List;

    for (final user in users) {
      if (user['email'] == email && user['password'] == password) {
        return true;
      }
    }

    return false;
  }
}
