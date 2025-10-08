import 'package:aurora_v1/config/routes.dart';
import 'package:aurora_v1/core/di/service_locator.dart';
import 'package:aurora_v1/core/themes/app_theme.dart';
import 'package:aurora_v1/core/utils/logger.dart';
import 'package:aurora_v1/features/add_grow/presentation/bloc/add_grow_bloc.dart';
import 'package:aurora_v1/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:aurora_v1/features/device_dashboard/presentation/bloc/device_dashboard_bloc.dart';
import 'package:aurora_v1/features/device_setup/presentation/bloc/device_setup_bloc.dart';
import 'package:aurora_v1/features/login/presentation/bloc/auth_bloc.dart';
import 'package:aurora_v1/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:aurora_v1/features/register/presentation/bloc/register_bloc.dart';
import 'package:aurora_v1/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:aurora_v1/features/strain/presentation/bloc/strain_bloc.dart';
import 'package:aurora_v1/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 

  // Initialize Firebase
  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    AppLogger.error("Firebase initialization error: $e");
  }
  // Load environment variables
  await dotenv.load();
  // Initialize service locator
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<AuthBloc>(),
        ),
        BlocProvider(
          create: (context) => sl<RegisterBloc>(),
        ),
        BlocProvider(
          create: (context) => sl<DashboardBloc>(),
        ),
        BlocProvider(
          create: (context) => sl<OnboardingBloc>(),
        ),
        BlocProvider(
          create: (context) => sl<AddGrowBloc>(),
        ),
        BlocProvider(
          create: (context) => sl<DeviceSetupBloc>(),
        ),
        BlocProvider(
          create: (context) => sl<DeviceDashboardBloc>(),
        ),
        BlocProvider(
          create: (context) => sl<StrainBloc>(),
        ),
        BlocProvider(
          create: (context) => sl<SettingsBloc>(),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Aurora Demo',
        theme: AppTheme.appTheme,
        routerConfig: AppRoutes.router,
      ),
    );
  }
}
