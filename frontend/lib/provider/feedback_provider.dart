import 'package:flutter/material.dart' hide Feedback;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/feedback.dart';
import '../repositories/feedback_repository.dart';
import 'auth_provider.dart';

final feedbackRepositoryProvider = Provider<FeedbackRepository>((ref) => FeedbackRepository());

final feedbackProvider = StateNotifierProvider<FeedbackNotifier, FeedbackState>((ref) {
  return FeedbackNotifier(ref);
});

class FeedbackState {
  final List<Feedback> feedbacks;
  final bool isLoading;

  FeedbackState({
    this.feedbacks = const [],
    this.isLoading = false,
  });

  FeedbackState copyWith({
    List<Feedback>? feedbacks,
    bool? isLoading,
  }) {
    return FeedbackState(
      feedbacks: feedbacks ?? this.feedbacks,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class FeedbackNotifier extends StateNotifier<FeedbackState> {
  final Ref _ref;
  final FeedbackRepository _repository;
  
  // Form Controllers
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController categoryController = TextEditingController(); // Stores target_type
  bool isAnonymous = false;

  FeedbackNotifier(this._ref)
      : _repository = _ref.read(feedbackRepositoryProvider),
        super(FeedbackState(feedbacks: [], isLoading: false));

  void setAnonymous(bool value) {
    isAnonymous = value;
  }

  void setCategory(String value) {
    categoryController.text = value;
  }

  Future<void> loadMyComplaints() async {
    state = state.copyWith(isLoading: true);
    final token = _ref.read(authProvider).token ?? '';
    final user = _ref.read(authProvider).currentUser;
    // If backend doesn't support filtering by type/user in GET, we filter locally.
    // Assuming GET /feedback returns all or user specific. 
    // CoSA usually filters by user if not admin.
    
    final allFeedbacks = await _repository.getFeedbacks(token);
    
    // Filter for 'Complaint' type
    final complaints = allFeedbacks.where((f) => f.type == 'Complaint').toList();
    
    // Sort by createdAt desc
    complaints.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    
    state = state.copyWith(feedbacks: complaints, isLoading: false);
  }

  Future<bool> addComplaint() async {
    final token = _ref.read(authProvider).token ?? '';
    final userId = _ref.read(authProvider).currentUser != null 
        ? (_ref.read(authProvider).currentUser as dynamic).id 
        : ''; // Dynamic cast to access ID effectively

    final data = {
      'type': 'Complaint',
      'target_type': categoryController.text.isNotEmpty ? categoryController.text : 'General',
      'comments': descriptionController.text,
      'rating': 1, // Default for complaint
      'is_anonymous': isAnonymous,
      'feedback_by': userId,
    };

    final success = await _repository.createFeedback(data, token);
    
    if (success) {
      // Clear form
      descriptionController.clear();
      categoryController.clear();
      isAnonymous = false;
      
      // Reload
      await loadMyComplaints();
    }
    
    return success;
  }
}
