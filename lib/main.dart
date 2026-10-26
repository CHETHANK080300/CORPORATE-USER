import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_providers.dart';
import 'services/corporate_repository.dart';
import 'theme/app_colors.dart';
import 'views/cio_overview_dashboard_view.dart';
import 'views/company_detail_view.dart';
import 'views/liquidity_analysis_view.dart';
import 'views/login_view.dart';
import 'views/pending_approvals_view.dart';
import 'widgets/main_layout.dart';

void main() {
  runApp(const CorporateBankingApp());
}

class CorporateBankingApp extends StatelessWidget {
  const CorporateBankingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CorporateRepository()),
        ChangeNotifierProxyProvider<CorporateRepository, AuthService>(
          create: (ctx) => AuthService(ctx.read<CorporateRepository>()),
          update: (ctx, repo, auth) => auth ?? AuthService(repo),
        ),
        ChangeNotifierProvider(create: (_) => AppState()),
      ],
      child: Consumer<AppState>(
        builder: (context, appState, child) {
          return MaterialApp(
            title: 'Treasury Dashboard',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              useMaterial3: true,
              scaffoldBackgroundColor: AppColors.background,
              colorScheme: ColorScheme.fromSeed(
                seedColor: AppColors.primary,
                primary: AppColors.primary,
                surface: AppColors.surface,
              ),
              fontFamily: 'Roboto',
            ),
            home: const AppEntryWidget(),
          );
        },
      ),
    );
  }
}

class AppEntryWidget extends StatelessWidget {
  const AppEntryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();

    if (!authService.isLoggedIn) {
      return const LoginView();
    }

    return const RootShell();
  }
}

class RootShell extends StatelessWidget {
  const RootShell({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainLayout(
      child: CioOverviewDashboardView(),
    );
  }
}
