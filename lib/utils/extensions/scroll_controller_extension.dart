import 'package:flutter/material.dart';
import 'package:wajanja/utils/helpers/logger.dart';

extension ScrollControllerExtensions on ScrollController {
  /// When reverse is set to true, [callback] is called when the user scrolls
  /// to the top of the page.
  void paginate({required void Function() callback, bool reverse = false}) {
    addListener(() {
      final maxScrollExtent = position.maxScrollExtent;
      if (position.atEdge) {
        if (position.pixels == maxScrollExtent) {
          log.d("Bottom");

          if (!reverse) callback();
        } else {
          log.d("top");

          if (reverse) callback();
        }
      }
    });
  }
}
