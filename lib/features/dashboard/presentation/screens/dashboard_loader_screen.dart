import 'package:aurora_v1/core/helpers/snackbar_helper.dart';
import 'package:aurora_v1/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class DashboardLoaderScreen extends StatefulWidget {
  const DashboardLoaderScreen({super.key});

  @override
  State<DashboardLoaderScreen> createState() => _DashboardLoaderScreenState();
}

class _DashboardLoaderScreenState extends State<DashboardLoaderScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(FetchPlantCount());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<DashboardBloc, DashboardState>(
        listener: (context, state) {
          if (!mounted) return;

          if (state is PlantCountLoaded) {
            if (state.count > 0) {
              context.go("/dashboard/grow_overview");
            } else {
              context.go("/dashboard/welcome");
            }
          }

          if (state is DashboardError) {
            if (state.errorType == AppErrorType.network) {
              context.go("/network_error");
            } else {
              showAppErrorSnackBar(context,
                  errorType: state.errorType, message: state.message);
            }
          }
        },
        builder: (context, state) {
          if (state is DashboardLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.tertiary,
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
