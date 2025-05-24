// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'report_model.g.dart';

@JsonSerializable()
class ReportModel {
  final String id;
  @JsonKey(name: 'user_id')
  final String? userId;
  @JsonKey(name: 'status_read')
  final String statusRead;
  final String status;
  @JsonKey(name: 'detail_pesan')
  final String? detailPesan;
  @JsonKey(name: 'pesan_type')
  final String pesanType;
  @JsonKey(name: 'item_id')
  final String itemId;
  ReportModel({
    required this.id,
    this.userId,
    required this.statusRead,
    required this.status,
    this.detailPesan,
    required this.pesanType,
    required this.itemId,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) =>
      _$ReportModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReportModelToJson(this);
}
