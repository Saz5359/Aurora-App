import 'package:aurora_v1/features/add_grow/data/datasources/add_grow_remote_datasource.dart';
import 'package:aurora_v1/features/add_grow/data/repository/add_grow_repository_impl.dart';
import 'package:aurora_v1/features/add_grow/domain/repository/add_grow_repository.dart';
import 'package:aurora_v1/features/add_grow/domain/usecases/add_grow_usecase.dart';
import 'package:aurora_v1/features/add_grow/presentation/bloc/add_grow_bloc.dart';
import 'package:aurora_v1/features/dashboard/data/datasources/dashboard_remote_datasource.dart';
import 'package:aurora_v1/features/dashboard/data/datasources/sensor_remote_datasource.dart';
import 'package:aurora_v1/features/dashboard/data/repository/dashboard_repository_impl.dart';
import 'package:aurora_v1/features/dashboard/data/repository/sensor_repository_impl.dart';
import 'package:aurora_v1/features/dashboard/domain/repository/dashboard_repository.dart';
import 'package:aurora_v1/features/dashboard/domain/repository/sensor_repository.dart';
import 'package:aurora_v1/features/dashboard/domain/usecases/add_task_usecase.dart';
import 'package:aurora_v1/features/dashboard/domain/usecases/complete_task_usecase.dart';
import 'package:aurora_v1/features/dashboard/domain/usecases/get_device_id_for_grow_usecase.dart';
import 'package:aurora_v1/features/dashboard/domain/usecases/get_plant_by_id_usecase.dart';
import 'package:aurora_v1/features/dashboard/domain/usecases/get_plant_count_usecase.dart';
import 'package:aurora_v1/features/dashboard/domain/usecases/get_plants_usecase.dart';
import 'package:aurora_v1/features/dashboard/domain/usecases/get_tasks_once_usecase.dart';
import 'package:aurora_v1/features/dashboard/domain/usecases/get_tasks_usecase.dart';
import 'package:aurora_v1/features/dashboard/domain/usecases/stream_sensor_data_usecase.dart';
import 'package:aurora_v1/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:aurora_v1/features/device_dashboard/data/datasources/device_remote_data_source.dart';
import 'package:aurora_v1/features/device_dashboard/data/datasources/device_sensor_remote_data_source.dart';
import 'package:aurora_v1/features/device_dashboard/data/repository/device_dashboard_repository_impl.dart';
import 'package:aurora_v1/features/device_dashboard/domain/repository/device_dashboard_repository.dart';
import 'package:aurora_v1/features/device_dashboard/domain/usecases/get_device_name.dart';
import 'package:aurora_v1/features/device_dashboard/domain/usecases/stream_device_sensor_data.dart';
import 'package:aurora_v1/features/device_dashboard/presentation/bloc/device_dashboard_bloc.dart';
import 'package:aurora_v1/features/device_setup/data/datasources/device_setup_remote_datasource.dart';
import 'package:aurora_v1/features/device_setup/data/repository/device_setup_repository_impl.dart';
import 'package:aurora_v1/features/device_setup/domain/repository/device_repository.dart';
import 'package:aurora_v1/features/device_setup/domain/usecases/update_connection_usecase.dart';
import 'package:aurora_v1/features/device_setup/presentation/bloc/device_setup_bloc.dart';
import 'package:aurora_v1/features/onboarding/data/datasources/onboarding_remote_datasource.dart';
import 'package:aurora_v1/features/onboarding/data/repository/onboarding_repository_impl.dart';
import 'package:aurora_v1/features/onboarding/domain/repository/onboarding_repository.dart';
import 'package:aurora_v1/features/onboarding/domain/usecases/is_first_time_usecase.dart';
import 'package:aurora_v1/features/onboarding/domain/usecases/is_user_authenticated_usecase.dart';
import 'package:aurora_v1/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:aurora_v1/features/register/domain/usecases/register_with_facebook_usecase.dart';
import 'package:aurora_v1/features/register/domain/usecases/register_with_google_usecase.dart';
import 'package:aurora_v1/features/register/presentation/bloc/register_bloc.dart';
import 'package:aurora_v1/features/settings/data/repository/settings_repository_impl.dart';
import 'package:aurora_v1/features/settings/domain/repository/settings_repository.dart';
import 'package:aurora_v1/features/settings/domain/usecases/sign_out_usecase.dart';
import 'package:aurora_v1/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:aurora_v1/features/strain/data/datasources/strain_remote_datasource.dart';
import 'package:aurora_v1/features/strain/data/repository/strain_repository_impl.dart';
import 'package:aurora_v1/features/strain/domain/repository/strain_repository.dart';
import 'package:aurora_v1/features/strain/domain/usecases/delete_plant_usecase.dart';
import 'package:aurora_v1/features/strain/presentation/bloc/strain_bloc.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import 'package:aurora_v1/features/login/data/datasources/login_remote_datasource.dart';
import 'package:aurora_v1/features/login/data/repository/login_repository_impl.dart';
import 'package:aurora_v1/features/login/domain/repository/login_repository.dart';
import 'package:aurora_v1/features/login/domain/usecases/sign_in_with_email_and_password.dart';
import 'package:aurora_v1/features/login/domain/usecases/sign_in_with_facebook.dart';
import 'package:aurora_v1/features/login/domain/usecases/sign_in_with_google.dart';
import 'package:aurora_v1/features/login/presentation/bloc/auth_bloc.dart';

