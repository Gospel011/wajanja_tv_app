import 'package:flutter/material.dart';
import 'package:wajanja/presentation/widgets/my_loading_widget.dart';

class LoadingStatesWidget extends StatelessWidget {
  const LoadingStatesWidget({
    super.key,
    required this.isLoading,
    required this.isEmpty,
    required this.emptyText,
  });
  final bool isLoading;
  final bool isEmpty;
  final String emptyText;

  @override
  Widget build(BuildContext context) {
    // CENTERED LOADING WIDGET WHEN LOADING INITALLY
    if (isLoading && isEmpty) {
      return SliverFillRemaining(child: Center(child: MyLoadingWidget()));
    }

    // LOADING WIDGET WHEN PAGINATING
    if (isLoading && !isEmpty) {
      return SliverToBoxAdapter(child: MyLoadingWidget());
    }

    // NO ITEM AND IS NOT FETCHING
    if (!isLoading && isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Text(
            emptyText,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return SliverToBoxAdapter(child: SizedBox.shrink());
  }
}
