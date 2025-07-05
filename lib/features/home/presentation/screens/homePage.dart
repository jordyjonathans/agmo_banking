import 'package:agmotest_banking/di/injector.dart';
import 'package:agmotest_banking/features/home/presentation/providers/state/bankingState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authViewModel = ref.read(authStateNotifier.notifier);
    final authState = ref.watch(authStateNotifier);
    final bankingState = ref.watch(bankingStateNotifier);

    final NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 2,
    );

    final DateFormat dateFormatter = DateFormat('dd MMM yyyy, HH:mm');

    ref.listen<BankingState>(bankingStateNotifier, (previous, current) {
      if (current.errorMessage != null &&
          current.status == BankingStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Banking Error: ${current.errorMessage}')),
        );
        ref.read(bankingStateNotifier.notifier).clearErrorMessage();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authViewModel.logout();
              context.go('/login');
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            ref.read(bankingStateNotifier.notifier).loadBankingData(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome, ${authState.currentUserName ?? authState.currentUserEmail ?? 'Guest'}!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),

                Text(
                  'Your Bank Account',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                if (bankingState.status == BankingStatus.loading &&
                    bankingState.bankAccount == null)
                  const Center(child: CircularProgressIndicator())
                else if (bankingState.bankAccount != null)
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Account Number: ${bankingState.bankAccount!.accountNumber}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Balance: ${currencyFormatter.format(bankingState.bankAccount!.balance)}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (bankingState.bankAccount == null &&
                    bankingState.status == BankingStatus.error)
                  Text(
                    'Failed to load account info: ${bankingState.errorMessage}',
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  ),

                SizedBox(height: 30),

                Text(
                  'Recent Transactions',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                if (bankingState.status == BankingStatus.loading &&
                    bankingState.transactions.isEmpty)
                  const Center(child: CircularProgressIndicator())
                else if (bankingState.transactions.isNotEmpty)
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: bankingState.transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = bankingState.transactions[index];
                      return Card(
                        elevation: 2,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: Icon(
                            transaction.amount > 0
                                ? Icons.arrow_downward
                                : Icons.arrow_upward,
                            color: transaction.amount > 0
                                ? Colors.green
                                : Colors.red,
                          ),
                          title: Text(
                            transaction.title,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            dateFormatter.format(transaction.date),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          trailing: Text(
                            currencyFormatter.format(transaction.amount),
                            style: TextStyle(
                              color: transaction.amount > 0
                                  ? Colors.green
                                  : Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    },
                  )
                else if (bankingState.transactions.isEmpty &&
                    bankingState.status == BankingStatus.loaded)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: Text(
                        'No recent transactions.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  )
                else if (bankingState.transactions.isEmpty &&
                    bankingState.status == BankingStatus.error)
                  Text(
                    'Failed to load transactions: ${bankingState.errorMessage}',
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
