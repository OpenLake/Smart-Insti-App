import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:smart_insti_app/constants/dummy_entries.dart';
import 'package:smart_insti_app/models/lost_and_found_item.dart';
import 'package:smart_insti_app/repositories/lost_and_found_repository.dart';
import 'dart:io';
import '../components/image_tile.dart';
import '../constants/constants.dart';

final lostAndFoundProvider =
    StateNotifierProvider<LostAndFoundStateNotifier, LostAndFoundState>((ref) => LostAndFoundStateNotifier(ref));

class LostAndFoundState {
  final List<LostAndFoundItem> lostAndFoundItemList;
  final TextEditingController itemNameController;
  final TextEditingController itemDescriptionController;
  final TextEditingController lastSeenLocationController;
  final TextEditingController searchLostAndFoundController;
  final TextEditingController contactNumberController;
  final String listingStatus;
  final File? selectedImage;
  final LoadingState gridLoadingState;

  LostAndFoundState({
    required this.lostAndFoundItemList,
    required this.itemNameController,
    required this.itemDescriptionController,
    required this.lastSeenLocationController,
    required this.searchLostAndFoundController,
    required this.contactNumberController,
    required this.listingStatus,
    this.selectedImage,
    required this.gridLoadingState,
  });

  LostAndFoundState copyWith({
    List<LostAndFoundItem>? lostAndFoundItemList,
    TextEditingController? itemNameController,
    TextEditingController? itemDescriptionController,
    TextEditingController? lastSeenLocationController,
    TextEditingController? searchLostAndFoundController,
    TextEditingController? contactNumberController,
    String? listingStatus,
    File? selectedImage,
    LoadingState? gridLoadingState,
  }) {
    return LostAndFoundState(
      lostAndFoundItemList: lostAndFoundItemList ?? this.lostAndFoundItemList,
      itemNameController: itemNameController ?? this.itemNameController,
      itemDescriptionController: itemDescriptionController ?? this.itemDescriptionController,
      lastSeenLocationController: lastSeenLocationController ?? this.lastSeenLocationController,
      searchLostAndFoundController: searchLostAndFoundController ?? this.searchLostAndFoundController,
      contactNumberController: contactNumberController ?? this.contactNumberController,
      listingStatus: listingStatus ?? this.listingStatus,
      selectedImage: selectedImage,
      gridLoadingState: gridLoadingState ?? this.gridLoadingState,
    );
  }
}

class LostAndFoundStateNotifier extends StateNotifier<LostAndFoundState> {
  LostAndFoundStateNotifier(Ref ref)
      : _api = ref.read(lostAndFoundRepositoryProvider),
        super(
          LostAndFoundState(
            lostAndFoundItemList: DummyLostAndFound.lostAndFoundItems,
            itemNameController: TextEditingController(),
            itemDescriptionController: TextEditingController(),
            lastSeenLocationController: TextEditingController(),
            searchLostAndFoundController: TextEditingController(),
            contactNumberController: TextEditingController(),
            listingStatus: LostAndFoundConstants.lostState,
            selectedImage: null,
            gridLoadingState: LoadingState.progress,
          ),
        );

  final LostAndFoundRepository _api;

  final Logger _logger = Logger();

  void addItem() {
    final item = LostAndFoundItem(
      name: state.itemNameController.text,
      lastSeenLocation: state.lastSeenLocationController.text,
      imagePath: state.selectedImage?.path ?? '',
      description: state.itemDescriptionController.text,
      isLost: state.listingStatus == LostAndFoundConstants.lostState,
      contactNumber: state.contactNumberController.text,
    );
    state = state.copyWith(lostAndFoundItemList: [item, ...state.lostAndFoundItemList]);
  }

  void updateListingStatus(String status) {
    state = state.copyWith(listingStatus: status);
  }

  Future<CroppedFile?> _cropImage(XFile image) {
    return ImageCropper().cropImage(
      sourcePath: image.path,
      aspectRatio: const CropAspectRatio(ratioX: 4, ratioY: 3),
      compressQuality: 100,
      compressFormat: ImageCompressFormat.jpg,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Lost and Found',
          toolbarColor: Colors.tealAccent,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: true,
        ),
      ],
    );
  }

  void pickImageFromCamera() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      CroppedFile? file = await _cropImage(pickedFile);
      state = state.copyWith(selectedImage: File(file!.path));
      _logger.d(file.path);
    }
  }

  void pickImageFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      CroppedFile? file = await _cropImage(pickedFile);
      state = state.copyWith(selectedImage: File(file!.path));
      _logger.d(file.path);
    }
    _logger.d(pickedFile?.path);
  }

  void resetImageSelection() {
    state = state.copyWith(selectedImage: null);
    _logger.d('Image selection reset');
  }

  List<ImageTile> buildImageTiles() {
    return state.lostAndFoundItemList.map((item) {
      return ImageTile(
        image: Image.file(File(item.imagePath)),
        body: [
          Text(
            item.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            item.lastSeenLocation,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
        primaryColor: Colors.tealAccent,
        secondaryColor: Colors.teal,
        onTap: () {},
      );
    }).toList();
  }

  void removeItem() {}

  void updateItem() {}

  void loadItems() async {
    final result = await _api.lostAndFoundItems();
  }
}
