import 'package:agmotest_banking/features/home/domain/entities/bankAccount.dart';
import 'package:agmotest_banking/features/home/domain/entities/transaction.dart';

abstract class BankingRepository {
  Future<BankAccount> getBankAccountInfo();
  Future<List<Transaction>> getRecentTransactions();
}
