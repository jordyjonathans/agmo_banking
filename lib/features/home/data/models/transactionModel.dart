import 'package:agmotest_banking/features/home/domain/entities/transaction.dart';
import 'package:equatable/equatable.dart';

class TransactionModel extends Transaction implements Equatable {
  const TransactionModel({
    required String id,
    required String title,
    required double amount,
    required DateTime date,
  }) : super(id: id, title: title, amount: amount, date: date);

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      title: json['title'] as String,
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
    };
  }

  @override
  List<Object> get props => [id, title, amount, date];
  @override
  bool get stringify => true;

  Transaction toEntity() {
    return Transaction(id: id, title: title, amount: amount, date: date);
  }
}
