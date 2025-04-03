import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:wajanja/utils/constants/app_colors.dart';
import 'package:wajanja/utils/mixins.dart';

class CountryDropDown extends StatelessWidget with StatelessThemesMixin {
  const CountryDropDown({super.key, required this.value, this.onChanged});

  final dynamic value;
  final void Function(Object?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          color: colorScheme(context).secondaryContainer),
      child: DropdownButton(
        value: value,
        alignment: Alignment.center,
        icon: SizedBox.shrink(),
        underline: SizedBox.shrink(),
        selectedItemBuilder: (context) {
          return List<Widget>.generate(countries.length, (index) {
            return Center(
              child: Text(
                countries.elementAt(index).flag,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(decoration: TextDecoration.none),
              ),
            );
          });
        },
        padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 17.w),
        borderRadius: BorderRadius.circular(16.r),
        focusColor: Colors.green,
        items:
            List<DropdownMenuItem<Country>>.generate(countries.length, (index) {
          final Country currentCountry = countries.elementAt(index);
          return DropdownMenuItem(
            value: currentCountry,
            child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: currentCountry.code,
                    style: Theme.of(context).textTheme.titleMedium,
                    children: [
                      TextSpan(
                          text: ' ${currentCountry.flag}',
                          style: Theme.of(context).textTheme.titleMedium)
                    ])),
          );
        }),
        onChanged: onChanged,
      ),
    );
  }
}
