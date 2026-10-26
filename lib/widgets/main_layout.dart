import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/app_providers.dart';
import '../services/corporate_repository.dart';
import '../theme/app_colors.dart';

class MainLayout extends StatelessWidget {
  final Widget child;

  const MainLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: isDesktop ? null : _buildMobileAppBar(context),
      drawer: isDesktop ? null : Drawer(child: _buildSidebarContent(context)),
      body: Row(
        children: [
          if (isDesktop)
            SizedBox(
              width: 260,
              child: _buildSidebarContent(context),
            ),
          Expanded(
            child: Column(
              children: [
                _buildHeader(context, isDesktop),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20.0),
                    child: child,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildMobileAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.sidebarBg,
      foregroundColor: Colors.white,
      title: const Text(
        'VIETNAM CORPORATE BANK',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.language),
          onPressed: () => context.read<AppState>().toggleLocale(),
          tooltip: 'Chuyển đổi ngôn ngữ',
        ),
      ],
    );
  }

  Widget _buildSidebarContent(BuildContext context) {
    final appState = context.watch<AppState>();
    final authService = context.watch<AuthService>();
    final isVi = appState.isVietnamese;
    final currentUser = authService.currentUser;

    final navItems = [
      {'route': 'overview', 'icon': Icons.dashboard, 'labelVi': 'Tổng quan', 'labelEn': 'Overview'},
      {'route': 'liquidity', 'icon': Icons.account_balance, 'labelVi': 'Thanh khoản & Vay', 'labelEn': 'Liquidity'},
      {'route': 'companies', 'icon': Icons.business, 'labelVi': 'Công ty', 'labelEn': 'Companies'},
      {'route': 'accounts', 'icon': Icons.account_balance_wallet, 'labelVi': 'Tài khoản', 'labelEn': 'Accounts'},
      {'route': 'approvals', 'icon': Icons.fact_check, 'labelVi': 'Phê duyệt', 'labelEn': 'Approvals'},
      {'route': 'transactions', 'icon': Icons.receipt_long, 'labelVi': 'Giao dịch', 'labelEn': 'Transactions'},
      {'route': 'reports', 'icon': Icons.analytics, 'labelVi': 'Báo cáo', 'labelEn': 'Reports'},
    ];

    return Container(
      color: AppColors.sidebarBg,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            alignment: Alignment.centerLeft,
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFF1E293B))),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.account_balance, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'VIETNAM BANK',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        'Corporate Gateway',
                        style: TextStyle(
                          color: AppColors.sidebarText,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.sidebarActiveItem,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primaryBlue,
                  radius: 18,
                  child: Text(
                    currentUser.name.substring(0, 1),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentUser.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        isVi ? currentUser.role.displayNameVi : currentUser.role.displayNameEn,
                        style: const TextStyle(
                          color: AppColors.sidebarText,
                          fontSize: 11,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              children: navItems.map((item) {
                final isSelected = appState.selectedNavigationRoute == item['route'];
                final label = isVi ? item['labelVi'] as String : item['labelEn'] as String;

                return Container(
                  margin: const EdgeInsets.only(bottom: 4),
                  child: ListTile(
                    dense: true,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    tileColor: isSelected ? AppColors.primaryBlue : Colors.transparent,
                    leading: Icon(
                      item['icon'] as IconData,
                      color: isSelected ? Colors.white : AppColors.sidebarText,
                      size: 20,
                    ),
                    title: Text(
                      label,
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppColors.sidebarText,
                        fontSize: 14,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                    onTap: () {
                      appState.navigateTo(item['route'] as String);
                      if (Scaffold.of(context).isDrawerOpen) {
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFF1E293B))),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(Icons.language, color: AppColors.sidebarText, size: 18),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          isVi ? 'Tiếng Việt' : 'English',
                          style: const TextStyle(color: AppColors.sidebarText, fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () => appState.toggleLocale(),
                  child: Text(
                    isVi ? 'EN' : 'VI',
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
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
    final appState = context.watch<AppState>();
    final isVi = appState.isVietnamese;
    final currentUser = authService.currentUser;

    final pendingApprovals = repository.getAccessiblePendingApprovals(currentUser);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.cardBorder)),
      ),
      child: Row(
        children: [
          if (isDesktop) ...[
            Flexible(
              child: _buildOrganizationDropdown(context, currentUser, repository, isVi),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                height: 38,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: AppColors.textMuted, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: isVi ? 'Tìm kiếm tài khoản, giao dịch...' : 'Search accounts, transactions...',
                          border: InputBorder.none,
                          isDense: true,
                          hintStyle: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],

          IconButton(
            icon: Badge(
              label: Text('${pendingApprovals.length}'),
              isLabelVisible: pendingApprovals.isNotEmpty,
              backgroundColor: AppColors.danger,
              child: const Icon(Icons.notifications_none, color: AppColors.textSecondary),
            ),
            onPressed: () => appState.navigateTo('approvals'),
            tooltip: isVi ? 'Danh sách phê duyệt' : 'Pending Approvals',
          ),

          const SizedBox(width: 8),

          Flexible(
            child: PopupMenuButton<User>(
              tooltip: isVi ? 'Đổi vai trò Demo' : 'Switch Demo User',
              onSelected: (newUser) {
                authService.switchUser(newUser);
                if (newUser.role == UserRole.companyAccountantHotels) {
                  appState.navigateTo('overview', verticalId: 'vtl-hotels');
                } else {
                  appState.navigateTo('overview');
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlueLight,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.primaryBlue.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.swap_horiz, color: AppColors.primaryBlue, size: 16),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        isVi ? 'Role: ${currentUser.name}' : 'Demo: ${currentUser.name}',
                        style: const TextStyle(
                          color: AppColors.primaryBlue,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(Icons.arrow_drop_down, color: AppColors.primaryBlue, size: 16),
                  ],
                ),
              ),
              itemBuilder: (context) {
                return authService.allDemoUsers.map((u) {
                  return PopupMenuItem<User>(
                    value: u,
                    child: Row(
                      children: [
                        Icon(
                          u.id == currentUser.id ? Icons.check_circle : Icons.radio_button_unchecked,
                          color: u.id == currentUser.id ? AppColors.primaryBlue : AppColors.textMuted,
                          size: 18,
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(u.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            Text(
                              isVi ? u.role.displayNameVi : u.role.displayNameEn,
                              style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList();
              },
            ),
          ),

          const SizedBox(width: 8),

          // Logout Icon Button
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.textSecondary, size: 20),
            tooltip: isVi ? 'Đăng xuất' : 'Logout',
            onPressed: () {
              authService.logout();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOrganizationDropdown(
    BuildContext context,
    User currentUser,
    CorporateRepository repository,
    bool isVi,
  ) {
    final accessibleCompanies = repository.getAccessibleCompanies(currentUser);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: 'ALL',
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.bold),
          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary, size: 18),
          items: [
            DropdownMenuItem(
              value: 'ALL',
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.apartment, color: AppColors.primaryBlue, size: 16),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      currentUser.isGroupWide
                          ? (isVi ? 'TẬP ĐOÀN VIỆT NAM' : 'VIETNAM GROUP')
                          : (isVi ? 'KHỐI KHÁCH SẠN' : 'HOTELS DIVISION'),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            ...accessibleCompanies.map((cmp) {
              return DropdownMenuItem(
                value: cmp.id,
                child: Text(isVi ? cmp.nameVi : cmp.nameEn, overflow: TextOverflow.ellipsis),
              );
            }),
          ],
          onChanged: (value) {},
        ),
      ),
    );
  }
}
