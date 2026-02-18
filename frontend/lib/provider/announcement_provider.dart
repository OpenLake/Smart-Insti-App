import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import '../models/announcement.dart';
import '../repositories/announcement_repository.dart';
import 'auth_provider.dart';

final announcementProvider = StateNotifierProvider<AnnouncementNotifier, AnnouncementState>((ref) {
  return AnnouncementNotifier(ref);
});

class AnnouncementState {
  final List<Announcement> announcements;
  final bool isLoading;
  final String selectedType;

  AnnouncementState({
    this.announcements = const [],
    this.isLoading = false,
    this.selectedType = 'All',
  });

  AnnouncementState copyWith({
    List<Announcement>? announcements,
    bool? isLoading,
    String? selectedType,
  }) {
    return AnnouncementState(
      announcements: announcements ?? this.announcements,
      isLoading: isLoading ?? this.isLoading,
      selectedType: selectedType ?? this.selectedType,
    );
  }
}

class AnnouncementNotifier extends StateNotifier<AnnouncementState> {
  final Ref _ref;
  final AnnouncementRepository _repository;
  final Logger _logger = Logger();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  String newAnnouncementType = 'General';

  AnnouncementNotifier(this._ref)
      : _repository = _ref.read(announcementRepositoryProvider),
        super(AnnouncementState());

  Future<void> loadAnnouncements() async {
    state = state.copyWith(isLoading: true);
    try {
      final token = _ref.read(authProvider).token;
      if (token != null) {
        final announcements = await _repository.getAnnouncements(token, type: state.selectedType == 'All' ? null : state.selectedType);
        state = state.copyWith(announcements: announcements, isLoading: false);
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      _logger.e(e);
      state = state.copyWith(isLoading: false);
    }
  }

  void updateFilter(String type) {
    state = state.copyWith(selectedType: type);
    loadAnnouncements();
  }

  Future<void> addAnnouncement() async {
    try {
      final token = _ref.read(authProvider).token;
      final currentUser = _ref.read(authProvider).currentUser;
      if (token != null && currentUser != null) {
        // Create basic announcement object
        // Note: ID, Author, CreatedAt will be handled/ignored by backend on create usually, 
        // but we need them for the object here. 
        // Better to let backend return the object or just reload.
        final newAnnouncement = Announcement(
          id: '',
          title: titleController.text,
          content: contentController.text,
          author: {}, // Backend will set
          type: newAnnouncementType,
          createdAt: DateTime.now(),
        );

        final success = await _repository.createAnnouncement(newAnnouncement, token);
        if (success) {
          await loadAnnouncements();
          clearControllers();
        }
      }
    } catch (e) {
      _logger.e(e);
    }
  }

  void clearControllers() {
    titleController.clear();
    contentController.clear();
    newAnnouncementType = 'General';
  }
}
