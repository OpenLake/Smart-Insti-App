import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import '../models/resource.dart';
import '../repositories/resource_repository.dart';
import 'auth_provider.dart';

final resourceProvider = StateNotifierProvider<ResourceNotifier, ResourceState>((ref) {
  return ResourceNotifier(ref);
});

class ResourceState {
  final List<Resource> resources;
  final bool isLoading;
  final String? selectedDepartment;
  final int? selectedSemester;
  final String? selectedSubject;

  ResourceState({
    this.resources = const [],
    this.isLoading = false,
    this.selectedDepartment,
    this.selectedSemester,
    this.selectedSubject,
  });

  ResourceState copyWith({
    List<Resource>? resources,
    bool? isLoading,
    String? selectedDepartment,
    int? selectedSemester,
    String? selectedSubject,
  }) {
    return ResourceState(
      resources: resources ?? this.resources,
      isLoading: isLoading ?? this.isLoading,
      selectedDepartment: selectedDepartment ?? this.selectedDepartment,
      selectedSemester: selectedSemester ?? this.selectedSemester,
      selectedSubject: selectedSubject ?? this.selectedSubject,
    );
  }
}

class ResourceNotifier extends StateNotifier<ResourceState> {
  final Ref _ref;
  final ResourceRepository _repository;
  final Logger _logger = Logger();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  String selectedType = 'Notes';
  int selectedSemester = 1;
  String selectedDepartment = 'CSE';
  
  File? pickedFile;

  ResourceNotifier(this._ref)
      : _repository = _ref.read(resourceRepositoryProvider),
        super(ResourceState());

  Future<void> loadResources() async {
    state = state.copyWith(isLoading: true);
    try {
      final token = _ref.read(authProvider).token;
      if (token != null) {
        final resources = await _repository.getResources(
          token, 
          department: state.selectedDepartment,
          semester: state.selectedSemester,
          subject: state.selectedSubject
        );
        state = state.copyWith(resources: resources, isLoading: false);
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      _logger.e(e);
      state = state.copyWith(isLoading: false);
    }
  }

  void selectFolder(String department, int semester, String? subject) {
    state = ResourceState(
        selectedDepartment: department,
        selectedSemester: semester,
        selectedSubject: subject,
        isLoading: true
    );
    loadResources();
  }

  void clearSelection() {
    state = ResourceState();
  }

  Future<bool> uploadResource() async {
    try {
      final token = _ref.read(authProvider).token;
      if (token != null && pickedFile != null) {
        final data = {
            'title': titleController.text,
            'description': descriptionController.text,
            'subject': subjectController.text,
            'semester': selectedSemester.toString(),
            'department': selectedDepartment,
            'type': selectedType,
        };

        final success = await _repository.uploadResource(token, pickedFile!, data);
        if (success) {
          clearUploadForm();
          loadResources(); // Reload current view
          return true;
        }
      }
      return false;
    } catch (e) {
      _logger.e(e);
      return false;
    }
  }

  void clearUploadForm() {
    titleController.clear();
    descriptionController.clear();
    subjectController.clear();
    pickedFile = null;
    selectedType = 'Notes';
    selectedSemester = 1;
    selectedDepartment = 'CSE';
  }
  
  void setPickedFile(File file) {
      pickedFile = file;
  }
}
