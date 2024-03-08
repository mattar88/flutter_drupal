import 'enum/message_status.dart';

class MessageModel {
  MessageStatus? status;
  String? title;
  String message;
  MessageModel({this.status, this.title, required this.message});
}
