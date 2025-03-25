import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wajanja/data_layer/models/helper_models/file_model.dart';
import 'package:wajanja/data_layer/models/user_model/user.dart';
import 'package:wajanja/data_layer/providers/auth_provider/auth_provider.dart';
import 'package:wajanja/data_layer/providers/user_provider/user_provider.dart';
import 'package:wajanja/presentation/widgets/buttons/my_elevated_button.dart';
import 'package:wajanja/presentation/widgets/my_textformfield.dart';
import 'package:wajanja/presentation/widgets/profile_picture.dart';
import 'package:wajanja/utils/constants/enums.dart';
import 'package:wajanja/utils/extensions/string_extension.dart';
import 'package:wajanja/utils/extensions/widget_extensions.dart';
import 'package:wajanja/utils/helpers/cloudinary_helper/cloudinary_helper.dart';
import 'package:wajanja/utils/mixins.dart';
import 'package:wajanja/utils/validators/validators.dart';
import 'dart:io' as io;

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage>
    with ThemesMixin, UiInfoMixin, ImageMixin, DebounceMixin {
  User? user;

  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _userName = TextEditingController();
  final TextEditingController _phone = TextEditingController();

  @override
  void initState() {
    super.initState();
    user = ref.read(authNotifierProvider).user;

    _fullName.text = user?.fullName ?? '';
    _email.text = user?.email ?? '';
    _userName.text = user?.userName ?? '';
    _phone.text = user?.phone ?? '';
  }

  @override
  void dispose() {
    _fullName.dispose();
    _email.dispose();
    _userName.dispose();
    _phone.dispose();
    super.dispose();
  }

  File? photo;
  bool isUploading = false;

  @override
  Widget build(BuildContext context) {
    ref.listen(
      userNotifierProvider,
      (previous, next) {
        switch (next.state) {
          case UserStates.upsertingUserFailed:
            showSnackMessage(
              context,
              next.error?.content ??
                  "We couldn't update your profile at the moment",
              flushbarPosition: FlushbarPosition.TOP,
              error: true,
            );
            break;
          case UserStates.userUpserted:
            showSnackMessage(
              context,
              "Profile updated",
              flushbarPosition: FlushbarPosition.TOP,
            );

            setState(() {
              user = next.user!;
            });
          default:
        }
      },
    );

    return Scaffold(
      appBar: AppBar(),
      bottomNavigationBar: Builder(builder: (context) {
        return MyElevatedButton(
          text: "Save",
          loading: ref.watch(userNotifierProvider).state ==
                  UserStates.upsertingUser ||
              isUploading,
          onPressed: () async {
            unfocus();
            if (user == null) return;
            final newUser = user!.copyWith(
              fullName: _fullName.text.trim().capitalize,
              // email: _email.text.trim(),
              userName:
                  _userName.text.trim().isEmpty ? null : _userName.text.trim(),
              phone: _phone.text.trim(),
            );

            if (newUser == user && photo == null) {
              showSnackMessage(context, "No change detected",
                  error: true, flushbarPosition: FlushbarPosition.TOP);
              return;
            }


            

            ref.read(userNotifierProvider.notifier).upsertUser(
                  newUser, photo: photo,
                );
          },
        ).pOnly(left: 16.w, right: 16.w, bottom: 20.h);
      }),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 64.h,
                ),
                Column(
                  spacing: 24.h,
                  children: [
                    ProfilePicture(
                      user: user,
                      size: 96.r,
                      file: photo,
                      onTap: () async {
                        final XFile? pickedImage =
                            await getSingleImageFromSource();
                        if (!context.mounted) return;
                        processPickedImage(context, pickedImage);
                        // showMyBottomSheet(context, children: [
                        //   Row(
                        //     spacing: 10.w,
                        //     children: [
                        //       Icon(
                        //         Icons.camera_rounded,
                        //         size: 24.r,
                        //       ),
                        //       Text(
                        //         "Take a picture",
                        //         style: textTheme.titleMedium,
                        //       )
                        //     ],
                        //   ).pSymmetric(vertical: 10.h),
                        //   GestureDetector(
                        //     onTap: () async {
                        //       context.pop();
                        //       final XFile? pickedImage =
                        //           await getSingleImageFromSource();
                        //       if (!context.mounted) return;
                        //       processPickedImage(context, pickedImage);
                        //     },
                        //     child: Row(
                        //       spacing: 10.w,
                        //       children: [
                        //         Icon(
                        //           Icons.photo_album_rounded,
                        //           size: 24.r,
                        //         ),
                        //         Text(
                        //           "Choose from gallery",
                        //           style: textTheme.titleMedium,
                        //         )
                        //       ],
                        //     ).pSymmetric(vertical: 10.h),
                        //   )
                        // ]);
                      },
                    ),
                    Text(
                      user?.fullName ?? '',
                      textAlign: TextAlign.center,
                      style: textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                SizedBox(
                  height: 84.h,
                ),
                Column(
                  spacing: 20.h,
                  children: [
                    MyTextFormField(
                      controller: _fullName,
                      sectionText: "Full name",
                      validator: (value) => nonNullValidator(
                        value,
                        message: "Please provide your name",
                      ),
                      hintText: 'Enter your full name',
                    ),
                    MyTextFormField(
                      controller: _email,
                      sectionText: "Email",
                      validator: emailValidator,
                      readOnly: true,
                      hintText: 'Enter your full email',
                    ),
                    MyTextFormField(
                      controller: _userName,
                      sectionText: "Username",
                      keyboardType: TextInputType.emailAddress,
                      validator: emailValidator,
                      hintText: 'Alice123',
                    ),
                    MyTextFormField(
                      sectionText: "Phone",
                      controller: _phone,
                      hintText: "+234-123-456-7890",
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                      validator: (value) => nonNullValidator(value,
                          message: "Please provide your phone number"),
                    )
                  ],
                ),


                SizedBox(height: 24.h),
              ],
            ).pSymmetric(),
          ),
        ),
      ),
    );
  }

  Future<void> processPickedImage(
      BuildContext context, XFile? pickedImage) async {
    if (pickedImage == null) {
      showSnackMessage(
        context,
        "No file picked",
        flushbarPosition: FlushbarPosition.TOP,
      );
      return;
    }

    CroppedFile? croppedFile = await cropImage(
      path: pickedImage.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
    );

    final image = croppedFile?.path;

    if (!context.mounted) return;

    if (image == null) {
      showSnackMessage(context, "No file detected",
          flushbarPosition: FlushbarPosition.TOP);
      return;
    }

    setState(() {
      photo = File(name: "profilePicture", path: image);
    });
  }
}
