class Tablet {
  String? itemName; // 제품명
  String? efcyQesitm; // 효능
  String? useMethodQesitm; // 사용법
  String? atpnWarnQesitm; // 주의사항(경고)
  String? atpnQesitm; // 주의사항
  String? intrcQesitm; // 상호작용 (주의해야 할 약 또는 음식)

  Tablet({
    this.itemName,
    this.efcyQesitm,
    this.useMethodQesitm,
    this.atpnWarnQesitm,
    this.atpnQesitm,
    this.intrcQesitm,
  });

  factory Tablet.fromJson(Map<String, dynamic> json) {
    return Tablet(
      itemName: json['itemName'],
      efcyQesitm: json['efcyQesitm'],
      useMethodQesitm: json['useMethodQesitm'],
      atpnWarnQesitm: json['atpnWarnQesitm'],
      atpnQesitm: json['atpnQesitm'],
      intrcQesitm: json['intrcQesitm'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemName': itemName,
      'efcyQesitm': efcyQesitm,
      'useMethodQesitm': useMethodQesitm,
      'atpnWarnQesitm': atpnWarnQesitm,
      'atpnQesitm': atpnQesitm,
      'intrcQesitm': intrcQesitm,
    };
  }
}
