import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_bundle.dart';
import '../repositories/hub_repository.dart';
import 'auth_provider.dart';

final userBundleProvider = FutureProvider<UserBundle?>((ref) async {
  final authState = ref.watch(authProvider);
  final token = authState.token;

  if (token == null) {
    return null;
  }

  final repository = ref.read(hubRepositoryProvider);
  return await repository.getUserBundle(token);
});
