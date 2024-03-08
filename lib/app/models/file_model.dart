import 'package:intl/intl.dart';

import '../../flavors/build_config.dart';

class FileModel {
  String? type = 'file-file';
  String? id;
  String? filename;
  Uri? uri;
  String? url;
  String? filemime;
  String? alt;
  int? filesize;
  bool? status;
  DateTime? created;
  DateTime? changed;

  FileModel(
      {this.type,
      this.id,
      this.filename,
      this.filemime,
      this.filesize,
      this.alt,
      this.uri,
      this.url,
      this.status,
      this.created,
      this.changed});

  FileModel.fromJson(Map<String, dynamic> json) {
    var data = json['data'];
    try {
      DateFormat dateFormat = DateFormat("yyyy-MM-ddTHH:mm:ssZ");
      type = data['type'];
      id = data['id'];
      if (data.containsKey('meta')) {
        alt = data['meta']['alt'];
      }

      if (data.containsKey('attributes')) {
        filename = data['attributes']['filename'];
        filemime = data['attributes']['filemime'];
        filesize = data['attributes']['filesize'];
        status = data['attributes']['status'];

        //Date ISO8601 format
        created = dateFormat.parse(data['attributes']['created']);

        // log('Hour: ${created!.hour},Minute: ${created!.minute}, second: ${created!.second}');
        changed = dateFormat.parse(data['attributes']['changed']);

        var baseUrl = Uri.parse(BuildConfig.instance.config.baseUrl);
        uri = Uri(
            scheme: baseUrl.scheme,
            host: baseUrl.host,
            path: data['attributes']['uri']['url']);
      }
    } catch (e) {
      throw Exception('An error occurred in FileModel.fromJson(): $e');
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = type;
    data['id'] = id;
    data['filename'] = filename;
    data['alt'] = alt;
    data['status'] = status;

    return data;
  }
}
