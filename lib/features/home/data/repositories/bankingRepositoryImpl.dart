import 'package:agmotest_banking/features/home/data/datasources/remote/bankingRemoteDataSource.dart';
import 'package:agmotest_banking/features/home/domain/entities/bankAccount.dart';
import 'package:agmotest_banking/features/home/domain/entities/transaction.dart';
import 'package:agmotest_banking/features/home/domain/repositories/bankingRepository.dart';

class BankingRepositoryImpl implements BankingRepository {
  final BankingRemoteDataSource remoteDataSource;

  BankingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<BankAccount> getBankAccountInfo() async {
    try {
      final bankAccountModel = await remoteDataSource.getBankAccountInfo();
      return bankAccountModel.toEntity();
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<List<Transaction>> getRecentTransactions() async {
    try {
      final transactionModels = await remoteDataSource.getRecentTransactions();
      return transactionModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw e.toString();
    }
  }
}
