import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wajanja/data_layer/models/audiobook/audiobook.dart';
import 'package:wajanja/presentation/widgets/audiobook_widget.dart';



class AudiobooksGrid extends StatelessWidget {
  const AudiobooksGrid({
    super.key,
    required this.audiobooks,
  });

  final List<Audiobook> audiobooks;

  @override
  Widget build(BuildContext context) {
    return SliverGrid.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 199 / 386,
          mainAxisSpacing: 20.h,
          crossAxisSpacing: 10.w),
      itemBuilder: (context, index) {
        final audiobook = audiobooks.elementAt(0);
        // final postedBy = ref.read(authNotifierProvider).user!;

        return AudiobookWidget(
          audiobook: audiobook,
        );
      },
    );
  }
}
