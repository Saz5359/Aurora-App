import 'package:aurora_v1/core/widgets/app_button.dart';
import 'package:aurora_v1/core/widgets/app_text_form_field.dart';
import 'package:aurora_v1/core/widgets/step_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aurora_v1/features/add_grow/presentation/widgets/custom_stepper.dart';
import '../bloc/add_grow_bloc.dart';

class SelectStrainPage extends StatefulWidget {
  final void Function()? onBack;

  const SelectStrainPage({super.key, this.onBack});

  @override
  State<SelectStrainPage> createState() => _SelectStrainPageState();
}

class _SelectStrainPageState extends State<SelectStrainPage> {
  final strainName1Controller = TextEditingController();
  final strainName2Controller = TextEditingController();
  bool isButtonEnabled = false;
  bool isHybrid = false;

  String? _selectedStrain;

  @override
  void initState() {
    super.initState();
    final bloc = context.read<AddGrowBloc>();

    _selectedStrain = bloc.state is AddGrowStepSuccess
        ? (bloc.state as AddGrowStepSuccess).form.strain
        : '';
    if (_selectedStrain == 'Custom') {
      strainName1Controller.text = (bloc.state is AddGrowStepSuccess
          ? (bloc.state as AddGrowStepSuccess).form.strainName1
          : '')!;
      strainName2Controller.text = (bloc.state is AddGrowStepSuccess
          ? (bloc.state as AddGrowStepSuccess).form.strainName2
          : '')!;
      isHybrid = (bloc.state is AddGrowStepSuccess
          ? (bloc.state as AddGrowStepSuccess).form.isHybrid
          : false)!;
    }
    if (_selectedStrain == null) {
      isButtonEnabled = false;
    } else {
      isButtonEnabled = true;
    }
    strainName1Controller.addListener(_validateInput);
    strainName2Controller.addListener(_validateInput);
  }

  @override
  void dispose() {
    strainName1Controller.dispose();
    strainName2Controller.dispose();
    super.dispose();
  }

  void _validateInput() {
    if (_selectedStrain == 'Custom') {
      // Validate for custom input
      setState(() {
        isButtonEnabled = strainName1Controller.text.isNotEmpty &&
            strainName2Controller.text.isNotEmpty;
      });
    } else {
      // Validate for dropdown selection
      setState(() {
        isButtonEnabled =
            _selectedStrain != null && _selectedStrain!.isNotEmpty;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final strains = ['Custom', 'Goat Cheese', 'Golden Haze', 'GG4'];

    return Scaffold(
      appBar: StepAppBar(onBack: widget.onBack, title: 'Add Grow'),
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
            RichText(
              text: TextSpan(
                  text: 'What kind of cannabis are you growing?',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700])),
            ),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: CustomStepper(currentStep: 1, totalSteps: 5),
            ),
            const SizedBox(
              height: 18,
            ),
            /* RichText(
                text: const TextSpan(children: [
                  TextSpan(
                      text: "Device one ",
                      style: TextStyle(color: Color(0xFF686777), fontSize: 14)),
                  TextSpan(
                    text: " Switch Devices",
                    style: TextStyle(
                        color: Color(0xFF749A78),
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  )
                ]),
              ), */
            const SizedBox(
              height: 15,
            ),
            RichText(
              text: TextSpan(
                  text:
                      'The Aurora Growing unit takes an environmental reading. So remember to keep additional plants in the same environment to ensure accuracy!',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700])),
            ),
            const SizedBox(
              height: 20,
            ),
            Image.asset(
              "assets/images/grow2.png",
              height: 192,
              width: 327,
            ),
            const SizedBox(
              height: 30,
            ),
            RichText(
              text: TextSpan(
                  text:
                      'Cannabis is available in many different varieties and forms, each needing their own requirements.',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700])),
            ),
            const SizedBox(
              height: 20,
            ),
            DropdownButtonFormField<String>(
              value: _selectedStrain,
              decoration: InputDecoration(
                labelText: 'What strain will you be growing?',
                labelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(
                    color: Color(0xFFE2E3E4),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(
                    color: Color(0xFFE2E3E4),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
              items: strains.map((String strain) {
                return DropdownMenuItem<String>(
                  value: strain,
                  child: Text(
                    strain.isEmpty ? '' : strain,
                    style: strain.isEmpty
                        ? TextStyle(
                            color: Theme.of(context).colorScheme.primary)
                        : const TextStyle(color: Colors.black),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedStrain = value;
                  _validateInput();
                });
              },
            ),
            const SizedBox(height: 10),
            if (_selectedStrain == 'Custom') ...[
              Row(
                children: [
                  Checkbox(
                    value: isHybrid,
                    checkColor: Colors.black,
                    activeColor: Colors.green,
                    side: BorderSide(
                        color: Theme.of(context).colorScheme.primary),
                    onChanged: (value) {
                      setState(() {
                        isHybrid = value ?? false;
                      });
                    },
                  ),
                  const Text(
                    'Is it a hybrid strain?',
                    style: TextStyle(color: Color(0xFF686777), fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              AppTextFormField(
                  label: "Strain Name #1",
                  fieldType: FormFieldType.normal,
                  controller: strainName1Controller),
              const SizedBox(height: 25),
              AppTextFormField(
                  label: "Strain Name #2",
                  fieldType: FormFieldType.normal,
                  controller: strainName2Controller),
            ],
            const SizedBox(height: 20),
            AppButton(
              label: 'Next',
              onPressed: isButtonEnabled
                  ? () {
                      context.read<AddGrowBloc>().add(SubmitStrainDetails(
                            strain: _selectedStrain ?? 'Custom',
                            strainName1: strainName1Controller.text,
                            strainName2: strainName2Controller.text,
                            isHybrid: isHybrid,
                          ));
                    }
                  : null,
              type: AppButtonType.confirm,
            ),
          ],
        ),
      ),
    );
  }
}
