import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_insti_app/theme/ultimate_theme.dart';
import 'package:smart_insti_app/components/borderless_button.dart';
import 'package:smart_insti_app/components/material_textformfield.dart';
import 'package:smart_insti_app/provider/auth_provider.dart';
import '../components/menu_tile.dart';
import '../components/timetable_button.dart';
import '../constants/constants.dart';
import '../models/admin.dart';
import '../models/faculty.dart';
import '../models/student.dart';
import '../models/timtable.dart';
import '../repositories/timetable_repository.dart';

final timetableProvider =
    StateNotifierProvider<TimetableProvider, TimetableState>(
        (ref) => TimetableProvider(ref));

class TimetableState {
  final List<Timetable> timetables;
  final TextEditingController searchTimetableController;
  final TextEditingController timetableNameController;
  final TextEditingController rowsController;
  final TextEditingController columnsController;
  final bool includeSaturday;
  final List<List<TextEditingController>> tileControllers;
  final List<(TimeOfDay, TimeOfDay)> timeRanges;
  final bool tilesDisabled;
  final LoadingState loadingState;

  TimetableState(
      {required this.timetables,
      required this.searchTimetableController,
      required this.timetableNameController,
      required this.rowsController,
      required this.columnsController,
      required this.includeSaturday,
      required this.tileControllers,
      required this.timeRanges,
      required this.tilesDisabled,
      required this.loadingState});

  TimetableState copyWith({
    List<Timetable>? timetables,
    List<MenuTile>? timetableTiles,
    TextEditingController? searchTimetableController,
    TextEditingController? timetableNameController,
    TextEditingController? rowsController,
    TextEditingController? columnsController,
    bool? includeSaturday,
    List<List<TextEditingController>>? tileControllers,
    List<(TimeOfDay, TimeOfDay)>? timeRanges,
    bool? tilesDisabled,
    LoadingState? loadingState,
  }) {
    return TimetableState(
      timetables: timetables ?? this.timetables,
      searchTimetableController:
          searchTimetableController ?? this.searchTimetableController,
      timetableNameController:
          timetableNameController ?? this.timetableNameController,
      rowsController: rowsController ?? this.rowsController,
      columnsController: columnsController ?? this.columnsController,
      includeSaturday: includeSaturday ?? this.includeSaturday,
      tileControllers: tileControllers ?? this.tileControllers,
      timeRanges: timeRanges ?? this.timeRanges,
      tilesDisabled: tilesDisabled ?? this.tilesDisabled,
      loadingState: loadingState ?? this.loadingState,
    );
  }
}

class TimetableProvider extends StateNotifier<TimetableState> {
  TimetableProvider(Ref ref)
      : _authState = ref.read(authProvider),
        _api = ref.read(timetableRepositoryProvider),
        super(
          TimetableState(
            timetables: [],
            searchTimetableController: TextEditingController(),
            timetableNameController: TextEditingController(),
            rowsController: TextEditingController(text: '6'),
            columnsController: TextEditingController(),
            includeSaturday: true,
            tileControllers: [],
            timeRanges: [],
            loadingState: LoadingState.progress,
            tilesDisabled: false,
          ),
        ) {
    loadTimetables();
  }

  final TimetableRepository _api;
  final AuthState _authState;
  final Logger _logger = Logger();

  void loadTimetables() async {
    state = state.copyWith(loadingState: LoadingState.progress);
    try {
      String userId;

      if (_authState.currentUserRole == 'student') {
        userId = (_authState.currentUser as Student).id;
      } else if (_authState.currentUserRole == 'faculty') {
        userId = (_authState.currentUser as Faculty).id;
      } else if (_authState.currentUserRole == 'admin') {
        userId = (_authState.currentUser as Admin).id;
      } else {
        return;
      }

      final List<Timetable> timetables =
          await _api.getTimetablesByCreatorId(userId) ?? [];
      state = state.copyWith(
        timetables: timetables,
        loadingState: LoadingState.success,
      );
    } catch (e) {
      _logger.e(e);
      state = state.copyWith(loadingState: LoadingState.error);
    }
  }

