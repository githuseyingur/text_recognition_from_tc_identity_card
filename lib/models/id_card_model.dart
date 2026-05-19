class IdCardModel {
  final String tckn;
  final String name;
  final String surname;
  final String birthdate;
  final String serialNumber;
  final String validUntil;

  const IdCardModel({
    this.tckn = '',
    this.name = '',
    this.surname = '',
    this.birthdate = '',
    this.serialNumber = '',
    this.validUntil = '',
  });

  factory IdCardModel.fromJson(Map<String, dynamic> json) => IdCardModel(
        tckn: json['tckn'] as String? ?? '',
        name: json['name'] as String? ?? '',
        surname: json['surname'] as String? ?? '',
        birthdate: json['birthdate'] as String? ?? '',
        serialNumber: json['serialNumber'] as String? ?? '',
        validUntil: json['validUntil'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'tckn': tckn,
        'name': name,
        'surname': surname,
        'birthdate': birthdate,
        'serialNumber': serialNumber,
        'validUntil': validUntil,
      };

  String get fullName => '$name $surname'.trim();

  int get fieldCount => [tckn, name, surname, birthdate, serialNumber, validUntil]
      .where((f) => f.isNotEmpty)
      .length;
}
