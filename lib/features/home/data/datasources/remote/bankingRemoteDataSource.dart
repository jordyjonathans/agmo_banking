import 'package:agmotest_banking/features/home/data/models/bankAccountModel.dart';
import 'package:agmotest_banking/features/home/data/models/transactionModel.dart';

abstract class BankingRemoteDataSource {
  Future<BankAccountModel> getBankAccountInfo();
  Future<List<TransactionModel>> getRecentTransactions();
}
