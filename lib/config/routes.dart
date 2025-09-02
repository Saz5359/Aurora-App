import 'package:aurora_v1/core/widgets/network_error_screen.dart';
import 'package:aurora_v1/features/add_grow/presentation/screens/add_grow_screen.dart';
import 'package:aurora_v1/features/dashboard/domain/entities/plant.dart';
import 'package:aurora_v1/features/dashboard/presentation/screens/dashboard_loader_screen.dart';
import 'package:aurora_v1/features/dashboard/presentation/screens/grow_overview_screen.dart';
import 'package:aurora_v1/features/dashboard/presentation/screens/plant_dashboard_screen.dart';
import 'package:aurora_v1/features/dashboard/presentation/screens/welcome_dashboard_screen.dart';
import 'package:aurora_v1/features/device_dashboard/presentation/screens/device_dashboard_screen.dart';
import 'package:aurora_v1/features/device_setup/presentation/screens/add_device_configure_wifi.dart';
import 'package:aurora_v1/features/device_setup/presentation/screens/add_device_screen.dart';
import 'package:aurora_v1/features/forgot_password/presentation/screen/forgot_password_screen.dart';
import 'package:aurora_v1/features/login/presentation/screens/login_screen.dart';
import 'package:aurora_v1/features/notifications/presentation/screen/notification_screen.dart';
import 'package:aurora_v1/features/onboarding/presentation/screens/onboarding_gate.dart';
import 'package:aurora_v1/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:aurora_v1/features/register/presentation/screens/register_legal.dart';
import 'package:aurora_v1/features/register/presentation/screens/register_screen.dart';
import 'package:aurora_v1/features/settings/presentation/screen/settings_add_people_screen.dart';
import 'package:aurora_v1/features/settings/presentation/screen/settings_added_guest_screen.dart';
import 'package:aurora_v1/features/settings/presentation/screen/settings_deactivate_session_screen.dart';
import 'package:aurora_v1/features/settings/presentation/screen/settings_device_config_screen.dart';
import 'package:aurora_v1/features/settings/presentation/screen/settings_devices_screen.dart';
import 'package:aurora_v1/features/settings/presentation/screen/settings_guest_removal_screen.dart';
import 'package:aurora_v1/features/settings/presentation/screen/settings_manage_people_screen.dart';
import 'package:aurora_v1/features/settings/presentation/screen/settings_personal_details_screen.dart';
import 'package:aurora_v1/features/settings/presentation/screen/settings_screen.dart';
import 'package:aurora_v1/features/settings/presentation/screen/settings_security_screen.dart';
import 'package:aurora_v1/features/settings/presentation/screen/settings_sign_out_screen.dart';
import 'package:aurora_v1/features/settings/presentation/screen/settings_unlink_confirm_screen.dart';
import 'package:aurora_v1/features/settings/presentation/screen/settings_unlink_screen.dart';
import 'package:aurora_v1/features/settings/presentation/screen/settings_wifi_configure_screen.dart';
import 'package:aurora_v1/features/strain/presentation/screens/delete_grow_screen.dart';
import 'package:aurora_v1/features/strain/presentation/screens/edit_confirm_screen.dart';
import 'package:aurora_v1/features/strain/presentation/screens/edit_strain_screen.dart';
import 'package:aurora_v1/features/strain/presentation/screens/strain_screen.dart';
import 'package:aurora_v1/features/task/presentation/screens/all_task_screen.dart';
import 'package:aurora_v1/features/task/presentation/screens/task_screen.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => OnboardingGate(),
      ),
      GoRoute(
        path: '/network_error',
        builder: (context, state) => NetworkErrorScreen(),
      ),
      GoRoute(
        path: '/welcome',
        builder: (context, state) => OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: '/Forgot_password',
        builder: (context, state) => ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => RegisterScreen(),
      ),
      GoRoute(
        path: '/register/legal',
        builder: (context, state) {
          final Map<String, dynamic> data = state.extra as Map<String, dynamic>;
          return RegisterLegalPage(
            onBack: data['onBack'],
            signUpMethod: data['signUpMethod'],
            credential: data['credential'],
          );
        },
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => DashboardLoaderScreen(),
      ),
      GoRoute(
        path: '/dashboard/welcome',
        builder: (context, state) => WelcomeDashboardScreen(),
      ),
      GoRoute(
        path: '/dashboard/grow_overview',
        builder: (context, state) => GrowOverviewScreen(),
      ),
      GoRoute(
        path: "/dashboard/:growId/:percentValue",
        builder: (context, state) => PlantDashboardScreen(),
      ),
      GoRoute(
        path: '/add_grow',
        builder: (context, state) => AddGrowScreen(),
      ),
      GoRoute(
        path: '/device_setup',
        builder: (context, state) {
          final Plant grow = state.extra as Plant;

          return AddDeviceScreen(
            grow: grow,
          );
        },
      ),
      GoRoute(
        path: '/add_device/config_wifi',
        builder: (context, state) {
          final String wifiName = state.extra as String;
          return AddDeviceConfigureWifi(
            name: wifiName,
          );
        },
      ),
      GoRoute(
        path: '/all_task',
        builder: (context, state) {
          final Plant grow = state.extra as Plant;
          return AllTasksScreen(
            grow: grow,
          );
        },
      ),
      GoRoute(
        path: '/task',
        builder: (context, state) => TaskScreen(),
      ),
      GoRoute(
        path: '/strain',
        builder: (context, state) {
          final Plant grow = state.extra as Plant;
          return StrainScreen(
            grow: grow,
          );
        },
      ),
      GoRoute(
        path: '/strain/edit/confirm',
        builder: (context, state) {
          final Plant grow = state.extra as Plant;
          return EditConfirmScreen(
            grow: grow,
          );
        },
      ),
      GoRoute(
        path: '/strain/edit',
        builder: (context, state) {
          final Plant grow = state.extra as Plant;
          return EditStrainScreen(
            grow: grow,
          );
        },
      ),
      GoRoute(
        path: '/strain/delete',
        builder: (context, state) {
          final Plant grow = state.extra as Plant;
          return DeleteGrowScreen(
            grow: grow,
          );
        },
      ),
      GoRoute(
        path: '/device_dash',
        builder: (context, state) {
          final Plant grow = state.extra as Plant;
          return DeviceDashScreen(
            growName: grow.plantName,
            plantId: grow.id,
          );
        },
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => NotificationsScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => SettingsScreen(),
      ),
      GoRoute(
        path: '/settings/personal',
        builder: (context, state) => SettingsPersonalDetailsScreen(),
      ),
      GoRoute(
        path: '/settings/personal/delete',
        builder: (context, state) => SettingsSignOutScreen(),
      ),
      GoRoute(
        path: "/settings/security",
        builder: (context, state) => SettingsSecurityScreen(),
      ),
      GoRoute(
        path: "/settings/personal/sessions/deactivate",
        builder: (context, state) => SettingsDeactivateSessionScreen(),
      ),
      GoRoute(
        path: "/settings/devices",
        builder: (context, state) => SettingsDevicesScreen(),
      ),
      GoRoute(
        path: "/settings/devices/device-config",
        builder: (context, state) => SettingsDeviceConfigScreen(),
      ),
      GoRoute(
        path: '/settings/devices/wifi-config',
        builder: (context, state) => SettingsWifiConfigureScreen(),
      ),
      GoRoute(
        path: "/settings/devices/people",
        builder: (context, state) => SettingsManagePeopleScreen(),
      ),
      GoRoute(
        path: "/settings/devices/people/remove",
        builder: (context, state) => SettingsGuestRemovalScreen(),
      ),
      GoRoute(
        path: "/settings/devices/people/add",
        builder: (context, state) => SettingsAddPeopleScreen(),
      ),
      GoRoute(
        path: '/settings/devices/people/added',
        builder: (context, state) => SettingsAddedGuestScreen(),
      ),
      GoRoute(
        path: '/settings/devices/unlink/confirm',
        builder: (context, state) => SettingsUnlinkConfirmScreen(),
      ),
      GoRoute(
        path: '/settings/devices/unlink',
        builder: (context, state) => SettingsUnlinkScreen(),
      ),
    ],
  );
}
