import 'package:flutter/material.dart';
import 'package:to_do_application_1/register/controller/register_controller.dart';
import 'package:to_do_application_1/register/model/register_model.dart';


class RegisterProvider with ChangeNotifier {
  final RegisterController _controller = RegisterController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<String?> register(String email, String name, String password) async {
    if (email.isEmpty || name.isEmpty || password.isEmpty) {
      return 'Please fill in all fields';
    }

    _isLoading = true;
    notifyListeners();

    final user = UserModel(email: email, name: name);
    final result = await _controller.registerUser(user, password);

    _isLoading = false;
    notifyListeners();

    return result;
  }
}
