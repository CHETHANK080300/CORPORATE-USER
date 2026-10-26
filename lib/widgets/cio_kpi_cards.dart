import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_colors.dart';
import '../utils/formatters.dart';

class CioKpiCards extends StatelessWidget {
  final CioKpiSummary summary;

  const CioKpiCards({
    super.key,
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 1200
            ? 5
            : constraints.maxWidth > 800
                ? 3
                : constraints.maxWidth > 500
                    ? 2
                    : 1;

        return GridView.count(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          shrinkWrap: true,
          childAspectRatio: 2.2,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildKpiCard(
              title: 'Global Cash Position',
              value: Formatters.formatCompactUsd(summary.globalCashPosition),
              subtitle: 'Total Across All Currencies',
              changePct: summary.cashChangePct,
              icon: Icons.account_balance_wallet_outlined,
              iconBg: const Color(0xFFEEF2FF),
              iconColor: AppColors.primary,
            ),
            _buildKpiCard(
              title: 'Available Cash',
              value: Formatters.formatCompactUsd(summary.availableCash),
              subtitle: 'Immediately Available',
              changePct: summary.availableChangePct,
              icon: Icons.account_balance_outlined,
              iconBg: const Color(0xFFF3E8FF),
              iconColor: AppColors.accentPurple,
            ),
            _buildKpiCard(
              title: 'Intra-day Liquidity',
              value: Formatters.formatCompactUsd(summary.intradayLiquidity),
              subtitle: 'From Sweeps & Pools',
              changePct: summary.liquidityChangePct,
              icon: Icons.sync_alt,
              iconBg: const Color(0xFFF3E8FF),
              iconColor: AppColors.accentPurple,
            ),
            _buildKpiCard(
              title: '7-Day Forecast',
              value: Formatters.formatCompactUsd(summary.forecast7Day),
              subtitle: 'Projected Ending Balance',
              changePct: summary.forecastChangePct,
              icon: Icons.trending_up,
              iconBg: const Color(0xFFEEF2FF),
              iconColor: AppColors.primary,
            ),
            _buildKpiCard(
              title: 'Entities',
              value: '${summary.totalEntities}',
              subtitle: 'Across ${summary.totalCountries} Countries',
              extraSubtitle: '${summary.newEntitiesThisMonth} new vs last month',
              icon: Icons.language,
              iconBg: const Color(0xFFE0F2FE),
              iconColor: const Color(0xFF0284C7),
            ),
          ],
        );
      },
    );
  }

  Widget _buildKpiCard({
    required String title,
    required String value,
    required String subtitle,
    double? changePct,
    String? extraSubtitle,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textMuted,
                  ),
                ),
                if (changePct != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        changePct >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
                        size: 12,
                        color: changePct >= 0 ? AppColors.success : AppColors.danger,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${changePct.abs()}% vs last month',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: changePct >= 0 ? AppColors.success : AppColors.danger,
                        ),
                      ),
                    ],
                  ),
                ] else if (extraSubtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    extraSubtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
