import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:doctor_robo/app/app.locator.dart';
import 'package:doctor_robo/app/app.logger.dart';
import 'package:doctor_robo/services/agora_service.dart';
import 'package:stacked/stacked.dart';

class DoctorViewModel extends ReactiveViewModel {
  final log = getLogger('DcotorViewModel');
  final AgoraService _agoraService = locator<AgoraService>();

  bool get isPermissionsGranted => _agoraService.isPermissionGranted;

  int? get remoteUid => _agoraService.remoteUid;
  bool get localUserJoined => _agoraService.localUserJoined;
  RtcEngine get engine => _agoraService.engine;

  void onModelReady() async {
    setBusy(true);
    await _agoraService.getPermission();
    _agoraService.initAgora();
    // log.i(await _agoraService.fetchToken());
    setBusy(false);
  }

  @override
  List<ListenableServiceMixin> get listenableServices => [_agoraService];

  @override
  void dispose() {
    engine.leaveChannel();
    super.dispose();
  }
}
