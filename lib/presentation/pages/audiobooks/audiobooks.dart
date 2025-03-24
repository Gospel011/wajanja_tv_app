import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wajanja/my_tests/sample_audiobooks.dart';
import 'package:wajanja/presentation/components/audiobooks_grid.dart';
import 'package:wajanja/utils/extensions/widget_extensions.dart';
import 'package:wajanja/utils/mixins.dart';

class AudiobooksPage extends ConsumerStatefulWidget {
  const AudiobooksPage({super.key});

  @override
  ConsumerState<AudiobooksPage> createState() => _AudiobooksPageState();
}

class _AudiobooksPageState extends ConsumerState<AudiobooksPage>
    with AppBarMixin, ThemesMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, ref: ref, title: "Audio books"),
      body: CustomScrollView(
        slivers: [
          AudiobooksGrid(audiobooks: audiobooks).spSymmetric(),
        ],
      ),
    );
  }
}
