import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:igcse_learning_hub/src/features/authentication/presentation/providers/auth_provider.dart';
import 'package:igcse_learning_hub/src/features/profile/presentation/providers/profile_provider.dart';
import 'package:igcse_learning_hub/src/shared/presentation/widgets/app_logo.dart';
import 'package:igcse_learning_hub/src/theme/design_tokens.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProfile();
    });
  }

  Future<void> _loadProfile() async {
    final authProvider = context.read<AuthProvider>();
    final profileProvider = context.read<ProfileProvider>();
    
    if (authProvider.currentUser != null && 
        authProvider.currentUser!.id != 'temp' &&
        authProvider.currentUser!.id != 'jwt-user') {
      await profileProvider.loadProfile(authProvider.currentUser!.id);
    } else {
      // User ID not available yet, skip profile load
      // This happens when user data is not properly parsed from login response
      print('⚠️ User ID not available, skipping profile load');
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final authProvider = context.watch<AuthProvider>();
    final profileProvider = context.watch<ProfileProvider>();
    final profile = profileProvider.profile;
    
    // Fallback to auth user if profile not loaded
    final displayName = profile?.fullName ?? 
                       profile?.userName ?? 
                       authProvider.currentUser?.name ?? 
                       'User';
    final displayEmail = profile?.email ?? 
                        authProvider.currentUser?.email ?? 
                        '';
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
      body: profileProvider.isLoading && profile == null
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadProfile,
              child: ListView(
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
                        // Avatar
                        CircleAvatar(
                          radius: 48,
                          backgroundColor: AppColors.primary.withOpacity(0.1),
                          backgroundImage: profile?.avatarUrl != null
                              ? NetworkImage(profile!.avatarUrl!)
                              : null,
                          child: profile?.avatarUrl == null
                              ? const Icon(Icons.person,
                                  size: 48, color: AppColors.primary)
                              : null,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          displayName,
                          style: textTheme.titleLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          displayEmail,
                          style: textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        if (profile?.phoneNumber != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            profile!.phoneNumber!,
                            style: textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: const [
                            _ProfileStat(value: '0', label: 'Courses'),
                            _ProfileStat(value: '0', label: 'Certificates'),
                            _ProfileStat(value: '0', label: 'Badges'),
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
            onPressed: () async {
              // Show confirmation dialog
              final shouldLogout = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Đăng xuất'),
                  content: const Text('Bạn có chắc chắn muốn đăng xuất?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Huỷ'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Đăng xuất'),
                    ),
                  ],
                ),
              );

              if (shouldLogout == true && context.mounted) {
                await context.read<AuthProvider>().signOut();
                if (context.mounted) {
                  context.go('/auth/sign-in');
                }
              }
            },
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Đăng xuất'),
          ),
        ],
      ),
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
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileProvider = context.read<ProfileProvider>();
      final profile = profileProvider.profile;
      
      if (profile != null) {
        _fullNameController.text = profile.fullName ?? '';
        _phoneController.text = profile.phoneNumber ?? '';
        _addressController.text = profile.address ?? '';
      }
    });
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final profileProvider = context.read<ProfileProvider>();
    
    if (authProvider.currentUser == null) return;

    // Check if we have a valid user ID
    final userId = authProvider.currentUser!.id;
    
    // DEBUG: Print user ID
    print('🔍 User ID: "$userId" (length: ${userId.length})');
    print('🔍 User Email: ${authProvider.currentUser!.email}');
    print('🔍 User Name: ${authProvider.currentUser!.name}');
    
    if (userId.isEmpty || userId == 'temp' || userId == 'jwt-user') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User ID không hợp lệ: "$userId"'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Include all required fields
    final currentProfile = profileProvider.profile;
    final currentUser = authProvider.currentUser!;
    
    final success = await profileProvider.updateProfile(
      userId,
      {
        'fullName': _fullNameController.text.trim(),
        'phoneNumber': _phoneController.text.trim(),
        'address': _addressController.text.trim(),
        // Include email from profile or auth user
        'email': currentProfile?.email ?? currentUser.email,
        // Include userName if available
        if (currentProfile?.userName != null) 
          'userName': currentProfile!.userName,
      },
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã cập nhật hồ sơ thành công'),
          backgroundColor: Colors.green,
        ),
      );
      context.pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(profileProvider.errorMessage ?? 'Có lỗi xảy ra'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();
    final profile = profileProvider.profile;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chỉnh sửa hồ sơ'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 12),
              // Email (read-only)
              TextFormField(
                initialValue: profile?.email ?? '',
                enabled: false,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  helperText: 'Email không thể thay đổi',
                ),
              ),
              const SizedBox(height: 16),
              // Full Name
              TextFormField(
                controller: _fullNameController,
                decoration: const InputDecoration(labelText: 'Họ và tên'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập họ tên';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Phone Number
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Số điện thoại'),
              ),
              const SizedBox(height: 16),
              // Address
              TextFormField(
                controller: _addressController,
                minLines: 2,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Địa chỉ'),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: profileProvider.isLoading ? null : _handleSave,
                  child: profileProvider.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Lưu thay đổi'),
                ),
              ),
            ],
          ),
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
