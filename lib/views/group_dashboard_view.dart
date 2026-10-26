import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_providers.dart';
import '../services/corporate_repository.dart';
import '../theme/app_colors.dart';
import '../utils/formatters.dart';

class GroupDashboardView extends StatefulWidget {
  const GroupDashboardView({super.key});

  @override
  State<GroupDashboardView> createState() => _GroupDashboardViewState();
}

class _GroupDashboardViewState extends State<GroupDashboardView> {
  final Map<String, bool> _expandedVerticals = {};

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();
    final repository = context.watch<CorporateRepository>();
    final appState = context.watch<AppState>();
    final isVi = appState.isVietnamese;
    final currentUser = authService.currentUser;

    final summary = repository.calculateSummaryForUser(currentUser);
    final accessibleVerticals = repository.getAccessibleVerticals(currentUser);
    final currencyBreakdown = repository.getCurrencyBreakdownForUser(currentUser);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 12,
          runSpacing: 8,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isVi ? 'Báo cáo Hợp nhất Tập đoàn' : 'Group Consolidated Dashboard',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isVi
                      ? 'Dữ liệu demo minh họa cho vị thế tài chính và thanh khoản toàn bộ khối kinh doanh'
                      : 'Illustrative demo position and liquidity across business verticals',
                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.history, size: 14, color: AppColors.textMuted),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      '${isVi ? 'Cập nhật' : 'Updated'}: ${Formatters.formatDateTime(DateTime.now())}',
                      style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 600;
            if (isMobile) {
              return Column(
                children: [
                  _buildSummaryCard(
                    title: isVi ? 'Tổng tiền mặt & Ngân hàng' : 'Total Cash & Bank',
                    amount: summary.totalCash,
                    icon: Icons.account_balance_wallet,
                    color: AppColors.primaryBlue,
                    tooltip: isVi ? 'Tổng số dư khả dụng' : 'Total available balances',
                  ),
                  const SizedBox(height: 10),
                  _buildSummaryCard(
                    title: isVi ? 'Tiền gửi có kỳ hạn' : 'Eligible Term Deposits',
                    amount: summary.totalDeposits,
                    icon: Icons.savings,
                    color: AppColors.success,
                    tooltip: isVi ? 'Tiền gửi ngắn hạn' : 'Eligible term deposits',
                  ),
                  const SizedBox(height: 10),
                  _buildSummaryCard(
                    title: isVi ? 'Dư nợ vay ngân hàng' : 'Outstanding Loans',
                    amount: summary.totalLoans,
                    icon: Icons.credit_score,
                    color: AppColors.warning,
                    tooltip: isVi ? 'Tổng dư nợ vay' : 'Total loan obligations',
                  ),
                  const SizedBox(height: 10),
                  _buildSummaryCard(
                    title: isVi ? 'Vị thế Thanh khoản Ròng' : 'Net Liquidity Position',
                    amount: summary.netLiquidity,
                    icon: Icons.pie_chart_outline,
                    color: AppColors.primary,
                    isHighlighted: true,
                    tooltip: isVi ? 'Thanh khoản ròng' : 'Net liquidity',
                  ),
                  const SizedBox(height: 10),
                  _buildPendingApprovalsCard(
                    count: summary.pendingApprovalsCount,
                    totalAmount: summary.pendingApprovalsAmount,
                    isVi: isVi,
                    onTap: () => appState.navigateTo('approvals'),
                  ),
                ],
              );
            }

            final crossAxisCount = constraints.maxWidth > 1100 ? 4 : 2;

            return GridView.count(
              crossAxisCount: crossAxisCount,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.1,
              children: [
                _buildSummaryCard(
                  title: isVi ? 'Tổng tiền mặt & Ngân hàng' : 'Total Cash & Bank',
                  amount: summary.totalCash,
                  icon: Icons.account_balance_wallet,
                  color: AppColors.primaryBlue,
                  tooltip: isVi
                      ? 'Tổng số dư khả dụng tại tất cả ngân hàng'
                      : 'Total available balances across all banks',
                ),
                _buildSummaryCard(
                  title: isVi ? 'Tiền gửi có kỳ hạn' : 'Eligible Term Deposits',
                  amount: summary.totalDeposits,
                  icon: Icons.savings,
                  color: AppColors.success,
                  tooltip: isVi ? 'Các khoản tiền gửi ngắn hạn khả dụng' : 'Eligible liquid term deposits',
                ),
                _buildSummaryCard(
                  title: isVi ? 'Dư nợ vay ngân hàng' : 'Outstanding Loans',
                  amount: summary.totalLoans,
                  icon: Icons.credit_score,
                  color: AppColors.warning,
                  tooltip: isVi ? 'Tổng dư nợ tín dụng trung & dài hạn' : 'Total bank loan obligations',
                ),
                _buildSummaryCard(
                  title: isVi ? 'Hạn mức Thấu chi đã dùng' : 'Utilized Overdraft',
                  amount: summary.totalUtilizedOverdraft,
                  icon: Icons.speed,
                  color: AppColors.danger,
                  tooltip: isVi ? 'Tổng hạn mức thấu chi đã sử dụng' : 'Utilized credit overdraft facilities',
                ),
                _buildSummaryCard(
                  title: isVi ? 'Hạn mức Thấu chi còn lại' : 'Available Overdraft',
                  amount: summary.totalAvailableOverdraft,
                  icon: Icons.verified_user,
                  color: Colors.teal,
                  tooltip: isVi ? 'Hạn mức thấu chi sẵn sàng sử dụng' : 'Remaining available overdraft credit',
                ),
                _buildSummaryCard(
                  title: isVi ? 'Vị thế Thanh khoản Ròng' : 'Net Liquidity Position',
                  amount: summary.netLiquidity,
                  icon: Icons.pie_chart_outline,
                  color: AppColors.primary,
                  isHighlighted: true,
                  tooltip: isVi
                      ? 'Tiền mặt + Tiền gửi - Dư nợ vay - Thấu chi sử dụng'
                      : 'Cash + Deposits - Loans - Utilized Overdraft',
                ),
                _buildPendingApprovalsCard(
                  count: summary.pendingApprovalsCount,
                  totalAmount: summary.pendingApprovalsAmount,
                  isVi: isVi,
                  onTap: () => appState.navigateTo('approvals'),
                ),
              ],
            );
          },
        ),

        const SizedBox(height: 24),

        _buildCurrencyBreakdownBanner(currencyBreakdown, isVi),

        const SizedBox(height: 24),

        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 12,
          runSpacing: 4,
          children: [
            Text(
              isVi ? 'Phân bổ theo Khối Kinh Doanh (5 Verticals)' : 'Business Vertical Breakdown',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            Text(
              isVi ? 'Bấm để mở rộng danh sách công ty' : 'Click row to expand company list',
              style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
          ],
        ),
        const SizedBox(height: 12),

        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: accessibleVerticals.length,
          itemBuilder: (context, index) {
            final vtl = accessibleVerticals[index];
            final vtlSummary = repository.calculateSummaryForUser(
              currentUser,
              verticalId: vtl.id,
            );
            final vtlCompanies = repository
                .getAccessibleCompanies(currentUser)
                .where((c) => c.verticalId == vtl.id)
                .toList();

            final isExpanded = _expandedVerticals[vtl.id] ?? false;

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        _expandedVerticals[vtl.id] = !isExpanded;
                      });
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Icon(
                            isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
                            color: AppColors.primaryBlue,
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primaryBlueLight,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(_getIconData(vtl.iconName), color: AppColors.primaryBlue, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isVi ? vtl.nameVi : vtl.nameEn,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                ),
                                Text(
                                  '${vtlCompanies.length} ${isVi ? 'Công ty thành viên' : 'Companies'}',
                                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: _buildVerticalMetricCell(
                              label: isVi ? 'Tiền mặt' : 'Cash',
                              value: Formatters.formatCurrency(vtlSummary.totalCash, 'VND', compact: true),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: _buildVerticalMetricCell(
                              label: isVi ? 'Dư nợ vay' : 'Loans',
                              value: Formatters.formatCurrency(vtlSummary.totalLoans, 'VND', compact: true),
                              textColor: vtlSummary.totalLoans > 0 ? AppColors.warning : AppColors.textPrimary,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: _buildVerticalMetricCell(
                              label: isVi ? 'Thanh khoản ròng' : 'Net Liquidity',
                              value: Formatters.formatCurrency(vtlSummary.netLiquidity, 'VND', compact: true),
                              textColor: vtlSummary.netLiquidity >= 0 ? AppColors.success : AppColors.danger,
                              isBold: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  if (isExpanded) ...[
                    const Divider(height: 1, color: AppColors.cardBorder),
                    Container(
                      color: AppColors.background,
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: vtlCompanies.map((cmp) {
                          final cmpSummary = repository.calculateSummaryForUser(
                            currentUser,
                            companyId: cmp.id,
                          );

                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.cardBorder),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.business, color: AppColors.textSecondary, size: 18),
                                const SizedBox(width: 12),
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        isVi ? cmp.nameVi : cmp.nameEn,
                                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                                      ),
                                      Text(
                                        'MST: ${cmp.taxCode}',
                                        style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    Formatters.formatCurrency(cmpSummary.totalCash, 'VND', compact: true),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    Formatters.formatCurrency(cmpSummary.totalLoans, 'VND', compact: true),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: cmpSummary.totalLoans > 0 ? AppColors.warning : AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    Formatters.formatCurrency(cmpSummary.netLiquidity, 'VND', compact: true),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: cmpSummary.netLiquidity >= 0 ? AppColors.success : AppColors.danger,
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryBlueLight,
                                    foregroundColor: AppColors.primaryBlue,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  ),
                                  onPressed: () {
                                    appState.navigateTo('companies', companyId: cmp.id);
                                  },
                                  child: Text(isVi ? 'Chi tiết' : 'Drill-down', style: const TextStyle(fontSize: 11)),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required double amount,
    required IconData icon,
    required Color color,
    required String tooltip,
    bool isHighlighted = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isHighlighted ? AppColors.primary : AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isHighlighted ? AppColors.primary : AppColors.cardBorder),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isHighlighted ? Colors.white70 : AppColors.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              Tooltip(
                message: tooltip,
                child: Icon(icon, color: isHighlighted ? Colors.white : color, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            Formatters.formatCurrency(amount, 'VND', compact: true),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isHighlighted ? Colors.white : AppColors.textPrimary,
            ),
          ),
          Text(
            Formatters.formatCurrency(amount, 'VND', compact: false),
            style: TextStyle(
              fontSize: 10,
              color: isHighlighted ? Colors.white54 : AppColors.textMuted,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildPendingApprovalsCard({
    required int count,
    required double totalAmount,
    required bool isVi,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.warningBg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    isVi ? 'Chờ phê duyệt' : 'Pending Approvals',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.warning,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.warning,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$count',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              Formatters.formatCurrency(totalAmount, 'VND', compact: true),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.warning,
              ),
            ),
            Text(
              isVi ? 'Bấm để mở danh sách duyệt' : 'Click to review queue',
              style: const TextStyle(fontSize: 10, color: AppColors.warning),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencyBreakdownBanner(
    Map<String, Map<String, double>> currencyBreakdown,
    bool isVi,
  ) {
    final usdData = currencyBreakdown['USD']!;
    final usdBalance = usdData['cash']!;
    final usdConverted = usdData['convertedVnd']!;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primaryBlueLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primaryBlue.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.currency_exchange, color: AppColors.primaryBlue, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isVi
                  ? 'Vị thế Ngoại tệ: Số dư USD nguyên tệ: ${Formatters.formatCurrency(usdBalance, 'USD')} (Quy đổi tương đương ~${Formatters.formatCurrency(usdConverted, 'VND', compact: true)} theo tỷ giá 1 USD = 25.400 VND)'
                  : 'Foreign Currency Position: USD Balance: ${Formatters.formatCurrency(usdBalance, 'USD')} (Converted ~${Formatters.formatCurrency(usdConverted, 'VND', compact: true)} @ 25,400 VND/USD)',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalMetricCell({
    required String label,
    required String value,
    Color textColor = AppColors.textPrimary,
    bool isBold = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            color: textColor,
          ),
        ),
      ],
    );
  }

  IconData _getIconData(String name) {
    switch (name) {
      case 'attractions':
        return Icons.attractions;
      case 'hotel':
        return Icons.hotel;
      case 'flight':
        return Icons.flight;
      case 'domain':
        return Icons.domain;
      case 'shopping_bag':
        return Icons.shopping_bag;
      default:
        return Icons.business;
    }
  }
}
