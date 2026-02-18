import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/event.dart';
import '../repositories/event_repository.dart';
import 'auth_provider.dart';

final eventProvider = StateNotifierProvider<EventNotifier, EventState>((ref) {
  return EventNotifier(ref);
});

class EventState {
  final List<Event> events;
  final bool isLoading;

  EventState({
    this.events = const [],
    this.isLoading = false,
  });

  EventState copyWith({
    List<Event>? events,
    bool? isLoading,
  }) {
    return EventState(
      events: events ?? this.events,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class EventNotifier extends StateNotifier<EventState> {
  final Ref _ref;
  final EventRepository _repository;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController organizedByController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  EventNotifier(this._ref)
      : _repository = _ref.read(eventRepositoryProvider),
        super(EventState());

  void updateDate(DateTime date) {
    selectedDate = date;
  }

  Future<void> addEvent() async {
    final data = {
      'title': titleController.text,
      'description': descriptionController.text,
      'location': locationController.text,
      'organizedBy': organizedByController.text,
      'date': selectedDate.toIso8601String(),
    };
    await createEvent(data);
    
    // Clear
    titleController.clear();
    descriptionController.clear();
    locationController.clear();
    organizedByController.clear();
  }

  Future<void> loadEvents() async {
    state = state.copyWith(isLoading: true);
    final token = _ref.read(authProvider).token;
    if (token != null) {
      final events = await _repository.getEvents(token);
      state = state.copyWith(events: events, isLoading: false);
    } else {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<bool> createEvent(Map<String, dynamic> data) async {
      final token = _ref.read(authProvider).token;
      if (token != null) {
          final success = await _repository.createEvent(data, token);
          if (success) {
              loadEvents();
              return true;
          }
      }
      return false;
  }
  
  Future<void> deleteEvent(String id) async {
      final token = _ref.read(authProvider).token;
      if (token != null) {
          await _repository.deleteEvent(id, token);
          loadEvents();
      }
  }
}
