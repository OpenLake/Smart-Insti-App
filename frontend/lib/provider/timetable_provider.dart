import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import '../components/menu_tile.dart';
import '../constants/constants.dart';
import '../models/timtable.dart';
import '../repositories/timetable_repository.dart';

final timetableProvider = StateNotifierProvider<TimetableProvider, TimetableState>((ref) => TimetableProvider(ref));

class TimetableState {
  final List<Timetable> timetableList;
  final List<MenuTile> timetableTiles;
  final TextEditingController searchTimetableController;
  final TextEditingController timetableNameController;
  final TextEditingController columnsController;
  final LoadingState loadingState;

  TimetableState(
      {required this.timetableList,
      required this.timetableTiles,
      required this.searchTimetableController,
      required this.timetableNameController,
      required this.columnsController,
      required this.loadingState});

  TimetableState copyWith({
    List<Timetable>? timetableList,
    List<MenuTile>? timetableTiles,
    TextEditingController? searchTimetableController,
    TextEditingController? timetableNameController,
    TextEditingController? columnsController,
    LoadingState? loadingState,
  }) {
    return TimetableState(
      timetableList: timetableList ?? this.timetableList,
      timetableTiles: timetableTiles ?? this.timetableTiles,
      searchTimetableController: searchTimetableController ?? this.searchTimetableController,
      timetableNameController: timetableNameController ?? this.timetableNameController,
      columnsController: columnsController ?? this.columnsController,
      loadingState: loadingState ?? this.loadingState,
    );
  }
}

class TimetableProvider extends StateNotifier<TimetableState> {
  TimetableProvider(Ref ref)
      : _api = ref.read(timetableRepositoryProvider),
        super(
          TimetableState(
            timetableList: [],
            timetableTiles: [],
            searchTimetableController: TextEditingController(),
            timetableNameController: TextEditingController(),
            columnsController: TextEditingController(),
            loadingState: LoadingState.progress,
          ),
        ) {
    // loadTimetables();
  }

  final TimetableRepository _api;
  final Logger _logger = Logger();

  void loadTimetables() async {
    try {
      final List<Timetable> timetables = await _api.getTimetables('');
      state = state.copyWith(
        timetableList: timetables,
        loadingState: LoadingState.success,
      );
    } catch (e) {
      _logger.e(e);
      state = state.copyWith(loadingState: LoadingState.error);
    }
  }

  void addTimetable() {
    final Timetable timetable =
        Timetable(id: '1', name: state.timetableNameController.text, rows: 5, columns: 5, timetable: []);
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
