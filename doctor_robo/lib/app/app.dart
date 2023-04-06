import 'package:doctor_robo/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:doctor_robo/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:doctor_robo/ui/views/home/home_view.dart';
import 'package:doctor_robo/ui/views/startup/startup_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_firebase_auth/stacked_firebase_auth.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:doctor_robo/ui/views/login/login_view.dart';
import 'package:doctor_robo/ui/views/settings/settings_view.dart';
import 'package:doctor_robo/services/firestore_service.dart';
import 'package:doctor_robo/services/user_service.dart';
import 'package:doctor_robo/ui/views/profile/profile_view.dart';
import 'package:doctor_robo/ui/views/doctor/doctor_view.dart';
import 'package:doctor_robo/ui/views/patient/patient_view.dart';
import 'package:doctor_robo/ui/views/register/register_view.dart';
import 'package:doctor_robo/ui/bottom_sheets/alert/alert_sheet.dart';
import 'package:doctor_robo/services/agora_service.dart';
import 'package:doctor_robo/services/rtdb_service.dart';
// @stacked-import

@StackedApp(
  routes: [
    MaterialRoute(page: HomeView),
    MaterialRoute(page: StartupView),
    MaterialRoute(page: LoginView),
    MaterialRoute(page: SettingsView),
    MaterialRoute(page: ProfileView),
    MaterialRoute(page: DoctorView),
    MaterialRoute(page: PatientView),
    MaterialRoute(page: RegisterView),
// @stacked-route
  ],
  dependencies: [
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: SnackbarService),
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: FirebaseAuthenticationService),
    LazySingleton(classType: FirestoreService),
    LazySingleton(classType: UserService),
    LazySingleton(classType: AgoraService),
    LazySingleton(classType: RtdbService),
// @stacked-service
  ],
  bottomsheets: [
    StackedBottomsheet(classType: NoticeSheet),
    StackedBottomsheet(classType: AlertSheet),
// @stacked-bottom-sheet
  ],
  dialogs: [
    StackedDialog(classType: InfoAlertDialog),
    // @stacked-dialog
  ],
  logger: StackedLogger(),
)
class App {}
