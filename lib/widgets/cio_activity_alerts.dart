import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_colors.dart';
import '../utils/formatters.dart';

class RecentTransactionsCard extends StatelessWidget {
  final List<RecentActivityItem> items;

  const RecentTransactionsCard({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Transactions',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'View All',
                  style: TextStyle(fontSize: 12, color: AppColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 20,
              headingRowHeight: 36,
              dataRowMinHeight: 40,
              dataRowMaxHeight: 44,
              columns: const [
                DataColumn(label: Text('Date', style: TextStyle(fontSize: 11, color: AppColors.textMuted, fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Entity', style: TextStyle(fontSize: 11, color: AppColors.textMuted, fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Type', style: TextStyle(fontSize: 11, color: AppColors.textMuted, fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Currency', style: TextStyle(fontSize: 11, color: AppColors.textMuted, fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Amount', style: TextStyle(fontSize: 11, color: AppColors.textMuted, fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Status', style: TextStyle(fontSize: 11, color: AppColors.textMuted, fontWeight: FontWeight.bold))),
              ],
              rows: items.map((item) {
                return DataRow(
                  cells: [
                    DataCell(Text(item.dateStr, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary))),
                    DataCell(Text(item.entityName, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textPrimary))),
                    DataCell(Text(item.type, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary))),
                    DataCell(Text(item.currency, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary))),
                    DataCell(Text(
                      Formatters.formatCurrency(item.amount, item.currency, compact: false),
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    )),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.successBg,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          item.status,
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.success),
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class SystemAlertsCard extends StatelessWidget {
  final List<SystemAlertItem> alerts;

  const SystemAlertsCard({
    super.key,
    required this.alerts,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Alerts',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'View All',
                  style: TextStyle(fontSize: 12, color: AppColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            children: alerts.map((a) {
              Color iconColor;
              Color iconBg;
              IconData iconData;

              switch (a.alertType) {
                case 'danger':
                  iconColor = AppColors.danger;
                  iconBg = AppColors.dangerBg;
                  iconData = Icons.error_outline;
                  break;
                case 'warning':
                  iconColor = AppColors.warning;
                  iconBg = AppColors.warningBg;
                  iconData = Icons.warning_amber;
                  break;
                default:
                  iconColor = AppColors.info;
                  iconBg = AppColors.infoBg;
                  iconData = Icons.info_outline;
              }

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: iconBg,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(iconData, color: iconColor, size: 16),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            a.title,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            a.description,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      a.timeAgo,
                      style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
