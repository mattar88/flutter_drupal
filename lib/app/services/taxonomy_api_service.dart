import 'dart:convert';
import 'dart:developer';

import '../locale/config_locale.dart';
import '../models/taxonomy/taxonomy_model.dart';
import 'api_service.dart';

class TaxonomyApiService extends ApiService {
  static String taxonomyPath = '/taxonomy_term';

  Map<String, Map<String, dynamic>> _filterListQueryCache = {};

  Future<List<TaxonomyModel>?> filterList(String vocabulary,
      {String? filterName,
      String? text,
      String? operation,
      int? offset,
      int? limit,
      bool localeEnabled = false}) async {
    Map<String, dynamic> filterQuery = {};
    var filterNameQuery = '${text}_$filterName';
    // bool allFiltersEmpty =
    //     (filter == null);
    log('Enter----FilterList ${filterName}');
    if (_filterListQueryCache.containsKey(filterNameQuery)) {
      filterQuery = _filterListQueryCache[filterNameQuery]!;
    } else {
      var textIsNotEmpty = (text != null && text.replaceAll(' ', '') != "");

      if (textIsNotEmpty) {
        //All filters unselected should search on name or description
        if (filterName == null) {
          filterQuery['filter[or-group][group][conjunction]'] = 'OR';
        }
        if (filterName == 'name' ||
            filterName == "published" ||
            filterName == null) {
          filterQuery['filter[name-filter][condition][path]'] = 'name';
          filterQuery['filter[name-filter][condition][value]'] = text;
          filterQuery['filter[name-filter][condition][operator]'] = 'CONTAINS';
          if (filterName == null) {
            filterQuery['filter[name-filter][condition][memberOf]'] =
                'or-group';
          }
        }

        if (filterName == 'description' ||
            filterName == "published" ||
            filterName == null) {
          filterQuery['filter[description-filter][condition][path]'] =
              'description.value';
          filterQuery['filter[description-filter][condition][value]'] = text;
          filterQuery['filter[description-filter][condition][operator]'] =
              'CONTAINS';
          if (filterName == null) {
            filterQuery['filter[description-filter][condition][memberOf]'] =
                'or-group';
          }
        }
      }

      if (filterName == "published") {
        filterQuery['filter[status-filter][condition][path]'] = 'status';
        filterQuery['filter[status-filter][condition][value]'] = '1';
        filterQuery['filter[status-filter][condition][operator]'] = '=';

        if (textIsNotEmpty) {
          filterQuery['filter[and-status-group][group][conjunction]'] = 'AND';
          filterQuery['filter[or-status-group][group][conjunction]'] = 'OR';
          //Put the OR group into the AND GROUP
          filterQuery['filter[or-status-group][group][memberOf]'] =
              'and-status-group';
          filterQuery['filter[status-filter][condition][memberOf]'] =
              'and-status-group';
          filterQuery['filter[name-filter][condition][memberOf]'] =
              'or-status-group';
          filterQuery['filter[description-filter][condition][memberOf]'] =
              'or-status-group';
        }
      }

      if (filterQuery.isNotEmpty) {
        _filterListQueryCache = {};
        _filterListQueryCache[filterNameQuery] = filterQuery;
        // log('_filterListQueryCache ----- ${_filterListQueryCache}');
      }
    }

    filterQuery['sort[sort-created][path]'] = 'revision_created';
    filterQuery['sort[sort-created][direction]'] = 'DESC';

    if (offset != null && limit != null) {
      filterQuery['page[offset]'] = offset.toString();
      filterQuery['page[limit]'] = limit.toString();
    }

    return getTaxonomiesByFilter(vocabulary, filterQuery, localeEnabled);
  }

  Future<List<TaxonomyModel>?> list(String vocabulary,
      {String? name,
      String condition = 'CONTAINS',
      int? offset,
      int? limit,
      bool localeEnabled = false}) async {
    var filterName = '${vocabulary}filterByName';
    Map<String, dynamic> filter = {};
    if (offset != null && limit != null) {
      filter['page[offset]'] = offset.toString();
      filter['page[limit]'] = limit.toString();
    }
    if (name != null) {
      filter['filter[$filterName][condition][path]'] = 'name';
      filter['filter[$filterName][condition][value]'] = name;
      filter['filter[$filterName][condition][operator]'] = condition;
    }
    log('Filterrrr --- ${filter}');
    return getTaxonomiesByFilter(vocabulary, filter, localeEnabled);
  }

  Future<List<TaxonomyModel>?> getTaxonomiesByFilter(String vocabulary,
      Map<String, dynamic> filter, bool localeEnabled) async {
    if (localeEnabled && ConfigLocale.supportedLocales) {
      filter['filter[langcode]'] =
          ConfigLocale.currentLocale.locale.languageCode;
    }
    var response = await get('$taxonomyPath/$vocabulary', query: filter);
    var result = jsonDecode(response.body);
    if (response.isOk) {
      log('dataaaa:${result}');
      return List<TaxonomyModel>.from(result['data']
          .map((taxonomyJson) => TaxonomyModel.fromJson({'data': taxonomyJson}))
          .toList());
    } else {
      throw Exception(
          'An error occurred when load list of terms(${result['error_messages']}), please try again');
    }
  }

  Future<TaxonomyModel?> load(String vocabulary, String id) async {
    var response = await get(
      '$taxonomyPath/$vocabulary/$id',
    );

    var result = jsonDecode(response.body);
    if (response.isOk) {
      return TaxonomyModel.fromJson(result);
    } else {
      throw Exception(
          'An error occurred when load taxonomy (${result['error_messages']}) please try again ${response.statusCode}');
    }
  }

  Future<TaxonomyModel> create(TaxonomyModel taxonomy) async {
    log('create--------${taxonomy.toJson()}');
    var response =
        await post('$taxonomyPath/${taxonomy.vocabulary}', taxonomy.toJson());
    var result = jsonDecode(response.body);
    if (response.isOk) {
      return TaxonomyModel.fromJson(result);
    } else {
      throw Exception(
          'An error occurred when creating an taxonomy(${result['error_messages']}), please try again! ${response.statusText}');
    }
  }

  Future<TaxonomyModel> update(TaxonomyModel taxonomy) async {
    log('update................${taxonomy.toJson()}');

    var response = await patch(
        '$taxonomyPath/${taxonomy.vocabulary}/${taxonomy.id}',
        taxonomy.toJson());
    log('Status error: ${response.statusText}, ${response.statusCode}');
    var result = jsonDecode(response.body);
    if (response.isOk) {
      return TaxonomyModel.fromJson(result);
    } else {
      throw Exception(
          'An error occurred when updating an taxonomy(${result['error_messages']}), please try again');
    }
  }

  ///Delete taxonomy by pass `vocabulary` and UUID `id`
  Future<bool> remove(String vocabulary, String id) async {
    log('delete taxonomy******delete********* ${id}');
    var response = await delete('$taxonomyPath/$vocabulary/$id');
    if (response.isOk) {
      return true;
    } else {
      //Only on exception response has body
      var result = jsonDecode(response.body);
      throw Exception(
          'An error occurred when deleting an taxonomy(${result['error_messages']}), please try again!');
    }
  }
}
