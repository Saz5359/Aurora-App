import 'package:aurora_v1/core/widgets/app_button.dart';
import 'package:aurora_v1/core/widgets/app_text_form_field.dart';
import 'package:aurora_v1/core/widgets/step_app_bar.dart';
import 'package:aurora_v1/features/add_grow/presentation/widgets/custom_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/add_grow_bloc.dart';

class NameGrowPage extends StatefulWidget {
  final void Function()? onBack;
  const NameGrowPage({super.key, this.onBack});

  @override
  State<NameGrowPage> createState() => _NameGrowPageState();
}

class _NameGrowPageState extends State<NameGrowPage> {
  final _controller = TextEditingController();
  bool _canProceed = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() => _canProceed = _controller.text.trim().isNotEmpty);
    });

    final bloc = context.read<AddGrowBloc>();
    final String? growName = bloc.state is AddGrowStepSuccess
        ? (bloc.state as AddGrowStepSuccess).form.plantName
        : '';

    if (growName!.isNotEmpty) {
      _controller.text = growName;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    context.read<AddGrowBloc>().add(
          SubmitPlantName(_controller.text.trim()),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StepAppBar(
        title: 'Add Grow',
        onBack: widget.onBack,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Getting started',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: CustomStepper(currentStep: 0, totalSteps: 5),
            ),
            const SizedBox(
              height: 25,
            ),
            RichText(
              text: TextSpan(
                  text:
                      'Growing marijuana can be a fun and rewarding experience. It can also be challenging requiring time, patience and a bit of trial and error.',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700])),
            ),
            const SizedBox(
              height: 10,
            ),
            RichText(
              text: TextSpan(
                  text:
                      'Over the next few steps we will go through 3 steps to get you going on your first Grow!',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700])),
            ),
            const SizedBox(
              height: 10,
            ),
            Image.asset(
              "assets/images/grow1.png",
              height: 209,
              width: 118,
            ),
            const SizedBox(
              height: 10,
            ),
            RichText(
              text: TextSpan(
                  text:
                      'Lets give your grow a name. This will be used to identify this grow from future grows.',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700])),
            ),
            const SizedBox(
              height: 20,
            ),
            AppTextFormField(
              label: 'Name Your Grow',
              fieldType: FormFieldType.normal,
              controller: _controller,
            ),
            const SizedBox(height: 20),
            BlocBuilder<AddGrowBloc, AddGrowState>(
              buildWhen: (prev, cur) =>
                  cur is AddGrowStepSuccess || cur is AddGrowInitial,
              builder: (context, state) {
                return AppButton(
                  label: 'Next',
                  onPressed: _canProceed ? _submit : null,
                  type: AppButtonType.confirm,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
