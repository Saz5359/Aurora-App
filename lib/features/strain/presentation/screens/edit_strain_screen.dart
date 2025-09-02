import 'package:aurora_v1/core/widgets/app_button.dart';
import 'package:aurora_v1/core/widgets/app_text_form_field.dart';
import 'package:aurora_v1/core/widgets/dashboard_app_bar.dart';
import 'package:aurora_v1/features/dashboard/domain/entities/plant.dart';
import 'package:aurora_v1/features/strain/presentation/widgets/compound_selector.dart';
import 'package:aurora_v1/features/strain/presentation/widgets/terpenes_selectors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EditStrainScreen extends StatefulWidget {
  final Plant grow;
  const EditStrainScreen({super.key, required this.grow});

  @override
  State<EditStrainScreen> createState() => _EditStrainScreenState();
}

class _EditStrainScreenState extends State<EditStrainScreen> {
  final TextEditingController _strainController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _feelingsController = TextEditingController();
  final TextEditingController _helpWithController = TextEditingController();
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    _strainController.text = widget.grow.strain;

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
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
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
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    "Edit Strain",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Image.asset(
                "assets/images/strain.png",
                height: 157,
                width: 355,
              ),
              const SizedBox(
                height: 50,
              ),
              AppTextFormField(
                  label: "Strain Name",
                  fieldType: FormFieldType.normal,
                  controller: _strainController),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _descriptionController,
                maxLines: 4,
                maxLength: 200,
                decoration: InputDecoration(
                  labelText: 'Enter strain description',
                  labelStyle:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(
                      color: Color(0xFFE2E3E4), // Border when not focused
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(
                      color: Theme.of(context)
                          .colorScheme
                          .secondary, // Border when focused
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                onChanged: (value) {
                  // Any additional logic for text change can go here
                },
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Strain Overview",
                style: TextStyle(
                    fontSize: 32,
                    color: Color(0xFF04021D),
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 10,
              ),
              RichText(
                text: TextSpan(
                    text: 'Detail the overall traits of the strain',
                    style: TextStyle(fontSize: 16, color: Colors.grey[700])),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _feelingsController,
                maxLines: 4,
                maxLength: 80,
                decoration: InputDecoration(
                  labelText: 'feelings',
                  labelStyle: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(
                      color: Color(0xFFE2E3E4), // Border when not focused
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(
                      color: Theme.of(context)
                          .colorScheme
                          .secondary, // Border when focused
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 5,
                  ),
                ),
                onChanged: (value) {
                  // Any additional logic for text change can go here
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _helpWithController,
                maxLines: 4,
                maxLength: 80,
                decoration: InputDecoration(
                  labelText: 'Helps with',
                  labelStyle: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(
                      color: Color(0xFFE2E3E4), // Border when not focused
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(
                      color: Theme.of(context)
                          .colorScheme
                          .secondary, // Border when focused
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 5,
                  ),
                ),
                onChanged: (value) {
                  // Any additional logic for text change can go here
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      initiallyExpanded: _expanded,
                      onExpansionChanged: (value) =>
                          setState(() => _expanded = value),
                      title: const Text(
                        "Advanced details",
                        style: TextStyle(
                          fontSize: 32,
                          color: Color(0xFF04021D),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      children: [
                        const SizedBox(height: 10),
                        RichText(
                          text: TextSpan(
                            text: 'Compound Levels ',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                          ),
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(height: 10),

                        const CompoundSelector(), // Replace with your actual widget
                        const SizedBox(height: 10),

                        RichText(
                          text: TextSpan(
                            text: 'Terpenes',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        const TerpenesSelectors(), // Replace with your actual widget
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ],
              ),

              /* const Text(
                "Advanced details",
                style: TextStyle(
                    fontSize: 32,
                    color: Color(0xFF04021D),
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 10,
              ),
              RichText(
                text: TextSpan(
                    text: 'Compound Levels ',
                    style: TextStyle(fontSize: 16, color: Colors.grey[700])),
              ),
              const SizedBox(
                height: 10,
              ),
              CompoundSelector(),
              const SizedBox(
                height: 10,
              ),
              RichText(
                text: TextSpan(
                    text: 'Terpenes',
                    style: TextStyle(fontSize: 16, color: Colors.grey[700])),
              ),
              const SizedBox(
                height: 10,
              ),
              const TerpenesSelectors(),*/
              const SizedBox(
                height: 30,
              ),
              AppButton(
                  label: "Save",
                  onPressed: () => context.pop(),
                  type: AppButtonType.confirm),
              const SizedBox(
                height: 10,
              ),
              AppButton(
                  label: "Cancel",
                  onPressed: () => context.pop(),
                  type: AppButtonType.cancel),
            ],
          ),
        ),
      ),
    );
  }
}
