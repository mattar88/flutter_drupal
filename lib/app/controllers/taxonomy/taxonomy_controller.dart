import 'dart:convert';
import 'dart:developer';
import '../../models/taxonomy/taxonomy_model.dart';
import '../../services/taxonomy_api_service.dart';

import 'package:get/get.dart';

import '../base_controller.dart';

class TaxonomyController extends BaseController {
  final TaxonomyApiService _taxonomyApiService;

  TaxonomyController(this._taxonomyApiService);

  Future<List<TaxonomyModel>?> getTaxonomies(String vocabulary,
      {String? name, String condition = 'CONTAINS', offset, limit}) async {
    try {
      return await _taxonomyApiService.list(vocabulary,
          name: name, condition: condition, offset: offset, limit: limit);
    } catch (e) {
      printError(info: e.toString());
      rethrow;
    }
  }

  Future<TaxonomyModel?> load(String vocabulary, String id) async {
    try {
      return await _taxonomyApiService.load(vocabulary, id);
    } catch (e) {
      printError(info: e.toString());
      rethrow;
    }
  }

  Future<TaxonomyModel> create(TaxonomyModel taxonomy) async {
    try {
      return await _taxonomyApiService.create(taxonomy);
    } catch (e) {
      printError(info: e.toString());
      rethrow;
    }
  }

  Future<TaxonomyModel> edit(TaxonomyModel taxonomy) async {
    try {
      return await _taxonomyApiService.update(taxonomy);
    } catch (e) {
      printError(info: e.toString());
      rethrow;
    }
  }

  Future<bool> delete(String vocabulary, String id) async {
    try {
      return await _taxonomyApiService.remove(vocabulary, id);

      // log('GetTaxonomyList:  ${response.body}');
    } catch (e) {
      printError(info: e.toString());

      rethrow;
    }
  }
}
