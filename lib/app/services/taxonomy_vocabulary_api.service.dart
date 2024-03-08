import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import '../models/taxonomy/taxonomy_vocabulary_mode.dart';
import 'api_service.dart';

class TaxonomyVocabularyApiService extends ApiService {
  static String taxonomyVocabularyPath =
      '/taxonomy_vocabulary/taxonomy_vocabulary';

  Future<List<TaxonomyVocabularyModel>?> list() async {
    return get(taxonomyVocabularyPath, headers: {
      // 'Content-type': 'application/vnd.api+json',
      'Accept': 'application/json'
    }).then((response) {
      log('response.statusCode: ${response.statusCode}');
      // log('${response.statusText}, ${response.statusCode}, ${response.body.toString()}');
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);

        if (result['data'] != null) {
          return List<TaxonomyVocabularyModel>.from(result['data']
              .map((vocabularyJson) =>
                  TaxonomyVocabularyModel.fromJson(vocabularyJson))
              .toList());
        }
      } else {
        if (response.statusCode == HttpStatus.unauthorized) {
          throw Exception(
              'An error occurred when load list of taxonomies maybe you don\'t have the right permissions!');
        }
        throw Exception(
            'An error occurred please try again ${response.statusCode}');
      }
      //
    });
  }
}
