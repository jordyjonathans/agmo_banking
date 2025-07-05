import 'package:agmotest_banking/features/home/domain/entities/bankAccount.dart';
import 'package:agmotest_banking/features/home/domain/repositories/bankingRepository.dart';

class GetBankAccountInfoUseCase {
  final BankingRepository repository;

  GetBankAccountInfoUseCase(this.repository);

  Future<BankAccount> call() {
    return repository.getBankAccountInfo();
  }
}
