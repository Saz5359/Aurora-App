import 'package:aurora_v1/core/helpers/snackbar_helper.dart';
import 'package:aurora_v1/features/add_grow/presentation/screens/name_grow_page.dart';
import 'package:aurora_v1/features/add_grow/presentation/screens/review_grow_page.dart';
import 'package:aurora_v1/features/add_grow/presentation/screens/select_environment_page.dart';
import 'package:aurora_v1/features/add_grow/presentation/screens/select_plant_stage_page.dart';
import 'package:aurora_v1/features/add_grow/presentation/screens/select_strain_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/add_grow_bloc.dart';

class AddGrowScreen extends StatefulWidget {
  const AddGrowScreen({super.key});

  @override
  State<AddGrowScreen> createState() => _AddGrowScreenState();
}

class _AddGrowScreenState extends State<AddGrowScreen> {
  final PageController _pageController = PageController();
  bool isEditing = false;

  void _onBack() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _goToStep(int step) {
    setState(() => isEditing = true);
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // If not on first page, go back one step
        if ((_pageController.page ?? 0) > 0) {
          _onBack();
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: BlocListener<AddGrowBloc, AddGrowState>(
            listener: (context, state) {
              if (state is AddGrowStepSuccess) {
                // advance one page on each step success
                final current = _pageController.page?.toInt() ?? 0;
                if (isEditing) {
                  // after edit, go back to REVIEW
                  _pageController.jumpToPage(4);
                  setState(() => isEditing = false);
                } else if (current < 4) {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              } else if (state is AddGrowSubmissionFailure) {
                // Show error snackbar
                showAppErrorSnackBar(
                  context,
                  message: state.message,
                  errorType: state.errorType,
                );
              } else if (state is AddGrowSubmissionSuccess) {
                context.go('/dashboard');
              }
            },
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                NameGrowPage(),
                SelectStrainPage(
                  onBack: _onBack,
                ),
                SelectPlantStagePage(
                  onBack: _onBack,
                ),
                SelectEnvironmentPage(
                  onBack: _onBack,
                ),
                ReviewGrowPage(
                  onBack: _onBack,
                  onEdit: (step) => _goToStep(step),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
