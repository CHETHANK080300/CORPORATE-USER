import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/app_providers.dart';
import '../services/corporate_repository.dart';
import '../theme/app_colors.dart';
import '../utils/formatters.dart';

class CompanyDetailView extends StatelessWidget {
  final String? companyId;

  const CompanyDetailView({super.key, this.companyId});

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();
    final repository = context.watch<CorporateRepository>();
    final appState = context.watch<AppState>();
    final isVi = appState.isVietnamese;
    final currentUser = authService.currentUser;

    final accessibleCompanies = repository.getAccessibleCompanies(currentUser);

    final selectedCmpId = (companyId != null && repository.isCompanyAccessible(currentUser, companyId!))
        ? companyId!
        : (accessibleCompanies.isNotEmpty ? accessibleCompanies.first.id : '');

    if (selectedCmpId.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(40),
        alignment: Alignment.center,
        child: Text(
          isVi ? 'Bạn không có quyền truy cập công ty nào.' : 'No accessible companies found.',
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 16),
        ),
      );
    }

    final company = accessibleCompanies.firstWhere((c) => c.id == selectedCmpId);
    final companySummary = repository.calculateSummaryForUser(currentUser, companyId: company.id);
    final companyAccounts = repository
        .getAccessibleAccounts(currentUser)
        .where((a) => a.companyId == company.id)
        .toList();
    final companyTransactions = repository
        .getAccessibleTransactions(currentUser)
        .where((t) => t.companyId == company.id)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            InkWell(
              onTap: () => appState.navigateTo('overview'),
              child: Text(
                isVi ? 'Tổng quan Group' : 'Group Overview',
                style: const TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.w600, fontSize: 13),
              ),
            ),
            const Icon(Icons.chevron_right, size: 16, color: AppColors.textMuted),
            Text(
              isVi ? company.nameVi : company.nameEn,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
          ],
        ),

        const SizedBox(height: 12),

        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlueLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.business, color: AppColors.primaryBlue, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isVi ? company.nameVi : company.nameEn,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'MST: ${company.taxCode}  |  ${company.address}',
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        Row(
          children: [
            _buildCompanyMetricCard(
              isVi ? 'Số dư Tiền mặt' : 'Cash Balance',
              Formatters.formatCurrency(companySummary.totalCash, 'VND', compact: true),
              Icons.account_balance_wallet,
              AppColors.primaryBlue,
            ),
            const SizedBox(width: 16),
            _buildCompanyMetricCard(
              isVi ? 'Tiền gửi ngắn hạn' : 'Term Deposits',
              Formatters.formatCurrency(companySummary.totalDeposits, 'VND', compact: true),
              Icons.savings,
              AppColors.success,
            ),
            const SizedBox(width: 16),
            _buildCompanyMetricCard(
              isVi ? 'Thanh khoản Ròng' : 'Net Liquidity',
              Formatters.formatCurrency(companySummary.netLiquidity, 'VND', compact: true),
              Icons.pie_chart,
              companySummary.netLiquidity >= 0 ? AppColors.success : AppColors.danger,
            ),
          ],
        ),

        const SizedBox(height: 24),

        Text(
          isVi ? 'Danh sách Tài khoản Ngân hàng' : 'Bank Accounts List',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                DataColumn(label: Text(isVi ? 'Số tài khoản' : 'Account Number')),
                DataColumn(label: Text(isVi ? 'Ngân hàng' : 'Bank')),
                DataColumn(label: Text(isVi ? 'Loại tài khoản' : 'Account Type')),
                DataColumn(label: Text(isVi ? 'Số dư Khả dụng' : 'Available Balance')),
                DataColumn(label: Text(isVi ? 'Số dư Sổ sách' : 'Ledger Balance')),
                DataColumn(label: Text(isVi ? 'Loại tiền' : 'Currency')),
                DataColumn(label: Text(isVi ? 'Trạng thái' : 'Status')),
              ],
              rows: companyAccounts.map((acc) {
                return DataRow(cells: [
                  DataCell(
                    Text(acc.accountNumber, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                  DataCell(Text(acc.bankName, style: const TextStyle(fontSize: 12))),
                  DataCell(Text(acc.accountType, style: const TextStyle(fontSize: 12))),
                  DataCell(
                    Text(
                      Formatters.formatCurrency(acc.balance, acc.currency),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primaryBlue),
                    ),
                  ),
                  DataCell(Text(Formatters.formatCurrency(acc.ledgerBalance, acc.currency), style: const TextStyle(fontSize: 12))),
                  DataCell(Text(acc.currency, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: AppColors.successBg, borderRadius: BorderRadius.circular(4)),
                      child: Text(acc.status, style: const TextStyle(color: AppColors.success, fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ]);
              }).toList(),
            ),
          ),
        ),

        const SizedBox(height: 24),

        Text(
          isVi ? 'Nhật ký Giao dịch Gần đây' : 'Recent Transactions Log',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: companyTransactions.isEmpty
              ? Container(
                  padding: const EdgeInsets.all(24),
                  alignment: Alignment.center,
                  child: Text(
                    isVi ? 'Chưa có giao dịch nào' : 'No transactions recorded',
                    style: const TextStyle(color: AppColors.textMuted),
                  ),
                )
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text(isVi ? 'Mã FT' : 'Ref FT')),
                      DataColumn(label: Text(isVi ? 'Loại' : 'Type')),
                      DataColumn(label: Text(isVi ? 'Đối tác' : 'Counterparty')),
                      DataColumn(label: Text(isVi ? 'Số tiền' : 'Amount')),
                      DataColumn(label: Text(isVi ? 'Thời gian' : 'Time')),
                      DataColumn(label: Text(isVi ? 'Trạng thái' : 'Status')),
                    ],
                    rows: companyTransactions.map((tx) {
                      return DataRow(cells: [
                        DataCell(Text(tx.referenceNumber, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                        DataCell(Text(tx.transactionType, style: const TextStyle(fontSize: 12))),
                        DataCell(Text(tx.counterparty, style: const TextStyle(fontSize: 12))),
                        DataCell(Text(Formatters.formatCurrency(tx.amount, tx.currency), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                        DataCell(Text(Formatters.formatDateTime(tx.date), style: const TextStyle(fontSize: 12))),
                        DataCell(
                          Text(
                            tx.status == TransactionStatus.approved
                                ? (isVi ? 'Đã duyệt' : 'Approved')
                                : (tx.status == TransactionStatus.pendingApproval
                                    ? (isVi ? 'Chờ duyệt' : 'Pending')
                                    : (isVi ? 'Từ chối' : 'Rejected')),
                            style: TextStyle(
                              fontSize: 12,
                              color: tx.status == TransactionStatus.approved
                                  ? AppColors.success
                                  : (tx.status == TransactionStatus.pendingApproval ? AppColors.warning : AppColors.danger),
                            ),
                          ),
                        ),
                      ]);
                    }).toList(),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildCompanyMetricCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                const SizedBox(height: 2),
                Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
