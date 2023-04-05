import 'package:doctor_robo/ui/widgets/loginRegister.dart';
import 'package:doctor_robo/ui/widgets/option.dart';
import 'package:doctor_robo/ui/widgets/videoCall.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../services/agora_service.dart';
import 'patient_viewmodel.dart';

class PatientView extends StackedView<PatientViewModel> {
  const PatientView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    PatientViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
        // backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: const Text('Patient'),
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
                                      "Welcome, ${viewModel.user?.fullName}",
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
                                videoCallButtonText: "Connect with Doctor",
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
                  loginText: "Existing patient",
                  registerText: "New patient",
                ),
        ));
  }

  @override
  PatientViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      PatientViewModel();

  @override
  void onViewModelReady(PatientViewModel viewModel) => viewModel.onModelReady();
}
