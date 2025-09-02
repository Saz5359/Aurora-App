import 'package:aurora_v1/core/helpers/snackbar_helper.dart';
import 'package:aurora_v1/core/widgets/dashboard_app_bar.dart';
import 'package:aurora_v1/features/dashboard/domain/entities/plant.dart';
import 'package:aurora_v1/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:aurora_v1/features/dashboard/presentation/widgets/grow_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class GrowOverviewScreen extends StatefulWidget {
  const GrowOverviewScreen({super.key});

  @override
  State<GrowOverviewScreen> createState() => _GrowOverviewScreenState();
}

class _GrowOverviewScreenState extends State<GrowOverviewScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(FetchPlantList());
  }

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  /* GestureDetector(
                    onTap: () {
                      // Optional: Could use context.pop() here
                    },
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      size: 20,
                      color: Color(0xFFAFCEB2),
                    ),
                  ), */
                  const SizedBox(width: 10),
                  Text(
                    "Strains",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              BlocConsumer<DashboardBloc, DashboardState>(
                listener: (context, state) {
                  if (state is DashboardError) {
                    showAppErrorSnackBar(context,
                        message: state.message, errorType: state.errorType);
                  }
                },
                builder: (context, state) {
                  if (state is PlantListLoaded) {
                    final plants = state.plants; // List<Plant> loaded

                    if (plants.isEmpty) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            'No plants available. Start by adding a new grow!',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: plants.length,
                      itemBuilder: (context, index) {
                        final Plant plant = plants[index];
                        //final random = Random();
                        final percentValue = 0.0; //random.nextDouble();
                        final percent =
                            '--%'; //'${(percentValue * 100).toInt()}%';
                        final devices = 1;

                        return GrowCard(
                          grow: plant,
                          onTap: () => context.push(
                            '/dashboard/${plant.id}/$percentValue',
                          ),
                          growName: plant.plantName,
                          percent: percent,
                          percentValue: percentValue,
                          devices: devices,
                          isDeviceConnected: plant.isDeviceConnected,
                          isShared: false,
                        );
                      },
                    );
                  }

                  if (state is PlantListLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    );
                  }

                  return const SizedBox();
                },
              ),
              const SizedBox(height: 40),
              Center(
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Color(0xFFD5EFD8)),
                    fixedSize: WidgetStateProperty.all(Size(150, 48)),
                  ),
                  onPressed: () => context.push("/add_grow"),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add, size: 14, color: Color(0xFF686777)),
                      SizedBox(width: 5),
                      Text(
                        "Add Grow",
                        style:
                            TextStyle(fontSize: 14, color: Color(0xFF686777)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
