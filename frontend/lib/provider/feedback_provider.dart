import 'package:flutter/material.dart' hide Feedback;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/feedback.dart';
import '../repositories/feedback_repository.dart';
import 'auth_provider.dart';

final feedbackRepositoryProvider =
    Provider<FeedbackRepository>((ref) => FeedbackRepository());

final feedbackProvider =
    StateNotifierProvider<FeedbackNotifier, FeedbackState>((ref) {
  return FeedbackNotifier(ref);
});

class FeedbackState {
  final List<Feedback> feedbacks;
  final bool isLoading;
  final Map<String, dynamic>
      targets; // { users: [...], events: [...], organizational_units: [...], positions: [...] }
  final bool isLoadingTargets;

  FeedbackState({
    this.feedbacks = const [],
    this.isLoading = false,
    this.targets = const {},
    this.isLoadingTargets = false,
  });

  FeedbackState copyWith({
    List<Feedback>? feedbacks,
    bool? isLoading,
    Map<String, dynamic>? targets,
    bool? isLoadingTargets,
  }) {
    return FeedbackState(
      feedbacks: feedbacks ?? this.feedbacks,
      isLoading: isLoading ?? this.isLoading,
      targets: targets ?? this.targets,
      isLoadingTargets: isLoadingTargets ?? this.isLoadingTargets,
    );
  }

  /// Get target entities filtered by target type
  List<Map<String, dynamic>> getTargetsForType(String targetType) {
    switch (targetType) {
      case 'User':
        return (targets['users'] as List?)?.cast<Map<String, dynamic>>() ?? [];
      case 'Event':
        return (targets['events'] as List?)?.cast<Map<String, dynamic>>() ?? [];
      case 'Club/Organization':
        return (targets['organizational_units'] as List?)
                ?.cast<Map<String, dynamic>>() ??
            [];
      case 'POR':
        return (targets['positions'] as List?)?.cast<Map<String, dynamic>>() ??
            [];
      default:
        return [];
    }
  }

  /// Get display name for a target entity
  static String getTargetDisplayName(
      String targetType, Map<String, dynamic> target) {
    switch (targetType) {
      case 'User':
        return target['name'] ?? target['user_id'] ?? 'Unknown';
      case 'Event':
        return target['title'] ?? 'Unknown Event';
      case 'Club/Organization':
        return target['name'] ?? 'Unknown Org';
      case 'POR':
        final title = target['title'] ?? 'Unknown';
        final unit = target['unit'] ?? '';
        return unit.isNotEmpty ? '$title ($unit)' : title;
      default:
        return 'Unknown';
    }
  }
}

class FeedbackNotifier extends StateNotifier<FeedbackState> {
  final Ref _ref;
  final FeedbackRepository _repository;

  // Form Controllers
  final TextEditingController descriptionController = TextEditingController();

  // Form state
  String selectedType = 'Complaint';
  String selectedTargetType = 'User';
  String? selectedTargetId;
  double selectedRating = 3;
  bool isAnonymous = false;

  FeedbackNotifier(this._ref)
      : _repository = _ref.read(feedbackRepositoryProvider),
        super(FeedbackState(feedbacks: [], isLoading: false));

  void setType(String value) => selectedType = value;
  void setTargetType(String value) {
    selectedTargetType = value;
    selectedTargetId = null; // Reset target when type changes
  }

  void setTargetId(String? value) => selectedTargetId = value;
  void setRating(double value) => selectedRating = value;
  void setAnonymous(bool value) => isAnonymous = value;

  // Legacy compat
  final TextEditingController categoryController = TextEditingController();
  void setCategory(String value) => categoryController.text = value;

  Future<void> loadFeedbacks() async {
    state = state.copyWith(isLoading: true);
    final token = _ref.read(authProvider).token ?? '';

    final allFeedbacks = await _repository.getFeedbacks(token);

    // Sort by createdAt desc
    allFeedbacks.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    state = state.copyWith(feedbacks: allFeedbacks, isLoading: false);
  }

  Future<void> loadTargets() async {
    state = state.copyWith(isLoadingTargets: true);
    final token = _ref.read(authProvider).token ?? '';

    final targets = await _repository.getTargets(token);

    state = state.copyWith(targets: targets, isLoadingTargets: false);
  }

  Future<void> loadMyComplaints() async {
    // Legacy support
    await loadFeedbacks();
    final complaints =
        state.feedbacks.where((f) => f.type == 'Complaint').toList();
    state = state.copyWith(feedbacks: complaints);
  }

  void resetForm() {
    descriptionController.clear();
    selectedType = 'Complaint';
    selectedTargetType = 'User';
    selectedTargetId = null;
    selectedRating = 3;
    isAnonymous = false;
  }

  Future<bool> submitFeedback() async {
    final token = _ref.read(authProvider).token ?? '';
    final currentUser = _ref.read(authProvider).currentUser;
    final String userId =
        currentUser != null ? (currentUser as dynamic).id : '';

    if (selectedTargetId == null || selectedTargetId!.isEmpty) {
      return false;
    }

    final data = {
      'type': selectedType,
      'target_type': selectedTargetType,
      'target_id': selectedTargetId,
      'comments': descriptionController.text,
      'rating': selectedRating.toInt(),
      'is_anonymous': isAnonymous,
      'feedback_by': userId,
    };

    final success = await _repository.createFeedback(data, token);

    if (success) {
      resetForm();
      await loadFeedbacks();
    }

    return success;
  }

  // Legacy alias
  Future<bool> addComplaint() => submitFeedback();
}
