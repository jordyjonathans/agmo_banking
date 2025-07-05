import 'package:agmotest_banking/features/home/domain/useCases/getBankAccountInfoUseCase.dart';
import 'package:agmotest_banking/features/home/domain/useCases/getRecentTransactions.dart';
import 'package:agmotest_banking/features/home/presentation/providers/state/bankingState.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BankingNotifier extends StateNotifier<BankingState> {
  final GetBankAccountInfoUseCase _getBankAccountInfoUseCase;
  final GetRecentTransactionsUseCase _getRecentTransactionsUseCase;

  BankingNotifier(
    this._getBankAccountInfoUseCase,
    this._getRecentTransactionsUseCase,
  ) : super(BankingState()) {
    loadBankingData();
  }

  Future<void> loadBankingData() async {
    state = state.copyWith(status: BankingStatus.loading, errorMessage: null);
    try {
      final account = await _getBankAccountInfoUseCase();
      final transactions = await _getRecentTransactionsUseCase();

      state = state.copyWith(
        status: BankingStatus.loaded,
        bankAccount: account,
        transactions: transactions,
      );
    } catch (e) {
      state = state.copyWith(
        status: BankingStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  void clearErrorMessage() {
    state = state.copyWith(errorMessage: null);
  }
}
