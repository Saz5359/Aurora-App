import 'package:aurora_v1/core/helpers/snackbar_helper.dart';
import 'package:aurora_v1/core/widgets/app_button.dart';
import 'package:aurora_v1/core/widgets/dashboard_app_bar.dart';
import 'package:aurora_v1/features/dashboard/domain/entities/plant.dart';
import 'package:aurora_v1/features/dashboard/presentation/widgets/grow_card.dart';
import 'package:aurora_v1/features/strain/presentation/bloc/strain_bloc.dart';
import 'package:aurora_v1/features/strain/presentation/bloc/strain_event.dart';
import 'package:aurora_v1/features/strain/presentation/bloc/strain_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class DeleteGrowScreen extends StatefulWidget {
  final Plant grow;

  const DeleteGrowScreen({super.key, required this.grow});

  @override
  State<DeleteGrowScreen> createState() => _DeleteGrowScreenState();
}

class _DeleteGrowScreenState extends State<DeleteGrowScreen> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DashboardAppBar(
        title: Image.asset(
          "assets/images/dash.png",
          height: 32,
          width: 104,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => context.pop(),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 20,
                    color: Color(0xFFAFCEB2),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  "Strain",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Delete Grow',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 5),
            RichText(
              text: TextSpan(
                text: 'Are you sure you want to delete this grow?',
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
            ),
            const SizedBox(height: 20),
            GrowCard(
              grow: widget.grow,
              growName: widget.grow.plantName,
              percent: "--%",
              percentValue: 0,
              devices: 0,
              isShared: false,
              more: (context) {},
              isDeviceConnected: widget.grow.isDeviceConnected,
            ),
            const Spacer(),
            Row(
              children: [
                Checkbox(
                  value: isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      isChecked = value ?? false;
                    });
                  },
                ),
                const Text(
                  "Yes, I want to delete this grow",
                  style: TextStyle(color: Color(0xFF686777), fontSize: 14),
                ),
              ],
            ),

            /// Bloc Handling
            BlocConsumer<StrainBloc, StrainState>(
              listener: (context, state) {
                if (state is StrainDeleteSuccess) {
                  context.go("/dashboard");
                } else if (state is StrainFailure) {
                  showAppErrorSnackBar(context,
                      message: state.message, errorType: state.errorType);
                }
              },
              builder: (context, state) {
                if (state is StrainDeleteInProgress) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  );
                }

                return AppButton(
                  label: "Delete Grow",
                  onPressed: isChecked
                      ? () {
                          final plantId = widget.grow.id as String?;
                          if (plantId != null && plantId.isNotEmpty) {
                            context
                                .read<StrainBloc>()
                                .add(DeleteStrainRequested(plantId));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Invalid plant ID.'),
                              ),
                            );
                          }
                        }
                      : null,
                  type: AppButtonType.delete,
                );
              },
            ),
            const SizedBox(height: 10),
            AppButton(
              label: "Cancel",
              onPressed: () => context.pop(),
              type: AppButtonType.cancel,
            )
          ],
        ),
      ),
    );
  }
}