  initTileControllersAndTime({Timetable? timetable}) {
    if (timetable != null) {
      state.rowsController.text = timetable.rows.toString();
      state.columnsController.text = timetable.columns.toString();
      state = state.copyWith(
        //2d matrix of text controllers
        tileControllers: List.generate(
          timetable.columns,
          (i) => List.generate(
            timetable.rows,
            (j) => TextEditingController(),
          ),
        ),
        includeSaturday: timetable.rows == 6 ? true : false,
        timeRanges: timetable.timeRanges,
        tilesDisabled: true,
      );

      for (int i = 0; i < timetable.columns; i++) {
        for (int j = 0; j < timetable.rows; j++) {
          state.tileControllers[i][j].text = timetable.timetable[i][j];
        }
      }
    } else {
      state = state.copyWith(
        //2d matrix of text controllers
        tileControllers: List.generate(
          int.parse(state.columnsController.text),
          (i) => List.generate(
            int.parse(state.rowsController.text),
            (j) => TextEditingController(),
          ),
        ),
        timeRanges: List.generate(
          int.parse(state.columnsController.text),
          (index) => (
            const TimeOfDay(hour: 0, minute: 0),
            const TimeOfDay(hour: 0, minute: 0)
          ),
        ),
        tilesDisabled: false,
      );
    }
  }

  Widget buildTimetableTiles(BuildContext context) {
    final timeTable = Consumer(
      builder: (_, ref, __) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Days Column
          Column(
            children: [
              const TimetableButton(
                onPressed: null,
                isHeader: true,
                child: Icon(Icons.access_time_rounded, size: 20),
              ),
              TimetableButton(
                onPressed: null,
                isHeader: true,
                child: const Text('MON'),
              ),
              TimetableButton(
                onPressed: null,
                isHeader: true,
                child: const Text('TUE'),
              ),
              TimetableButton(
                onPressed: null,
                isHeader: true,
                child: const Text('WED'),
              ),
              TimetableButton(
                onPressed: null,
                isHeader: true,
                child: const Text('THU'),
              ),
              TimetableButton(
                onPressed: null,
                isHeader: true,
                child: const Text('FRI'),
              ),
              if (state.includeSaturday)
                TimetableButton(
                  onPressed: null,
                  isHeader: true,
                  child: const Text('SAT'),
                ),
            ],
          ),

          // Time Slots Columns
          for (int i = 0; i < int.parse(state.columnsController.text); i++)
            Column(
              children: [
                // Time Range Header Tile
                TimetableButton(
                  isHeader: true,
                  onPressed: ref.read(timetableProvider).tilesDisabled
                      ? null
                      : () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28)),
                              title: Text('Set Time Slot ${i + 1}',
                                  style: GoogleFonts.spaceGrotesk(
                                      fontWeight: FontWeight.bold)),
                              content: Consumer(
                                builder: (_, ref, __) => Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildTimePickerButton(
                                      context: context,
                                      label: "Start",
                                      time: ref
                                          .watch(timetableProvider)
                                          .timeRanges[i]
                                          .$1,
                                      onTimeSelected: (time) {
                                        state = state.copyWith(
                                          timeRanges: [
                                            ...state.timeRanges.sublist(0, i),
                                            (time, state.timeRanges[i].$2),
                                            ...state.timeRanges.sublist(i + 1),
                                          ],
                                        );
                                      },
                                    ),
                                    Icon(Icons.arrow_forward_rounded,
                                        color: UltimateTheme.textSub),
                                    _buildTimePickerButton(
                                      context: context,
                                      label: "End",
                                      time: ref
                                          .watch(timetableProvider)
                                          .timeRanges[i]
                                          .$2,
                                      onTimeSelected: (time) {
                                        state = state.copyWith(
                                          timeRanges: [
                                            ...state.timeRanges.sublist(0, i),
                                            (state.timeRanges[i].$1, time),
                                            ...state.timeRanges.sublist(i + 1),
                                          ],
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text("Done",
                                      style: GoogleFonts.inter(
                                          fontWeight: FontWeight.bold,
                                          color: UltimateTheme.primary)),
                                ),
                              ],
                            ),
                          );
                        },
                  child: AutoSizeText(
                    '${_formatTimeOfDay(ref.watch(timetableProvider).timeRanges[i].$1)} - ${_formatTimeOfDay(ref.watch(timetableProvider).timeRanges[i].$2)}',
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                        fontSize: 11, fontWeight: FontWeight.bold),
                    minFontSize: 9,
                  ),
                ),

