import 'package:aurora_v1/core/widgets/app_button.dart';
import 'package:aurora_v1/core/widgets/step_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aurora_v1/features/add_grow/presentation/widgets/custom_stepper.dart';
import 'package:aurora_v1/features/add_grow/presentation/widgets/growth_stage_selector.dart';
import '../bloc/add_grow_bloc.dart';

class SelectPlantStagePage extends StatefulWidget {
  final void Function()? onBack;

  const SelectPlantStagePage({super.key, this.onBack});

  @override
  State<SelectPlantStagePage> createState() => _SelectPlantStagePageState();
}

class _SelectPlantStagePageState extends State<SelectPlantStagePage> {
  int? selectedStageIndex;
  bool warning = false;
  final _stages = ['seed', 'seedling', 'vegetative', 'flowering'];

  @override
  void initState() {
    super.initState();
    final bloc = context.read<AddGrowBloc>();

    final initialPlantStage = bloc.state is AddGrowStepSuccess
        ? (bloc.state as AddGrowStepSuccess).form.plantStage
        : '';
    if (initialPlantStage != null) {
      selectedStageIndex = _stages.indexOf(initialPlantStage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StepAppBar(onBack: widget.onBack, title: 'Add Grow'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Plant stages',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
            const SizedBox(height: 20),
            RichText(
              text: TextSpan(
                  text: 'Where would you like us to begin the grow?',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700])),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: CustomStepper(currentStep: 2, totalSteps: 5),
            ),
            const SizedBox(height: 20),
            RichText(
              text: TextSpan(
                  text:
                      'The growth stages of marijuana can be broken down into four primary stages from seed to harvest.',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700])),
            ),
            const SizedBox(height: 30),
            RichText(
              text: TextSpan(
                  text: 'Where are you starting your grow?',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700])),
            ),
            const SizedBox(height: 15),

            // GrowthStageSelector with the selectedIndex state and callback function
            SizedBox(
              height: 530,
              child: GrowthStageSelector(
                selectedIndex: selectedStageIndex,
                onStageSelected: (index) {
                  setState(() {
                    selectedStageIndex = index;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            warning
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
                        text: const TextSpan(children: [
                          TextSpan(
                              text:
                                  'Warning! Based on the time of year this is not an optimal time to be growing from ',
                              style: TextStyle(
                                  color: Color(0xFFEF6363), fontSize: 14)),
                          TextSpan(
                              text:
                                  ' Germination consider germinating from 15 July-30 September',
                              style: TextStyle(
                                  color: Color(0xFFEF6363),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600)),
                        ]),
                      ),
                    ],
                  )
                : const SizedBox(),
            AppButton(
              label: 'Next',
              onPressed: (selectedStageIndex != null)
                  ? () => context
                      .read<AddGrowBloc>()
                      .add(SubmitPlantStage(_stages[selectedStageIndex!]))
                  : null,
              type: AppButtonType.confirm,
            ),
          ],
        ),
      ),
    );
  }
}
