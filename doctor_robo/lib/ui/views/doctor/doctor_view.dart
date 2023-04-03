import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:doctor_robo/services/agora_service.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'doctor_viewmodel.dart';

class DoctorView extends StackedView<DoctorViewModel> {
  const DoctorView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    DoctorViewModel viewModel,
    Widget? child,
  ) {
    // Display remote user's video
    Widget _remoteVideo() {
      if (viewModel.remoteUid != null) {
        return AgoraVideoView(
          controller: VideoViewController.remote(
            rtcEngine: viewModel.engine,
            canvas: VideoCanvas(uid: viewModel.remoteUid),
            connection: const RtcConnection(channelId: channel),
          ),
        );
      } else {
        return const Text(
          'Please wait for remote user to join',
          textAlign: TextAlign.center,
        );
      }
    }

    return Scaffold(
      // backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: const Text('Doctor'),
        // actions: [
        //   if (viewModel.user != null)
        //     IconButton(
        //       onPressed: viewModel.logout,
        //       icon: const Icon(Icons.logout),
        //     )
        // ],
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
        child: viewModel.isBusy
            ? const Center(child: Text("Loading.."))
            : viewModel.isPermissionsGranted
                ? Stack(
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
                            child: viewModel.localUserJoined
                                ? AgoraVideoView(
                                    controller: VideoViewController(
                                      rtcEngine: viewModel.engine,
                                      canvas: const VideoCanvas(uid: 0),
                                    ),
                                  )
                                : const CircularProgressIndicator(),
                          ),
                        ),
                      ),
                    ],
                  )
                : const Center(
                    child: Text("Camera/Microphone permission denied")),
      ),
    );
  }

  @override
  DoctorViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      DoctorViewModel();

  @override
  void onViewModelReady(DoctorViewModel viewModel) => viewModel.onModelReady();
}
