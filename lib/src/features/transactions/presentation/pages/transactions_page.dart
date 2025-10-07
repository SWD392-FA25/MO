import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:igcse_learning_hub/src/theme/design_tokens.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final transactions = _mockTransactions;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Transactions'),
        actions: [
          TextButton(
            onPressed: () => context.push('/payments/methods'),
            child: const Text('Phương thức'),
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: transactions.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          return InkWell(
            onTap: () => context.push('/transactions/${transaction.id}'),
            borderRadius: BorderRadius.circular(24),
            child: Ink(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.cardShadow,
                    blurRadius: 18,
                    offset: Offset(0, 12),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: AppColors.primary.withAlpha(18),
                    ),
                    child: Icon(
                      transaction.status == 'Paid'
                          ? Icons.check_circle_rounded
                          : Icons.pending_actions_rounded,
                      color: transaction.status == 'Paid'
                          ? AppColors.primary
                          : AppColors.accent,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          transaction.title,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${transaction.date} • ${transaction.method}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '-\$${transaction.amount.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppColors.primary,
                            ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        transaction.status,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: transaction.status == 'Paid'
                                  ? Colors.green
                                  : AppColors.accent,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/payments/methods'),
        label: const Text('Thanh toán khoá học'),
        icon: const Icon(Icons.credit_card),
      ),
    );
  }
}

class PaymentMethodsPage extends StatelessWidget {
  const PaymentMethodsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final methods = _paymentMethods;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chọn phương thức thanh toán'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: methods.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final method = methods[index];
          return ListTile(
            tileColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            leading: CircleAvatar(
              backgroundColor: AppColors.primary.withAlpha(26),
              // TODO: Thay icon phương thức thanh toán bằng SVG phù hợp theo Figma.
              child: Icon(method.icon, color: AppColors.primary),
            ),
            title: Text(method.title),
            subtitle: Text(method.description),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => context.push('/payments/success'),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: OutlinedButton(
          onPressed: () => context.push('/profile/payment-options'),
          child: const Text('Quản lý thẻ của tôi'),
        ),
      ),
    );
  }
}

class PaymentSuccessPage extends StatelessWidget {
  const PaymentSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green.withAlpha(32),
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.green,
                  size: 64,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Thanh toán thành công!',
                style: textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Text(
                'Chúng tôi đã gửi biên lai đến email của bạn. Bạn có thể xem lại trong mục giao dịch.',
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.push('/transactions/receipt'),
                child: const Text('Xem e-Receipt'),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => context.go('/dashboard'),
                child: const Text('Về trang chủ'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EReceiptPage extends StatelessWidget {
  const EReceiptPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('E-Receipt'),
        actions: [
          IconButton(
            onPressed: () => context.push('/transactions/receipt/edit'),
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'IGCSE Learning Hub',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              _ReceiptRow(label: 'Invoice ID', value: '#INV-2025-1532'),
              _ReceiptRow(label: 'Date', value: '06 Oct 2025'),
              _ReceiptRow(label: 'Payment Method', value: 'Visa **** 8291'),
              const Divider(height: 32),
              _ReceiptRow(label: 'Course', value: 'Graphic Design Advanced'),
              _ReceiptRow(label: 'Subtotal', value: '\$28.00'),
              _ReceiptRow(label: 'Tax', value: '\$2.80'),
              const Divider(height: 32),
              _ReceiptRow(
                label: 'Total Paid',
                value: '\$30.80',
                emphasize: true,
              ),
              const SizedBox(height: 32),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.file_download_outlined),
                label: const Text('Tải về PDF'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EReceiptEditPage extends StatefulWidget {
  const EReceiptEditPage({super.key});

  @override
  State<EReceiptEditPage> createState() => _EReceiptEditPageState();
}

class _EReceiptEditPageState extends State<EReceiptEditPage> {
  final _companyController = TextEditingController(text: 'Luna Creative Studio');
  final _taxController = TextEditingController(text: '0101929394');
  final _emailController = TextEditingController(text: 'billing@luna.studio');

  @override
  void dispose() {
    _companyController.dispose();
    _taxController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chỉnh sửa e-Receipt'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _companyController,
              decoration: const InputDecoration(labelText: 'Tên công ty'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _taxController,
              decoration: const InputDecoration(labelText: 'Mã số thuế'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email nhận hoá đơn'),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đã lưu thông tin e-Receipt')),
                );
                context.pop();
              },
              child: const Text('Lưu thông tin'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReceiptRow extends StatelessWidget {
  const _ReceiptRow({
    required this.label,
    required this.value,
    this.emphasize = false,
  });

  final String label;
  final String value;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Text(
            value,
            style: (emphasize ? textTheme.titleMedium : textTheme.bodyMedium)
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _Transaction {
  const _Transaction({
    required this.id,
    required this.title,
    required this.date,
    required this.method,
    required this.amount,
    required this.status,
  });

  final String id;
  final String title;
  final String date;
  final String method;
  final double amount;
  final String status;
}

class _PaymentMethod {
  const _PaymentMethod({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;
}

const _mockTransactions = [
  _Transaction(
    id: 'trx-1',
    title: 'Graphic Design Advanced',
    date: '05 Oct 2025',
    method: 'Visa **** 8291',
    amount: 30.80,
    status: 'Paid',
  ),
  _Transaction(
    id: 'trx-2',
    title: 'Web Developer Concepts',
    date: '28 Sep 2025',
    method: 'Mastercard **** 1128',
    amount: 45.50,
    status: 'Paid',
  ),
  _Transaction(
    id: 'trx-3',
    title: 'Digital Marketing Crash Course',
    date: '15 Sep 2025',
    method: 'Momo Wallet',
    amount: 25.00,
    status: 'Pending',
  ),
];

const _paymentMethods = [
  _PaymentMethod(
    icon: Icons.credit_card,
    title: 'Visa / Mastercard',
    description: 'Thanh toán bằng thẻ quốc tế',
  ),
  _PaymentMethod(
    icon: Icons.account_balance_wallet_outlined,
    title: 'Ví điện tử',
    description: 'ShopeePay, Momo, ZaloPay...',
  ),
  _PaymentMethod(
    icon: Icons.payments_outlined,
    title: 'Chuyển khoản ngân hàng',
    description: 'Thanh toán qua Internet Banking',
  ),
];
