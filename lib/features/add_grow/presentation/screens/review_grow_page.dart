import 'package:aurora_v1/core/widgets/app_button.dart';
import 'package:aurora_v1/core/widgets/step_app_bar.dart';
import 'package:aurora_v1/features/add_grow/presentation/widgets/custom_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aurora_v1/features/add_grow/domain/entities/grow_form.dart';
import '../bloc/add_grow_bloc.dart';

class ReviewGrowPage extends StatefulWidget {
  final void Function()? onBack;
  final void Function(int step) onEdit;
  const ReviewGrowPage({super.key, this.onBack, required this.onEdit});

  @override
  State<ReviewGrowPage> createState() => _ReviewGrowPageState();
}

class _ReviewGrowPageState extends State<ReviewGrowPage> {
  final TextEditingController _strainController = TextEditingController();
  final TextEditingController _stageController = TextEditingController();
  final TextEditingController _environmentController = TextEditingController();
  bool warning = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddGrowBloc, AddGrowState>(
      builder: (ctx, state) {
        final form = (state is AddGrowStepSuccess) ? state.form : GrowForm();
        _strainController.text = form.strain ?? '';
        _stageController.text = form.plantStage ?? '';
        _environmentController.text = form.environment ?? '';

        return Scaffold(
          appBar: StepAppBar(
            title: 'Add Grow',
            onBack: widget.onBack,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Plant Information',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
                const SizedBox(
                  height: 20,
                ),
                RichText(
                  text: TextSpan(
                      text: 'Review',
                      style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: CustomStepper(currentStep: 4, totalSteps: 5),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  controller: _strainController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'What strain will you be growing?',
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFFD2D2D7)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onTap: () => widget.onEdit(1),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _stageController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Plant Stage',
                    suffixIcon: const Icon(Icons.arrow_forward_ios_sharp),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFFD2D2D7)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onTap: () => widget.onEdit(2),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _environmentController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Environment',
                    suffixIcon: const Icon(Icons.arrow_forward_ios_sharp),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFFD2D2D7)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onTap: () => widget.onEdit(3),
                ),
                const SizedBox(
                  height: 20,
                ),
                warning
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Warning!',
                            style: TextStyle(
                                color: Color(0xFFEF6363), fontSize: 14),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          RichText(
                            text: const TextSpan(
                                text:
                                    'Based on the time of year this is not an optimal time to be growing from Germination consider germinating from 15 July-30 September',
                                style: TextStyle(
                                    color: Color(0xFFEF6363), fontSize: 14)),
                          ),
                        ],
                      )
                    : const SizedBox(),
                const Spacer(),
                if (state is AddGrowSubmissionInProgress)
                  const Center(child: CircularProgressIndicator()),
                if (state is! AddGrowSubmissionInProgress)
                  AppButton(
                    label: 'Finish',
                    type: AppButtonType.confirm,
                    onPressed: () {
                      context.read<AddGrowBloc>().add(AddGrow());
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
