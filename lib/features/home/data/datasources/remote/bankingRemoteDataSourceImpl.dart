import 'package:agmotest_banking/features/home/data/datasources/remote/bankingRemoteDataSource.dart';
import 'package:agmotest_banking/features/home/data/models/bankAccountModel.dart';
import 'package:agmotest_banking/features/home/data/models/transactionModel.dart';

class BankingRemoteDataSourceImpl implements BankingRemoteDataSource {
  @override
  Future<BankAccountModel> getBankAccountInfo() async {
    await Future.delayed(const Duration(seconds: 1));

    // Dummy data
    return const BankAccountModel(
      accountNumber: '1234 5678 9012',
      balance: 1575000.50,
    );
  }

  @override
  Future<List<TransactionModel>> getRecentTransactions() async {
    await Future.delayed(const Duration(seconds: 1));

    // Dummy data
    final List<TransactionModel> transactions = [
      TransactionModel(
        id: 'txn001',
        title: 'Payment to ABC Store',
        amount: -50000.00,
        date: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
      ),
      TransactionModel(
        id: 'txn002',
        title: 'Received from John Doe',
        amount: 250000.00,
        date: DateTime.now().subtract(const Duration(days: 2, hours: 10)),
      ),
      TransactionModel(
        id: 'txn003',
        title: 'Online Subscription',
        amount: -120000.00,
        date: DateTime.now().subtract(const Duration(days: 5, hours: 1)),
      ),
      TransactionModel(
        id: 'txn004',
        title: 'Salary Deposit',
        amount: 5000000.00,
        date: DateTime.now().subtract(const Duration(days: 7, hours: 15)),
      ),
      TransactionModel(
        id: 'txn005',
        title: 'Utility Bill',
        amount: -300000.00,
        date: DateTime.now().subtract(const Duration(days: 8, hours: 2)),
      ),
    ];

    return transactions;
  }
}
