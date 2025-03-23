import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wajanja/data_layer/models/news/news.dart';
import 'package:wajanja/data_layer/models/user_model/user.dart';
import 'package:wajanja/data_layer/providers/auth_provider/auth_provider.dart';
import 'package:wajanja/presentation/widgets/engagementButtons.dart';
import 'package:wajanja/presentation/widgets/image_place_holder_widget.dart';
import 'package:wajanja/presentation/widgets/my_image_widget.dart';
import 'package:wajanja/presentation/widgets/profile_picture.dart';
import 'package:wajanja/utils/constants/enums.dart';
import 'package:wajanja/utils/extensions/widget_extensions.dart';
import 'package:wajanja/utils/mixins.dart';

class NewsDetails extends ConsumerStatefulWidget {
  const NewsDetails({super.key, required this.news});
  final News news;

  @override
  ConsumerState<NewsDetails> createState() => _NewsDetailsState();
}

class _NewsDetailsState extends ConsumerState<NewsDetails> with ThemesMixin {
  late final User postedBy;
  News? targetNews;

  @override
  void initState() {
    super.initState();
    postedBy = ref.read(authNotifierProvider).user!;

    targetNews = widget.news;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        bottom: PreferredSize(preferredSize: Size(0, 10.h), child: Container()),
        centerTitle: true,
        title: Text(
          targetNews!.shortDate,
          style: textTheme.bodySmall?.copyWith(color: colorScheme.tertiary),
        ),
        // actions: [
        //   ProfilePicture(
        //     user: postedBy,
        //     // size: 32.r,
        //   ),
        //   SizedBox(
        //     width: 10.w,
        //   )
        // ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 16.h,
            ),
            Text(
              targetNews!.title,
              style: textTheme.headlineMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10.w,
              children: [
                ProfilePicture(user: postedBy),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8.h,
                  children: [
                    Text(
                      postedBy.fullName!,
                      style: textTheme.bodyMedium
                          ?.copyWith(color: colorScheme.tertiaryFixedDim, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.news.shortDate,
                      style: textTheme.bodySmall
                          ?.copyWith(color: colorScheme.tertiaryFixedDim),
                    )
                  ],
                )
              ],
            ).pSymmetric(horizontal: 0, vertical: 16.h),
            Builder(builder: (context) {
              final liked = targetNews!.likes.contains(postedBy.email);
              final disliked = targetNews!.dislikes.contains(postedBy.email);
              return Engagementbuttons(
                liked: liked,
                disliked: disliked,
                onLikePressed: () {
                  setState(() {
                    if (liked) {
                      targetNews = targetNews!.copyWith(
                        likes: targetNews!.likes
                            .where((el) => el != postedBy.email)
                            .toList(),
                      );
                    } else {
                      targetNews = targetNews!.copyWith(
                        dislikes: targetNews!.dislikes
                            .where((el) => el != postedBy.email)
                            .toList(),
                        likes: targetNews!.likes..add(postedBy.email!),
                      );
                    }
                  });
                },
                onDislikePressed: () {
                  setState(() {
                    if (disliked) {
                      targetNews = targetNews!.copyWith(
                        dislikes: targetNews!.dislikes
                            .where((el) => el != postedBy.email)
                            .toList(),
                      );
                    } else {
                      targetNews = targetNews!.copyWith(
                          likes: targetNews!.likes
                              .where((el) => el != postedBy.email)
                              .toList(),
                          dislikes: targetNews!.likes..add(postedBy.email!));
                    }
                  });
                },
              ).pSymmetric(horizontal: 0, vertical: 16.h);
            }),
            SizedBox(
              height: 10.h,
            ),
            MyImageWidget(
              image: targetNews!.coverPhoto,
              borderRadius: 8.r,
            ),
            SizedBox(
              height: 42.h,
            ),
            ...List<Widget>.generate(targetNews!.sections.length, (index) {
              final section = targetNews!.sections.elementAt(index);

              switch (section.sectionType) {
                case NewsSectionType.text:
                  return Text(
                    section.text!,
                    textAlign: TextAlign.justify,
                  );
                // return SizedBox.shrink();
                case NewsSectionType.pictures:
                  final imagesLength = section.images!.length;

                  final int axisCount = imagesLength == 1
                      ? 1
                      : imagesLength == 2
                          ? 2
                          : 4;

                  return Container(
                    // color: Colors.red,
                    alignment: Alignment.center,
                    height: 200.r,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: Center(
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate: SliverQuiltedGridDelegate(
                            crossAxisCount: 4,
                            // mainAxisSpacing: 4,
                            // crossAxisSpacing: 4,
                            repeatPattern: QuiltedGridRepeatPattern.inverted,
                            pattern: imagesLength == 1
                                ? [
                                    QuiltedGridTile(1, 1),
                                  ]
                                : imagesLength == 2
                                    ? [
                                        QuiltedGridTile(1, 1),
                                        QuiltedGridTile(1, 1),
                                      ]
                                    : imagesLength == 3
                                        ? [
                                            QuiltedGridTile(2, 4),
                                            QuiltedGridTile(2, 2),
                                            QuiltedGridTile(2, 2),
                                          ]
                                        : [
                                            QuiltedGridTile(2, 2),
                                            QuiltedGridTile(1, 1),
                                            QuiltedGridTile(1, 1),
                                            QuiltedGridTile(1, 1),
                                          ],
                          ),
                          itemBuilder: (context, index) {
                            final random = Random(index);

                            // return Container(
                            //   color: Color.fromARGB(
                            //     255,
                            //     random.nextInt(255),
                            //     random.nextInt(255),
                            //     random.nextInt(255),
                            //   ),
                            // );

                            if (index == 4) {
                              return Container(
                                alignment: Alignment.center,
                                // color: colorScheme.tertiaryFixed,
                                color: isDarkTheme
                                    ? colorScheme.surfaceTint
                                        .withValues(alpha: 0.1)
                                    : colorScheme.tertiaryFixed
                                        .withValues(alpha: 0.1),
                                child: Container(
                                  padding: EdgeInsets.all(16.r),
                                  decoration: BoxDecoration(
                                      // color: colorScheme.surfaceTint.withValues(alpha: 0.1),
                                      shape: BoxShape.circle),
                                  child: Text(
                                    "+${imagesLength - 4}",
                                    style: textTheme.titleMedium?.copyWith(
                                        color: colorScheme.onSurface),
                                  ),
                                ),
                              );
                            }
                            return MyImageWidget(
                              image: section.images!.elementAt(index),
                              borderRadius: 0,
                              size: 500.r,
                              // boxfit: BoxFit.cover,
                            );
                          },
                          itemCount: imagesLength >= 5 ? 5 : imagesLength,
                          // itemBuilder: SliverChildBuilderDelegate(
                          // (context, index) => MyImageWidget(
                          //   image: section.images!.elementAt(index),
                          //   borderRadius: 0,
                          // ),
                          // ),
                        ),
                      ),
                    ),
                  ).pSymmetric(horizontal: 0, vertical: 20.h);
                // return ImageLoadingPlaceHolderWidget(
                //   placeHolderText: "${section.images!.length} images here",
                // );
                default:
                  return Text('unknow section');
              }
            })
          ],
        ).pSymmetric(),
      ),
    );
  }
}
