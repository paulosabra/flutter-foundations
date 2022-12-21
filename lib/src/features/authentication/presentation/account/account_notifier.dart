import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountNotifier extends StateNotifier<AsyncValue> {
  final FakeAuthRepository repository;

  AccountNotifier({required this.repository})
      : super(const AsyncValue.data(null));

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => repository.signOut());
  }
}

final accountNotifierProvider =
    StateNotifierProvider.autoDispose<AccountNotifier, AsyncValue>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AccountNotifier(repository: repository);
});
