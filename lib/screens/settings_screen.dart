import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final Function(ThemeMode)? setThemeMode;

  const SettingsScreen({Key? key, required this.setThemeMode})
    : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isDarkMode = false;
  String _accentColor = 'blue';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
      if (widget.setThemeMode != null) {
        widget.setThemeMode!(_isDarkMode ? ThemeMode.dark : ThemeMode.light);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Account'),
                Tab(text: 'Business'),
                Tab(text: 'Billing'),
                Tab(text: 'App'),
              ],
              isScrollable: true,
            ),

            const SizedBox(height: 24),

            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Account Tab
                  _buildAccountTab(),

                  // Business Tab
                  _buildBusinessTab(),

                  // Billing Tab
                  _buildBillingTab(),

                  // App Tab
                  _buildAppTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountTab() {
    return ListView(
      children: [
        _buildSettingsCard(
          title: 'Personal Information',
          icon: Icons.person,
          description: 'Manage your personal account details',
          content: Column(
            children: [
              _buildTextField(label: 'Full Name', initialValue: 'John Doe'),
              const SizedBox(height: 12),
              _buildTextField(
                label: 'Email Address',
                initialValue: 'john.doe@example.com',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                label: 'Phone Number',
                initialValue: '+1 (555) 123-4567',
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Save Changes'),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        _buildSettingsCard(
          title: 'Security',
          icon: null,
          description: 'Manage your account security',
          content: Column(
            children: [
              _buildSettingsRow(
                title: 'Change Password',
                subtitle: 'Update your password regularly',
                trailing: OutlinedButton(
                  onPressed: () {},
                  child: const Text('Change'),
                ),
              ),
              const Divider(),
              _buildSettingsRow(
                title: 'Two-Factor Authentication',
                subtitle: 'Add an extra layer of security',
                trailing: Switch(value: false, onChanged: (value) {}),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBusinessTab() {
    return ListView(
      children: [
        _buildSettingsCard(
          title: 'Business Profile',
          icon: Icons.business,
          description: 'Manage your business information',
          content: Column(
            children: [
              _buildTextField(
                label: 'Business Name',
                initialValue: 'Acme Invoicing LLC',
              ),
              const SizedBox(height: 12),
              _buildTextField(
                label: 'Business Email',
                initialValue: 'invoices@acmeinvoicing.com',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                label: 'Business Phone',
                initialValue: '+1 (555) 987-6543',
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                label: 'Business Address',
                initialValue:
                    '123 Business Ave, Suite 200\nSan Francisco, CA 94107\nUnited States',
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                label: 'Tax ID / VAT Number',
                initialValue: 'US123456789',
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Save Changes'),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        _buildSettingsCard(
          title: 'Invoice Settings',
          icon: Icons.receipt,
          description: 'Customize your invoice defaults',
          content: Column(
            children: [
              _buildTextField(
                label: 'Invoice Number Prefix',
                initialValue: 'INV-',
              ),
              const SizedBox(height: 12),
              _buildDropdown(
                label: 'Default Payment Terms',
                value: '30',
                items: const [
                  DropdownMenuItem(
                    value: '7',
                    child: Text('Net 7 - Due in 7 days'),
                  ),
                  DropdownMenuItem(
                    value: '14',
                    child: Text('Net 14 - Due in 14 days'),
                  ),
                  DropdownMenuItem(
                    value: '30',
                    child: Text('Net 30 - Due in 30 days'),
                  ),
                  DropdownMenuItem(
                    value: '60',
                    child: Text('Net 60 - Due in 60 days'),
                  ),
                ],
                onChanged: (value) {},
              ),
              const SizedBox(height: 12),
              _buildTextField(
                label: 'Default Invoice Notes',
                initialValue:
                    'Thank you for your business. Please make payment by the due date.',
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Save Changes'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBillingTab() {
    return ListView(
      children: [
        _buildSettingsCard(
          title: 'Payment Methods',
          icon: Icons.credit_card,
          description: 'Manage your payment methods',
          content: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Container(
                      width: 64,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(Icons.credit_card),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Visa ending in 4242',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            'Expires 12/2025',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        OutlinedButton(
                          onPressed: () {},
                          child: const Text('Edit'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton(
                          onPressed: () {},
                          child: const Text('Remove'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            foregroundColor: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('Add Payment Method'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        _buildSettingsCard(
          title: 'Currency & Tax',
          icon: Icons.language,
          description: 'Manage your currency and tax settings',
          content: Column(
            children: [
              _buildDropdown(
                label: 'Default Currency',
                value: 'usd',
                items: const [
                  DropdownMenuItem(
                    value: 'usd',
                    child: Text('USD - US Dollar'),
                  ),
                  DropdownMenuItem(value: 'eur', child: Text('EUR - Euro')),
                  DropdownMenuItem(
                    value: 'gbp',
                    child: Text('GBP - British Pound'),
                  ),
                  DropdownMenuItem(
                    value: 'cad',
                    child: Text('CAD - Canadian Dollar'),
                  ),
                  DropdownMenuItem(
                    value: 'aud',
                    child: Text('AUD - Australian Dollar'),
                  ),
                ],
                onChanged: (value) {},
              ),
              const SizedBox(height: 12),
              _buildTextField(
                label: 'Default Tax Rate (%)',
                initialValue: '0',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Switch(value: false, onChanged: (value) {}),
                  const SizedBox(width: 8),
                  const Text('Prices are tax inclusive'),
                ],
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Save Changes'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAppTab() {
    return ListView(
      children: [
        _buildSettingsCard(
          title: 'Notifications',
          icon: Icons.notifications,
          description: 'Manage your notification preferences',
          content: Column(
            children: [
              _buildSettingsRow(
                title: 'Email Notifications',
                subtitle: 'Receive email notifications for important updates',
                trailing: Switch(value: true, onChanged: (value) {}),
              ),
              const Divider(),
              _buildSettingsRow(
                title: 'Payment Reminders',
                subtitle: 'Send reminders for upcoming and overdue payments',
                trailing: Switch(value: true, onChanged: (value) {}),
              ),
              const Divider(),
              _buildSettingsRow(
                title: 'App Notifications',
                subtitle: 'Enable push notifications on your device',
                trailing: Switch(value: false, onChanged: (value) {}),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        _buildSettingsCard(
          title: 'Appearance',
          icon: Icons.palette,
          description: 'Customize how the app looks',
          content: Column(
            children: [
              _buildSettingsRow(
                title: 'Dark Mode',
                subtitle: 'Switch between light and dark themes',
                trailing: Row(
                  children: [
                    const Icon(Icons.light_mode, size: 16),
                    const SizedBox(width: 8),
                    Switch(
                      value: _isDarkMode,
                      onChanged: (value) {
                        _toggleTheme();
                      },
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.dark_mode, size: 16),
                  ],
                ),
              ),
              const Divider(),
              _buildDropdown(
                label: 'Accent Color',
                value: _accentColor,
                items: const [
                  DropdownMenuItem(value: 'blue', child: Text('Blue')),
                  DropdownMenuItem(value: 'green', child: Text('Green')),
                  DropdownMenuItem(value: 'purple', child: Text('Purple')),
                  DropdownMenuItem(value: 'orange', child: Text('Orange')),
                  DropdownMenuItem(value: 'pink', child: Text('Pink')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _accentColor = value;
                    });
                  }
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        _buildSettingsCard(
          title: 'Advanced',
          icon: Icons.settings,
          description: 'Advanced app settings',
          content: Column(
            children: [
              _buildSettingsRow(
                title: 'Data Export',
                subtitle: 'Export all your invoice data',
                trailing: OutlinedButton(
                  onPressed: () {},
                  child: const Text('Export'),
                ),
              ),
              const Divider(),
              _buildSettingsRow(
                title: 'Clear Cache',
                subtitle: 'Clear the app\'s local cache',
                trailing: OutlinedButton(
                  onPressed: () {},
                  child: const Text('Clear'),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.logout),
          label: const Text('Sign Out'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
            foregroundColor: Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsCard({
    required String title,
    required Widget content,
    IconData? icon,
    String? description,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 20),
                  const SizedBox(width: 8),
                ],
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            if (description != null) ...[
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
            ],
            const SizedBox(height: 16),
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsRow({
    required String title,
    required String subtitle,
    required Widget trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String initialValue,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: initialValue,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<DropdownMenuItem<String>> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              items: items,
              onChanged: onChanged,
              isExpanded: true,
            ),
          ),
        ),
      ],
    );
  }
}
