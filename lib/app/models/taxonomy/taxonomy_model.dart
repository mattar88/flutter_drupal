import 'dart:developer';

class TaxonomyModel {
  
  late String? id;
  late String vocabulary;
  late String name;
  late String? description;
  late bool? status;
  String? alias;
  late String? langcode;
  List<Map<String, dynamic>>? parent = [];

  TaxonomyModel(
      {this.id,
      required this.vocabulary,
      required this.name,
      this.description,
      this.status,
      this.alias,
      this.parent,
      this.langcode});

  TaxonomyModel.fromJson(Map<String, dynamic> json) {
    var data = json['data'];
    id = data['id'];
    vocabulary = data['type'].toString().replaceAll('taxonomy_term--', '');
    name = data['attributes']['name'];
    description = data['attributes']['description'] != null
        ? data['attributes']['description']['value']
        : '';
    langcode = data['attributes']['langcode'] != null
        ? data['attributes']['langcode']
        : '';
    alias = data['attributes']['path'] != null
        ? data['attributes']['path']['alias']
        : '';
    status = data['attributes']['status'];
    langcode = data['attributes']['langcode'] ?? '';
    data['relationships']['parent']['data'].forEach((element) {
      if (element['id'] != 'virtual') {
        parent!.add({'id': element['id'], 'vocabulary': vocabulary});
      }
    });
  }

  dynamic toJson() {
    dynamic data = {
      "data": {
        "type": "taxonomy_term--$vocabulary",
        "id": id,
        "attributes": {
          "name": name,
          "description": {"value": description, "format": "plain_text"},
          "path": {"alias": alias},
          "status": status
        }
      }
    };

    data['data']!['relationships'] = {
      'parent': {
        'data': parent != null && parent!.isNotEmpty
            ? parent!.map((term) {
                return {"type": "taxonomy_term--$vocabulary", "id": term['id']};
              }).toList()
            : []
      }
    };

    return data;
  }
}
