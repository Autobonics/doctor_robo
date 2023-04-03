import 'package:doctor_robo/app/app.bottomsheets.dart';
import 'package:doctor_robo/app/app.dialogs.dart';
import 'package:doctor_robo/app/app.locator.dart';
import 'package:doctor_robo/app/app.router.dart';
import 'package:doctor_robo/services/user_service.dart';
import 'package:doctor_robo/ui/common/app_strings.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();
  final _bottomSheetService = locator<BottomSheetService>();

  final _userService = locator<UserService>();

  // Place anything here that needs to happen before we get into the application
  Future runStartupLogic() async {
    await Future.delayed(const Duration(seconds: 1));

    // This is where you can make decisions on where your app should navigate when
    // you have custom startup logic

    if (_userService.hasLoggedInUser) {
      _navigationService.replaceWithPatientView();
    }
    // else {
    //   _navigationService.replaceWithLoginView();
    // }
  }

  void openDoctorView() {
    _navigationService.navigateToDoctorView();
  }

  void openUserView() {
    _navigationService.navigateToPatientView();
  }

  void showDialog() {
    _dialogService.showCustomDialog(
      variant: DialogType.infoAlert,
      title: 'Stacked Rocks!',
      // description: 'Give stacked $_counter stars on Github',
    );
  }

  void showBottomSheet() {
    _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.alert,
      title: ksHomeBottomSheetTitle,
      description: ksHomeBottomSheetDescription,
    );
  }
}
