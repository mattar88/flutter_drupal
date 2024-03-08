import 'dart:developer';

import '../../models/node/node_model.dart';

import '../file_model.dart';
import '../taxonomy/taxonomy_model.dart';

class ArticleModel extends NodeModel {
  List<FileModel>? images = [];
  List<TaxonomyModel>? tags = [];

  ArticleModel(
      {id,
      required type,
      required title,
      body,
      status,
      alias,
      langcode,
      this.tags,
      this.images})
      : super(
            id: id,
            type: type,
            title: title,
            body: body,
            status: status,
            alias: alias,
            langcode: langcode) {
    images = images ?? [];
  }

  ArticleModel.fromJson(
    Map<String, dynamic> json,
  ) : super.fromJson(json) {
    try {
      var data = json['data'];

      var imgsData = data['relationships']['field_image']['data'];
      if (imgsData != null) {
        if (imgsData is! List) {
          imgsData = [imgsData];
        }

        for (var record in imgsData) {
          var f = FileModel.fromJson({'data': record});
          images!.add(f);
        }
      }

      //Then we load all the objects of the relations using included
      if (json['included'] != null) {
        json['included'].forEach((includedJson) {
          if (includedJson['type'] == 'taxonomy_term--tags') {
            tags!.add(TaxonomyModel.fromJson({'data': includedJson}));
          }
          if (includedJson['type'] == 'file--file') {
            var indexI = images!.lastIndexWhere(
                (FileModel element) => element.id == includedJson['id']);
            var imgTemp = images![indexI];
            images![indexI] = FileModel.fromJson({'data': includedJson});
            images![indexI].alt = imgTemp.alt;
          }
        });
      }
    } catch (e) {
      throw Exception('Error occurred on ArticleModel.fromJson $e');
    }
  }

  @override
  dynamic toJson() {
    dynamic data = super.toJson();
    //Add relations
    data['data']['relationships'] = {
      "field_tags": {'data': _tagsToJson()},
      'field_image': {'data': _imagesToJson()}
    };

    // log('After ToJson ${data}');
    return data;
  }

  dynamic _tagsToJson() {
    var data = [];
    // log('_tagsToJson: ${tags!.length}');
    tags!.forEach((element) {
      data.add({
        "type": "taxonomy_term--tags",
        "id": element.id,
      });
    });
    return data;
  }

  dynamic _imagesToJson() {
    var data = [];
    // log('images.....: ${images!.length}');
    images!.forEach((element) {
      // log('_imagesToJson ${element.alt ?? 'nulllllll'}');
      data.add({
        "type": "file--file",
        "id": element.id,
        "meta": {"alt": element.alt ?? ''}
      });
    });
    return data;
  }
}
