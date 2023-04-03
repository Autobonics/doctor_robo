import 'package:stacked/stacked.dart';
import 'package:doctor_robo/app/app.locator.dart';
import 'package:doctor_robo/app/app.router.dart';
// import 'package:stacked_firebase_auth/stacked_firebase_auth.dart';
import 'package:stacked_services/stacked_services.dart';

class StartupViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  // final _authenticationService = locator<FirebaseAuthenticationService>();

  // Place anything here that needs to happen before we get into the application
  Future runStartupLogic() async {
    await Future.delayed(const Duration(seconds: 1));

    // This is where you can make decisions on where your app should navigate when
    // you have custom startup logic

    // if (hasLoggedInUser) {
    _navigationService.replaceWithHomeView();
    // } else {
    //   _navigationService.replaceWithLoginView();
    // }
  }
}
