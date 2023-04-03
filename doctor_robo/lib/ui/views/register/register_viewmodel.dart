import 'package:doctor_robo/app/app.bottomsheets.dart';
import 'package:doctor_robo/app/app.locator.dart';
import 'package:doctor_robo/app/app.logger.dart';
import 'package:doctor_robo/models/appuser.dart';
import 'package:doctor_robo/services/user_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_firebase_auth/stacked_firebase_auth.dart';
import 'package:stacked_services/stacked_services.dart';
import 'register_view.form.dart';

class RegisterViewModel extends FormViewModel {
  final log = getLogger('RegisterViewModel');
  final _userService = locator<UserService>();

  final FirebaseAuthenticationService? _firebaseAuthenticationService =
      locator<FirebaseAuthenticationService>();
  final _navigationService = locator<NavigationService>();
  final BottomSheetService _bottomSheetService = locator<BottomSheetService>();

  void registerUser() async {
    if (isFormValid &&
        emailValue != null &&
        passwordValue != null &&
        nameValue != null &&
        ageValue != null &&
        genderValue != null) {
      setBusy(true);
      log.i("email and pass valid");
      log.i(emailValue!);
      log.i(passwordValue!);
      FirebaseAuthenticationResult result =
          await _firebaseAuthenticationService!.createAccountWithEmail(
        email: emailValue!,
        password: passwordValue!,
      );
      if (result.user != null) {
        String? error = await _userService.createUser(AppUser(
          id: result.user!.uid,
          fullName: nameValue!,
          email: result.user!.email!,
          age: int.parse(ageValue!),
          gender: genderValue!,
          userRole: "patient",
        ));
        if (error == null) {
          _navigationService.back();
        } else {
          log.i("Firebase error");
          _bottomSheetService.showCustomSheet(
            variant: BottomSheetType.alert,
            title: "Upload Error",
            description: error ?? "Enter valid credentials",
          );
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
