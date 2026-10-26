import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/app_providers.dart';
import '../services/corporate_repository.dart';
import '../theme/app_colors.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController(text: 'minh.nguyen@vietnamcorp.vn');
  final _passwordController = TextEditingController(text: '••••••••••••');
  User? _selectedUser;

  @override
  void initState() {
    super.initState();
    final repo = context.read<CorporateRepository>();
    _selectedUser = repo.users.first;
  }

  @override
  Widget build(BuildContext context) {
    final repository = context.watch<CorporateRepository>();
    final authService = context.watch<AuthService>();
    final appState = context.watch<AppState>();
    final isVi = appState.isVietnamese;

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 480),
            padding: const EdgeInsets.all(32.0),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 20,
                  offset: Offset(0, 8),
                )
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Language Switcher at Top Right
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.primaryBlue,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Icon(Icons.account_balance, color: Colors.white, size: 18),
                          ),
                          const SizedBox(width: 6),
                          const Flexible(
                            child: Text(
                              'VIETNAM BANK',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                                letterSpacing: 0.5,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                        onPressed: () => appState.toggleLocale(),
                        icon: const Icon(Icons.language, size: 16),
                        label: Text(isVi ? 'English' : 'Tiếng Việt', style: const TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  Text(
                    isVi ? 'Đăng nhập Ngân hàng Doanh nghiệp' : 'Corporate Banking Login',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    isVi ? 'Cổng quản trị Nguồn vốn & Thanh khoản Tập đoàn' : 'Consolidated Group Treasury & Liquidity Portal',
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 28),

                  // Quick Demo User Selector Section
                  Text(
                    isVi ? 'Chọn tài khoản Demo để đăng nhập:' : 'Select Demo Account Role:',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 8),

                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<User>(
                        isExpanded: true,
                        value: _selectedUser,
                        items: repository.users.map((u) {
                          return DropdownMenuItem<User>(
                            value: u,
                            child: Text(
                              '${u.name} — ${isVi ? u.role.displayNameVi : u.role.displayNameEn}',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: (user) {
                          if (user != null) {
                            setState(() {
                              _selectedUser = user;
                              _usernameController.text = user.email;
                            });
                          }
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Username Field
                  Text(
                    isVi ? 'Tên đăng nhập / Email' : 'Username / Email',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_outline, size: 20),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Password Field
                  Text(
                    isVi ? 'Mật khẩu' : 'Password',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_outline, size: 20),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Login Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                    onPressed: () {
                      if (_selectedUser != null) {
                        authService.login(_selectedUser!);
                        if (_selectedUser!.role == UserRole.companyAccountantHotels) {
                          appState.navigateTo('overview', verticalId: 'vtl-hotels');
                        } else {
                          appState.navigateTo('overview');
                        }
                      }
                    },
                    child: Text(
                      isVi ? 'ĐĂNG NHẬP' : 'LOGIN',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Footer Notice
                  Text(
                    isVi
                        ? '* Hệ thống Demo minh họa môi trường Corporate Banking dành cho Tập đoàn Việt Nam'
                        : '* Demo system showcasing Vietnam Corporate Banking Consolidated Gateway',
                    style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
