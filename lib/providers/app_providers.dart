import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../services/corporate_repository.dart';

class AuthService extends ChangeNotifier {
  final CorporateRepository _repository;
  User _currentUser;
  bool _isLoggedIn = false;

  AuthService(this._repository)
      : _currentUser = _repository.users.first;

  User get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;
  List<User> get allDemoUsers => _repository.users;

  void login(User user) {
    _currentUser = user;
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }

  void switchUser(User newUser) {
    _currentUser = newUser;
    notifyListeners();
  }

  void switchUserById(String userId) {
    final user = _repository.users.firstWhere((u) => u.id == userId, orElse: () => _currentUser);
    switchUser(user);
  }
}

class AppState extends ChangeNotifier {
  String _currentLocale = 'vi-VN';
  String _selectedNavigationRoute = 'overview';
  String? _selectedVerticalId;
  String? _selectedCompanyId;
  String? _selectedAccountId;

  String get currentLocale => _currentLocale;
  bool get isVietnamese => _currentLocale == 'vi-VN';
  String get selectedNavigationRoute => _selectedNavigationRoute;
  String? get selectedVerticalId => _selectedVerticalId;
  String? get selectedCompanyId => _selectedCompanyId;
  String? get selectedAccountId => _selectedAccountId;

  void setLocale(String locale) {
    _currentLocale = locale;
    notifyListeners();
  }

  void toggleLocale() {
    _currentLocale = _currentLocale == 'vi-VN' ? 'en-VN' : 'vi-VN';
    notifyListeners();
  }

  void navigateTo(String route, {String? verticalId, String? companyId, String? accountId}) {
    _selectedNavigationRoute = route;
    _selectedVerticalId = verticalId;
    _selectedCompanyId = companyId;
    _selectedAccountId = accountId;
    notifyListeners();
  }
}
