import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';

import '../components/menu_tile.dart';
import '../models/student.dart';
import '../models/faculty.dart';

import '../repositories/student_repository.dart';
import '../repositories/faculty_repository.dart';

final userProvider =
    StateNotifierProvider<UserProvider, UserState>((ref) => UserProvider(ref));

class UserState {
  final Student student;
  final Faculty faculty;
  final bool toggleSearch;
  final TextEditingController searchController;
  final List<MenuTile> menuTiles;

  UserState({
    required this.student,
    required this.faculty,
    required this.toggleSearch,
    required this.searchController,
    required this.menuTiles,
  });

  UserState copyWith({
    Student? student,
    Faculty? faculty,
    bool? toggleSearch,
    TextEditingController? searchController,
    List<MenuTile>? menuTiles,
  }) {
    return UserState(
        student: student ?? this.student,
        faculty: faculty ?? this.faculty,
        toggleSearch: toggleSearch ?? this.toggleSearch,
        searchController: searchController ?? this.searchController,
        menuTiles: menuTiles ?? this.menuTiles);
  }
}

class UserProvider extends StateNotifier<UserState> {
  final StudentRepository _studentApi;
  final FacultyRepository _facultyApi;

  UserProvider(Ref ref)
      : _studentApi = ref.read(studentRepositoryProvider),
        _facultyApi = ref.read(facultyRepositoryProvider),
        super(
          UserState(
            student: Student(
              id: '',
              name: '',
              email: '',
              rollNumber: '',
              about: '',
              profilePicURI: '',
              branch: '',
              graduationYear: null,
              skills: [],
              achievements: [],
              roles: [],
            ),
            faculty: Faculty(
              id: '',
              name: '',
              email: '',
              department: '',
              cabinNumber: '',
              courses: [],
            ),
            searchController: TextEditingController(),
            toggleSearch: false,
            menuTiles: [],
          ),
        );
  get searchController => state.searchController;

  get toggleSearch => state.toggleSearch;

  get menuTiles => state.menuTiles;

  final Logger _logger = Logger();

  Future<void> getStudent(String email) async {
    try {
      final student = await _studentApi.getStudent(email);
      state = state.copyWith(student: student);
    } catch (e) {
      Logger().e(e);
    }
  }

  Future<void> postStudent(String email) async {
    try {
      final newStudent = await _studentApi.addStudent(email);
      state = state.copyWith(student: newStudent);
    } catch (e) {
      Logger().e(e);
    }
  }

  Future<void> updateStudent(Student student) async {
    try {
      final updatedStudent = await _studentApi.updateStudent(student);
      state = state.copyWith(student: updatedStudent);
    } catch (e) {
      Logger().e(e);
    }
  }

  Future<void> getFaculty(String email) async {
    try {
      final faculty = await _facultyApi.getFaculty(email);
      state = state.copyWith(faculty: faculty);
    } catch (e) {
      Logger().e(e);
    }
  }

  Future<void> postFaculty(String email) async {
    try {
      final newFaculty = await _facultyApi.addFaculty(email);
      state = state.copyWith(faculty: newFaculty);
    } catch (e) {
      Logger().e(e);
    }
  }

  Future<void> updateFaculty(Faculty faculty) async {
    try {
      final updatedFaculty = await _facultyApi.updateFaculty(faculty);
      state = state.copyWith(faculty: updatedFaculty);
    } catch (e) {
      Logger().e(e);
    }
  }

  void buildMenuTiles(BuildContext context) {
    List<MenuTile> menuTiles = [
      MenuTile(
        title: "View\nStudents",
        onTap: () => context.push('/user_home/view_students'),
        icon: Icons.add,
        primaryColor: Colors.greenAccent.shade100,
        secondaryColor: Colors.greenAccent.shade200,
      ),
      MenuTile(
        title: "View\nCourses",
        onTap: () => context.push('/user_home/view_courses'),
        icon: Icons.add,
        primaryColor: Colors.lightBlueAccent.shade100,
        secondaryColor: Colors.lightBlueAccent.shade200,
      ),
      MenuTile(
        title: "View\nFaculty",
        onTap: () => context.push('/user_home/view_faculty'),
        icon: Icons.add,
        primaryColor: Colors.orangeAccent.shade100,
        secondaryColor: Colors.orangeAccent.shade200,
      ),
      MenuTile(
        title: "View\nMess\nMenu",
        onTap: () => context.push('/user_home/view_menu'),
        icon: Icons.add,
        primaryColor: Colors.blueAccent.shade100,
        secondaryColor: Colors.blueAccent.shade200,
      ),
      MenuTile(
        title: "View\nRooms",
        onTap: () => context.push('/user_home/manage_rooms'),
        icon: Icons.add,
        primaryColor: Colors.tealAccent.shade100,
        secondaryColor: Colors.tealAccent.shade200,
      ),
      MenuTile(
        title: 'Room\nVacancy',
        onTap: () => context.push('/user_home/classroom_vacancy'),
        icon: Icons.add,
        primaryColor: Colors.pinkAccent.shade100,
        secondaryColor: Colors.pinkAccent.shade200,
      ),
      MenuTile(
        title: "Lost\n&\nFound",
        onTap: () => context.push('/user_home/lost_and_found'),
        primaryColor: Colors.orangeAccent.shade100,
        secondaryColor: Colors.orangeAccent.shade200,
        icon: Icons.search,
      ),
    ];
    String query = state.searchController.text;
    state = state.copyWith(
        menuTiles: menuTiles
            .where((element) =>
                element.title.toLowerCase().contains(query.toLowerCase()))
            .toList());
  }

  void toggleSearchBar() {
    state = state.copyWith(toggleSearch: !state.toggleSearch);
  }
}
