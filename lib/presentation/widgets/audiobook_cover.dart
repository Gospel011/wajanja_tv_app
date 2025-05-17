import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wajanja/data_layer/models/audiobook/audiobook.dart';
import 'package:wajanja/data_layer/models/user_model/user.dart';
import 'package:wajanja/presentation/widgets/my_image_widget.dart';
import 'package:wajanja/utils/extensions/string_extension.dart';
import 'package:wajanja/utils/mixins.dart';

class AudiobookCoverAndAuthorInfo extends ConsumerStatefulWidget {
  const AudiobookCoverAndAuthorInfo({
    super.key,
    required this.audiobook,
  });

  final Audiobook? audiobook;

  @override
  ConsumerState<AudiobookCoverAndAuthorInfo> createState() =>
      _AudiobookCoverAndAuthorInfoState();
}

class _AudiobookCoverAndAuthorInfoState
    extends ConsumerState<AudiobookCoverAndAuthorInfo> with ThemesMixin {
  double get screenWidth => MediaQuery.sizeOf(context).width - 32.w;

  late final User postedBy;

  @override
  void initState() {
    super.initState();

    postedBy = widget.audiobook!.postedBy;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 24.h,
      children: [
        SizedBox(
          width: screenWidth * 3 / 4,
          height: (screenWidth * 3 / 4) * 386 / 199,
          child: MyImageWidget(
            image: widget.audiobook!.coverphoto,
            borderRadius: 32.r,
          ),
        ),
        Column(
          spacing: 10.h,
          children: [
            Text(
              widget.audiobook!.title.capitalizeAll,
              textAlign: TextAlign.center,
              style:
                  textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500),
            ),
            Text(
              postedBy.fullName!.capitalizeAll,
              textAlign: TextAlign.center,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.tertiary,
              ),
            )
          ],
        )
      ],
    );
  }
}
