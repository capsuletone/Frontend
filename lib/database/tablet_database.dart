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
    String? clean(String? value) {
      if (value == null) return null;
      return value.replaceAll(RegExp(r'\\n|\n|\\\\|\\|nn|n'), '').trim();
    }

    return Tablet(
      itemName: clean(json['itemName']),
      efcyQesitm: clean(json['efcyQesitm']),
      useMethodQesitm: clean(json['useMethodQesitm']),
      atpnWarnQesitm: clean(json['atpnWarnQesitm']),
      atpnQesitm: clean(json['atpnQesitm']),
      intrcQesitm: clean(json['intrcQesitm']),
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
