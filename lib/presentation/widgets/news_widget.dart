import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wajanja/data_layer/models/news/news.dart';
import 'package:wajanja/data_layer/models/user_model/user.dart';
import 'package:wajanja/presentation/widgets/my_image_widget.dart';
import 'package:wajanja/presentation/widgets/profile_picture.dart';
import 'package:wajanja/utils/extensions/string_extension.dart';
import 'package:wajanja/utils/extensions/widget_extensions.dart';
import 'package:wajanja/utils/mixins.dart';

class NewsWidget extends ConsumerStatefulWidget {
  const NewsWidget({
    super.key,
    required this.news,
    this.onTap,
  });

  final News news;
  final VoidCallback? onTap;

  @override
  ConsumerState<NewsWidget> createState() => _NewsWidgetState();
}

class _NewsWidgetState extends ConsumerState<NewsWidget> with ThemesMixin {
  late final User postedBy;

  @override
  void initState() {
    super.initState();
    postedBy = widget.news.postedBy;
  }

  TextStyle? get highlightStyle =>
      textTheme.bodySmall?.copyWith(color: colorScheme.tertiary);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 33.w,
        children: [
          MyImageWidget(
            image: widget.news.coverPhoto,
            size: 150.r,
          ).pOnly(bottom: 20.h),
          Expanded(
              child: SizedBox(
            height: 150.r,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.news.category.describe.capitalize,
                  style: highlightStyle,
                ),
                Text(widget.news.title.capitalize),
                Row(
                  spacing: 8.w,
                  children: [
                    ProfilePicture(user: postedBy, size: 28.r),
                    Expanded(
                      child: Row(
                        spacing: 4.w,
                        children: [
                          Expanded(
                            child: Text(
                              "${postedBy.fullName}",
                              // "US News dafdj fkajdfad;lfkas dfk",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: highlightStyle,
                            ),
                          ),
                          // Text(
                          //   '\u2022',
                          //   style: highlightStyle,
                          // ),
                          Text(
                            widget.news.shortDate,
                            style: highlightStyle,
                          )
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ))
        ],
      ),
    );
  }
}
