import 'dart:developer';

import 'package:flutter/cupertino.dart';
import '../../controllers/node/node_controller.dart';
import 'package:get/get.dart';

import '../../models/node/node_model.dart';
import '../../services/node_api_service.dart';

class NodeListController extends NodeController {
  final NodeApiService _nodeApiService;
  final String nodeType;

  Rxn<bool> isLoading = Rxn<bool>(false);
  var list = RxList(<NodeModel>[]);
  var reachTheEnd = Rxn<bool>(false);

  int range = 10;
  final int scrollAdvancedReachEnd = 100;
  late double scrollOffset;
  late ScrollPosition scrollPosition;

  Map<String, List<NodeModel>?> searchCache = {};
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
  NodeListController(this.nodeType, this._nodeApiService)
      : super(_nodeApiService);

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
          searchCache[currentSearch] = <NodeModel>[];
          searchCache[currentSearch] = (await _nodeApiService.filterList(
                  nodeType,
                  filterTitle: filterSelected,
                  text: value,
                  offset: 0,
                  limit: range))!
              .cast<NodeModel>();

          if (onSearchQueryCount == 1) {
            isLoading.value = false;
            reachTheEnd.value = false;
          }
          onSearchQueryCount--;
        }

        list.value = searchCache[lastSearch] ?? <NodeModel>[];
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
    filterList(nodeType, offset: 0, limit: range);
    super.onInit();
  }

  @override
  void dispose() {
    listViewController.dispose();
    super.dispose();
  }

  void addListItem(NodeModel node) {
    list.insert(0, node);
  }

  List<NodeModel> editListItem(String nodeType, String id, NodeModel node) {
    try {
      list[list.indexWhere((nodeI) => nodeI.id == id)] = node;
      return list;
    } catch (e) {
      printError(info: e.toString());
      rethrow;
    }
  }

  bool deleteListItem(String id) {
    try {
      list.value = list.where((nodeI) => nodeI.id != id).toList();
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

        filterList(nodeType,
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

    getNodes(nodeType, offset: offset, limit: limit).then((value) async {
      list.addAll(value! as Iterable<NodeModel>);
      isLoading.value = false;
      reachTheEnd.value = false;
    });
  }

  Future<void> filterList(String nodeType,
      {String? filterName, String? text, int? offset, int? limit}) async {
    try {
      isLoading.value = true;

      list.addAll((await _nodeApiService.filterList(nodeType,
          filterTitle: filterName,
          text: text,
          offset: offset,
          limit: limit))! as Iterable<NodeModel>);
      isLoading.value = false;
      reachTheEnd.value = false;

      // return
      // log('is logged in : ${crednetials!.accessToken}');
    } catch (e) {
      // printLog(e);
      printError(info: e.toString());
      rethrow;
    }
  }
}
