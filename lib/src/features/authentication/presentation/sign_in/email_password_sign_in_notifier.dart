import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmailPasswordSignInNotifier
    extends StateNotifier<EmailPasswordSignInState> {
  final FakeAuthRepository repository;

  EmailPasswordSignInNotifier({
    required EmailPasswordSignInFormType formType,
    required this.repository,
  }) : super(EmailPasswordSignInState(formType: formType));

  Future<bool> submit(String email, String password) async {
    state = state.copyWith(value: const AsyncValue.loading());
    final value = await AsyncValue.guard(() => _authenticate(email, password));
    state = state.copyWith(value: value);
    return value.hasError == false;
  }

  Future<void> _authenticate(String email, String password) {
    switch (state.formType) {
      case EmailPasswordSignInFormType.signIn:
        return repository.signInWithEmailAndPassword(email, password);
      case EmailPasswordSignInFormType.register:
        return repository.createUserWithEmailAndPassword(email, password);
    }
  }

  void updateFormType(EmailPasswordSignInFormType formType) {
    state = state.copyWith(formType: formType);
  }
}

final emailPasswordSignInNotifierProvider = StateNotifierProvider.autoDispose
    .family<EmailPasswordSignInNotifier, EmailPasswordSignInState,
        EmailPasswordSignInFormType>((ref, formType) {
  final repository = ref.watch(authRepositoryProvider);
  return EmailPasswordSignInNotifier(
    formType: formType,
    repository: repository,
  );
});
