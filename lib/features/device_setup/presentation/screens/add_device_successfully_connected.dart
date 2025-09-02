import 'package:aurora_v1/core/helpers/snackbar_helper.dart';
import 'package:aurora_v1/core/widgets/app_button.dart';
import 'package:aurora_v1/core/widgets/step_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/device_setup_bloc.dart';
import '../../domain/entities/device_connection.dart';

class AddDeviceSuccessScreen extends StatelessWidget {
  final PageController pageController;
  final String plantId;
  final String deviceId;

  const AddDeviceSuccessScreen({
    super.key,
    required this.pageController,
    required this.plantId,
    required this.deviceId,
  });

  void _goBack() {
    pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StepAppBar(
        onBack: _goBack,
        title: 'Add Device',
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Device Successfully Added!',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
            const SizedBox(height: 10),
            Text(
              'Your device has been paired to this grow. ',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const Spacer(),
            BlocConsumer<DeviceSetupBloc, DeviceSetupState>(
              listener: (context, state) {
                if (state is DeviceSetupSuccess) {
                  // Connection updated, navigate to dashboard
                  context.go('/dashboard');
                } else if (state is DeviceSetupFailure) {
                  showAppErrorSnackBar(context,
                      message: state.message, errorType: state.errorType);
                }
              },
              builder: (context, state) {
                if (state is DeviceSetupInProgress) {
                  return const Center(child: CircularProgressIndicator());
                }
                return AppButton(
                  label: 'Next',
                  type: AppButtonType.confirm,
                  onPressed: () {
                    // Dispatch event with full DeviceConnection entity
                    final connection = DeviceConnection(
                      plantId: plantId,
                      deviceName: deviceId,
                      isConnected: true,
                    );
                    context
                        .read<DeviceSetupBloc>()
                        .add(ConnectionStatusUpdated(connection));
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
