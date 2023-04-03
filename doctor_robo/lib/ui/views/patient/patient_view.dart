import 'package:doctor_robo/ui/widgets/option.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

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
      body: viewModel.hasUser
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
                        ],
                      ),
                    ),
            )
          : GridView.count(
              crossAxisCount: 1,
              children: [
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Option(
                    name: 'Existing patient',
                    onTap: viewModel.openLoginView,
                    file: 'assets/lottie/login.json',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Option(
                    name: 'New patient',
                    onTap: viewModel.openRegisterView,
                    file: 'assets/lottie/register.json',
                  ),
                ),
              ],
            ),
    );
  }

  @override
  PatientViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      PatientViewModel();

  @override
  void onViewModelReady(PatientViewModel viewModel) => viewModel.onModelReady();
}
