import 'package:aurora_v1/core/widgets/app_button.dart';
import 'package:aurora_v1/core/widgets/dashboard_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TaskScreen extends StatelessWidget {
  const TaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DashboardAppBar(
        title: SizedBox(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
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
                    "Tasks",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Image.asset(
                "assets/images/task.png",
                height: 157,
                width: 355,
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Begin germination",
                style: TextStyle(
                    color: Color(0xFF04021D),
                    fontSize: 32,
                    fontWeight: FontWeight.w600),
              ),
              RichText(
                text: const TextSpan(
                    text: 'A brief overview of the germination process',
                    style: TextStyle(fontSize: 16, color: Color(0xFF686777))),
              ),
              const SizedBox(
                height: 10,
              ),
              const Row(
                children: [
                  Icon(
                    Icons.access_time,
                    color: Color(0xFF686777),
                  ),
                  Text(
                    '10 mins',
                    style: TextStyle(fontSize: 16, color: Color(0xFF686777)),
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              RichText(
                text: const TextSpan(
                    text:
                        "Often overlooked, it is all too easy to assume that the vegetative and flowering stages of cannabis growth are the most critical parts of the plant's life cycle. However, with the chance of failure high unless you know what you're doing, poor planning when it comes to germination can make or break your next grow. Giving your cannabis seeds the best possible start on their journey to bulging buds is a surefire way to encourage a healthy and robust plant ",
                    style: TextStyle(fontSize: 16, color: Color(0xFF686777))),
              ),
              const SizedBox(
                height: 15,
              ),
              RichText(
                text: const TextSpan(
                    text:
                        "Small, fragile, and in desperate need of a helping hand, there are several ways you can germinate your cannabis seeds. All methods have varying degrees of success, with both advantages and disadvantages. It is important to note that even with advanced growing expertise and top-of-the-line equipment, you may still end up with a few failed seeds. This is a natural part of dealing with a living organism. At Royal Queen Seeds, we provide a wide range of high-quality regular and feminized cannabis seeds. We label our genetics clearly, so you don’t have to worry about any unwanted surprises.",
                    style: TextStyle(fontSize: 16, color: Color(0xFF686777))),
              ),
              const SizedBox(
                height: 20,
              ),
              Image.asset(
                "assets/images/task.png",
                height: 135,
                width: 317,
              ),
              const SizedBox(
                height: 20,
              ),
              RichText(
                text: const TextSpan(
                    text: "What To Look Out For In Cannabis Seeds",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
              ),
              const SizedBox(
                height: 5,
              ),
              RichText(
                text: const TextSpan(
                    text:
                        "Regardless of where you get your seeds from, it is best to give them a slight (and delicate) inspection before planting. Most of the time, all seeds will germinate; however, poor-quality seeds will produce a weaker plant. Unfortunately, that is something you will not find out until well into the vegetative and flowering stages.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF686777),
                    )),
              ),
              const SizedBox(
                height: 5,
              ),
              RichText(
                text: const TextSpan(
                    text:
                        "To avoid disappointment, seeds that have a darker colouration stand a better chance of germinating, while pale green or white seeds are likely to fail. Even if dark seeds look slightly damaged, they should be planted anyway. There is a good chance they will still germinate, even if the outer shell is somewhat crushed.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF686777),
                    )),
              ),
              const SizedBox(
                height: 20,
              ),
              AppButton(
                  label: "Mark as Complete",
                  onPressed: () => context.pop(),
                  type: AppButtonType.confirm)
            ],
          ),
        ),
      ),
    );
  }
}
