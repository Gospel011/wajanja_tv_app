import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wajanja/my_tests/sample_news.dart';
import 'package:wajanja/utils/constants/enums.dart';
import 'package:wajanja/utils/mixins.dart';

class NewsPage extends ConsumerStatefulWidget {
  const NewsPage({super.key});

  @override
  ConsumerState<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends ConsumerState<NewsPage> with AppBarMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(ref, title: "News"),
      body: CustomScrollView(
        slivers: [
          SliverList.builder(
            itemBuilder: (context, index) {
              final news = sampleNews.elementAt(index);
              return Row(
                children: [Expanded(child: Text(news.title))],
              );
            },
            itemCount: sampleNews.length,
          )
        ],
      ),
    );
  }
}
