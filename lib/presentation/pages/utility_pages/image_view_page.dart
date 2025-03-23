import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:wajanja/utils/helpers/logger.dart';

class ImageViewPage extends StatefulWidget {
  const ImageViewPage({
    super.key,
    this.image,
    this.showWatermark = false,
    this.tag,
    this.images,
    this.currentIndex,
  });

  final String? image;
  final String? tag;
  final List<String>? images;
  final int? currentIndex;
  final bool showWatermark;

  @override
  State<ImageViewPage> createState() => _ImageViewPageState();
}

class _ImageViewPageState extends State<ImageViewPage> {
  final TransformationController _controller = TransformationController();

  int? _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
    pageController = PageController(initialPage: _currentIndex ?? 0);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  late final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
        // backgroundColor: Colors.transparent,
      //   // title: const Text('pinch to zoom'),
      // ),
      bottomNavigationBar: Platform.isWindows
          ? BottomAppBar(
              color: Colors.black,
              child: IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            )
          : null,
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: widget.tag != null && widget.images == null
                  ? Hero(
                      tag: widget.tag!,
                      child: InteractiveViewer(
                        transformationController: _controller,
                        boundaryMargin: const EdgeInsets.all(8),
                        maxScale: 20,
                        child: GestureDetector(
                          onDoubleTap: () {
                            gotoDefaultScale();
                          },
                          child: widget.image != null
                              ? widget.image!.startsWith('http')
                                  ? CachedNetworkImage(
                                      imageUrl: widget.image!,
                                      height: double.maxFinite,
                                    )
                                  : Image.asset(
                                      widget.image!,
                                      height: double.maxFinite,
                                    )
                              : const SizedBox(),
                        ),
                      ),
                    )
                  : GestureDetector(
                      onDoubleTap: () {
                        _controller.value = Matrix4.identity();
                      },
                      onLongPress: () {
                        log.i("Long pressed");
                        Navigator.pop(context);
                      },
                      child: widget.image != null
                          ? Builder(builder: (context) {
                              log.i("TAG: ${widget.tag}, IMAGE: ${widget.image}");
            
                              // return Text("Hello");
                              return Hero(
                                tag: widget.tag ?? widget.image!,
                                child: InteractiveViewer(
                                  transformationController: _controller,
                                  child: CachedNetworkImage(
                                    imageUrl: widget.image!,
                                    height: double.maxFinite,
                                  ),
                                ),
                              );
                            })
                          : Stack(
                              children: [
                                PageView.builder(
                                    controller: pageController,
                                    itemCount: widget.images?.length ?? 0,
                                    // physics: const NeverScrollableScrollPhysics(),
                                    onPageChanged: (newIndex) {
                                      _controller.value = Matrix4.identity();
                                    },
                                    itemBuilder: (context, index) {
                                      return Hero(
                                        tag: widget.images![index],
                                        child: InteractiveViewer(
                                            transformationController: _controller,
                                            boundaryMargin:
                                                const EdgeInsets.all(8),
                                            maxScale: 20,
                                            panAxis: PanAxis.vertical,
                                            child: CachedNetworkImage(
                                                imageUrl: widget.images![index])),
                                      );
                                    }),
            
                                //* PREVIOUS AND NEXT PAGE BUTTONS
                                // Padding(
                                //   padding:
                                //       const EdgeInsets.symmetric(horizontal: 8.0),
                                //   child: Align(
                                //     alignment: Alignment.center,
                                //     child: Row(
                                //       mainAxisAlignment:
                                //           MainAxisAlignment.spaceBetween,
                                //       children: [
                                //         //* PREVIOUS PAGE BUTTON
                                //         MyCircleAvatar(
                                //           padding: EdgeInsets.zero,
                                //           icon: const Icon(
                                //               Icons.arrow_back_ios_outlined),
                                //           iconColor: AppColors.textColor,
                                //           backgroundColor: Colors.white,
                                //           onPressed: () {
                                //             _currentIndex = (_currentIndex! - 1) %
                                //                 widget.images!.length;
                                //             ;
                                //             gotoDefaultScale();
            
                                //             animateToPage(pageController);
                                //           },
                                //         ),
            
                                //         //* NEXT PAGE BUTTON
                                //         MyCircleAvatar(
                                //           padding: EdgeInsets.zero,
                                //           icon: const Icon(
                                //               Icons.arrow_forward_ios_outlined),
                                //           iconColor: AppColors.textColor,
                                //           backgroundColor: Colors.white,
                                //           onPressed: () {
                                //             _currentIndex = (_currentIndex! + 1) %
                                //                 widget.images!.length;
                                //             gotoDefaultScale();
            
                                //             animateToPage(pageController);
                                //           },
                                //         ),
                                //       ],
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                    ),
            ),
        
        
            Positioned(
              top: 16.r,
              left: 16.r,
              child: IconButton(onPressed: context.pop, icon: Icon(Icons.adaptive.arrow_back)))
          ],
        ),
      ),
    );
  }

  void animateToPage(PageController pageController) {
    pageController.animateToPage(_currentIndex!,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  void gotoDefaultScale() {
    _controller.value = Matrix4.identity();
  }
}
