import 'package:aurora_v1/core/widgets/app_button.dart';
import 'package:aurora_v1/core/widgets/step_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aurora_v1/features/add_grow/presentation/widgets/custom_stepper.dart';
import 'package:aurora_v1/features/add_grow/presentation/widgets/environment_options.dart';
import '../bloc/add_grow_bloc.dart';

class SelectEnvironmentPage extends StatefulWidget {
  final void Function()? onBack;

  const SelectEnvironmentPage({super.key, this.onBack});

  @override
  State<SelectEnvironmentPage> createState() => _SelectEnvironmentPageState();
}

class _SelectEnvironmentPageState extends State<SelectEnvironmentPage> {
  String? selectedEnvironment;

  @override
  void initState() {
    super.initState();
    final bloc = context.read<AddGrowBloc>();

    final initialEnvironment = bloc.state is AddGrowStepSuccess
        ? (bloc.state as AddGrowStepSuccess).form.environment
        : '';

    if (initialEnvironment != null) {
      selectedEnvironment = initialEnvironment;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StepAppBar(title: 'Add Grow', onBack: widget.onBack),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Grow environment',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
            const SizedBox(
              height: 10,
            ),
            RichText(
              text: TextSpan(
                  text: 'Where are you growing?',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700])),
            ),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: CustomStepper(currentStep: 3, totalSteps: 5),
            ),
            const SizedBox(
              height: 20,
            ),
            RichText(
              text: TextSpan(
                  text:
                      'There’s no “best” way to grow cannabis, it all comes down to your personal preference. There are numerous benefits for growing indoors and outdoors',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700])),
            ),
            const SizedBox(
              height: 10,
            ),
            EnvironmentOptions(
              label: 'Outdoor',
              description: 'Full-term outdoor growing',
              imagePath: "assets/images/outdoor.png",
              isSelected: selectedEnvironment == 'Outdoor',
              isRecommended: true,
              onTap: () {
                setState(() {
                  selectedEnvironment = 'Outdoor';
                });
              },
            ),
            EnvironmentOptions(
              label: 'Greenhouse',
              description: 'Sun-grown with light deprivation',
              imagePath: 'assets/images/greenhouse.png',
              isSelected: selectedEnvironment == 'Greenhouse',
              isRecommended: false,
              onTap: () {
                setState(() {
                  selectedEnvironment = 'Greenhouse';
                });
              },
            ),
            EnvironmentOptions(
              label: 'Indoor',
              description: 'Fully controlled environment',
              imagePath: 'assets/images/indoor.png',
              isSelected: selectedEnvironment == 'Indoor',
              isRecommended: false,
              onTap: () {
                setState(() {
                  selectedEnvironment = 'Indoor';
                });
              },
            ),
            const SizedBox(
              height: 20,
            ),
            selectedEnvironment == "Greenhouse" ||
                    selectedEnvironment == "Indoor"
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Warning!',
                        style:
                            TextStyle(color: Color(0xFFEF6363), fontSize: 14),
                      ),
                      const SizedBox(height: 5),
                      RichText(
                        text: const TextSpan(
                            text:
                                'Warning! We currently do not support growing in this environment.',
                            style: TextStyle(
                                color: Color(0xFFEF6363), fontSize: 14)),
                      ),
                    ],
                  )
                : SizedBox(),
            const SizedBox(
              height: 20,
            ),
            AppButton(
              label: 'Next',
              type: AppButtonType.confirm,
              onPressed: (selectedEnvironment != null)
                  ? () => context
                      .read<AddGrowBloc>()
                      .add(SubmitEnvironment(selectedEnvironment!))
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
