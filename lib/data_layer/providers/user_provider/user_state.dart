// ignore_for_file: public_member_api_docs, sort_constructors_first
part  of 'user_provider.dart';

class UserState {
  final UserStates state;
  final User? user;
  final AppError? error;
  UserState({
    required this.state,
    this.user,
    this.error,
  });

  UserState copyWith({
    UserStates? state,
    User? user,
    AppError? error,
  }) {
    return UserState(
      state: state ?? this.state,
      user: user ?? this.user,
      error: error ?? this.error,
    );
  }

  @override
  String toString() => 'UserState(state: $state, user: $user, error: $error)';
}
