import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:doctor_robo/app/app.locator.dart';
import 'package:doctor_robo/app/app.logger.dart';
import 'package:doctor_robo/app/app.router.dart';
import 'package:doctor_robo/models/appuser.dart';
import 'package:doctor_robo/services/agora_service.dart';
import 'package:doctor_robo/services/user_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class PatientViewModel extends ReactiveViewModel {
  final log = getLogger('PatientViewModel');
  final _userService = locator<UserService>();
  final _navigationService = locator<NavigationService>();
  final AgoraService _agoraService = locator<AgoraService>();

  AppUser? get user => _userService.user;
  bool get hasUser => _userService.hasLoggedInUser;

  void onModelReady() async {
    if (hasUser) {
      setBusy(true);
      if (user == null) {
        AppUser? _user = await _userService.fetchUser();
        if (_user != null) {
          log.i(_user.fullName);
          if (_user.userRole == "doctor") {
            _navigationService.replaceWithHomeView();
          }
        } else {
          log.i("Error");
        }
      }
      setBusy(false);
    }
  }

  ///VideoCall
  bool _isVideoCallStarted = false;
  bool get isVideoCallStarted => _isVideoCallStarted;

  void setAgora() async {
    setBusy(true);
    _isVideoCallStarted = true;
    await _agoraService.getPermission();
    _agoraService.initAgora(user!);
    setBusy(false);
  }

  void leaveCall() {
    _isVideoCallStarted = false;
    engine!.leaveChannel();
    notifyListeners();
  }

  bool get isPermissionsGranted => _agoraService.isPermissionGranted;
  int? get remoteUid => _agoraService.remoteUid;
  bool get localUserJoined => _agoraService.localUserJoined;
  RtcEngine? get engine => _agoraService.engine;

  @override
  List<ListenableServiceMixin> get listenableServices => [_agoraService];

  @override
  void dispose() {
    if (_isVideoCallStarted) engine!.leaveChannel();
    super.dispose();
  }

  ///===========================================
  void logout() {
    _userService.logout();
    _navigationService.replaceWithHomeView();
  }

  void openLoginView() {
    _navigationService.navigateToLoginView(userRole: "patient");
  }

  void openRegisterView() {
    _navigationService.navigateToRegisterView(userRole: "patient");
  }
}
