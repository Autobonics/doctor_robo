import 'package:doctor_robo/services/agora_service.dart';
import 'package:doctor_robo/ui/widgets/loginRegister.dart';
import 'package:doctor_robo/ui/widgets/videoCall.dart';
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
    return Scaffold(
      // backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: const Text('Doctor'),
        actions: [
          if (viewModel.user != null)
            IconButton(
              onPressed: viewModel.logout,
              icon: const Icon(Icons.logout),
            )
        ],
      ),
      body: Container(
        child: viewModel.hasUser
            ? Container(
                child: viewModel.isBusy
                    ? const Center(child: CircularProgressIndicator())
                    : Center(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                color: Colors.teal.shade200,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                    "Welcome, Dr.${viewModel.user?.fullName}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            VideoCallView(
                              onInit: viewModel.setAgora,
                              videoCallButtonText: "Connect with patient",
                              isStarted: viewModel.isVideoCallStarted,
                              isPermissionsGranted:
                                  viewModel.isPermissionsGranted,
                              channel: channel,
                              engine: viewModel.engine,
                              remoteUid: viewModel.remoteUid,
                              localUserJoined: viewModel.localUserJoined,
                            ),
                          ],
                        ),
                      ),
              )
            : LoginRegisterView(
                onLogin: viewModel.openLoginView,
                onRegister: viewModel.openRegisterView,
                loginText: "Existing Doctor",
                registerText: "Doctor registration",
              ),
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
