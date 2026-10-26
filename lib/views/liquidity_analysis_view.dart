import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/app_providers.dart';
import '../services/corporate_repository.dart';
import '../theme/app_colors.dart';
import '../utils/formatters.dart';

class LiquidityAnalysisView extends StatelessWidget {
  const LiquidityAnalysisView({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();
    final repository = context.watch<CorporateRepository>();
    final appState = context.watch<AppState>();
    final isVi = appState.isVietnamese;
    final currentUser = authService.currentUser;

    final accessibleVerticals = repository.getAccessibleVerticals(currentUser);
    final groupSummary = repository.calculateSummaryForUser(currentUser);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isVi ? 'Phân tích Thanh khoản & Vay nợ' : 'Liquidity & Borrowing Analysis',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          isVi
              ? 'Phân tích đối ứng giữa các đơn vị dồi dào tiền mặt và các đơn vị phụ thuộc nguồn vay'
              : 'Analysis comparing cash-rich verticals against borrowing-dependent verticals',
          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 20),

        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isVi ? 'Vị thế Thanh khoản Ròng theo Khối Kinh doanh' : 'Net Liquidity Position by Vertical',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ...accessibleVerticals.map((vtl) {
                final vSummary = repository.calculateSummaryForUser(currentUser, verticalId: vtl.id);
                final maxScale = groupSummary.totalCash.abs() > 0 ? groupSummary.totalCash : 1.0;
                final ratio = (vSummary.netLiquidity / maxScale).clamp(-1.0, 1.0);

                final isPositive = vSummary.netLiquidity >= 0;

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                isVi ? vtl.nameVi : vtl.nameEn,
                                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: isPositive ? AppColors.successBg : AppColors.dangerBg,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  isPositive ? (isVi ? 'Thặng dư tiền' : 'Cash Rich') : (isVi ? 'Sử dụng Vay' : 'Borrowing Heavy'),
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: isPositive ? AppColors.success : AppColors.danger,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            Formatters.formatCurrency(vSummary.netLiquidity, 'VND', compact: true),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: isPositive ? AppColors.success : AppColors.danger,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Stack(
                        children: [
                          Container(
                            height: 10,
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          FractionallySizedBox(
                            widthFactor: ratio.abs().clamp(0.05, 1.0),
                            child: Container(
                              height: 10,
                              decoration: BoxDecoration(
                                color: isPositive ? AppColors.success : AppColors.danger,
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),

        const SizedBox(height: 20),

        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isVi ? 'Chi tiết Danh mục Vay & Hạn mức Thấu chi' : 'Loans & Overdraft Credit Schedule',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text(isVi ? 'Số Hợp đồng / Ngân hàng' : 'Contract / Bank')),
                    DataColumn(label: Text(isVi ? 'Công ty' : 'Company')),
                    DataColumn(label: Text(isVi ? 'Dư nợ Vay' : 'Outstanding Loan')),
                    DataColumn(label: Text(isVi ? 'Thấu chi đã dùng' : 'Utilized Overdraft')),
                    DataColumn(label: Text(isVi ? 'Lãi suất (%/năm)' : 'Interest Rate')),
                    DataColumn(label: Text(isVi ? 'Đáo hạn' : 'Maturity Date')),
                  ],
                  rows: repository.getAccessibleLoans(currentUser).map((loan) {
                    final cmp = repository.companies.firstWhere((c) => c.id == loan.companyId);
                    final ovd = repository.overdrafts.firstWhere(
                      (o) => o.companyId == loan.companyId,
                      orElse: () => const Overdraft(
                        id: '',
                        companyId: '',
                        bankName: '',
                        creditLimit: 0,
                        utilizedAmount: 0,
                        currency: 'VND',
                      ),
                    );

                    return DataRow(cells: [
                      DataCell(Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(loan.loanContractNumber, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          Text(loan.bankName, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
                        ],
                      )),
                      DataCell(Text(isVi ? cmp.nameVi : cmp.nameEn, style: const TextStyle(fontSize: 12))),
                      DataCell(Text(Formatters.formatCurrency(loan.outstandingBalance, 'VND', compact: true))),
                      DataCell(Text(Formatters.formatCurrency(ovd.utilizedAmount, 'VND', compact: true))),
                      DataCell(Text('${loan.interestRate}%')),
                      DataCell(Text(Formatters.formatDate(loan.maturityDate))),
                    ]);
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
