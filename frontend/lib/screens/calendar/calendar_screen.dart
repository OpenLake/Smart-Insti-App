import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_insti_app/theme/ultimate_theme.dart';
import 'package:smart_insti_app/provider/event_provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../models/event.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(eventProvider.notifier).loadEvents();
    });
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    final state = ref.read(eventProvider);
    return state.events.where((event) {
        return isSameDay(event.startTime, day);
    }).toList();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(eventProvider);

    // Update selected events when state changes (e.g. initial load)
    if (!state.isLoading) {
        // This might cause loop if not careful, but ValueNotifier handles equality check? 
        // Better to update _selectedEvents.value only if we are building.
        // Actually, just calling _getEventsForDay inside ValueListenableBuilder is safer if we passed list directly
        // But table_calendar expects a loader. 
        // Let's just update the notifier value here if the day matches.
        final eventsForDay = _getEventsForDay(_selectedDay!);
        if (eventsForDay.length != _selectedEvents.value.length) { // Basic check
            WidgetsBinding.instance.addPostFrameCallback((_) {
                 _selectedEvents.value = eventsForDay;
            });
        }
    }

    return Scaffold(
      backgroundColor: UltimateTheme.backgroundColor,
      appBar: AppBar(
        title: Text("Academic Calendar", style: GoogleFonts.outfit(color: UltimateTheme.textColor, fontWeight: FontWeight.bold)),
        backgroundColor: UltimateTheme.surfaceColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: UltimateTheme.textColor),
      ),
      body: Column(
        children: [
          TableCalendar<Event>(
            firstDay: DateTime.utc(2024, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            calendarFormat: _calendarFormat,
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
              markerDecoration: const BoxDecoration(color: UltimateTheme.primaryColor, shape: BoxShape.circle),
              selectedDecoration: const BoxDecoration(color: UltimateTheme.primaryColor, shape: BoxShape.circle),
              todayDecoration: BoxDecoration(color: UltimateTheme.primaryColor.withOpacity(0.5), shape: BoxShape.circle),
            ),
            onDaySelected: _onDaySelected,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ValueListenableBuilder<List<Event>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                if (state.isLoading) return const Center(child: CircularProgressIndicator());
                if (value.isEmpty) return Center(child: Text("No events for this day", style: GoogleFonts.outfit(color: Colors.grey)));

                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    final event = value[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.withOpacity(0.2)),
                        borderRadius: BorderRadius.circular(12.0),
                        color: Colors.white
                      ),
                      child: ListTile(
                        leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: _getEventTypeColor(event.type).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8)
                            ),
                            child: Icon(Icons.event, color: _getEventTypeColor(event.type)),
                        ),
                        title: Text(event.title, style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                if (event.description.isNotEmpty) Text(event.description, maxLines: 1, overflow: TextOverflow.ellipsis),
                                Text("${_formatTime(event.startTime)} - ${_formatTime(event.endTime)}", style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey)),
                                if (event.location.isNotEmpty) 
                                    Row(children: [
                                        const Icon(Icons.location_on, size: 12, color: Colors.grey),
                                        Text(event.location, style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey))
                                    ])
                            ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _getEventTypeColor(String type) {
      switch (type) {
          case 'Academic': return Colors.blue;
          case 'Exam': return Colors.red;
          case 'Holiday': return Colors.green;
          case 'Club': return Colors.purple;
          case 'Sports': return Colors.orange;
          default: return Colors.grey;
      }
  }

  String _formatTime(DateTime date) {
      return "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }
}
