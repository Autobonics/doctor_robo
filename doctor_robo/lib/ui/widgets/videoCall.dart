import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';

class VideoCallView extends StatelessWidget {
  final bool isPermissionsGranted;
  final String channel;
  final int? remoteUid;
  final RtcEngine? engine;
  final bool localUserJoined;
  final bool isStarted;
  final String videoCallButtonText;
  final VoidCallback onInit;
  const VideoCallView({
    Key? key,
    required this.isPermissionsGranted,
    required this.channel,
    this.remoteUid,
    this.engine,
    required this.localUserJoined,
    required this.isStarted,
    required this.videoCallButtonText,
    required this.onInit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Display remote user's video
    Widget _remoteVideo() {
      if (remoteUid != null) {
        return AgoraVideoView(
          controller: VideoViewController.remote(
            rtcEngine: engine!,
            canvas: VideoCanvas(uid: remoteUid),
            connection: RtcConnection(channelId: channel),
          ),
        );
      } else {
        return const Text(
          'Please wait for remote user to join',
          textAlign: TextAlign.center,
        );
      }
    }

    if (!isStarted) {
      return TextButton(onPressed: onInit, child: Text(videoCallButtonText));
    } else if (isPermissionsGranted) {
      return Stack(
        children: [
          Center(
            child: _remoteVideo(),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 100,
              height: 150,
              child: Center(
                child: localUserJoined
                    ? AgoraVideoView(
                        controller: VideoViewController(
                          rtcEngine: engine!,
                          canvas: const VideoCanvas(uid: 0),
                        ),
                      )
                    : const CircularProgressIndicator(),
              ),
            ),
          ),
        ],
      );
    } else {
      return const Center(child: Text("Camera/Microphone permission denied"));
    }
  }
}
