import 'package:aurora_v1/core/widgets/app_button.dart';
import 'package:aurora_v1/core/widgets/step_app_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddDeviceConnected extends StatefulWidget {
  final PageController pageController;
  final String? deviceId;
  final String? growName;

  const AddDeviceConnected({
    super.key,
    required this.pageController,
    this.deviceId,
    this.growName,
  });

  @override
  State<AddDeviceConnected> createState() => _AddDeviceConnectedState();
}

class _AddDeviceConnectedState extends State<AddDeviceConnected> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _registerDevice() async {
    String deviceName = _controller.text.trim();
    if (deviceName.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final dbRef = FirebaseDatabase.instance.ref('devices/${widget.deviceId}');

      await dbRef.update({
        'status': 'registered',
        'deviceName': deviceName,
        'growName': widget.growName,
        'userId': FirebaseAuth.instance.currentUser?.uid,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Device registered successfully!')),
      );

      if (mounted) {
        Future.microtask(() {
          widget.pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: StepAppBar(
        onBack: () => widget.pageController.previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        ),
        title: 'Add Device',
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Connected!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      RichText(
                        text: TextSpan(
                          text: 'Let’s give the device a recognizable name',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _controller,
                        onChanged: (value) {
                          setState(() {
                            _isButtonEnabled = value.isNotEmpty;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Device Name',
                          border: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Color(0xFFD2D2D7)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Spacer(),
                      _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : AppButton(
                              label: 'Next',
                              onPressed:
                                  _isButtonEnabled ? _registerDevice : null,
                              type: AppButtonType.confirm,
                            ),
                    ],
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

//////////////////////////////////////////////////////////Original Code//////////////////////////////////////////////////////////
/* import 'package:aurora_demo_app/core/widgets/custom_app_bar.dart';
import 'package:aurora_demo_app/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class AddDeviceConnected extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  final PageController pageController;

  AddDeviceConnected({super.key, required this.pageController});

  @override
  Widget build(BuildContext context) {
    _controller.text = " ";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
          navigateBack: () => pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              ),
          title: 'Add Device'),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Connected!',
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
                          text: 'Let’s give the device a recognizable name',
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[700]),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          labelText: 'Device Name',
                          border: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Color(0xFFD2D2D7)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Spacer(),
                      CustomButton(
                        label: 'Next',
                        onPressed: () => pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut),
                        type: ButtonType.confirm,
                      ),
                    ],
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
 */
