import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
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

final timetableProvider = StateNotifierProvider<TimetableProvider, TimetableState>((ref) => TimetableProvider(ref));

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
      searchTimetableController: searchTimetableController ?? this.searchTimetableController,
      timetableNameController: timetableNameController ?? this.timetableNameController,
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

      final List<Timetable> timetables = await _api.getTimetablesByCreatorId(userId) ?? [];
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
          (index) => (const TimeOfDay(hour: 0, minute: 0), const TimeOfDay(hour: 0, minute: 0)),
        ),
        tilesDisabled: false,
      );
    }
  }
    state = state.copyWith(
      timetableList: [...state.timetableList, timetable],
      timetableNameController: TextEditingController(),
    );
  }

  void deleteTimetable(Timetable timetable) {
    state = state.copyWith(
      timetableList: state.timetableList.where((t) => t.id != timetable.id).toList(),
    );
  }
}
