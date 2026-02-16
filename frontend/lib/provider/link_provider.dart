import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import '../models/link.dart';
import '../repositories/link_repository.dart';
import 'auth_provider.dart';

final linkProvider = StateNotifierProvider<LinkProvider, LinkState>((ref) {
  return LinkProvider(ref);
});

class LinkState {
  final List<Link> links;
  final bool isLoading;

  LinkState({
    this.links = const [],
    this.isLoading = false,
  });

  LinkState copyWith({
    List<Link>? links,
    bool? isLoading,
  }) {
    return LinkState(
      links: links ?? this.links,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class LinkProvider extends StateNotifier<LinkState> {
  final Ref _ref;
  final LinkRepository _repository;
  final Logger _logger = Logger();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController urlController = TextEditingController();
  String selectedCategory = "Other";

  LinkProvider(this._ref)
      : _repository = _ref.read(linkRepositoryProvider),
        super(LinkState());

  Future<void> loadLinks() async {
    state = state.copyWith(isLoading: true);
    try {
      final token = _ref.read(authProvider).token ?? "";
      final links = await _repository.getLinks(token);
      state = state.copyWith(links: links, isLoading: false);
    } catch (e) {
      _logger.e(e);
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> addLink() async {
    try {
      final token = _ref.read(authProvider).token;
      if (token != null) {
        final newLink = Link(
          id: '',
          title: titleController.text,
          url: urlController.text,
          category: selectedCategory,
        );
        final success = await _repository.addLink(newLink, token);
        if (success) {
          await loadLinks();
          clearControllers();
        }
      }
    } catch (e) {
      _logger.e(e);
    }
  }

  Future<void> deleteLink(String id) async {
    try {
      final token = _ref.read(authProvider).token;
      if (token != null) {
        final success = await _repository.deleteLink(id, token);
        if (success) {
          await loadLinks();
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
    urlController.clear();
    selectedCategory = "Other";
  }
}
