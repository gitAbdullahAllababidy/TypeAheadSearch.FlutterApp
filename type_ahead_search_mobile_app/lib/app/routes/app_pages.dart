import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:type_ahead_search_mobile_app/app/features/search_feature/binding/details_binding.dart';
import 'package:type_ahead_search_mobile_app/app/features/search_feature/binding/search_binding.dart';
import 'package:type_ahead_search_mobile_app/app/features/search_feature/views/details_view.dart';
import 'package:type_ahead_search_mobile_app/app/features/search_feature/views/search_view.dart';

part 'app_routes.dart';
class AppPages {
  static const INITIAL = Routes.SEARCH;

  static final routes = [
    GetPage(
      name: Routes.SEARCH,
      page: () => const SearchView(),
      binding: SearchBinding(),
      transition: Transition.fadeIn,
      preventDuplicates: true,
      // Add custom transitions with minimal overhead
      curve: Curves.easeInOut,
    ),
    GetPage(
      name: Routes.DETAILS,
      page: () => const DetailsView(),
      binding: DetailsBinding(),
      transition: Transition.rightToLeftWithFade,
      preventDuplicates: true,
      curve: Curves.easeInOut,
    ),
  ];
}







