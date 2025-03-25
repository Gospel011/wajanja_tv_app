import 'package:flutter/material.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:wajanja/utils/helpers/logger.dart';
import 'package:wajanja/utils/mixins.dart';

class MyExpandableText extends StatefulWidget {
  const MyExpandableText(this.text,
      {super.key,
      this.maxLines,
      this.textStyle,
      this.linkStyle,
      this.onTextTap});
  final String text;
  final int? maxLines;
  final TextStyle? linkStyle;
  final TextStyle? textStyle;
  final VoidCallback? onTextTap;

  @override
  State<MyExpandableText> createState() => _MyExpandableTextState();
}

class _MyExpandableTextState extends State<MyExpandableText>
    with ThemesMixin, UiInfoMixin, UrlMixin {
  // Future<void> _launchUrl(String url, context) async {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTextTap,
      child: ExpandableText(
        widget.text,
        maxLines: widget.maxLines ?? 4,
        collapseOnTextTap: true,
        style: widget.textStyle,
        expandOnTextTap: widget.onTextTap == null,
        expandText: "read more",
        linkStyle: TextStyle(
          color:
              isDarkTheme ? colorScheme.primary : colorScheme.tertiaryFixedDim,
          fontWeight: isDarkTheme ? FontWeight.w500 : FontWeight.bold,
        ).merge(widget.linkStyle),
        onUrlTap: (url) {
          log.f("Url $url tapped");

          // launch(url, context);
          launch(context, uri: Uri.parse(url));
        },
        urlStyle: TextStyle(
          color: colorScheme.primary,
          fontWeight: FontWeight.w500,
          overflow: TextOverflow.ellipsis,
        ),
        // linkStyle: const TextStyle(
        //   color: Colors.black,
        // ),
        // hashtagStyle:
        //     const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        // onHashtagTap: (value) {
        //   log.i("Hashtag $value tapped");
        // },
        // mentionStyle:
        //     const TextStyle(color: Colors.blue, fontWeight: FontWeight.w500),
        onMentionTap: (value) {
          // log.i("Mention: $value tapped");
        },
        collapseText: "",
      ),
    );
  }
}
