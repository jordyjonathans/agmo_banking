import 'package:agmotest_banking/features/home/domain/entities/transaction.dart';
import 'package:agmotest_banking/features/home/domain/repositories/bankingRepository.dart';

class GetRecentTransactionsUseCase {
  final BankingRepository repository;

  GetRecentTransactionsUseCase(this.repository);

  Future<List<Transaction>> call() {
    return repository.getRecentTransactions();
  }
}
