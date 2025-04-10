import 'package:flutter/material.dart';

import '../database/tablet_database.dart';
import '../repository/tablet_repository.dart';

class TabletProvider extends ChangeNotifier {

  TabletRepository _TabletRepository = TabletRepository();
  Tablet? _tablet; // 단일 약품 정보 저장
  Tablet? get tablet => _tablet;

  loadTablets(String itemName) async {
    // TabletRepository 접근해서 데이터를 로드
    // listTablets에 _Tablets를 바로 작성해도 되지만 예외 처리와 추가적인 가공을 위해 나눠서 작성한다.
    Tablet? listTablets = await _TabletRepository.loadTablet(itemName);
    _tablet = listTablets!;
    notifyListeners(); // 데이터가 업데이트가 됐으면 구독자에게 알린다.
  }
}
