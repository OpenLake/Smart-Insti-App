import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_insti_app/theme/ultimate_theme.dart';
import 'package:smart_insti_app/components/borderless_button.dart';
import 'package:smart_insti_app/components/material_textformfield.dart';
import 'package:smart_insti_app/provider/lost_and_found_provider.dart';
import '../../components/image_tile.dart';
import '../../constants/constants.dart';
import '../../provider/auth_provider.dart';
import '../../models/admin.dart';
import '../../models/faculty.dart';
import '../../models/student.dart';

class LostAndFound extends ConsumerWidget {
  LostAndFound({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lfState = ref.watch(lostAndFoundProvider);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(authProvider.notifier).tokenCheckProgress != LoadingState.progress) {
        ref.read(authProvider.notifier).verifyAuthTokenExistence(context, AuthConstants.generalAuthLabel.toLowerCase());
      }
    });
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddListingDialog(context, ref),
        backgroundColor: UltimateTheme.primary,
        icon: const Icon(Icons.add_photo_alternate_rounded, color: Colors.white),
        label: Text("Add Listing", style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold, color: Colors.white)),
      ).animate().scale(delay: 400.ms, curve: Curves.easeOutBack),
      body: lfState.loadingState == LoadingState.success
          ? lfState.lostAndFoundItemList.isNotEmpty
              ? CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                      sliver: SliverGrid(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.75,
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
                      Icon(Icons.search_off_rounded, size: 64, color: UltimateTheme.textSub.withOpacity(0.5)),
                      const SizedBox(height: 16),
                      Text("No items found yet", style: GoogleFonts.inter(color: UltimateTheme.textSub)),
                    ],
                  ),
                )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildItemCard(BuildContext context, item, WidgetRef ref, int index) {
    final bool isLost = item.isLost;
    final Color statusColor = isLost ? Colors.redAccent : UltimateTheme.accent;

    return InkWell(
      onTap: () => _showItemDetails(context, item, ref),
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: UltimateTheme.primary.withOpacity(0.08)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
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
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: UltimateTheme.primary.withOpacity(0.05),
                  ),
                  child: item.imagePath != null
                      ? Image.memory(
                          ref.read(lostAndFoundProvider.notifier).imageFromBase64String(item.imagePath!),
                          fit: BoxFit.cover,
                        )
                      : Center(
                          child: Icon(
                            isLost ? Icons.search_rounded : Icons.backpack_rounded,
                            color: UltimateTheme.primary.withOpacity(0.2),
                            size: 48,
                          ),
                        ),
                ),
              ),
              // Content Section
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        isLost ? "LOST" : "FOUND",
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 8,
                          fontWeight: FontWeight.w900,
                          color: statusColor,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.spaceGrotesk(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: UltimateTheme.textMain,
                      ),
                    ),
                    Text(
                      item.lastSeenLocation,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: UltimateTheme.textSub,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: (index * 50).ms).slideY(begin: 0.1, curve: Curves.easeOutQuad);
  }

  void _showItemDetails(BuildContext context, item, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        title: Text(item.name, style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (item.imagePath != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.memory(ref.read(lostAndFoundProvider.notifier).imageFromBase64String(item.imagePath!)),
                ),
              const SizedBox(height: 16),
              _detailRow("Description", item.description),
              const SizedBox(height: 12),
              _detailRow("Location", item.lastSeenLocation),
              const SizedBox(height: 12),
              _detailRow("Contact", item.contactNumber),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => ref.read(lostAndFoundProvider.notifier).launchCaller(item.contactNumber),
            icon: const Icon(Icons.call_rounded, color: Colors.green),
          ),
          BorderlessButton(
            onPressed: () => context.pop(),
            label: const Text('Close'),
            backgroundColor: UltimateTheme.textSub.withOpacity(0.1),
            splashColor: UltimateTheme.textSub,
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: GoogleFonts.spaceGrotesk(fontSize: 10, fontWeight: FontWeight.w800, color: UltimateTheme.textSub)),
        Text(value, style: GoogleFonts.inter(color: UltimateTheme.textMain, fontSize: 14)),
      ],
    );
  }

  void _showAddListingDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        title: Text('New Listing', style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Image Picker Section
              Consumer(
                builder: (_, ref, __) {
                  final selectedImage = ref.watch(lostAndFoundProvider).selectedImage;
                  return Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: UltimateTheme.primary.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: UltimateTheme.primary.withOpacity(0.1)),
                    ),
                    child: selectedImage == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_a_photo_rounded, color: UltimateTheme.primary.withOpacity(0.3), size: 48),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _pickerButton(
                                    icon: Icons.camera_alt_rounded,
                                    onTap: () => ref.read(lostAndFoundProvider.notifier).pickImageFromCamera(),
                                  ),
                                  const SizedBox(width: 16),
                                  _pickerButton(
                                    icon: Icons.photo_library_rounded,
                                    onTap: () => ref.read(lostAndFoundProvider.notifier).pickImageFromGallery(),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : Stack(
                            fit: StackFit.expand,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(24),
                                child: Image.file(selectedImage, fit: BoxFit.cover),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: IconButton(
                                  onPressed: () => ref.read(lostAndFoundProvider.notifier).resetImageSelection(),
                                  icon: const Icon(Icons.close, color: Colors.white),
                                  style: IconButton.styleFrom(backgroundColor: Colors.black38),
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
                      hintText: "What did you find/lose?",
                      controller: ref.read(lostAndFoundProvider).itemNameController,
                      validator: (value) => Validators.nameValidator(value),
                    ),
                    const SizedBox(height: 16),
                    MaterialTextFormField(
                      hintText: "Provide some details...",
                      controller: ref.read(lostAndFoundProvider).itemDescriptionController,
                      validator: (value) => Validators.descriptionValidator(value),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    MaterialTextFormField(
                      hintText: "Location / Last seen",
                      controller: ref.read(lostAndFoundProvider).lastSeenLocationController,
                      validator: (value) => Validators.nonEmptyValidator(value),
                    ),
                    const SizedBox(height: 16),
                    MaterialTextFormField(
                      hintText: "Phone Number",
                      controller: ref.read(lostAndFoundProvider).contactNumberController,
                      validator: (value) => Validators.contactNumberValidator(value),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Status Toggle
              Consumer(
                builder: (_, ref, __) {
                  return AnimatedToggleSwitch.dual(
                    height: 50,
                    spacing: 20,
                    current: ref.watch(lostAndFoundProvider).listingStatus,
                    first: LostAndFoundConstants.lostState,
                    second: LostAndFoundConstants.foundState,
                    textBuilder: (value) => Text(
                      value.toUpperCase(),
                      style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    onChanged: (value) => ref.read(lostAndFoundProvider.notifier).updateListingStatus(value),
                    styleBuilder: (value) => value == LostAndFoundConstants.lostState
                        ? ToggleStyle(
                            indicatorColor: Colors.redAccent,
                            backgroundColor: Colors.redAccent.withOpacity(0.1),
                            borderColor: Colors.transparent,
                          )
                        : ToggleStyle(
                            indicatorColor: UltimateTheme.accent,
                            backgroundColor: UltimateTheme.accent.withOpacity(0.1),
                            borderColor: Colors.transparent,
                          ),
                    iconBuilder: (value) => Icon(
                      value == LostAndFoundConstants.lostState ? Icons.search_rounded : Icons.check_circle_rounded,
                      color: Colors.white,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        actions: [
          BorderlessButton(
            onPressed: () => context.pop(),
            label: const Text('Cancel'),
            backgroundColor: UltimateTheme.textSub.withOpacity(0.05),
            splashColor: UltimateTheme.textSub,
          ),
          BorderlessButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                ref.read(lostAndFoundProvider.notifier).addItem();
                ref.read(lostAndFoundProvider.notifier).clearControllers();
                context.pop();
              }
            },
            label: const Text('Post Listing'),
            backgroundColor: UltimateTheme.primary.withOpacity(0.1),
            splashColor: UltimateTheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _pickerButton({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4),
          ],
        ),
        child: Icon(icon, color: UltimateTheme.primary),
      ),
    );
  }
}