import 'package:aurora_v1/features/register/data/datasources/register_remote_datasource.dart';
import 'package:aurora_v1/features/register/data/repository/register_repository_impl.dart';
import 'package:aurora_v1/features/register/domain/repository/register_repository.dart';
import 'package:aurora_v1/features/register/domain/usecases/request_otp_usecase.dart';
import 'package:aurora_v1/features/register/domain/usecases/verify_otp_usecase.dart';
import 'package:aurora_v1/features/register/domain/usecases/register_user_usecase.dart';
import 'package:aurora_v1/features/register/domain/usecases/get_google_register_credentials_usecase.dart';
import 'package:aurora_v1/features/register/domain/usecases/get_facebook_credentials_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ─── CORE / EXTERNAL ───────────────────────────────────────────────────────────

  sl.registerLazySingleton<FirebaseAuth>(
    () => FirebaseAuth.instance,
  );
  sl.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );
  sl.registerLazySingleton<GoogleSignIn>(
    () => GoogleSignIn(),
  );
  sl.registerLazySingleton<FacebookAuth>(
    () => FacebookAuth.instance,
  );
  sl.registerLazySingleton<FirebaseDatabase>(() => FirebaseDatabase.instance);

  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => prefs);

  // ─── LOGIN FEATURE ──────────────────────────────────────────────────────────────

  // 1. DataSource
  sl.registerLazySingleton<LoginRemoteDataSource>(
    () => LoginRemoteDataSourceImpl(
      firebaseAuth: sl<FirebaseAuth>(),
      googleSignIn: sl<GoogleSignIn>(),
      facebookAuth: sl<FacebookAuth>(),
    ),
  );

  // 2. Repository
  sl.registerLazySingleton<LoginRepository>(
    () => LoginRepositoryImpl(
      sl<LoginRemoteDataSource>(),
    ),
  );

  // 3. Use‐cases (Login)
  sl.registerLazySingleton<SignInWithEmailUseCase>(
    () => SignInWithEmailUseCase(sl<LoginRepository>()),
  );
  sl.registerLazySingleton<SignInWithGoogleUseCase>(
    () => SignInWithGoogleUseCase(sl<LoginRepository>()),
  );
  sl.registerLazySingleton<SignInWithFacebookUseCase>(
    () => SignInWithFacebookUseCase(sl<LoginRepository>()),
  );

  // 4. LoginBloc
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(
      signInWithEmail: sl<SignInWithEmailUseCase>(),
      signInWithGoogle: sl<SignInWithGoogleUseCase>(),
      signInWithFacebook: sl<SignInWithFacebookUseCase>(),
    ),
  );

  // ─── REGISTER FEATURE ───────────────────────────────────────────────────────────

  // 1. Data Source
  sl.registerLazySingleton<RegisterRemoteDataSource>(
    () => RegisterRemoteDataSourceImpl(
      auth: sl<FirebaseAuth>(),
      firestore: sl<FirebaseFirestore>(),
    ),
  );

  // 2. Repository
  sl.registerLazySingleton<RegisterRepository>(
    () => RegisterRepositoryImpl(
      remoteDataSource: sl<RegisterRemoteDataSource>(),
    ),
  );

  // 3. Use‐cases (Register)
  sl.registerLazySingleton<RequestOtpUseCase>(
    () => RequestOtpUseCase(sl<RegisterRepository>()),
  );
  sl.registerLazySingleton<VerifyOtpUseCase>(
    () => VerifyOtpUseCase(sl<RegisterRepository>()),
  );
  sl.registerLazySingleton<RegisterUserUseCase>(
    () => RegisterUserUseCase(sl<RegisterRepository>()),
  );

  // Rename these so they don’t conflict with Login use‐cases:
  sl.registerLazySingleton<GetGoogleRegisterCredentialsUseCase>(
    () => GetGoogleRegisterCredentialsUseCase(sl<RegisterRepository>()),
  );
  sl.registerLazySingleton<RegisterWithGoogleUseCase>(
    () => RegisterWithGoogleUseCase(sl<RegisterRepository>()),
  );

  sl.registerLazySingleton<GetFacebookRegisterCredentialsUseCase>(
    () => GetFacebookRegisterCredentialsUseCase(sl<RegisterRepository>()),
  );
  sl.registerLazySingleton<RegisterWithFacebookUseCase>(
    () => RegisterWithFacebookUseCase(sl<RegisterRepository>()),
  );

  // 4. RegisterBloc
  sl.registerFactory<RegisterBloc>(
    () => RegisterBloc(
      requestOtp: sl<RequestOtpUseCase>(),
      verifyOtp: sl<VerifyOtpUseCase>(),
      registerUser: sl<RegisterUserUseCase>(),
      getGoogleCredentials: sl<GetGoogleRegisterCredentialsUseCase>(),
      registerWithGoogle: sl<RegisterWithGoogleUseCase>(),
      getFacebookCredentials: sl<GetFacebookRegisterCredentialsUseCase>(),
      registerWithFacebook: sl<RegisterWithFacebookUseCase>(),
    ),
  );

  // ─── DASHBOARD ───────────────────────────────────────────────────────────────
  // DataSources
  sl.registerLazySingleton<DashboardRemoteDataSource>(
    () => DashboardRemoteDataSource(
      firestore: sl<FirebaseFirestore>(),
      auth: sl<FirebaseAuth>(),
    ),
  );

  sl.registerLazySingleton<SensorRemoteDataSource>(
    () => SensorRemoteDataSource(
      firestore: sl<FirebaseFirestore>(),
      database: sl<FirebaseDatabase>(),
      auth: sl<FirebaseAuth>(),
    ),
  );

  // Repositories
  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(
      remoteDataSource: sl<DashboardRemoteDataSource>(),
    ),
  );
  sl.registerLazySingleton<SensorRepository>(
    () => SensorRepositoryImpl(
      remoteDataSource: sl<SensorRemoteDataSource>(),
    ),
  );

  // UseCases
  sl.registerLazySingleton(() => GetPlantsUseCase(sl<DashboardRepository>()));
  sl.registerLazySingleton(
      () => GetPlantByIdUseCase(sl<DashboardRepository>()));
  sl.registerLazySingleton(
      () => GetPlantCountUseCase(sl<DashboardRepository>()));
  sl.registerLazySingleton(() => GetTasksUseCase(sl<DashboardRepository>()));
  sl.registerLazySingleton(() => AddTaskUseCase(sl<DashboardRepository>()));
  sl.registerLazySingleton(
      () => CompleteTaskUseCase(sl<DashboardRepository>()));
  sl.registerLazySingleton(
      () => GetTasksOnceUseCase(sl<DashboardRepository>()));
  sl.registerLazySingleton(
      () => GetDeviceIdForGrowUseCase(sl<SensorRepository>()));
  sl.registerLazySingleton(
      () => StreamSensorDataUseCase(sl<SensorRepository>()));

  // DashboardBloc
  sl.registerFactory<DashboardBloc>(
    () => DashboardBloc(
      getPlantCount: sl<GetPlantCountUseCase>(),
      getPlants: sl<GetPlantsUseCase>(),
      getPlantById: sl<GetPlantByIdUseCase>(),
      getTasks: sl<GetTasksUseCase>(),
      addTask: sl<AddTaskUseCase>(),
      completeTask: sl<CompleteTaskUseCase>(),
      getTasksOnce: sl<GetTasksOnceUseCase>(),
    ),
  );

  // ─── ONBOARDING FEATURE ───────────────────────────────────────────────────────
  // Remote data source
  sl.registerLazySingleton<OnboardingRemoteDataSource>(
    () => OnboardingRemoteDataSourceImpl(
      prefs: sl<SharedPreferences>(),
      firebaseAuth: sl<FirebaseAuth>(),
    ),
  );

  // Repository
  sl.registerLazySingleton<OnboardingRepository>(
    () => OnboardingRepositoryImpl(sl<OnboardingRemoteDataSource>()),
  );

  // Use cases
  sl.registerLazySingleton<IsFirstTimeUseCase>(
    () => IsFirstTimeUseCase(sl<OnboardingRepository>()),
  );
  sl.registerLazySingleton<IsUserAuthenticatedUseCase>(
    () => IsUserAuthenticatedUseCase(sl<OnboardingRepository>()),
  );

  // OnboardingBloc
  sl.registerLazySingleton<OnboardingBloc>(
    () => OnboardingBloc(
      isFirstTimeUseCase: sl<IsFirstTimeUseCase>(),
      isUserAuthenticatedUseCase: sl<IsUserAuthenticatedUseCase>(),
    ),
  );

  // ─── DEVICE DASHBOARD ───────────────────────────────────────────────────────

  // DataSources
  sl.registerLazySingleton<DeviceRemoteDataSource>(
    () => DeviceRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<DeviceSensorRemoteDataSource>(
    () => SensorRemoteDataSourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<DeviceDashboardRepository>(
    () => DeviceDashboardRepositoryImpl(
      deviceRemoteDataSource: sl(),
      sensorRemoteDataSource: sl(),
    ),
  );

  // UseCases
  sl.registerLazySingleton<GetDeviceNameUseCase>(
    () => GetDeviceNameUseCase(sl()),
  );

  sl.registerLazySingleton<StreamDeviceSensorData>(
    () => StreamDeviceSensorData(sl()),
  );

  // DeviceDashboardBloc
  sl.registerFactory<DeviceDashboardBloc>(
    () => DeviceDashboardBloc(
      getDeviceName: sl<GetDeviceNameUseCase>(),
      streamSensorData: sl<StreamDeviceSensorData>(),
    ),
  );

  // ─── ADD GROW ───────────────────────────────────────────────────────
  sl.registerLazySingleton<AddGrowRemoteDataSource>(
    () => AddGrowRemoteDataSourceImpl(firestore: sl<FirebaseFirestore>()),
  );
  sl.registerLazySingleton<AddGrowRepository>(
    () => AddGrowRepositoryImpl(
      auth: sl<FirebaseAuth>(),
      remoteDataSource: sl<AddGrowRemoteDataSource>(),
    ),
  );
  sl.registerLazySingleton<AddGrowUseCase>(
    () => AddGrowUseCase(sl<AddGrowRepository>()),
  );

  // AddGrowBloc
  sl.registerFactory<AddGrowBloc>(
    () => AddGrowBloc(
      sl<AddGrowUseCase>(),
    ),
  );

  // ─── Device Setup ───────────────────────────────────────────────────────
  sl.registerLazySingleton(
    () => DeviceSetupRemoteDataSourceImpl(firestore: sl()),
  );

  sl.registerLazySingleton<DeviceSetupRemoteDataSource>(
    () => DeviceSetupRemoteDataSourceImpl(firestore: sl<FirebaseFirestore>()),
  );

  // Repositories
  sl.registerLazySingleton<DeviceSetupRepository>(
    () => DeviceSetupRepositoryImpl(
      remoteDs: sl<DeviceSetupRemoteDataSource>(),
    ),
  );

  sl.registerLazySingleton(
    () => DeviceSetupRepositoryImpl(
      remoteDs: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => UpdateConnectionUseCase(sl()),
  );

  // DeviceSetupBloc
  sl.registerFactory<DeviceSetupBloc>(
    () => DeviceSetupBloc(
      updateConnection: sl<UpdateConnectionUseCase>(),
    ),
  );

// ─── STRAIN FEATURE ────────────────────────────────────────────────────────────
  // Data sources
  sl.registerLazySingleton<StrainRemoteDataSource>(
    () => StrainRemoteDataSourceImpl(
      firestore: sl<FirebaseFirestore>(),
      firebaseAuth: sl<FirebaseAuth>(),
    ),
  );

// Repositories
  sl.registerLazySingleton<StrainRepository>(
    () => StrainRepositoryImpl(
      remoteDataSource: sl<StrainRemoteDataSource>(),
    ),
  );

// Use cases
  sl.registerLazySingleton<DeletePlantUseCase>(
    () => DeletePlantUseCase(repository: sl<StrainRepository>()),
  );

  // StrainBloc
  sl.registerFactory<StrainBloc>(
    () => StrainBloc(
      deletePlant: sl<DeletePlantUseCase>(),
    ),
  );

  // ─── SETTINGS FEATURE ────────────────────────────────────────────────────────────
  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(),
  );
  sl.registerLazySingleton<SignOutUseCase>(
    () => SignOutUseCase(sl<SettingsRepository>()),
  );

  // SettingsBloc
  sl.registerFactory<SettingsBloc>(
    () => SettingsBloc(signOutUseCase: sl<SignOutUseCase>()),
  );
}
