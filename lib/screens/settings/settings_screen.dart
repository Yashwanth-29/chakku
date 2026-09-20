
import 'package:flutter/material.dart';
import '../../database/database_helper.dart';
import '../../services/session_service.dart';
import '../../theme/app_theme.dart';
import '../auth/login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Map<String, dynamic>? admin;
  bool loading = true;

  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAdmin();
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _loadAdmin() async {
    setState(() {
      loading = true;
    });

    try {
      final data = await DatabaseHelper.instance.getAdmin();
      if (!mounted) return;
      setState(() {
        admin = data;
      });
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load administrator details.')),
      );
    } finally {
      if (!mounted) return;
      setState(() {
        loading = false;
      });
    }
  }

  Widget _buildHeader() {
    final String name = (admin?['name'] ?? 'Administrator').toString();
    final String email = (admin?['email'] ?? 'admin@chakshu.com').toString();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 34,
            backgroundColor: Colors.white.withOpacity(0.2),
            child: const Icon(Icons.admin_panel_settings,
                size: 36, color: Colors.white),
          ),
          const SizedBox(height: 12),
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            email,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: Colors.white24),
            ),
            child: const Text(
              'System Administrator',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 10),
      child: Text(
        title,
        style: TextStyle(
          color: AppTheme.primaryColor,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildSectionCard(List<Widget> children) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(children: children),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    Color? iconColor,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            radius: 18,
            backgroundColor: (iconColor ?? AppTheme.primaryColor).withOpacity(
              0.12,
            ),
            child: Icon(icon, size: 20, color: iconColor ?? AppTheme.primaryColor),
          ),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: subtitle != null ? Text(subtitle) : null,
          trailing:
              const Icon(Icons.chevron_right_rounded, color: Colors.black45),
          onTap: onTap,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
        ),
        if (showDivider)
          Padding(
            padding: const EdgeInsets.only(left: 64),
            child: Divider(height: 1, color: Colors.grey.shade200),
          ),
      ],
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 28),
      child: Column(
        children: [
          Text(
            'CHAKSHU',
            style: TextStyle(
              color: AppTheme.primaryColor,
              fontSize: 20,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'AI Powered Cataract Screening',
            style: TextStyle(color: Colors.black54, fontSize: 13),
          ),
          const SizedBox(height: 6),
          const Text(
            'Version 1.0.0',
            style: TextStyle(color: Colors.black45, fontSize: 12),
          ),
          const SizedBox(height: 6),
          const Text(
            '© 2026',
            style: TextStyle(color: Colors.black38, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Future<void> _showAboutDialog() async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Application'),
        content: const Text(
          'CHAKSHU is an AI-powered cataract screening application designed to '
          'assist in early screening through eye image analysis.\n\n'
          'This tool supports screening workflows and improves accessibility for '
          'faster preliminary assessment.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close', style: TextStyle(color: AppTheme.primaryColor)),
          ),
        ],
      ),
    );
  }

  Future<void> _showModelDialog() async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('AI Model Information'),
        content: const SingleChildScrollView(
          child: Text(
            '• Model: MobileNetV2\n'
            '• Framework: TensorFlow Lite\n'
            '• Input: Eye Image\n'
            '• Output: Cataract / Normal\n\n'
            'This app is intended for screening only and is not a medical diagnosis.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close', style: TextStyle(color: AppTheme.primaryColor)),
          ),
        ],
      ),
    );
  }

  Future<void> _showVersionDialog() async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Application Version'),
        content: const Text('Version 1.0.0\nStable Release'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close', style: TextStyle(color: AppTheme.primaryColor)),
          ),
        ],
      ),
    );
  }

  Future<void> _changePassword() async {
    final String currentPassword = _currentPasswordController.text.trim();
    final String newPassword = _newPasswordController.text.trim();
    final String confirmPassword = _confirmPasswordController.text.trim();

    if (currentPassword.isEmpty ||
        newPassword.isEmpty ||
        confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all password fields.')),
      );
      return;
    }

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('New password and confirm password do not match.')),
      );
      return;
    }

    if (newPassword.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('New password must be at least 6 characters.')),
      );
      return;
    }

    final result = await DatabaseHelper.instance.changePassword(
      admin?['email'] ?? '',
      currentPassword,
      newPassword,
    );

    final bool success = result == true || result == 1;

    if (!mounted) return;

    if (success) {
      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password changed successfully.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Current password is incorrect.')),
      );
    }
  }

  Future<void> _showChangePasswordDialog() async {
    _currentPasswordController.clear();
    _newPasswordController.clear();
    _confirmPasswordController.clear();

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _currentPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Current Password',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'New Password',
                  prefixIcon: Icon(Icons.lock_reset),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirm New Password',
                  prefixIcon: Icon(Icons.verified_user_outlined),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
            onPressed: _changePassword,
            child: const Text('Change'),
          ),
        ],
      ),
    );
  }

  Future<void> _showClearDatabaseDialog() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Database'),
        content: const Text(
          'Are you sure you want to clear all data from the database? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    await DatabaseHelper.instance.clearDatabase();
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Database cleared successfully.')),
    );

    await _loadAdmin();
  }

  Future<void> _logout() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout from this account?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    await SessionService().logout();
    if (!mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  Future<void> _showContactDeveloperDialog() async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Contact Developer'),
        content: const SelectableText('support@chakshu.com'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close', style: TextStyle(color: AppTheme.primaryColor)),
          ),
        ],
      ),
    );
  }

  Future<void> _showProjectDialog() async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Project'),
        content: const Text(
          'CHAKSHU is a cataract screening project that leverages AI to assist '
          'healthcare workflows with quick and accessible eye-image based screening.\n\n'
          'It is designed to support awareness and early referral decisions.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close', style: TextStyle(color: AppTheme.primaryColor)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        color: AppTheme.primaryColor,
        onRefresh: _loadAdmin,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          children: [
            if (loading) ...[
              const SizedBox(height: 120),
              Center(
                child: CircularProgressIndicator(color: AppTheme.primaryColor),
              ),
              const SizedBox(height: 14),
              const Center(
                child: Text(
                  'Loading settings...',
                  style: TextStyle(color: Colors.black54),
                ),
              ),
              const SizedBox(height: 240),
            ] else ...[
              _buildHeader(),
              const SizedBox(height: 18),
              _buildSectionTitle('Application'),
              _buildSectionCard([
                _buildSettingsTile(
                  icon: Icons.info_outline_rounded,
                  title: 'About Application',
                  subtitle: 'Learn what this app does',
                  onTap: _showAboutDialog,
                ),
                _buildSettingsTile(
                  icon: Icons.memory_rounded,
                  title: 'AI Model Information',
                  subtitle: 'Model and screening details',
                  onTap: _showModelDialog,
                ),
                _buildSettingsTile(
                  icon: Icons.verified_outlined,
                  title: 'Application Version',
                  subtitle: 'Current release information',
                  onTap: _showVersionDialog,
                  showDivider: false,
                ),
              ]),
              const SizedBox(height: 16),
              _buildSectionTitle('Data'),
              _buildSectionCard([
                _buildSettingsTile(
                  icon: Icons.delete_sweep_outlined,
                  title: 'Clear Database',
                  subtitle: 'Remove all app data permanently',
                  iconColor: Colors.red.shade600,
                  onTap: _showClearDatabaseDialog,
                ),
                _buildSettingsTile(
                  icon: Icons.file_download_outlined,
                  title: 'Export Reports (Coming Soon)',
                  subtitle: 'Feature under development',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Export reports feature is coming soon.'),
                      ),
                    );
                  },
                  showDivider: false,
                ),
              ]),
              const SizedBox(height: 16),
              _buildSectionTitle('Security'),
              _buildSectionCard([
                _buildSettingsTile(
                  icon: Icons.password_rounded,
                  title: 'Change Password',
                  subtitle: 'Update your administrator password',
                  onTap: _showChangePasswordDialog,
                ),
                _buildSettingsTile(
                  icon: Icons.logout_rounded,
                  title: 'Logout',
                  subtitle: 'Sign out from this device',
                  iconColor: Colors.orange.shade700,
                  onTap: _logout,
                  showDivider: false,
                ),
              ]),
              const SizedBox(height: 16),
              _buildSectionTitle('Support'),
              _buildSectionCard([
                _buildSettingsTile(
                  icon: Icons.support_agent_outlined,
                  title: 'Contact Developer',
                  subtitle: 'support@chakshu.com',
                  onTap: _showContactDeveloperDialog,
                ),
                _buildSettingsTile(
                  icon: Icons.folder_special_outlined,
                  title: 'About Project',
                  subtitle: 'Learn about CHAKSHU initiative',
                  onTap: _showProjectDialog,
                  showDivider: false,
                ),
              ]),
              _buildFooter(),
            ],
          ],
        ),
      ),
    );
  }
}