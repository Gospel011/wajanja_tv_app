import 'package:hive_flutter/hive_flutter.dart';
import 'package:wajanja/data_layer/models/user_model/user.dart';

class UserDb {
  static final UserDb _instance = UserDb._();

  late Box<User> _userBox;

  UserDb._();

  static UserDb get instance => _instance;

  Future<void> init() async {
    _userBox = await Hive.openBox<User>('user');
  }

  Future<void> save(User user) async {
    _userBox.put('user', user);
  }

  User? retrieveUser() {
    return _userBox.get('user');
  }

  void clearUser() {
    _userBox.clear();
  }
}
