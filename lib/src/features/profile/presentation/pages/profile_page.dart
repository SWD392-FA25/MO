import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:igcse_learning_hub/src/shared/presentation/widgets/app_logo.dart';
import 'package:igcse_learning_hub/src/theme/design_tokens.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            onPressed: () => context.push('/profile/edit'),
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.cardShadow,
                  blurRadius: 18,
                  offset: Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              children: [
                const AppLogo(size: 72),
                const SizedBox(height: 12),
                Text(
                  'Shirayuki Luna',
                  style: textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  'IGCSE Student • STEM & Creative Arts',
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    _ProfileStat(value: '12', label: 'Courses'),
                    _ProfileStat(value: '7', label: 'Certificates'),
                    _ProfileStat(value: '18', label: 'Badges'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _ProfileMenuSection(
            title: 'Học tập',
            items: [
              _ProfileMenuItem(
                icon: Icons.bookmark_outline_rounded,
                label: 'Đánh dấu của tôi',
                route: '/profile/bookmarks',
              ),
              _ProfileMenuItem(
                icon: Icons.notifications_outlined,
                label: 'Thông báo',
                route: '/profile/notifications',
              ),
            ],
          ),
          const SizedBox(height: 20),
          _ProfileMenuSection(
            title: 'Thanh toán',
            items: [
              _ProfileMenuItem(
                icon: Icons.credit_card_outlined,
                label: 'Phương thức thanh toán',
                route: '/profile/payment-options',
              ),
              _ProfileMenuItem(
                icon: Icons.receipt_long_outlined,
                label: 'Biên lai & hoá đơn',
                route: '/transactions',
              ),
            ],
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Đăng xuất'),
          ),
        ],
      ),
    );
  }
}

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _nameController = TextEditingController(text: 'Shirayuki Luna');
  final _emailController = TextEditingController(text: 'luna@igcse.app');
  final _bioController =
      TextEditingController(text: 'Graphic Design & STEM learner');

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chỉnh sửa hồ sơ'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 12),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Họ và tên'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _bioController,
              minLines: 3,
              maxLines: 4,
              decoration: const InputDecoration(labelText: 'Giới thiệu ngắn'),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đã cập nhật hồ sơ')),
                );
                context.pop();
              },
              child: const Text('Lưu thay đổi'),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool _courseUpdates = true;
  bool _marketing = false;
  bool _reminders = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cài đặt thông báo'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Cập nhật khoá học'),
            subtitle: const Text('Nhận thông báo về bài học mới, deadline.'),
            value: _courseUpdates,
            onChanged: (value) => setState(() => _courseUpdates = value),
          ),
          SwitchListTile(
            title: const Text('Ưu đãi & khuyến mãi'),
            value: _marketing,
            onChanged: (value) => setState(() => _marketing = value),
          ),
          SwitchListTile(
            title: const Text('Nhắc nhở học tập'),
            subtitle: const Text('Nhắc lịch học, quiz, bài tập.'),
            value: _reminders,
            onChanged: (value) => setState(() => _reminders = value),
          ),
        ],
      ),
    );
  }
}

class PaymentOptionsPage extends StatelessWidget {
  const PaymentOptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phương thức thanh toán'),
        actions: [
          IconButton(
            onPressed: () => context.push('/profile/payment-options/add'),
            icon: const Icon(Icons.add_card),
          ),
        ],
      ),
      body: ListView(
        children: const [
          _PaymentMethodTile(
            brand: 'Visa',
            lastDigits: '8291',
            holder: 'Shirayuki Luna',
            expDate: '05/27',
          ),
          _PaymentMethodTile(
            brand: 'Mastercard',
            lastDigits: '1128',
            holder: 'Shirayuki Luna',
            expDate: '09/26',
          ),
        ],
      ),
    );
  }
}

class AddNewCardPage extends StatefulWidget {
  const AddNewCardPage({super.key});

  @override
  State<AddNewCardPage> createState() => _AddNewCardPageState();
}

class _AddNewCardPageState extends State<AddNewCardPage> {
  final _numberController = TextEditingController();
  final _nameController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvcController = TextEditingController();

  @override
  void dispose() {
    _numberController.dispose();
    _nameController.dispose();
    _expiryController.dispose();
    _cvcController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm thẻ mới'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _numberController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Số thẻ'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Tên chủ thẻ'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _expiryController,
                    decoration: const InputDecoration(labelText: 'MM/YY'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _cvcController,
                    decoration: const InputDecoration(labelText: 'CVC'),
                  ),
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đã thêm thẻ mới')),
                );
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/payments/methods');
                }
              },
              child: const Text('Lưu thẻ'),
            ),
          ],
        ),
      ),
    );
  }
}

class BookmarksPage extends StatelessWidget {
  const BookmarksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmark của tôi'),
      ),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primary.withAlpha(20),
              child: const Icon(Icons.bookmark),
            ),
            title: Text('Khoá học yêu thích #${index + 1}'),
            subtitle: const Text('Creative Arts • 24 bài học'),
            trailing: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
            ),
          );
        },
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  const _ProfileStat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.primary,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
      ],
    );
  }
}

class _ProfileMenuSection extends StatelessWidget {
  const _ProfileMenuSection({required this.title, required this.items});

  final String title;
  final List<_ProfileMenuItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          for (final item in items)
            ListTile(
              onTap: () => context.push(item.route),
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundColor: AppColors.primary.withAlpha(14),
                child: Icon(item.icon, color: AppColors.primary),
              ),
              title: Text(item.label),
              trailing: const Icon(Icons.chevron_right_rounded),
            ),
        ],
      ),
    );
  }
}

class _ProfileMenuItem {
  const _ProfileMenuItem({
    required this.icon,
    required this.label,
    required this.route,
  });

  final IconData icon;
  final String label;
  final String route;
}

class _PaymentMethodTile extends StatelessWidget {
  const _PaymentMethodTile({
    required this.brand,
    required this.lastDigits,
    required this.holder,
    required this.expDate,
  });

  final String brand;
  final String lastDigits;
  final String holder;
  final String expDate;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withAlpha(22),
          // TODO: Thay icon brand thẻ bằng asset SVG từ Figma.
          child: const Icon(Icons.credit_card),
        ),
        title: Text('$brand •••• $lastDigits'),
        subtitle: Text('$holder • Exp $expDate'),
        trailing: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.more_horiz),
        ),
      ),
    );
  }
}
