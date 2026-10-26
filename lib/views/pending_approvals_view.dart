import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/app_providers.dart';
import '../services/corporate_repository.dart';
import '../theme/app_colors.dart';
import '../utils/formatters.dart';

class PendingApprovalsView extends StatefulWidget {
  const PendingApprovalsView({super.key});

  @override
  State<PendingApprovalsView> createState() => _PendingApprovalsViewState();
}

class _PendingApprovalsViewState extends State<PendingApprovalsView> {
  String _searchQuery = '';
  String _selectedStatus = 'ALL';

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();
    final repository = context.watch<CorporateRepository>();
    final appState = context.watch<AppState>();
    final isVi = appState.isVietnamese;
    final currentUser = authService.currentUser;

    var accessibleTxList = repository.getAccessibleTransactions(currentUser);

    if (_searchQuery.isNotEmpty) {
      accessibleTxList = accessibleTxList.where((t) {
        return t.referenceNumber.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            t.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            t.counterparty.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    if (_selectedStatus != 'ALL') {
      accessibleTxList = accessibleTxList.where((t) {
        if (_selectedStatus == 'PENDING') return t.status == TransactionStatus.pendingApproval;
        if (_selectedStatus == 'APPROVED') return t.status == TransactionStatus.approved;
        if (_selectedStatus == 'REJECTED') return t.status == TransactionStatus.rejected;
        return true;
      }).toList();
    }

    final pendingList = accessibleTxList.where((t) => t.status == TransactionStatus.pendingApproval).toList();
    final double pendingVndSum = pendingList.fold(
      0.0,
      (sum, t) => sum + repository.convertToVnd(t.amount, t.currency),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isVi ? 'Danh sách Phê duyệt Tập trung' : 'Unified Pending Approvals',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          isVi
              ? 'Xem và duyệt các giao dịch thanh toán trong phạm vi thẩm quyền'
              : 'Review and approve eligible corporate transactions within authorization limits',
          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 20),

        Row(
          children: [
            _buildApprovalSummaryCard(
              title: isVi ? 'Giao dịch Chờ duyệt' : 'Pending Items',
              value: '${pendingList.length}',
              icon: Icons.hourglass_top,
              color: AppColors.warning,
            ),
            const SizedBox(width: 16),
            _buildApprovalSummaryCard(
              title: isVi ? 'Tổng Giá trị Chờ duyệt' : 'Total Pending Value',
              value: Formatters.formatCurrency(pendingVndSum, 'VND', compact: true),
              icon: Icons.monetization_on,
              color: AppColors.primaryBlue,
            ),
          ],
        ),

        const SizedBox(height: 20),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search, size: 20),
                    hintText: isVi ? 'Tìm theo mã FT, nội dung, đối tác...' : 'Search by FT ref, description, counterparty...',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val;
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              DropdownButton<String>(
                value: _selectedStatus,
                items: [
                  DropdownMenuItem(value: 'ALL', child: Text(isVi ? 'Tất cả trạng thái' : 'All Statuses')),
                  DropdownMenuItem(value: 'PENDING', child: Text(isVi ? 'Chờ phê duyệt' : 'Pending Approval')),
                  DropdownMenuItem(value: 'APPROVED', child: Text(isVi ? 'Đã phê duyệt' : 'Approved')),
                  DropdownMenuItem(value: 'REJECTED', child: Text(isVi ? 'Đã từ chối' : 'Rejected')),
                ],
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedStatus = val;
                    });
                  }
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: accessibleTxList.isEmpty
              ? Container(
                  padding: const EdgeInsets.all(40),
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      const Icon(Icons.check_circle_outline, size: 48, color: AppColors.textMuted),
                      const SizedBox(height: 12),
                      Text(
                        isVi ? 'Không có giao dịch nào phù hợp' : 'No transactions found',
                        style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text(isVi ? 'Mã Giao dịch (FT)' : 'Ref Number')),
                      DataColumn(label: Text(isVi ? 'Công ty' : 'Company')),
                      DataColumn(label: Text(isVi ? 'Loại giao dịch' : 'Type')),
                      DataColumn(label: Text(isVi ? 'Số tiền' : 'Amount')),
                      DataColumn(label: Text(isVi ? 'Người khởi tạo' : 'Initiator')),
                      DataColumn(label: Text(isVi ? 'Ngày tạo' : 'Date')),
                      DataColumn(label: Text(isVi ? 'Trạng thái' : 'Status')),
                      DataColumn(label: Text(isVi ? 'Thao tác' : 'Actions')),
                    ],
                    rows: accessibleTxList.map((tx) {
                      final company = repository.companies.firstWhere(
                        (c) => c.id == tx.companyId,
                        orElse: () => const Company(
                          id: '',
                          code: '',
                          nameVi: 'Khác',
                          nameEn: 'Other',
                          verticalId: '',
                          taxCode: '',
                          address: '',
                        ),
                      );

                      return DataRow(cells: [
                        DataCell(
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(tx.referenceNumber, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                              Text(tx.counterparty, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
                            ],
                          ),
                        ),
                        DataCell(Text(isVi ? company.nameVi : company.nameEn, style: const TextStyle(fontSize: 12))),
                        DataCell(Text(tx.transactionType, style: const TextStyle(fontSize: 12))),
                        DataCell(
                          Text(
                            Formatters.formatCurrency(tx.amount, tx.currency),
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
                        DataCell(Text(tx.initiator, style: const TextStyle(fontSize: 12))),
                        DataCell(Text(Formatters.formatDateTime(tx.date), style: const TextStyle(fontSize: 12))),
                        DataCell(_buildStatusBadge(tx.status, isVi)),
                        DataCell(
                          tx.status == TransactionStatus.pendingApproval
                              ? Row(
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.success,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                      ),
                                      onPressed: () => _handleApprove(context, tx, currentUser, repository, isVi),
                                      child: Text(isVi ? 'Duyệt' : 'Approve', style: const TextStyle(fontSize: 11)),
                                    ),
                                    const SizedBox(width: 8),
                                    OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: AppColors.danger,
                                        side: const BorderSide(color: AppColors.danger),
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                      ),
                                      onPressed: () => _handleReject(context, tx, currentUser, repository, isVi),
                                      child: Text(isVi ? 'Từ chối' : 'Reject', style: const TextStyle(fontSize: 11)),
                                    ),
                                  ],
                                )
                              : Text(
                                  tx.status == TransactionStatus.approved
                                      ? (isVi ? 'Đã hoàn tất' : 'Done')
                                      : (isVi ? 'Đã hủy' : 'Rejected'),
                                  style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
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

  Widget _buildApprovalSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
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
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                const SizedBox(height: 2),
                Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(TransactionStatus status, bool isVi) {
    Color bg;
    Color text;
    String label;

    switch (status) {
      case TransactionStatus.pendingApproval:
        bg = AppColors.warningBg;
        text = AppColors.warning;
        label = isVi ? 'Chờ duyệt' : 'Pending';
        break;
      case TransactionStatus.approved:
      case TransactionStatus.completed:
        bg = AppColors.successBg;
        text = AppColors.success;
        label = isVi ? 'Đã duyệt' : 'Approved';
        break;
      case TransactionStatus.rejected:
        bg = AppColors.dangerBg;
        text = AppColors.danger;
        label = isVi ? 'Từ chối' : 'Rejected';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
      child: Text(label, style: TextStyle(color: text, fontWeight: FontWeight.bold, fontSize: 11)),
    );
  }

  void _handleApprove(
    BuildContext context,
    Transaction tx,
    User currentUser,
    CorporateRepository repository,
    bool isVi,
  ) {
    final success = repository.approveTransaction(tx.id, currentUser);
    if (!success) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.error_outline, color: AppColors.danger),
              const SizedBox(width: 8),
              Text(isVi ? 'Không thể duyệt' : 'Approval Denied'),
            ],
          ),
          content: Text(
            isVi
                ? 'Quy tắc Maker-Checker: Bạn không thể tự phê duyệt lệnh thanh toán do chính mình tạo ra (${tx.initiator}).'
                : 'Maker-Checker Rule: You cannot approve transactions created by yourself (${tx.initiator}).',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isVi
                ? 'Đã phê duyệt thành công giao dịch ${tx.referenceNumber}'
                : 'Approved transaction ${tx.referenceNumber} successfully',
          ),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  void _handleReject(
    BuildContext context,
    Transaction tx,
    User currentUser,
    CorporateRepository repository,
    bool isVi,
  ) {
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isVi ? 'Từ chối giao dịch' : 'Reject Transaction'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(isVi ? 'Mã giao dịch: ${tx.referenceNumber}' : 'Ref: ${tx.referenceNumber}'),
            const SizedBox(height: 12),
            TextField(
              controller: reasonController,
              decoration: InputDecoration(
                labelText: isVi ? 'Lý do từ chối' : 'Rejection Reason',
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(isVi ? 'Hủy' : 'Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () {
              final reason = reasonController.text.trim();
              repository.rejectTransaction(tx.id, currentUser, reason.isEmpty ? 'Không đạt điều kiện' : reason);
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isVi ? 'Đã từ chối giao dịch' : 'Transaction rejected'),
                  backgroundColor: AppColors.danger,
                ),
              );
            },
            child: Text(isVi ? 'Xác nhận từ chối' : 'Confirm Reject'),
          ),
        ],
      ),
    );
  }
}
