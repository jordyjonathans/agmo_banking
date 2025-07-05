import 'package:agmotest_banking/features/home/domain/entities/bankAccount.dart';
import 'package:equatable/equatable.dart';

class BankAccountModel extends BankAccount implements Equatable {
  const BankAccountModel({
    required String accountNumber,
    required double balance,
  }) : super(accountNumber: accountNumber, balance: balance);

  factory BankAccountModel.fromJson(Map<String, dynamic> json) {
    return BankAccountModel(
      accountNumber: json['accountNumber'] as String,
      balance: (json['balance'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'accountNumber': accountNumber, 'balance': balance};
  }

  @override
  List<Object> get props => [accountNumber, balance];
  @override
  bool get stringify => true;

  BankAccount toEntity() {
    return BankAccount(accountNumber: accountNumber, balance: balance);
  }
}
