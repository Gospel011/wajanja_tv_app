import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wajanja/data_layer/models/user_model/user.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({super.key, required this.user, this.size});

  final User? user;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      // final user = ref.read(authNotifierProvider).user!;
      return ClipRRect(
        borderRadius: BorderRadius.circular(100.r),
        child: CachedNetworkImage(
          imageUrl: user?.photoURL ?? '',
          fit: BoxFit.cover,
          width: size ?? 50.r,
          errorWidget: (context, url, error) {
            return Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Theme.of(context).colorScheme.onSurface)),
                child: Text(user?.initials ?? ''));
          },
        ),
      );
    });
  }
}
