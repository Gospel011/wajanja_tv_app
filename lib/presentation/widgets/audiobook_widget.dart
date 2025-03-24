import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:wajanja/data_layer/models/audiobook/audiobook.dart';
import 'package:wajanja/data_layer/models/extras/audiobook_extra.dart';
import 'package:wajanja/data_layer/models/user_model/user.dart';
import 'package:wajanja/data_layer/providers/auth_provider/auth_provider.dart';
import 'package:wajanja/presentation/widgets/my_image_widget.dart';
import 'package:wajanja/utils/constants/app_svgs.dart';
import 'package:wajanja/utils/constants/enums.dart';
import 'package:wajanja/utils/extensions/string_extension.dart';
import 'package:wajanja/utils/extensions/widget_extensions.dart';
import 'package:wajanja/utils/mixins.dart';



class AudiobookWidget extends ConsumerStatefulWidget {
  const AudiobookWidget({
    super.key,
    required this.audiobook,
  });

  final Audiobook audiobook;

  @override
  ConsumerState<AudiobookWidget> createState() => _AudiobookWidgetState();
}

class _AudiobookWidgetState extends ConsumerState<AudiobookWidget> with ThemesMixin {
  late final User postedBy;

  @override
  void initState() {
    super.initState();
    postedBy = ref.read(authNotifierProvider).user!;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(
          AppRoutes.audiobooksDetail.name,
          extra: AudiobookExtra(
            audiobook: widget.audiobook,
          ),
        );
      },
      child: Column(
        spacing: 12.h,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 199 / 300,
            child: MyImageWidget(
              image: widget.audiobook.coverphoto,
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  postedBy.fullName!.capitalizeAll,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.labelLarge,
                ),
                Text(
                  widget.audiobook.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  spacing: 10.w,
                  children: [
                    AppSvgs.starFilled.assetCopy(
                      color: colorScheme.primary,
                      width: 24.r,
                      height: 24.r,
                    ),
                    Expanded(
                      child: Text(
                        widget.audiobook.averageRating == 0
                            ? "No reviews yet"
                            : widget.audiobook.averageRating.toString(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: widget.audiobook.averageRating > 0
                            ? null
                            : textTheme.bodySmall,
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
