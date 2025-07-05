import 'package:equatable/equatable.dart';

class BankAccount extends Equatable {
  final String accountNumber;
  final double balance;

  const BankAccount({required this.accountNumber, required this.balance});

  @override
  List<Object> get props => [accountNumber, balance];
}
