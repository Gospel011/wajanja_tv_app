// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:wajanja/data_layer/models/helper_models/error_model.dart';
import 'package:wajanja/data_layer/models/user_model/user.dart';
import 'package:wajanja/utils/constants/enums.dart';

class AuthState {
  final AuthStates states;
  final User? user;
  final AppError? error;
  AuthState({
    required this.states,
    this.user,
    this.error,
  });

  AuthState copyWith({
    AuthStates? states,
    User? user,
    AppError? error,
  }) {
    return AuthState(
      states: states ?? this.states,
      user: user ?? this.user,
      error: error ?? this.error,
    );
  }

  factory AuthState.initial() {
    return AuthState(states: AuthStates.initial);
  }

  @override
  String toString() => 'AuthState(states: $states, user: $user, error: $error)';
}
