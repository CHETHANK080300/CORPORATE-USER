import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/app_providers.dart';
import '../services/corporate_repository.dart';
import '../theme/app_colors.dart';

class MainLayout extends StatelessWidget {
  final Widget child;

  const MainLayout({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final isDesktop = media.size.width >= 1024;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: !isDesktop
          ? AppBar(
              backgroundColor: AppColors.sidebarBg,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.white),
              title: const Text(
                'Treasury Dashboard',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
          : null,
      drawer: !isDesktop ? _buildSidebar(context, isMobileDrawer: true) : null,
      body: Row(
        children: [
          if (isDesktop) _buildSidebar(context, isMobileDrawer: false),
          Expanded(
            child: Column(
              children: [
                _buildHeader(context, isDesktop),
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar(BuildContext context, {required bool isMobileDrawer}) {
    final appState = context.watch<AppState>();

    final menuItems = [
      {'id': 'overview', 'icon': Icons.home, 'label': 'Overview', 'route': 'overview'},
      {'id': 'cash_position', 'icon': Icons.account_balance_wallet, 'label': 'Cash Position', 'route': 'overview'},
      {'id': 'forecasting', 'icon': Icons.trending_up, 'label': 'Forecasting', 'route': 'overview'},
      {'id': 'entities', 'icon': Icons.corporate_fare, 'label': 'Entities', 'route': 'overview'},
      {'id': 'transactions', 'icon': Icons.receipt_long, 'label': 'Transactions', 'route': 'overview'},
      {'id': 'sweep_pooling', 'icon': Icons.swap_horiz, 'label': 'Sweep & Pooling', 'route': 'overview'},
      {'id': 'fx_exposure', 'icon': Icons.currency_exchange, 'label': 'FX Exposure', 'route': 'overview'},
      {'id': 'reports', 'icon': Icons.assessment, 'label': 'Reports', 'route': 'overview'},
      {'id': 'alerts', 'icon': Icons.notifications_active, 'label': 'Alerts', 'route': 'overview'},
      {'id': 'analytics', 'icon': Icons.pie_chart, 'label': 'Analytics', 'route': 'overview'},
      {'id': 'settings', 'icon': Icons.settings, 'label': 'Settings', 'route': 'overview'},
    ];

    return Container(
      width: 240,
      color: AppColors.sidebarBg,
      child: Column(
        children: [
          // Logo & Title
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.language, color: Colors.white, size: 22),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Treasury HQ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          // Menu Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              children: menuItems.map((item) {
                final isSelected = item['id'] == 'overview';

                return Container(
                  margin: const EdgeInsets.only(bottom: 4),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.sidebarActiveItem : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                    leading: Icon(
                      item['icon'] as IconData,
                      color: isSelected ? Colors.white : AppColors.sidebarText,
                      size: 20,
                    ),
                    title: Text(
                      item['label'] as String,
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppColors.sidebarText,
                        fontSize: 14,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                    onTap: () {
                      appState.navigateTo(item['route'] as String);
                      if (isMobileDrawer) {
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          // Bottom switch locale
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFF312E81))),
            ),
            child: Row(
              children: [
                const Icon(Icons.language, color: AppColors.sidebarText, size: 18),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Global USD',
                    style: TextStyle(color: AppColors.sidebarText, fontSize: 12),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.swap_horiz, color: Colors.white, size: 18),
                  onPressed: () => appState.toggleLocale(),
                  tooltip: 'Toggle Language',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDesktop) {
    final authService = context.watch<AuthService>();
    final repository = context.watch<CorporateRepository>();
    final currentUser = authService.currentUser;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.cardBorder)),
      ),
      child: Row(
        children: [
          const Text(
            'Treasury Dashboard',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const Spacer(),

          // Currency Dropdown Selector
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Row(
              children: const [
                Text(
                  'USD',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(width: 4),
                Icon(Icons.keyboard_arrow_down, size: 16, color: AppColors.textSecondary),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Date Selector
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Row(
              children: const [
                Icon(Icons.calendar_today, size: 14, color: AppColors.textSecondary),
                SizedBox(width: 6),
                Text(
                  'May 31, 2024',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          // Notification Bell Icon
          IconButton(
            icon: Badge(
              label: Text('${repository.systemAlerts.length}'),
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.notifications_none, color: AppColors.textSecondary),
            ),
            onPressed: () {},
            tooltip: 'System Alerts',
          ),

          const SizedBox(width: 16),

          // User Profile Avatar & Role
          Row(
            children: [
              const CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.primaryLight,
                child: Icon(Icons.person, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 10),
              if (isDesktop)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      currentUser.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      currentUser.title,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
