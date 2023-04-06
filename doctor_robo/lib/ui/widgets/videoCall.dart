import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class VideoCallView extends StatelessWidget {
  final bool isPermissionsGranted;
  final String channel;
  final int? remoteUid;
  final RtcEngine? engine;
  final bool localUserJoined;
  final bool isStarted;
  final String videoCallButtonText;
  final VoidCallback onInit;
  final VoidCallback onStop;
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
    required this.onStop,
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
          'Please wait for remote user to join!',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        );
      }
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        clipBehavior: Clip.antiAlias,
        height: MediaQuery.of(context).size.height * 0.6,
        width: MediaQuery.of(context).size.width * 9.5,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            if (!isStarted)
              Positioned.fill(
                child: TextButton(
                  onPressed: onInit,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        'assets/lottie/video-call.json',
                        width: 100,
                        height: 100,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            videoCallButtonText,
                            style: const TextStyle(
                              color: Colors.white,
                              // fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (isStarted && isPermissionsGranted)
              Center(
                child: _remoteVideo(),
              ),
            if (isStarted && isPermissionsGranted)
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  width: 100,
                  height: 150,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: localUserJoined
                        ? AgoraVideoView(
                            controller: VideoViewController(
                              rtcEngine: engine!,
                              canvas: const VideoCanvas(uid: 0),
                            ),
                          )
                        : const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                  ),
                ),
              ),
            if (!isPermissionsGranted)
              const Center(
                child: Text("Camera/Microphone permission denied"),
              ),
            if (isStarted && isPermissionsGranted)
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: IconButton(
                  onPressed: onStop,
                  icon: const Icon(
                    Icons.videocam_off_outlined,
                    color: Colors.red,
                    size: 30,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
