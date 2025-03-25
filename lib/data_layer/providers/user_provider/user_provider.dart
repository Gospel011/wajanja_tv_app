import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wajanja/data_layer/models/helper_models/error_model.dart';
import 'package:wajanja/data_layer/models/helper_models/file_model.dart';
import 'package:wajanja/data_layer/models/user_model/user.dart';
import 'package:wajanja/utils/constants/enums.dart';
import 'package:wajanja/utils/helpers/cloudinary_helper/cloudinary_helper.dart';
import 'package:wajanja/utils/helpers/logger.dart';
import 'dart:io' as io;
part 'user_state.dart';

class UserNotifier extends Notifier<UserState> {
  @override
  UserState build() {
    return UserState(state: UserStates.initial);
  }

  static final _db = FirebaseFirestore.instance;

  final usersRef = _db.collection(CollectionPaths.users.path).withConverter(
        fromFirestore: User.fromFirestore,
        toFirestore: (user, _) => user.toFirestore(),
      );

  Future<void> upsertUser(User user, {File? photo}) async {
    state = state.copyWith(state: UserStates.upsertingUser);

    try {
      log.f("MAKING REQUEST: ${user.userName != null}");
      if (user.userName != null) {
        final response = await usersRef
            .where(
              "userName",
              isEqualTo: user.userName ?? '',
            )
            .limit(1)
            .get();

        log.f("RESPONSE IS NOT EMPTY: ${response.docs.isNotEmpty}");

        if (response.docs.isNotEmpty) {
          final userDoc = response.docs.first.data();

          log.f("USER DOC: $userDoc");
          log.f("USER TO UPDATE DOC: $user");

          if (userDoc.email != user.email) {
            state = state.copyWith(
              state: UserStates.upsertingUserFailed,
              error: AppError(
                  title: "Username not available",
                  content:
                      "${user.userName} is already chosen by another user, please choose another username."),
            );
            return;
          }
        }
      }

      String? photoUrl;

      if (photo != null) {
        photoUrl = await CloudinaryHelper.instance.upload(
          io.File(photo.path),
          path: CloudinaryUploadPath.photo_urls,
        );

        if (user.photoURL != null) {
          // try {
            await CloudinaryHelper.instance.delete(user.photoURL!);
          // } catch (e) {
          //   log.f(e);
          // }
        }
      }

      log.f("PHOTO URL: $photoUrl");

      // return;
      await usersRef
          .doc(user.email!)
          .set(user.copyWith(photoURL: photoUrl), SetOptions(merge: true));
      state = state.copyWith(
        state: UserStates.userUpserted,
        user: user.copyWith(photoURL: photoUrl),
      );
    } catch (e) {
      state = state.copyWith(
        state: UserStates.upsertingUserFailed,
        error: AppError.fromErrorObject(e),
      );
    }
  }

  Future<void> fetchUser(String email) async {
    try {
      final docSnapshot = await usersRef.doc(email).get();
      final user = docSnapshot.data();

      if (user == null) {
        state = state.copyWith(
          state: UserStates.fetchingUserFailed,
          error: AppError(
              title: "Error", content: "The requested user does not exist"),
        );
        return;
      }

      state = state.copyWith(state: UserStates.userFetched, user: user);
    } catch (e) {
      state = state.copyWith(
          state: UserStates.fetchingUserFailed,
          error: AppError(title: "Error", content: e.toString()));
    }
  }
}

final userNotifierProvider = NotifierProvider<UserNotifier, UserState>(
  () {
    return UserNotifier();
  },
);
