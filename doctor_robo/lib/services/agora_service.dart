import 'dart:convert';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:doctor_robo/app/app.bottomsheets.dart';
import 'package:doctor_robo/app/app.locator.dart';
import 'package:doctor_robo/app/app.logger.dart';
import 'package:doctor_robo/constants/app_keys.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:http/http.dart' as http;

import 'firestore_service.dart';

// const token = "006bdbedca4074a4e9da74fcbe4448aa5b8IAC7/lBJDYGnEfDI6bXW7ixxd1aybDZrs+gm7j2x6UGz4OR+K9i379yDEABg+PwCKwYsZAEAAQDXtSpk";
const channel = "robot";

class AgoraService with ListenableServiceMixin {
  final log = getLogger('AgoraService');
  final _bottomSheetService = locator<BottomSheetService>();
  final _firestoreService = locator<FirestoreService>();

  ///Permission======================================
  final Permission _permissionCamera = Permission.camera;
  final Permission _permissionMicrophone = Permission.microphone;
  bool _isPermissionGranted = true;
  bool get isPermissionGranted => _isPermissionGranted;
  Future<bool> getPermission() async {
    bool isCameraPermissionGranted = await _permissionCamera.isGranted;
    bool isMicrophonePermissionGranted = await _permissionMicrophone.isGranted;

    // if (isCameraPermissionGranted & isMicrophonePermissionGranted) {
    //   log.i("All permissions granted");
    //   _isPermissionGranted = true;
    //   return _isPermissionGranted;
    // }

    //Camera
    if (!isCameraPermissionGranted) {
      PermissionStatus status = await _permissionCamera.request();
      if (status == PermissionStatus.permanentlyDenied) {
        _isPermissionGranted = false;
        _bottomSheetService.showCustomSheet(
          variant: BottomSheetType.alert,
          title: "Camera permission denied.",
          description:
              "Open app settings and enable camera permission to continue using this app!",
        );
      } else if (status == PermissionStatus.denied) {
        _isPermissionGranted = false;
        log.i("Camera permission denied");
      } else if (status == PermissionStatus.granted) {
        log.i("Camera permission granted");
        // _isPermissionGranted = true;
      }
    }
    //Microphone
    if (!isMicrophonePermissionGranted) {
      PermissionStatus status = await _permissionMicrophone.request();
      if (status == PermissionStatus.permanentlyDenied) {
        _isPermissionGranted = false;
        _bottomSheetService.showCustomSheet(
          variant: BottomSheetType.alert,
          title: "Microphone permission denied.",
          description:
              "Open app settings and enable Microphone permission to continue using this app!",
        );
      } else if (status == PermissionStatus.denied) {
        _isPermissionGranted = false;
        log.i("Camera permission denied");
      } else if (status == PermissionStatus.granted) {
        log.i("Microphone permission granted");
        // _isPermissionGranted = true;
      }
    }
    return _isPermissionGranted;
  }

  ///===============
  int? _remoteUid;
  int? get remoteUid => _remoteUid;
  bool _localUserJoined = false;
  bool get localUserJoined => _localUserJoined;
  late RtcEngine _engine;
  RtcEngine get engine => _engine;

  Future<String> getToken(bool isNew) async {
    String? token = isNew ? null : await _firestoreService.getToken();
    if (token == null) {
      token = await fetchToken();
      _firestoreService.updateToken(token: token);
    }
    log.i("|||Token:$token|||");
    return token;
  }

  Future<void> initAgora() async {
    _remoteUid = null;
    _localUserJoined = false;

    String? token = await getToken(false);

    //create the engine
    _engine = createAgoraRtcEngine();

    await _engine.initialize(const RtcEngineContext(
      appId: agoraAppID,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          log.i("local user ${connection.localUid} joined");
          _localUserJoined = true;
          notifyListeners();
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          log.i("remote user $remoteUid joined");
          _remoteUid = remoteUid;
          notifyListeners();
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          log.i("remote user $remoteUid left channel");
          _remoteUid = null;
          notifyListeners();
        },
        onTokenPrivilegeWillExpire:
            (RtcConnection connection, String token) async {
          log.i(
              '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');

          /// new token
          String tokenNew = await getToken(true);
          _engine.renewToken(tokenNew);
        },
      ),
    );

    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine.enableVideo();
    await _engine.startPreview();

    await _engine.joinChannel(
      token: token,
      channelId: channel,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  Future<String> fetchToken() async {
    log.i("Creating new token");
    http.Response response = await http.get(Uri.parse(
        'https://agora-token-service-production-ae63.up.railway.app/rtc/$channel/publisher/uid/0/'));
    return jsonDecode(response.body)['rtcToken'];
  }
}
