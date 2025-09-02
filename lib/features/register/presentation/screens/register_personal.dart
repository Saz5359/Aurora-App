import 'package:aurora_v1/core/widgets/app_button.dart';
import 'package:aurora_v1/core/widgets/app_text_form_field.dart';
import 'package:aurora_v1/core/widgets/phone_text_field.dart';
import 'package:aurora_v1/core/widgets/step_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/register_bloc.dart';

class RegisterPersonalPage extends StatefulWidget {
  final Function()? onBack;

  const RegisterPersonalPage({
    super.key,
    required this.onBack,
  });

  @override
  State<RegisterPersonalPage> createState() => _RegisterPersonalPageState();
}

class _RegisterPersonalPageState extends State<RegisterPersonalPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StepAppBar(
        title: "Personal Details",
        onBack: widget.onBack,
      ),
      body: BlocBuilder<RegisterBloc, RegisterState>(
        builder: (context, state) {
          final isLoading = state is RegisterLoading;

          return LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Personal Details',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                        ),
                        const SizedBox(height: 10),
                        RichText(
                          text: const TextSpan(children: [
                            TextSpan(
                              text: 'Tell us about yourself!',
                              style: TextStyle(
                                  fontSize: 16, color: Color(0xFF686777)),
                            ),
                          ]),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Display Name',
                            labelStyle: TextStyle(
                                color: Theme.of(context).colorScheme.primary),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
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
                                width: 2.0,
                              ),
                            ),
                            suffixIcon: const Icon(
                              Icons.check_box,
                              color: Colors.green,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        PhoneTextField(phoneController: _phoneController),
                        const SizedBox(height: 10),
                        AppTextFormField(
                            label: 'Age',
                            fieldType: FormFieldType.normal,
                            controller: _phoneController),
                        const SizedBox(height: 10),
                        const Spacer(),
                        AppButton(
                            label: "Skip",
                            onPressed: () => context.read<RegisterBloc>().add(
                                SubmitPersonalInfo(fullName: '', email: '')),
                            type: AppButtonType.cancel),
                        const SizedBox(height: 10),
                        isLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              )
                            : AppButton(
                                label: 'Continue',
                                onPressed:
                                    (!(_formKey.currentState?.validate() ??
                                            false))
                                        ? null
                                        : () {
                                            context.read<RegisterBloc>().add(
                                                  SubmitPersonalInfo(
                                                    fullName:
                                                        _fullNameController.text
                                                            .trim(),
                                                    email: _phoneController.text
                                                        .trim(),
                                                  ),
                                                );
                                          },
                                type: AppButtonType.confirm,
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
