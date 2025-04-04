import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wajanja/data_layer/models/search/search.dart';
import 'package:wajanja/data_layer/providers/audiobooks_provider/audiobooks_provider.dart';
import 'package:wajanja/my_tests/sample_audiobooks.dart';
import 'package:wajanja/presentation/components/audiobooks_grid.dart';
import 'package:wajanja/presentation/widgets/loading_states_widget.dart';
import 'package:wajanja/presentation/widgets/my_search_bar.dart';
import 'package:wajanja/utils/constants/enums.dart';
import 'package:wajanja/utils/extensions/widget_extensions.dart';
import 'package:wajanja/utils/helpers/logger.dart';
import 'package:wajanja/utils/mixins.dart';

class AudiobooksPage extends ConsumerStatefulWidget {
  const AudiobooksPage({super.key});

  @override
  ConsumerState<AudiobooksPage> createState() => _AudiobooksPageState();
}

class _AudiobooksPageState extends ConsumerState<AudiobooksPage>
    with AppBarMixin, ThemesMixin, PaginationMixin {
  Search search = Search();

  ScrollController scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();
  int get page => calculatePage(
      itemCount: ref.read(audiobooksNotifierProvider).audiobooks.length);

  void searchAudiobooks(String text, Search searchObj,
      {bool newSearch = false}) {
    ref.read(audiobooksNotifierProvider.notifier).fetchAudiobooks(
          query: text,
          countryCode: searchObj.country.code,
          newSearch: newSearch,
          page: page,
        );
  }

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      paginationScrollControllerListener(scrollController, onBottomReached: () {
        log.i("At bottom");

        log.f("REQUESTING LODGES FOR PAGE: $page");

        searchAudiobooks(searchController.text.trim(), search);
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(audiobooksNotifierProvider.notifier)
          .fetchAudiobooks(countryCode: search.country.code);
    });
  }

  @override
  Widget build(BuildContext context) {
    final audiobooksState = ref.watch(audiobooksNotifierProvider);

    return Scaffold(
      appBar: buildAppBar(context, ref: ref, title: "Audio books"),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
              child: SizedBox(
            height: 32.h,
          )),
          SliverToBoxAdapter(
              child: MySearchBar(
            search: search,
            searchController: searchController,
            onSearch: searchAudiobooks,
          ).pSymmetric()),
          SliverToBoxAdapter(
              child: SizedBox(
            height: 32.h,
          )),
          AudiobooksGrid(audiobooks: audiobooksState.audiobooks).spSymmetric(),

          LoadingStatesWidget(
            isLoading: audiobooksState.states == AudiobooksStates.fetchingAudiobooks,
            isEmpty: audiobooksState.audiobooks.isEmpty,
            emptyText: "No audiobooks found in ${search.country.name}",
          ),
        ],
      ),
    );
  }
}
