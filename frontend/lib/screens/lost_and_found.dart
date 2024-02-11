import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smart_insti_app/components/borderless_button.dart';
import 'package:smart_insti_app/components/material_textformfield.dart';
import 'package:smart_insti_app/provider/lost_and_found_provider.dart';
import '../components/image_tile.dart';
import '../constants/constants.dart';

class LostAndFound extends ConsumerWidget {
  LostAndFound({super.key});

  final _formKey = GlobalKey<FormState>();

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
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                MaterialTextFormField(
                                  hintText: "Item Name",
                                  controller: ref.read(lostAndFoundProvider).itemNameController,
                                  validator: (value) => Validators.nameValidator(value),
                                ),
                                const SizedBox(height: 20),
                                MaterialTextFormField(
                                  hintText: "Item Description",
                                  controller: ref.read(lostAndFoundProvider).itemDescriptionController,
                                  validator: (value) => Validators.descriptionValidator(value),
                                ),
                                const SizedBox(height: 20),
                                MaterialTextFormField(
                                  hintText: "Contact Number",
                                  controller: ref.read(lostAndFoundProvider).contactNumberController,
                                  validator: (value) => Validators.contactNumberValidator(value),
                                ),
                                const SizedBox(height: 20),
                                MaterialTextFormField(
                                  hintText: "Last seen at location",
                                  controller: ref.read(lostAndFoundProvider).lastSeenLocationController,
                                  validator: (value) => Validators.nonEmptyValidator(value),
                                ),
                              ],
                            ),
                          ),
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
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    ref.read(lostAndFoundProvider.notifier).addItem();
                                    ref.read(lostAndFoundProvider.notifier).clearControllers();
                                    context.pop();
                                  }
                                },
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
            const SizedBox(width: 20),
          ],
        ),
        body: ref.watch(lostAndFoundProvider).loadingState == LoadingState.success
            ? (ref.read(lostAndFoundProvider).lostAndFoundItemList.isNotEmpty
                ? GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    children: <Widget>[
                      for (var item in ref.watch(lostAndFoundProvider).lostAndFoundItemList)
                        ImageTile(
                          image: item.imagePath != null
                              ? ref.read(lostAndFoundProvider.notifier).imageFromBase64String(item.imagePath!)
                              : null,
                          body: [
                            Text(
                              "Item : ${item.name}",
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              "Last Seen at : ${item.lastSeenLocation}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              item.isLost ? " Status : Lost" : "Status : Found",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                          primaryColor: item.isLost ? Colors.redAccent.shade100 : Colors.tealAccent.shade100,
                          secondaryColor: item.isLost ? Colors.redAccent.shade200 : Colors.tealAccent.shade200,
                          onTap: () => showDialog(
                            context: context,
                            builder: (_) => Dialog(
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Item name : ${item.name}",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      "Item description : \n${item.description}",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      "Last seen at : ${item.lastSeenLocation}",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          item.contactNumber,
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        const SizedBox(width: 10),
                                        IconButton(
                                            onPressed: () => ref
                                                .read(lostAndFoundProvider.notifier)
                                                .launchCaller(item.contactNumber),
                                            icon: const Icon(Icons.call, color: Colors.green)),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    BorderlessButton(
                                      onPressed: () => context.pop(),
                                      backgroundColor: Colors.redAccent.shade100.withOpacity(0.5),
                                      splashColor: Colors.red.shade700,
                                      label: const Text('Close'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  )
                : const Center(
                    child: Text("No Listings"),
                  ))
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
