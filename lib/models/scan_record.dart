import 'id_card_model.dart';

class ScanRecord {
  final IdCardModel card;
  final DateTime scannedAt;

  const ScanRecord({required this.card, required this.scannedAt});

  factory ScanRecord.fromJson(Map<String, dynamic> json) => ScanRecord(
        card: IdCardModel.fromJson(json['card'] as Map<String, dynamic>),
        scannedAt: DateTime.parse(json['scannedAt'] as String),
      );

  Map<String, dynamic> toJson() => {
        'card': card.toJson(),
        'scannedAt': scannedAt.toIso8601String(),
      };
}
