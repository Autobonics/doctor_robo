import 'package:doctor_robo/app/app.bottomsheets.dart';
import 'package:doctor_robo/app/app.locator.dart';
import 'package:doctor_robo/app/app.logger.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_firebase_auth/stacked_firebase_auth.dart';
import 'package:stacked_services/stacked_services.dart';
import 'login_view.form.dart';

class LoginViewModel extends FormViewModel {
  final log = getLogger('LoginViewModel');

  final FirebaseAuthenticationService? _firebaseAuthenticationService =
      locator<FirebaseAuthenticationService>();
  final _navigationService = locator<NavigationService>();
  final BottomSheetService _bottomSheetService = locator<BottomSheetService>();

  late String _userRole;

  void onModelReady(String userRole) {
    _userRole = userRole;
  }

  void authenticateUser() async {
    if (isFormValid && emailValue != null && passwordValue != null) {
      setBusy(true);
      log.i("email and pass valid");
      log.i(emailValue!);
      log.i(passwordValue!);
      FirebaseAuthenticationResult result =
          await _firebaseAuthenticationService!.loginWithEmail(
        email: emailValue!,
        password: passwordValue!,
      );
      if (result.user != null) {
        if (result.user != null) {
          _navigationService.back();
        }
      } else {
        log.i("Error: ${result.errorMessage}");
        _bottomSheetService.showCustomSheet(
          variant: BottomSheetType.alert,
          title: "Error",
          description: result.errorMessage ?? "Enter valid credentials",
        );
      }
    }
    setBusy(false);
  }
}
