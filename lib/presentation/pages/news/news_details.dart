import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:wajanja/data_layer/models/extras/image_extra.dart';
import 'package:wajanja/data_layer/models/news/news.dart';
import 'package:wajanja/data_layer/models/user_model/user.dart';
import 'package:wajanja/data_layer/providers/auth_provider/auth_provider.dart';
import 'package:wajanja/data_layer/providers/news_provider/news_provider.dart';
import 'package:wajanja/presentation/widgets/engagementButtons.dart';
import 'package:wajanja/presentation/widgets/image_overflow.dart';
import 'package:wajanja/presentation/widgets/my_image_widget.dart';
import 'package:wajanja/presentation/widgets/profile_picture.dart';
import 'package:wajanja/utils/constants/enums.dart';
import 'package:wajanja/utils/extensions/string_extension.dart';
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
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 16.h,
            ),
            Text(
              targetNews!.title.capitalize,
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
                      style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.tertiaryFixedDim,
                          fontWeight: FontWeight.bold),
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
                onLikePressed: () async {
                  final newNews = await ref
                      .read(newsNotifierProvider.notifier)
                      .like(targetNews!);

                  if (newNews != null) {
                    setState(() {
                      targetNews = newNews;
                    });
                  }
                },
                onDislikePressed: () async {
                  if (targetNews == null) return;

                  final newNews = await ref
                      .read(newsNotifierProvider.notifier)
                      .dislike(targetNews!);

                  if (newNews != null) {
                    setState(() {
                      targetNews = newNews;
                    });
                  }
                },
              ).pSymmetric(horizontal: 0, vertical: 16.h);
            }),
            SizedBox(
              height: 10.h,
            ),
            MyImageWidget(
              image: targetNews!.coverPhoto,
              borderRadius: 8.r,
              onTap: () {
                context.pushNamed(
                  AppRoutes.imageView.name,
                  extra: ImageExtra(image: targetNews!.coverPhoto),
                );
              },
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
                case NewsSectionType.pictures:
                  final imagesLength = section.images!.length;
                  final containerWidth =
                      (MediaQuery.sizeOf(context).width - 16.w);
                  final containerHeight = 300.r;

                  return Container(
                    alignment: Alignment.center,
                    height: containerHeight,
                    // color: Colors.red,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: Center(
                        child: Table(
                          children: imagesLength <= 2
                              ? [
                                  TableRow(
                                      children: List<Widget>.generate(
                                          imagesLength, (index) {
                                    return MyImageWidget(
                                      image: section.images!.elementAt(index),
                                      borderRadius: 0,
                                      size: containerHeight,
                                      onTap: () {
                                        context.pushNamed(
                                          AppRoutes.imageView.name,
                                          extra: ImageExtra(
                                            images: section.images,
                                            currentIndex: index,
                                          ),
                                        );
                                      },
                                      // boxfit: BoxFit.cover,
                                    );
                                  })),
                                ]
                              :
                              // imagesLength == 3
                              //     ?
                              [
                                  TableRow(
                                    children: [
                                      MyImageWidget(
                                        image: section.images!.elementAt(0),
                                        borderRadius: 0,
                                        width: containerWidth * 0.5,

                                        height: containerHeight,

                                        // size: index == 2
                                        //     ? containerWidth * 0.25
                                        //     : null,

                                        onTap: () {
                                          context.pushNamed(
                                            AppRoutes.imageView.name,
                                            extra: ImageExtra(
                                              images: section.images,
                                              currentIndex: 0,
                                            ),
                                          );
                                        },
                                      ),
                                      Column(
                                        children: [
                                          MyImageWidget(
                                            image: section.images!.elementAt(1),
                                            borderRadius: 0,
                                            width: containerWidth * 0.5,

                                            height: containerHeight * 0.5,

                                            // size: index == 2
                                            //     ? containerWidth * 0.25
                                            //     : null,

                                            onTap: () {
                                              context.pushNamed(
                                                AppRoutes.imageView.name,
                                                extra: ImageExtra(
                                                  images: section.images,
                                                  currentIndex: 1,
                                                ),
                                              );
                                            },
                                          ),
                                          if (imagesLength == 3)
                                            MyImageWidget(
                                              image:
                                                  section.images!.elementAt(2),
                                              borderRadius: 0,
                                              width: containerWidth * 0.5,

                                              height: containerHeight * 0.5,

                                              // size: index == 2
                                              //     ? containerWidth * 0.25
                                              //     : null,

                                              onTap: () {
                                                context.pushNamed(
                                                  AppRoutes.imageView.name,
                                                  extra: ImageExtra(
                                                    images: section.images,
                                                    currentIndex: 2,
                                                  ),
                                                );
                                              },
                                            ),
                                          if (imagesLength > 3)
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: MyImageWidget(
                                                    image: section.images!
                                                        .elementAt(2),
                                                    borderRadius: 0,
                                                    // width: containerWidth * 0.25,

                                                    height:
                                                        containerHeight * 0.5,

                                                    // size: index == 2
                                                    //     ? containerWidth * 0.25
                                                    //     : null,

                                                    onTap: () {
                                                      context.pushNamed(
                                                        AppRoutes
                                                            .imageView.name,
                                                        extra: ImageExtra(
                                                          images:
                                                              section.images,
                                                          currentIndex: 2,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                                Expanded(
                                                  child: ImageOverflow(
                                                    overflow: imagesLength - 3,
                                                    height:
                                                        containerHeight * 0.5,
                                                    onTap: () {
                                                      context.pushNamed(
                                                          AppRoutes
                                                              .imageView.name,
                                                          extra: ImageExtra(
                                                            images:
                                                                section.images,
                                                          ));
                                                    },
                                                  ),
                                                )

                                                // Expanded(
                                                //   child: Container(
                                                //     // width: 50.r,
                                                //     height: 100.r,
                                                //     color: Colors.blue,
                                                //   ),
                                                // )
                                              ],
                                            )
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                          // : [],
                        ),
                        // child: GridView.builder(
                        //   physics: const NeverScrollableScrollPhysics(),
                        //   shrinkWrap: true,
                        //   gridDelegate: SliverQuiltedGridDelegate(
                        //     crossAxisCount: 4,
                        //     repeatPattern: QuiltedGridRepeatPattern.inverted,
                        //     pattern: imagesLength == 1
                        //         ? [
                        //             QuiltedGridTile(4, 4),
                        //           ]
                        //         : imagesLength == 2
                        //             ? [
                        //                 QuiltedGridTile(2, 2),
                        //                 QuiltedGridTile(2, 2),
                        //               ]
                        //             : imagesLength == 3
                        //                 ? [
                        //                     QuiltedGridTile(2, 4),
                        //                     QuiltedGridTile(2, 2),
                        //                     QuiltedGridTile(2, 2),
                        //                   ]
                        //                 : [
                        //                     QuiltedGridTile(2, 2),
                        //                     QuiltedGridTile(1, 1),
                        //                     QuiltedGridTile(1, 1),
                        //                     QuiltedGridTile(1, 1),
                        //                   ],
                        //   ),
                        //   itemBuilder: (context, index) {
                        //     // final random = Random(index);

                        //     // return Container(
                        //     //   color: Color.fromARGB(
                        //     //     255,
                        //     //     random.nextInt(255),
                        //     //     random.nextInt(255),
                        //     //     random.nextInt(255),
                        //     //   ),
                        //     // );

                        //     if (index == 4) {
                        //       return ImageOverflow(
                        //           overflow: imagesLength - 4,
                        //           onTap: () {
                        //             context.pushNamed(AppRoutes.imageView.name,
                        //                 extra:
                        //                     ImageExtra(images: section.images));
                        //           });
                        //     }
                        // return MyImageWidget(
                        //   image: section.images!.elementAt(index),
                        //   borderRadius: 0,
                        //   size: 500.r,
                        //   onTap: () {
                        //     context.pushNamed(
                        //       AppRoutes.imageView.name,
                        //       extra: ImageExtra(
                        //           images: section.images,
                        //           currentIndex: index),
                        //     );
                        //   },
                        //   // boxfit: BoxFit.cover,
                        // );
                        //   },
                        //   itemCount: imagesLength >= 5 ? 5 : imagesLength,
                        // ),
                      ),
                    ),
                  ).pSymmetric(horizontal: 0, vertical: 20.h);
              }
            }),
            SizedBox(
              height: 32.h,
            )
          ],
        ).pSymmetric(),
      ),
    );
  }
}
