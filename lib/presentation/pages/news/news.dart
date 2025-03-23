import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:wajanja/data_layer/models/news/news.dart';
import 'package:wajanja/data_layer/models/user_model/user.dart';
import 'package:wajanja/data_layer/providers/auth_provider/auth_provider.dart';
import 'package:wajanja/my_tests/sample_news.dart';
import 'package:wajanja/presentation/widgets/my_image_widget.dart';
import 'package:wajanja/presentation/widgets/news_widget.dart';
import 'package:wajanja/presentation/widgets/profile_picture.dart';
import 'package:wajanja/utils/constants/enums.dart';
import 'package:wajanja/utils/extensions/string_extension.dart';
import 'package:wajanja/utils/extensions/widget_extensions.dart';
import 'package:wajanja/utils/mixins.dart';

class NewsPage extends ConsumerStatefulWidget {
  const NewsPage({super.key});

  @override
  ConsumerState<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends ConsumerState<NewsPage>
    with AppBarMixin, ThemesMixin {
  late final User user;

  @override
  void initState() {
    super.initState();
    user = ref.read(authNotifierProvider).user!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(ref, title: "News"),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: SizedBox(height: 32.h,)),
          SliverList.builder(
            itemBuilder: (context, index) {
              final news = sampleNews.elementAt(index);

              return NewsWidget(
                news: news,
                onTap: () {
                  context.pushNamed(
                    AppRoutes.newsDetails.name,
                    extra: news,
                  );
                },
              ).pOnly(bottom: 20.h);
            },
            itemCount: sampleNews.length,
          ).spSymmetric()
        ],
      ),
    );
  }
}
