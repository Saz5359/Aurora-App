import 'package:aurora_v1/core/widgets/dashboard_app_bar.dart';
import 'package:aurora_v1/features/dashboard/domain/entities/plant.dart';
import 'package:aurora_v1/features/dashboard/presentation/widgets/grow_actions_popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StrainScreen extends StatelessWidget {
  final Plant grow;
  const StrainScreen({super.key, required this.grow});

  @override
  Widget build(BuildContext context) {
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
                  const SizedBox(width: 10),
                  const Text(
                    "Strain",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Image.asset(
                "assets/images/strain.png",
                height: 157,
                width: 355,
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            grow.strain,
                            style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Container(
                                height: 22,
                                width: 62,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: const Color(0xFF686777),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Hybrid',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Flexible(
                                child: Text(
                                  'THC 24% CBD 1%',
                                  style: TextStyle(
                                      color: Color(0xFF686777), fontSize: 14),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Row(
                            children: [
                              Icon(
                                Icons.local_convenience_store_outlined,
                                color: Colors.black,
                                size: 20,
                              ),
                              SizedBox(width: 5),
                              Flexible(
                                child: Text(
                                  "Caryophyllene, Humulene, Myrcene",
                                  style: TextStyle(
                                      color: Color(0xFF686777), fontSize: 14),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Builder(
                      builder: (iconContext) {
                        return GestureDetector(
                          onTap: () {
                            final RenderBox renderBox =
                                iconContext.findRenderObject() as RenderBox;
                            final Offset offset = renderBox.localToGlobal(
                              Offset(renderBox.size.width, 0),
                            );

                            GrowActionsPopupMenu.show(
                              context: iconContext,
                              position: offset,
                              grow: grow,
                            );
                          },
                          child: const Icon(
                            Icons.more_vert,
                            color: Colors.black,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F8FA),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Feeling",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          SizedBox(height: 5),
                          Text("Relaxed, Hungry"),
                          Text("Sleepy, Paranoid"),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Uses",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          SizedBox(height: 5),
                          Text("Insomnia, Anxiety"),
                          Text("Cancer, Stress"),
                          Text("Depression"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  text:
                      "G.O.A.T. Cheese is an Indica-leaning hybrid strain bred by TEG, crossing UK Cheese and Grandma's Cookies. The reviewed jar contained one large nug (pictured) and 4 smaller ones with a fairly dense/chunky structure. The nugs are dark green with purple leaves, dark orange hairs, and a nice dusting of trichomes, and I have no complaints about the cure. Testing is as follows:",
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
              ),
              const SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  text:
                      'Package date: 1/03/23\nTHC: 31.10%\nTotal Cannabinoids: 32.19%\nTerpenes: 1.35%\nPrimary terpenes: Caryophyllene, Limonene, Myrcene, Linalool, Humulene',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
              ),
              const SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  text:
                      'Smell/taste: 8.7/10\nThe nose on this strain is super funky, but not as loud as some other TEG cultivars. It has an interesting cheese and skunk profile, followed up by light sweet gas fumes and a hint of cookie dough. The smell translates well to a clean flavor that emphasizes the cheese (sharp cheddar) and skunk. Clean burn with slightly flecked ash.',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
              ),
              const SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  text:
                      'Effects: 8.9/10\nSlow rolling effects here that feature a heavy euphoric body high and a slight cerebral buzz, leading to a very calming effect overall. This bud often leads to couch lock and the munchies and is recommended as an evening smoke. Medium-long duration.',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
