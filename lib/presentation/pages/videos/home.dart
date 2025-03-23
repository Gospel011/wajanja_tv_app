import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:wajanja/presentation/pages/videos/video_description.dart';
import 'package:wajanja/utils/constants/app_svgs.dart';
import 'package:wajanja/utils/extensions/widget_extensions.dart';
import 'package:wajanja/utils/mixins.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with ThemesMixin {
  static final navIcons = [
    AppSvgs.video,
    AppSvgs.news,
    AppSvgs.audiobook,
    AppSvgs.podcast
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          widget.shell,
          Container(
            decoration: BoxDecoration(
                color: colorScheme.secondary,
                borderRadius: BorderRadius.circular(16.r)),
            constraints: BoxConstraints(
                minWidth: MediaQuery.sizeOf(context).width * 0.63),
            padding: EdgeInsets.all(20.r),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ...List<Widget>.generate(navIcons.length, (index) {
                  final icon = navIcons.elementAt(index);

                  return IconContainer(
                    backgroundColor: widget.shell.currentIndex == index
                        ? colorScheme.primary
                        : null,
                    onTap: () {
                      widget.shell.goBranch(index);
                    },
                    icon: icon.assetCopy(
                      color: widget.shell.currentIndex == index
                          ? colorScheme.onPrimary
                          : colorScheme.onSurface,
                    ),
                  );
                }),
                // IconContainer(icon: AppSvgs.news),
                // IconContainer(icon: AppSvgs.audiobook),
                // IconContainer(icon: AppSvgs.podcast),
              ],
            ),
          ).pSymmetric(vertical: 20.h)
        ],
      ),
    );
  }
}
