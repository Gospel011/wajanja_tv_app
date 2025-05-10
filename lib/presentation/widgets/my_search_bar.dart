import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:wajanja/data_layer/models/search/search.dart';
import 'package:wajanja/presentation/widgets/country_drop_down.dart';
import 'package:wajanja/presentation/widgets/my_textformfield.dart';
// import 'package:wajanja/utils/helpers/logger.dart';

class MySearchBar extends StatefulWidget {
  const MySearchBar({
    super.key,
    required this.search,
    this.searchController,
    required this.onSearch,
  });
  final Search search;
  final TextEditingController? searchController;
  final void Function(String text, Search filters, {bool newSearch}) onSearch;

  @override
  State<MySearchBar> createState() => _MySearchBarState();
}

class _MySearchBarState extends State<MySearchBar> {
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = widget.searchController ?? TextEditingController();

    searchController.text = widget.search.text;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      // key: phoneKey,
      spacing: 8.w,
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: MyTextFormField(
            controller: searchController,
            hintText: 'Search',
            // keyboardType: Textinp,
            textInputAction: TextInputAction.search,
            onChanged: (value) {
              widget.search.text = value;
            },
            onFieldSubmitted: (value) {
              // log.f("FIELD SUBMITTED");

              widget.onSearch(value, widget.search, newSearch: true);
            },
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
            validator: (value) => null,
          ),
        ),
        CountryDropDown(
          value: widget.search.country,
          onChanged: (value) {
            // log.i("Clicked value is $value");

            if (value == null || value is! Country) return;

            setState(() {
              widget.search.country = value;
              widget.onSearch(searchController.text, widget.search,
                  newSearch: true);
            });
          },
        ),
      ],
    );
  }
}
