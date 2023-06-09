import 'dart:async';

import 'package:doctor_robo/app/app.locator.dart';
import 'package:doctor_robo/app/app.logger.dart';
import 'package:doctor_robo/models/device.dart';
import 'package:doctor_robo/services/rtdb_service.dart';
import 'package:stacked/stacked.dart';

class OnlineStatusViewModel extends BaseViewModel {
  final log = getLogger('StatusWidget');

  final _dbService = locator<RtdbService>();

  DeviceReading? get node => _dbService.node;

  bool _isOnline = false;
  bool get isOnline => _isOnline;

  bool isOnlineCheck(DateTime? time) {
    if (time == null) return false;
    final DateTime now = DateTime.now();
    final difference = now.difference(time).inSeconds;
    // log.i("Status $difference");
    return difference >= 0 && difference <= 4;
  }

  late Timer timer;

  void setTimer() {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        _isOnline = isOnlineCheck(node?.lastSeen);
        notifyListeners();
      },
    );
  }
}
