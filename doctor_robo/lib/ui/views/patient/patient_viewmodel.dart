import 'package:doctor_robo/app/app.locator.dart';
import 'package:doctor_robo/app/app.logger.dart';
import 'package:doctor_robo/app/app.router.dart';
import 'package:doctor_robo/models/appuser.dart';
import 'package:doctor_robo/services/user_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class PatientViewModel extends BaseViewModel {
  final log = getLogger('PatientViewModel');
  final _userService = locator<UserService>();
  final _navigationService = locator<NavigationService>();

  AppUser? get user => _userService.user;
  bool get hasUser => _userService.hasLoggedInUser;

  void onModelReady() async {
    if (hasUser) {
      setBusy(true);
      AppUser? _user = await _userService.fetchUser();
      if (_user != null) {
        log.i(_user.fullName);
        // _navigationService.na
      } else {
        log.i("Error");
      }
      setBusy(false);
    }
  }

  void logout() {
    _userService.logout();
    _navigationService.replaceWithHomeView();
  }

  void openLoginView() {
    _navigationService.navigateToLoginView();
  }

  void openRegisterView() {
    _navigationService.navigateToRegisterView();
  }
}
