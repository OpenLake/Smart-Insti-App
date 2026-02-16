import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import '../models/event.dart';
import '../repositories/event_repository.dart';
import '../repositories/student_db_repository.dart';
import 'auth_provider.dart';

final eventProvider = StateNotifierProvider<EventProvider, EventState>((ref) {
  return EventProvider(ref);
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

class EventProvider extends StateNotifier<EventState> {
  final Ref _ref;
  final EventRepository _repository;
  final StudentDbRepository _studentDbRepository;
  final Logger _logger = Logger();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController organizedByController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  EventProvider(this._ref)
      : _repository = _ref.read(eventRepositoryProvider),
        _studentDbRepository = _ref.read(studentDbRepositoryProvider), // Fixed ref -> _ref
        super(EventState());

  Future<void> loadEvents() async {
    state = state.copyWith(isLoading: true);
    try {
      final token = _ref.read(authProvider).token;
      if (token != null) {
        final events = await _repository.getEvents(token);
        
        // Fetch events from Student DB
        final externalEvents = await _studentDbRepository.getEvents();
        final mappedExternalEvents = externalEvents.map((e) => Event(
          id: e['_id'] ?? '',
          title: e['title'] ?? 'No Title',
          description: e['description'] ?? '',
          date: DateTime.tryParse(e['schedule']?['start_time'] ?? '') ?? DateTime.now(),
          location: e['venue'] ?? 'TBD',
          organizedBy: e['organizing_unit_id']?['name'] ?? 'Unknown',
          createdBy: 'External', 
        )).toList();

        state = state.copyWith(events: [...events, ...mappedExternalEvents], isLoading: false);
      } else {
        // Even if not logged in (Guest), fetch external events!
        final externalEvents = await _studentDbRepository.getEvents();
        final mappedExternalEvents = externalEvents.map((e) => Event(
          id: e['_id'] ?? '',
          title: e['title'] ?? 'No Title',
          description: e['description'] ?? '',
          date: DateTime.tryParse(e['schedule']?['start_time'] ?? '') ?? DateTime.now(),
          location: e['venue'] ?? 'TBD',
          organizedBy: e['organizing_unit_id']?['name'] ?? 'Unknown',
          createdBy: 'External', 
        )).toList();
        state = state.copyWith(events: mappedExternalEvents, isLoading: false);
      }
    } catch (e) {
      _logger.e(e);
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> addEvent() async {
    try {
      final token = _ref.read(authProvider).token;
      if (token != null) {
        final newEvent = Event(
          id: '', // Backward compatibility, backend generates ID
          title: titleController.text,
          description: descriptionController.text,
          date: selectedDate,
          location: locationController.text,
          organizedBy: organizedByController.text,
          createdBy: '', // Backward compatibility, backend handles this
        );
        final success = await _repository.addEvent(newEvent, token);
        if (success) {
          await loadEvents();
          clearControllers();
        }
      }
    } catch (e) {
      _logger.e(e);
    }
  }

  Future<void> deleteEvent(String id) async {
    try {
      final token = _ref.read(authProvider).token;
      if (token != null) {
        final success = await _repository.deleteEvent(id, token);
        if (success) {
          await loadEvents();
        }
      }
    } catch (e) {
      _logger.e(e);
    }
  }

  void updateDate(DateTime date) {
    selectedDate = date;
  }

  void clearControllers() {
    titleController.clear();
    descriptionController.clear();
    locationController.clear();
    organizedByController.clear();
    selectedDate = DateTime.now();
  }
}
