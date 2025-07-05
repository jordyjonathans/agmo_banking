import 'package:agmotest_banking/features/home/domain/entities/bankAccount.dart';
import 'package:agmotest_banking/features/home/domain/entities/transaction.dart';

enum BankingStatus { initial, loading, loaded, error }

class BankingState {
  final BankingStatus status;
  final BankAccount? bankAccount;
  final List<Transaction> transactions;
  final String? errorMessage;

  BankingState({
    this.status = BankingStatus.initial,
    this.bankAccount,
    this.transactions = const [],
    this.errorMessage,
  });

  BankingState copyWith({
    BankingStatus? status,
    BankAccount? bankAccount,
    List<Transaction>? transactions,
    String? errorMessage,
  }) {
    return BankingState(
      status: status ?? this.status,
      bankAccount: bankAccount ?? this.bankAccount,
      transactions: transactions ?? this.transactions,
      errorMessage: errorMessage,
    );
  }
}