                // Subject Tiles
                for (int j = 0; j < int.parse(state.rowsController.text); j++)
                  TimetableButton(
                    onPressed: ref.read(timetableProvider).tilesDisabled
                        ? null
                        : () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(28)),
                                title: Text('Edit Subject',
                                    style: GoogleFonts.spaceGrotesk(
                                        fontWeight: FontWeight.bold)),
                                content: Container(
                                  width: 300,
                                  child: MaterialTextFormField(
                                    controller: state.tileControllers[i][j],
                                    hintText: 'e.g. CS301 / Lab',
                                    prefixIcon: const Icon(Icons.book_outlined),
                                    autofocus: true,
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      state = state.copyWith(); // Force rebuild
                                      Navigator.pop(context);
                                    },
                                    child: Text("Save",
                                        style: GoogleFonts.inter(
                                            fontWeight: FontWeight.bold,
                                            color: UltimateTheme.primary)),
                                  ),
                                ],
                              ),
                            );
                          },
                    child: AutoSizeText(
                      state.tileControllers[i][j].text.isEmpty
                          ? '+'
                          : state.tileControllers[i][j].text,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      minFontSize: 10,
                      style: GoogleFonts.inter(
                        color: state.tileControllers[i][j].text.isEmpty
                            ? UltimateTheme.textSub.withValues(alpha: 0.3)
                            : UltimateTheme.textMain,
                        fontWeight: state.tileControllers[i][j].text.isEmpty
                            ? FontWeight.normal
                            : FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );

    return FittedBox(
      fit: BoxFit.contain,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: timeTable,
      ),
    );
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour =
        time.hour == 0 ? 12 : (time.hour > 12 ? time.hour - 12 : time.hour);
    final period = time.hour >= 12 ? "PM" : "AM";
    return "$hour:${time.minute.toString().padLeft(2, '0')} $period";
  }

  Widget _buildTimePickerButton({
    required BuildContext context,
    required String label,
    required TimeOfDay time,
    required Function(TimeOfDay) onTimeSelected,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label,
                style: GoogleFonts.inter(
                    fontSize: 12,
                    color: UltimateTheme.textSub,
                    fontWeight: FontWeight.w500)),
          ],
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final picked =
                await showTimePicker(context: context, initialTime: time);
            if (picked != null) onTimeSelected(picked);
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: UltimateTheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: UltimateTheme.primary.withValues(alpha: 0.2)),
            ),
            child: Text(
              _formatTimeOfDay(time),
              style: GoogleFonts.spaceGrotesk(
                  fontWeight: FontWeight.bold, color: UltimateTheme.primary),
            ),
          ),
        ),
      ],
    );
  }

  void toggleIncludeSaturday() {
    state.rowsController.text = state.includeSaturday ? '5' : '6';
    state = state.copyWith(includeSaturday: !state.includeSaturday);
  }

  Future<void> addTimetable() async {
    String userId;

    if (_authState.currentUserRole == 'student') {
      userId = (_authState.currentUser as Student).id;
    } else if (_authState.currentUserRole == 'faculty') {
      userId = (_authState.currentUser as Faculty).id;
    } else {
      userId = (_authState.currentUser as Admin).id;
    }

    final Timetable timetable = Timetable(
      creatorId: userId,
      name: state.timetableNameController.text,
      rows: int.parse(state.rowsController.text),
      columns: int.parse(state.columnsController.text),
      timeRanges: state.timeRanges,
      timetable: List.generate(
        int.parse(state.columnsController.text),
        (i) => List.generate(
          int.parse(state.rowsController.text),
          (j) => state.tileControllers[i][j].text,
        ),
      ),
    );
    if (await _api.createTimetable(timetable)) {
      loadTimetables();
    }
  }

  Future<void> deleteTimetable(Timetable timetable) async {
    if (await _api.deleteTimetableById(timetable.id!)) {
      loadTimetables();
    }
  }

  void clearControllers() {
    state = state.copyWith(
      timetableNameController: TextEditingController(),
      rowsController: TextEditingController(text: '6'),
      columnsController: TextEditingController(),
      tileControllers: [],
      timeRanges: [],
      includeSaturday: true,
    );
  }
}
