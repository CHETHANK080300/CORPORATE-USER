import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/corporate_repository.dart';
import '../widgets/cio_activity_alerts.dart';
import '../widgets/cio_kpi_cards.dart';
import '../widgets/cio_primary_charts.dart';
import '../widgets/cio_secondary_widgets.dart';

class CioOverviewDashboardView extends StatelessWidget {
  const CioOverviewDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = context.watch<CorporateRepository>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: KPI Cards
          CioKpiCards(summary: repo.cioKpiSummary),
          const SizedBox(height: 24),

          // Row 2: Charts & Top Entities
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth >= 1024) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: CurrencySpendCard(
                        items: repo.currencySpendList,
                        totalCashUsd: repo.cioKpiSummary.globalCashPosition,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 4,
                      child: CashForecastCard(points: repo.forecastPoints),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 4,
                      child: TopEntitiesCard(entities: repo.topEntities),
                    ),
                  ],
                );
              } else {
                return Column(
                  children: [
                    CurrencySpendCard(
                      items: repo.currencySpendList,
                      totalCashUsd: repo.cioKpiSummary.globalCashPosition,
                    ),
                    const SizedBox(height: 20),
                    CashForecastCard(points: repo.forecastPoints),
                    const SizedBox(height: 20),
                    TopEntitiesCard(entities: repo.topEntities),
                  ],
                );
              }
            },
          ),
          const SizedBox(height: 24),

          // Row 3: Country Positions, Sweep/Pooling & FX Exposure
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth >= 1024) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: CountryPositionsCard(positions: repo.countryPositions),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 4,
                      child: SweepPoolingCard(metrics: repo.utilizationMetrics),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 4,
                      child: RiskExposureCard(exposures: repo.riskExposures),
                    ),
                  ],
                );
              } else {
                return Column(
                  children: [
                    CountryPositionsCard(positions: repo.countryPositions),
                    const SizedBox(height: 20),
                    SweepPoolingCard(metrics: repo.utilizationMetrics),
                    const SizedBox(height: 20),
                    RiskExposureCard(exposures: repo.riskExposures),
                  ],
                );
              }
            },
          ),
          const SizedBox(height: 24),

          // Row 4: Recent Transactions & Alerts
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth >= 1024) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 7,
                      child: RecentTransactionsCard(items: repo.recentActivities),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 5,
                      child: SystemAlertsCard(alerts: repo.systemAlerts),
                    ),
                  ],
                );
              } else {
                return Column(
                  children: [
                    RecentTransactionsCard(items: repo.recentActivities),
                    const SizedBox(height: 20),
                    SystemAlertsCard(alerts: repo.systemAlerts),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
