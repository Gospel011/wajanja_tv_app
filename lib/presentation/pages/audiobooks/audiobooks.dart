import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wajanja/utils/mixins.dart';

class AudiobooksPage extends ConsumerStatefulWidget {
  const AudiobooksPage({super.key});

  @override
  ConsumerState<AudiobooksPage> createState() => _AudiobooksPageState();
}

class _AudiobooksPageState extends ConsumerState<AudiobooksPage> with AppBarMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(ref, title: "Audio books"),
      body: CustomScrollView(
        slivers: [
         
        ],
      ),
    );
  
  }
}