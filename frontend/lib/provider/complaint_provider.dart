import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import '../models/complaint.dart';
import '../repositories/complaint_repository.dart';
import 'auth_provider.dart';

final complaintProvider = StateNotifierProvider<ComplaintProvider, ComplaintState>((ref) {
  return ComplaintProvider(ref);
});

class ComplaintState {
  final List<Complaint> complaints;
  final bool isLoading;

  ComplaintState({
    this.complaints = const [],
    this.isLoading = false,
  });

  ComplaintState copyWith({
    List<Complaint>? complaints,
    bool? isLoading,
  }) {
    return ComplaintState(
      complaints: complaints ?? this.complaints,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class ComplaintProvider extends StateNotifier<ComplaintState> {
  final Ref _ref;
  final ComplaintRepository _repository;
  final Logger _logger = Logger();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String selectedCategory = "Other";

  ComplaintProvider(this._ref)
      : _repository = _ref.read(complaintRepositoryProvider),
        super(ComplaintState());

  Future<void> loadComplaints() async {
    state = state.copyWith(isLoading: true);
    try {
      final token = _ref.read(authProvider).token;
      if (token != null) {
        final complaints = await _repository.getComplaints(token);
        // Sort by status? Or just let backend sort.
        state = state.copyWith(complaints: complaints, isLoading: false);
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      _logger.e(e);
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> addComplaint() async {
    try {
      final token = _ref.read(authProvider).token;
      if (token != null) {
        final newComplaint = Complaint(
          id: '',
          title: titleController.text,
          description: descriptionController.text,
          category: selectedCategory,
          status: 'Pending',
          createdBy: '',
          upvotes: [],
          createdAt: DateTime.now(),
        );
        final success = await _repository.addComplaint(newComplaint, token);
        if (success) {
          await loadComplaints();
          clearControllers();
        }
      }
    } catch (e) {
      _logger.e(e);
    }
  }

  Future<void> upvoteComplaint(String id) async {
    try {
      final token = _ref.read(authProvider).token;
      if (token != null) {
        final success = await _repository.upvoteComplaint(id, token);
        if (success) {
          await loadComplaints();
        }
      }
    } catch (e) {
      _logger.e(e);
    }
  }

  void updateCategory(String category) {
    selectedCategory = category;
  }

  void clearControllers() {
    titleController.clear();
    descriptionController.clear();
    selectedCategory = "Other";
  }
}
