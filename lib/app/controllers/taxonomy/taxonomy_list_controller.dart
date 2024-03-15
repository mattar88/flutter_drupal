import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import '../../controllers/taxonomy/taxonomy_controller.dart';

import '../../models/taxonomy/taxonomy_model.dart';
import '../../services/taxonomy_api_service.dart';

import 'package:get/get.dart';

class TaxonomyListController extends TaxonomyController {
  final TaxonomyApiService _taxonomyApiService;
  final String vocabulary;
  final bool localeEnabled = true;
  Rxn<bool> isLoading = Rxn<bool>(false);
  var list = RxList(<TaxonomyModel>[]);
  var reachTheEnd = Rxn<bool>(false);

  int range = 10;
  final int scrollAdvancedReachEnd = 100;
  late double scrollOffset;
  late ScrollPosition scrollPosition;

  Map<String, List<TaxonomyModel>?> searchCache = {};
  String lastSearch = '';

  String title = '';

  ///Save the last search apply
  Map<String, dynamic> lastFilter = {
    'filterSelected': null,
    'value': null,
    'operation': null
  };

  ///Used to syncronize and prevent disable the load progress indicator
  int onSearchQueryCount = 0;

  ///To stop loading when Load all items
  int tryLazyLoad = 2;

  late ScrollController listViewController = ScrollController();
  TaxonomyListController(this.vocabulary, this._taxonomyApiService)
      : super(_taxonomyApiService);

  String generateSearchKey(filterSelected, value, operation) {
    return filterSelected.toString() + value.toString() + operation.toString();
  }

  ///Handle the search for the field in the AppBar
  void onSearch(filterSelected, value, operation) async {
    tryLazyLoad = 1;

    lastFilter = {
      'filterSelected': filterSelected,
      'value': value,
      'operation': operation
    };
    try {
      var currentSearch = generateSearchKey(filterSelected, value, operation);

      ///lastSearch it's the last query applied in future, it used to return
      lastSearch = generateSearchKey(filterSelected, value, operation);

      log('OnSearch----${filterSelected}---${value}---${operation}');

      // waiting to get last search
      await Future<void>.delayed(const Duration(milliseconds: 500));

      //if equal apply a remote request search
      if (currentSearch == lastSearch) {
        //Maybe already exist same request
        if (searchCache.keys
            .where((record) => currentSearch == record)
            .isEmpty) {
          onSearchQueryCount++;
          if (onSearchQueryCount == 1) {
            isLoading.value = true;
          }
          //put the cache null to skip the repeated
          //queries meanwhile the remote one done
          searchCache[currentSearch] = <TaxonomyModel>[];
          searchCache[currentSearch] = (await _taxonomyApiService.filterList(
              vocabulary,
              filterName: filterSelected,
              text: value,
              offset: 0,
              limit: range,
              localeEnabled: localeEnabled));

          if (onSearchQueryCount == 1) {
            isLoading.value = false;
            reachTheEnd.value = false;
          }
          onSearchQueryCount--;
        }

        list.value = searchCache[lastSearch] ?? <TaxonomyModel>[];
      }
      // return
      // log('is logged in : ${crednetials!.accessToken}');
    } catch (e) {
      isLoading.value = false;
      reachTheEnd.value = false;
      // printLog(e);
      printError(info: e.toString());
      rethrow;
    }
  }

  @override
  void onInit() {
    log('enter second scroll on init--------------------');
    title = Get.arguments['title'];
    listViewController.addListener(_scrollListener);
    filterList(vocabulary, offset: 0, limit: range);
    super.onInit();
  }

  @override
  void dispose() {
    listViewController.dispose();
    super.dispose();
  }

  void addListItem(TaxonomyModel taxonomy) {
    list.insert(0, taxonomy);
  }

  List<TaxonomyModel> editListItem(
      String vocabulary, String id, TaxonomyModel taxonomy) {
    try {
      list[list.indexWhere((taxonomyI) => taxonomyI.id == id)] = taxonomy;
      return list;
    } catch (e) {
      printError(info: e.toString());
      rethrow;
    }
  }

  bool deleteListItem(String id) {
    try {
      list.value = list.where((taxonomyI) => taxonomyI.id != id).toList();
      searchCache.clear();
      return true;
    } catch (e) {
      printError(info: e.toString());
      rethrow;
    }
  }

  ///Handler used to load new items
  _scrollListener() {
    scrollOffset = listViewController.positions.last.pixels;
    scrollPosition = listViewController.positions.last;
    if (scrollOffset < 0) listViewController.jumpTo(0);

    if (scrollOffset + scrollAdvancedReachEnd >=
            scrollPosition.maxScrollExtent &&
        !scrollPosition.outOfRange) {
      if (!isLoading.value! && tryLazyLoad > 0) {
        var length = list.length;
        reachTheEnd.value = true;

        filterList(vocabulary,
                filterName: lastFilter['filterSelected'],
                text: lastFilter['value'],
                offset: length,
                limit: range)
            .then((value) {
          if (list.length < length + range) {
            tryLazyLoad--;
          }
        });
      }
    }
    if (scrollOffset <= scrollPosition.minScrollExtent &&
        !scrollPosition.outOfRange) {
      log('Reach the top');
    }
  }

  void setReachTheEnd(bool status) => reachTheEnd.value = status;
  void setLoading(bool status) => isLoading.value = status;

  void loadList({int offset = 0, int limit = 0}) {
    isLoading.value = true;

    getTaxonomies(vocabulary, offset: offset, limit: limit).then((value) async {
      list.addAll(value!);
      isLoading.value = false;
      reachTheEnd.value = false;
    });
  }

  Future<void> filterList(String vocabulary,
      {String? filterName,
      String? text,
      int? offset,
      int? limit,
      bool localeEnabled = false}) async {
    try {
      isLoading.value = true;

      list.addAll((await _taxonomyApiService.filterList(vocabulary,
          filterName: filterName,
          text: text,
          offset: offset,
          limit: limit,
          localeEnabled: localeEnabled))!);
      isLoading.value = false;
      reachTheEnd.value = false;

      // return
      // log('is logged in : ${crednetials!.accessToken}');
    } catch (e) {
      // printLog(e);
      isLoading.value = false;
      printError(info: e.toString());
      rethrow;
    }
  }
}
