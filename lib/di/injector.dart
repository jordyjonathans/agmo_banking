import 'package:agmotest_banking/features/auth/data/datasources/local/authLocalDataSource.dart';
import 'package:agmotest_banking/features/auth/data/datasources/local/authLocalDataSourceImpl.dart';
import 'package:agmotest_banking/features/auth/data/datasources/remote/authRemoteDataSource.dart';
import 'package:agmotest_banking/features/auth/data/datasources/remote/authRemoteDataSourceImpl.dart';
import 'package:agmotest_banking/features/auth/data/repositories/authRepositoryImpl.dart';
import 'package:agmotest_banking/features/auth/domain/repositories/authRepository.dart';
import 'package:agmotest_banking/features/auth/domain/useCases/getCacheTokenUseCase.dart';
import 'package:agmotest_banking/features/auth/domain/useCases/loginUseCase.dart';
import 'package:agmotest_banking/features/auth/domain/useCases/logoutUseCase.dart';
import 'package:agmotest_banking/features/auth/presentation/providers/notifier/authNotifier.dart';
import 'package:agmotest_banking/features/auth/presentation/providers/state/authState.dart';
import 'package:agmotest_banking/features/home/data/datasources/remote/bankingRemoteDataSource.dart';
import 'package:agmotest_banking/features/home/data/datasources/remote/bankingRemoteDataSourceImpl.dart';
import 'package:agmotest_banking/features/home/data/repositories/bankingRepositoryImpl.dart';
import 'package:agmotest_banking/features/home/domain/repositories/bankingRepository.dart';
import 'package:agmotest_banking/features/home/domain/useCases/getBankAccountInfoUseCase.dart';
import 'package:agmotest_banking/features/home/domain/useCases/getRecentTransactions.dart';
import 'package:agmotest_banking/features/home/presentation/providers/notifier/bankingNotifier.dart';
import 'package:agmotest_banking/features/home/presentation/providers/state/bankingState.dart';
import 'package:agmotest_banking/shared/providers/notifier/sessionNotifier.dart';
import 'package:agmotest_banking/shared/providers/state/sessionState.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final injector = GetIt.instance;

void provideDataSources() {
  // Login
  injector.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(),
  );
  injector.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(
      sharedPreferences: injector<SharedPreferences>(),
    ),
  );

  // Home
  injector.registerLazySingleton<BankingRemoteDataSource>(
    () => BankingRemoteDataSourceImpl(),
  );
}

void provideRepositories() {
  // Login
  injector.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: injector<AuthRemoteDataSource>(),
      localDataSource: injector<AuthLocalDataSource>(),
    ),
  );

  // Home
  injector.registerLazySingleton<BankingRepository>(
    () => BankingRepositoryImpl(
      remoteDataSource: injector<BankingRemoteDataSource>(),
    ),
  );
}

void provideUseCases() {
  //Login
  injector.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(injector<AuthRepository>()),
  );
  injector.registerLazySingleton<LogoutUseCase>(
    () => LogoutUseCase(injector<AuthRepository>()),
  );
  injector.registerLazySingleton<GetCachedUserUseCase>(
    () => GetCachedUserUseCase(injector<AuthRepository>()),
  );

  // Home
  injector.registerLazySingleton<GetBankAccountInfoUseCase>(
    () => GetBankAccountInfoUseCase(injector<BankingRepository>()),
  );
  injector.registerLazySingleton<GetRecentTransactionsUseCase>(
    () => GetRecentTransactionsUseCase(injector<BankingRepository>()),
  );
}

Future<void> setupInjector() async {
  injector.registerSingletonAsync<SharedPreferences>(
    () => SharedPreferences.getInstance(),
  );

  await injector.isReady<SharedPreferences>();

  provideDataSources();
  provideRepositories();
  provideUseCases();
}

final authStateNotifier = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    injector<LoginUseCase>(),
    injector<LogoutUseCase>(),
    injector<GetCachedUserUseCase>(),
  );
});

final bankingStateNotifier =
    StateNotifierProvider<BankingNotifier, BankingState>((ref) {
      return BankingNotifier(
        injector<GetBankAccountInfoUseCase>(),
        injector<GetRecentTransactionsUseCase>(),
      );
    });

final sessionStateNotifier =
    StateNotifierProvider<SessionNotifier, SessionState>((ref) {
      final authViewModel = ref.watch(authStateNotifier.notifier);
      final manager = SessionNotifier(authViewModel);

      ref.listen<AuthState>(authStateNotifier, (previous, current) {
        if (current.status == AuthStatus.success &&
            previous?.status != AuthStatus.success) {
          manager.startMonitoring();
        } else if (current.status == AuthStatus.loggedOut &&
            previous?.status != AuthStatus.loggedOut) {
          manager.dispose();
        }
      });

      return manager;
    });
