import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smart_insti_app/components/borderless_button.dart';
import 'package:smart_insti_app/components/material_textformfield.dart';
import 'package:smart_insti_app/provider/lost_and_found_provider.dart';

import '../components/image_tile.dart';
import '../constants/constants.dart';

class LostAndFound extends ConsumerWidget {
  const LostAndFound({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ResponsiveScaledBox(
      width: 411,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Lost & Found'),
          actions: [
            BorderlessButton(
              backgroundColor: Colors.greenAccent.shade100,
              splashColor: Colors.green.shade700,
              onPressed: () => showDialog(
                context: context,
                builder: (context) => Dialog(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Add Listing',
                            style: TextStyle(fontSize: 30),
                          ),
                          const SizedBox(height: 20),
                          Consumer(
                            builder: (_, ref, __) {
                              if (ref.watch(lostAndFoundProvider).selectedImage == null) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () => ref.read(lostAndFoundProvider.notifier).pickImageFromCamera(),
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                      child: const Icon(Icons.camera_alt),
                                    ),
                                    const Text("OR"),
                                    ElevatedButton(
                                      onPressed: () => ref.watch(lostAndFoundProvider.notifier).pickImageFromGallery(),
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                      child: const Icon(Icons.photo),
                                    ),
                                  ],
                                );
                              } else {
                                return GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (_) => Dialog(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text("Remove image?"),
                                            const SizedBox(height: 20),
                                            BorderlessButton(
                                              onPressed: () {
                                                ref.read(lostAndFoundProvider.notifier).resetImageSelection();
                                                Navigator.pop(context);
                                              },
                                              backgroundColor: Colors.redAccent.shade100.withOpacity(0.5),
                                              splashColor: Colors.red.shade700,
                                              label: const Text('Remove Image'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  child: SizedBox(
                                    width: 200,
                                    height: 150,
                                    child: Image.file(ref.watch(lostAndFoundProvider).selectedImage!),
                                  ),
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                          MaterialTextFormField(
                            hintText: "Item Name",
                            controller: ref.read(lostAndFoundProvider).itemNameController,
                          ),
                          const SizedBox(height: 20),
                          MaterialTextFormField(
                              hintText: "Item Description",
                              controller: ref.read(lostAndFoundProvider).itemDescriptionController),
                          const SizedBox(height: 20),
                          MaterialTextFormField(
                              hintText: "Contact Number",
                              controller: ref.read(lostAndFoundProvider).contactNumberController),
                          const SizedBox(height: 20),
                          MaterialTextFormField(
                              hintText: "Last seen at location",
                              controller: ref.read(lostAndFoundProvider).lastSeenLocationController),
                          const SizedBox(height: 20),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Consumer(
                              builder: (_, ref, __) {
                                return AnimatedToggleSwitch.dual(
                                  height: 45,
                                  spacing: 20,
                                  current: ref.watch(lostAndFoundProvider).listingStatus,
                                  first: LostAndFoundConstants.lostState,
                                  second: LostAndFoundConstants.foundState,
                                  textBuilder: (value) => Text(value),
                                  onChanged: (value) =>
                                      ref.read(lostAndFoundProvider.notifier).updateListingStatus(value),
                                  styleBuilder: (value) => value == LostAndFoundConstants.lostState
                                      ? ToggleStyle(
                                          indicatorColor: Colors.redAccent,
                                          backgroundColor: Colors.redAccent.shade100,
                                          borderColor: Colors.transparent,
                                        )
                                      : ToggleStyle(
                                          indicatorColor: Colors.teal,
                                          backgroundColor: Colors.tealAccent.shade100,
                                          borderColor: Colors.transparent,
                                        ),
                                  iconBuilder: (value) => value == LostAndFoundConstants.lostState
                                      ? const Icon(
                                          Icons.search_outlined,
                                          color: Colors.white,
                                        )
                                      : const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                        ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              BorderlessButton(
                                onPressed: () => context.pop(),
                                backgroundColor: Colors.redAccent.shade100.withOpacity(0.5),
                                splashColor: Colors.red.shade700,
                                label: const Text('Cancel'),
                              ),
                              const Spacer(),
                              ElevatedButton(
                                onPressed: () {},
                                child: const Text('Add'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              label: const Text('Add Listing'),
            ),
            const SizedBox(width: 10),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {},
            ),
          ],
        ),
        body: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          children: <Widget>[
            ImageTile(
              primaryColor: Colors.grey.shade300,
              secondaryColor: Colors.blue[200]!,
              onTap: () {},
            ),
            ImageTile(
              image: Image.asset("lib/assets/placeholder.png"),
              primaryColor: Colors.grey.shade300,
              secondaryColor: Colors.blue[200]!,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
