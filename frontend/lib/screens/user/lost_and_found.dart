import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_insti_app/theme/ultimate_theme.dart';
import 'package:smart_insti_app/components/borderless_button.dart';
import 'package:smart_insti_app/components/material_textformfield.dart';
import 'package:smart_insti_app/provider/lost_and_found_provider.dart';
import '../../constants/constants.dart';
import '../../provider/auth_provider.dart';

class LostAndFound extends ConsumerWidget {
  LostAndFound({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lfState = ref.watch(lostAndFoundProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(authProvider.notifier).tokenCheckProgress !=
          LoadingState.progress) {
        ref.read(authProvider.notifier).verifyAuthTokenExistence(
            context, AuthConstants.generalAuthLabel.toLowerCase());
      }
    });
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddListingDialog(context, ref),
        backgroundColor: UltimateTheme.primary,
        elevation: 4,
        highlightElevation: 8,
        icon: const Icon(Icons.add_a_photo_rounded, color: Colors.white),
        label: Text("Post Item",
            style: GoogleFonts.spaceGrotesk(
                fontWeight: FontWeight.bold, color: Colors.white)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ).animate().scale(delay: 400.ms, curve: Curves.easeOutBack),
      body: lfState.loadingState == LoadingState.success
          ? lfState.lostAndFoundItemList.isNotEmpty
              ? CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 20,
                          childAspectRatio: 0.72,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final item = lfState.lostAndFoundItemList[index];
                            return _buildItemCard(context, item, ref, index);
                          },
                          childCount: lfState.lostAndFoundItemList.length,
                        ),
                      ),
                    ),
                  ],
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: UltimateTheme.primary.withValues(alpha: 0.05),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.search_off_rounded,
                            size: 64,
                            color:
                                UltimateTheme.primary.withValues(alpha: 0.3)),
                      ),
                      const SizedBox(height: 24),
                      Text("No items found yet",
                          style: GoogleFonts.spaceGrotesk(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: UltimateTheme.textMain)),
                      Text("Be the first to post something!",
                          style:
                              GoogleFonts.inter(color: UltimateTheme.textSub)),
                    ],
                  ).animate().fadeIn(),
                )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildItemCard(BuildContext context, item, WidgetRef ref, int index) {
    final bool isLost = item.isLost;
    final Color statusColor =
        isLost ? Colors.redAccent : UltimateTheme.secondary;

    return GestureDetector(
      onTap: () => _showItemDetails(context, item, ref),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border:
              Border.all(color: UltimateTheme.primary.withValues(alpha: 0.05)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Section
              Expanded(
                child: Hero(
                  tag: 'item_${item.id}',
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: UltimateTheme.primary.withValues(alpha: 0.02),
                    ),
                    child: item.imagePath != null
                        ? Image.memory(
                            ref
                                .read(lostAndFoundProvider.notifier)
                                .imageFromBase64String(item.imagePath!),
                            fit: BoxFit.cover,
                          )
                        : Center(
                            child: Icon(
                              isLost
                                  ? Icons.search_rounded
                                  : Icons.backpack_rounded,
                              color:
                                  UltimateTheme.primary.withValues(alpha: 0.1),
                              size: 40,
                            ),
                          ),
                  ),
                ),
              ),
              // Content Section
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        isLost ? "LOST" : "FOUND",
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          color: statusColor,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.spaceGrotesk(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: UltimateTheme.textMain,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined,
                            size: 12, color: UltimateTheme.textSub),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            item.lastSeenLocation,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: UltimateTheme.textSub,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: (index * 40).ms).slideY(begin: 0.1);
  }

  void _showItemDetails(BuildContext context, item, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        contentPadding: EdgeInsets.zero,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (item.imagePath != null)
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(28)),
                child: Hero(
                  tag: 'item_${item.id}',
                  child: Image.memory(
                    ref
                        .read(lostAndFoundProvider.notifier)
                        .imageFromBase64String(item.imagePath!),
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              )
            else
              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: UltimateTheme.primary.withValues(alpha: 0.05),
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: Icon(Icons.inventory_2_outlined,
                    size: 48,
                    color: UltimateTheme.primary.withValues(alpha: 0.2)),
              ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name,
                      style: GoogleFonts.spaceGrotesk(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: UltimateTheme.textMain)),
                  const SizedBox(height: 20),
                  _detailRow("Description", item.description),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                          child: _detailRow("Location", item.lastSeenLocation)),
                      const SizedBox(width: 16),
                      Expanded(
                          child: _detailRow("Contact", item.contactNumber)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          BorderlessButton(
            onPressed: () => context.pop(),
            label: const Text('Close'),
            backgroundColor: UltimateTheme.textSub.withValues(alpha: 0.05),
            splashColor: UltimateTheme.textSub,
          ),
          ElevatedButton.icon(
            onPressed: () => ref
                .read(lostAndFoundProvider.notifier)
                .launchCaller(item.contactNumber),
            icon: const Icon(Icons.call_rounded, size: 18),
            label: const Text("Contact"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(),
            style: GoogleFonts.spaceGrotesk(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: UltimateTheme.textSub,
              letterSpacing: 1,
            )),
        const SizedBox(height: 4),
        Text(value,
            style: GoogleFonts.inter(
              color: UltimateTheme.textMain,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            )),
      ],
    );
  }

  void _showAddListingDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
        title: Text('New Listing',
            style: GoogleFonts.spaceGrotesk(
                fontWeight: FontWeight.bold, fontSize: 24)),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Image Picker Section
                Consumer(
                  builder: (_, ref, __) {
                    final selectedImage =
                        ref.watch(lostAndFoundProvider).selectedImage;
                    return Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: UltimateTheme.primary.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                            color: UltimateTheme.primary.withValues(alpha: 0.1),
                            width: 2),
                      ),
                      child: selectedImage == null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: UltimateTheme.primary
                                        .withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.add_a_photo_rounded,
                                      color: UltimateTheme.primary, size: 32),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _pickerButton(
                                      icon: Icons.camera_alt_rounded,
                                      label: "Camera",
                                      onTap: () => ref
                                          .read(lostAndFoundProvider.notifier)
                                          .pickImageFromCamera(),
                                    ),
                                    const SizedBox(width: 16),
                                    _pickerButton(
                                      icon: Icons.photo_library_rounded,
                                      label: "Gallery",
                                      onTap: () => ref
                                          .read(lostAndFoundProvider.notifier)
                                          .pickImageFromGallery(),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : Stack(
                              fit: StackFit.expand,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(22),
                                  child: Image.file(selectedImage,
                                      fit: BoxFit.cover),
                                ),
                                Positioned(
                                  top: 10,
                                  right: 10,
                                  child: IconButton(
                                    onPressed: () => ref
                                        .read(lostAndFoundProvider.notifier)
                                        .resetImageSelection(),
                                    icon: const Icon(Icons.close,
                                        color: Colors.white, size: 20),
                                    style: IconButton.styleFrom(
                                      backgroundColor:
                                          Colors.black.withValues(alpha: 0.5),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                // Form Fields
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      MaterialTextFormField(
                        hintText: "Item Name",
                        controller:
                            ref.read(lostAndFoundProvider).itemNameController,
                        validator: (value) => Validators.nameValidator(value),
                        prefixIcon: const Icon(Icons.inventory_2_outlined),
                      ),
                      const SizedBox(height: 16),
                      MaterialTextFormField(
                        hintText: "Description",
                        controller: ref
                            .read(lostAndFoundProvider)
                            .itemDescriptionController,
                        validator: (value) =>
                            Validators.descriptionValidator(value),
                        maxLines: 3,
                        prefixIcon: const Icon(Icons.description_outlined),
                      ),
                      const SizedBox(height: 16),
                      MaterialTextFormField(
                        hintText: "Location",
                        controller: ref
                            .read(lostAndFoundProvider)
                            .lastSeenLocationController,
                        validator: (value) =>
                            Validators.nonEmptyValidator(value),
                        prefixIcon: const Icon(Icons.location_on_outlined),
                      ),
                      const SizedBox(height: 16),
                      MaterialTextFormField(
                        hintText: "Contact Number",
                        controller: ref
                            .read(lostAndFoundProvider)
                            .contactNumberController,
                        validator: (value) =>
                            Validators.contactNumberValidator(value),
                        prefixIcon: const Icon(Icons.phone_outlined),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Status Toggle
                Consumer(
                  builder: (_, ref, __) {
                    final status =
                        ref.watch(lostAndFoundProvider).listingStatus;
                    return AnimatedToggleSwitch.dual(
                      height: 54,
                      spacing: 24,
                      current: status,
                      first: LostAndFoundConstants.lostState,
                      second: LostAndFoundConstants.foundState,
                      textBuilder: (value) => Text(
                        value.toUpperCase(),
                        style: GoogleFonts.spaceGrotesk(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            letterSpacing: 1),
                      ),
                      onChanged: (value) => ref
                          .read(lostAndFoundProvider.notifier)
                          .updateListingStatus(value),
                      styleBuilder: (value) =>
                          value == LostAndFoundConstants.lostState
                              ? ToggleStyle(
                                  indicatorColor: Colors.redAccent,
                                  backgroundColor:
                                      Colors.redAccent.withValues(alpha: 0.1),
                                  borderColor: Colors.transparent,
                                )
                              : ToggleStyle(
                                  indicatorColor: UltimateTheme.secondary,
                                  backgroundColor: UltimateTheme.secondary
                                      .withValues(alpha: 0.1),
                                  borderColor: Colors.transparent,
                                ),
                      iconBuilder: (value) => Icon(
                        value == LostAndFoundConstants.lostState
                            ? Icons.search_rounded
                            : Icons.check_circle_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        actions: [
          Row(
            children: [
              Expanded(
                child: BorderlessButton(
                  onPressed: () => context.pop(),
                  label: const Text('Cancel'),
                  backgroundColor:
                      UltimateTheme.textSub.withValues(alpha: 0.05),
                  splashColor: UltimateTheme.textSub,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: BorderlessButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ref.read(lostAndFoundProvider.notifier).addItem();
                      ref
                          .read(lostAndFoundProvider.notifier)
                          .clearControllers();
                      context.pop();
                    }
                  },
                  label: const Text('Post'),
                  backgroundColor: UltimateTheme.primary.withValues(alpha: 0.1),
                  splashColor: UltimateTheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _pickerButton(
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2)),
              ],
            ),
            child: Icon(icon, color: UltimateTheme.primary, size: 24),
          ),
        ),
        const SizedBox(height: 6),
        Text(label,
            style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: UltimateTheme.textSub)),
      ],
    );
  }
}
