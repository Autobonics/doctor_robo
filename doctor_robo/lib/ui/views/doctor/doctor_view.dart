import 'package:doctor_robo/services/agora_service.dart';
import 'package:doctor_robo/ui/smart_widgets/device_control/device_control.dart';
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
        title: Text('Doctor ${viewModel.user?.fullName ?? ""}'),
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
                    : SingleChildScrollView(
                        child: Center(
                          child: Column(
                            children: [
                              if (viewModel.hasUser &&
                                  viewModel.user!.userRole == "doctor")
                                const DeviceControlView(),
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
                                onStop: viewModel.leaveCall,
                              ),
                            ],
                          ),
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

class DeviceControl extends StatelessWidget {
  const DeviceControl({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
