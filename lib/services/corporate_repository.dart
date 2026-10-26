import 'package:flutter/foundation.dart';
import '../models/models.dart';

class CorporateRepository extends ChangeNotifier {
  static const double usdToVndRate = 25400.0;

  final List<User> _users = [
    const User(
      id: 'usr-001',
      name: 'Minh Nguyễn',
      title: 'Group CIO / Treasurer',
      role: UserRole.groupTreasuryManager,
      assignedCompanyIds: [],
      assignedVerticalIds: [],
      email: 'minh.nguyen@globalcorp.com',
      phone: '+1 555 019 2831',
    ),
    const User(
      id: 'usr-002',
      name: 'Lê Hoàng Nam',
      title: 'Giám đốc Tài chính Tập đoàn',
      role: UserRole.corporateGroupFinanceManager,
      assignedCompanyIds: [],
      assignedVerticalIds: [],
      email: 'nam.le@vietnamcorp.vn',
      phone: '0912 345 678',
    ),
    const User(
      id: 'usr-003',
      name: 'Trần Thị Mỹ',
      title: 'Kế toán trưởng - Khách sạn',
      role: UserRole.companyAccountantHotels,
      assignedCompanyIds: ['cmp-hotels-01', 'cmp-hotels-02'],
      assignedVerticalIds: ['vtl-hotels'],
      email: 'my.tran@viethotels.vn',
      phone: '0988 765 432',
    ),
    const User(
      id: 'usr-004',
      name: 'Phạm Văn Đức',
      title: 'Cấp Phê duyệt Tài chính',
      role: UserRole.corporateApprover,
      assignedCompanyIds: [],
      assignedVerticalIds: [],
      email: 'duc.pham@vietnamcorp.vn',
      phone: '0977 112 233',
    ),
    const User(
      id: 'usr-005',
      name: 'Nguyễn Thị Hương',
      title: 'Kiểm toán viên Tập đoàn',
      role: UserRole.corporateViewerAuditor,
      assignedCompanyIds: [],
      assignedVerticalIds: [],
      email: 'huong.nguyen@vietnamcorp.vn',
      phone: '0966 554 433',
    ),
  ];

  late User _currentUser;

  // Global CIO Data
  final CioKpiSummary cioKpiSummary = const CioKpiSummary(
    globalCashPosition: 2580000000.0, // $2.58B
    cashChangePct: 8.5,
    availableCash: 1860000000.0, // $1.86B
    availableChangePct: 11.3,
    intradayLiquidity: 720000000.0, // $720M
    liquidityChangePct: 15.7,
    forecast7Day: 2730000000.0, // $2.73B
    forecastChangePct: 6.2,
    totalEntities: 48,
    totalCountries: 12,
    newEntitiesThisMonth: 2,
  );

  final List<CurrencySpendItem> currencySpendList = const [
    CurrencySpendItem(currencyCode: 'USD', currencyName: 'USD (US Dollar)', amountUsd: 1120000000, percentage: 43.4, colorHex: 0xFF6366F1),
    CurrencySpendItem(currencyCode: 'EUR', currencyName: 'EUR (Euro)', amountUsd: 620000000, percentage: 24.0, colorHex: 0xFF8B5CF6),
    CurrencySpendItem(currencyCode: 'GBP', currencyName: 'GBP (Pound Sterling)', amountUsd: 310000000, percentage: 12.0, colorHex: 0xFF3B82F6),
    CurrencySpendItem(currencyCode: 'JPY', currencyName: 'JPY (Japanese Yen)', amountUsd: 210000000, percentage: 8.1, colorHex: 0xFF06B6D4),
    CurrencySpendItem(currencyCode: 'CNY', currencyName: 'CNY (Chinese Yuan)', amountUsd: 160000000, percentage: 6.2, colorHex: 0xFFEC4899),
    CurrencySpendItem(currencyCode: 'Other', currencyName: 'Other Currencies', amountUsd: 160000000, percentage: 6.2, colorHex: 0xFF10B981),
  ];

  final List<CashForecastPoint> forecastPoints = const [
    CashForecastPoint(label: 'May 31', projectedBalance: 2.10, confidenceMin: 2.00, confidenceMax: 2.20),
    CashForecastPoint(label: 'Jun 1', projectedBalance: 2.35, confidenceMin: 2.20, confidenceMax: 2.45),
    CashForecastPoint(label: 'Jun 2', projectedBalance: 2.25, confidenceMin: 2.10, confidenceMax: 2.38),
    CashForecastPoint(label: 'Jun 3', projectedBalance: 2.67, confidenceMin: 2.50, confidenceMax: 2.80),
    CashForecastPoint(label: 'Jun 4', projectedBalance: 2.55, confidenceMin: 2.40, confidenceMax: 2.68),
    CashForecastPoint(label: 'Jun 5', projectedBalance: 2.62, confidenceMin: 2.48, confidenceMax: 2.75),
    CashForecastPoint(label: 'Jun 6', projectedBalance: 2.73, confidenceMin: 2.55, confidenceMax: 2.88),
  ];

  final List<TopEntityBalance> topEntities = const [
    TopEntityBalance(entityName: 'Global Holdings Inc.', currency: 'USD', balanceUsd: 620000000, ratio: 0.85),
    TopEntityBalance(entityName: 'Europe Ltd.', currency: 'EUR', balanceUsd: 480000000, ratio: 0.68),
    TopEntityBalance(entityName: 'Asia Pacific Pte. Ltd.', currency: 'USD', balanceUsd: 310000000, ratio: 0.45),
    TopEntityBalance(entityName: 'North America Corp.', currency: 'USD', balanceUsd: 280000000, ratio: 0.38),
    TopEntityBalance(entityName: 'Latin America S.A.', currency: 'USD', balanceUsd: 210000000, ratio: 0.28),
  ];

  final List<CountryCashPosition> countryPositions = const [
    CountryCashPosition(countryName: 'United States', countryCode: 'US', cashBalanceUsd: 1120000000, percentageOfTotal: 43.4),
    CountryCashPosition(countryName: 'Germany', countryCode: 'DE', cashBalanceUsd: 480000000, percentageOfTotal: 18.6),
    CountryCashPosition(countryName: 'United Kingdom', countryCode: 'GB', cashBalanceUsd: 310000000, percentageOfTotal: 12.0),
    CountryCashPosition(countryName: 'Singapore', countryCode: 'SG', cashBalanceUsd: 210000000, percentageOfTotal: 8.1),
    CountryCashPosition(countryName: 'China', countryCode: 'CN', cashBalanceUsd: 160000000, percentageOfTotal: 6.2),
    CountryCashPosition(countryName: 'Others (7 Countries)', countryCode: 'GL', cashBalanceUsd: 300000000, percentageOfTotal: 11.7),
  ];

  final UtilizationMetrics utilizationMetrics = const UtilizationMetrics(
    utilizationPct: 87,
    sweptTodayUsd: 720000000,
    pooledBalanceUsd: 1450000000,
    accountsInPool: 128,
    trappedCashReducedUsd: 135000000,
    capitalEfficiencyGainPct: 15.7,
  );

  final List<RiskExposureSummary> riskExposures = const [
    RiskExposureSummary(currency: 'EUR', exposureUsd: 620000000, pctOfTotal: 24.0, isTrendUp: true),
    RiskExposureSummary(currency: 'GBP', exposureUsd: 310000000, pctOfTotal: 12.0, isTrendUp: true),
    RiskExposureSummary(currency: 'JPY', exposureUsd: 210000000, pctOfTotal: 8.1, isTrendUp: false),
    RiskExposureSummary(currency: 'CNY', exposureUsd: 160000000, pctOfTotal: 6.2, isTrendUp: true),
    RiskExposureSummary(currency: 'Other', exposureUsd: 160000000, pctOfTotal: 6.2, isTrendUp: false),
  ];

  final List<RecentActivityItem> recentActivities = const [
    RecentActivityItem(dateStr: 'May 31, 2024', entityName: 'Global Holdings Inc.', type: 'Sweep In', currency: 'USD', amount: 120000000, status: 'Completed'),
    RecentActivityItem(dateStr: 'May 31, 2024', entityName: 'Europe Ltd.', type: 'Sweep In', currency: 'EUR', amount: 85000000, status: 'Completed'),
    RecentActivityItem(dateStr: 'May 30, 2024', entityName: 'Asia Pacific Pte. Ltd.', type: 'Pool Transfer', currency: 'USD', amount: 50000000, status: 'Completed'),
    RecentActivityItem(dateStr: 'May 30, 2024', entityName: 'North America Corp.', type: 'Sweep Out', currency: 'USD', amount: 45000000, status: 'Completed'),
    RecentActivityItem(dateStr: 'May 29, 2024', entityName: 'Latin America S.A.', type: 'Pool Transfer', currency: 'USD', amount: 25000000, status: 'Completed'),
  ];

  final List<SystemAlertItem> systemAlerts = const [
    SystemAlertItem(title: 'Low cash balance alert for Europe Ltd.', description: 'Current balance below threshold', timeAgo: '2h ago', alertType: 'warning'),
    SystemAlertItem(title: 'FX exposure limit breached for JPY', description: 'Exposure is 112% of approved limit', timeAgo: '5h ago', alertType: 'danger'),
    SystemAlertItem(title: 'Sweep schedule completed successfully', description: 'All eligible accounts swept', timeAgo: '6h ago', alertType: 'info'),
    SystemAlertItem(title: 'Large incoming payment expected', description: '\$50M from Customer ABC on Jun 3, 2024', timeAgo: '1d ago', alertType: 'warning'),
  ];

  // Banking domain structures preserved for API compatibility
  final List<Vertical> _verticals = [
    const Vertical(id: 'vtl-parks', code: 'PARKS', nameVi: 'Công viên & Giải trí', nameEn: 'Parks and Entertainment', iconName: 'attractions'),
    const Vertical(id: 'vtl-hotels', code: 'HOTELS', nameVi: 'Khách sạn & Nghỉ dưỡng', nameEn: 'Hotels and Hospitality', iconName: 'hotel'),
    const Vertical(id: 'vtl-air', code: 'AIR', nameVi: 'Hàng không & Dịch vụ bay', nameEn: 'Aviation and Air Services', iconName: 'flight'),
    const Vertical(id: 'vtl-realestate', code: 'REALESTATE', nameVi: 'Bất động sản & Quản lý tài sản', nameEn: 'Real Estate & Property', iconName: 'domain'),
    const Vertical(id: 'vtl-retail', code: 'RETAIL', nameVi: 'Bán lẻ & Dịch vụ tiêu dùng', nameEn: 'Retail & Consumer Services', iconName: 'shopping_bag'),
  ];

  final List<Company> _companies = [
    const Company(id: 'cmp-parks-01', code: 'VIETPARK', nameVi: 'Công ty CP Công viên Việt', nameEn: 'Viet Park Joint Stock Co.', verticalId: 'vtl-parks', taxCode: '0101234567', address: 'Hà Nội, Việt Nam'),
    const Company(id: 'cmp-hotels-01', code: 'VIETHOTEL', nameVi: 'Công ty TNHH Khách sạn Việt Nam', nameEn: 'Vietnam Hotels Ltd.', verticalId: 'vtl-hotels', taxCode: '0307654321', address: 'TP. Hồ Chí Minh, Việt Nam'),
    const Company(id: 'cmp-hotels-02', code: 'VIETRESORT', nameVi: 'Công ty CP Khu nghỉ dưỡng Việt', nameEn: 'Viet Resort Group', verticalId: 'vtl-hotels', taxCode: '0309988776', address: 'Đà Nẵng, Việt Nam'),
    const Company(id: 'cmp-air-01', code: 'VIETAIR', nameVi: 'Công ty CP Hàng không Việt', nameEn: 'Viet Aviation Corp', verticalId: 'vtl-air', taxCode: '0109876543', address: 'Hà Nội, Việt Nam'),
    const Company(id: 'cmp-realestate-01', code: 'VIETPROP', nameVi: 'Công ty TNHH Bất động sản Việt', nameEn: 'Viet Property Mgmt', verticalId: 'vtl-realestate', taxCode: '0311223344', address: 'TP. Hồ Chí Minh, Việt Nam'),
    const Company(id: 'cmp-retail-01', code: 'VIETRETAIL', nameVi: 'Công ty CP Bán lẻ Việt', nameEn: 'Viet Retail Group', verticalId: 'vtl-retail', taxCode: '0105566778', address: 'Hà Nội, Việt Nam'),
  ];

  final List<BankAccount> _accounts = [
    const BankAccount(id: 'acc-001', companyId: 'cmp-parks-01', accountNumber: '1020000188', bankName: 'Vietcombank', bankCode: 'VCB', accountType: 'Thanh toán', balance: 420000000000, ledgerBalance: 425000000000, currency: 'VND'),
    const BankAccount(id: 'acc-002', companyId: 'cmp-hotels-01', accountNumber: '1180000999', bankName: 'BIDV', bankCode: 'BIDV', accountType: 'Thanh toán', balance: 310000000000, ledgerBalance: 310000000000, currency: 'VND'),
    const BankAccount(id: 'acc-003', companyId: 'cmp-hotels-02', accountNumber: '1900002233', bankName: 'Techcombank', bankCode: 'TCB', accountType: 'Thanh toán', balance: 180000000000, ledgerBalance: 180000000000, currency: 'VND'),
    const BankAccount(id: 'acc-004', companyId: 'cmp-air-01', accountNumber: '00710008888', bankName: 'Vietcombank', bankCode: 'VCB', accountType: 'Ngoại tệ', balance: 12500000, ledgerBalance: 12500000, currency: 'USD'),
    const BankAccount(id: 'acc-005', companyId: 'cmp-realestate-01', accountNumber: '2121000555', bankName: 'VietinBank', bankCode: 'CTG', accountType: 'Thanh toán', balance: 250000000000, ledgerBalance: 250000000000, currency: 'VND'),
    const BankAccount(id: 'acc-006', companyId: 'cmp-retail-01', accountNumber: '1150000333', bankName: 'MBBank', bankCode: 'MB', accountType: 'Thanh toán', balance: 220000000000, ledgerBalance: 220000000000, currency: 'VND'),
  ];

  final List<TermDeposit> _deposits = [
    TermDeposit(id: 'dep-001', companyId: 'cmp-parks-01', depositNumber: 'TD-2026-001', bankName: 'Vietcombank', principalAmount: 200000000000, interestRate: 5.5, currency: 'VND', startDate: DateTime(2026, 1, 15), maturityDate: DateTime(2026, 7, 15)),
    TermDeposit(id: 'dep-002', companyId: 'cmp-hotels-01', depositNumber: 'TD-2026-002', bankName: 'BIDV', principalAmount: 150000000000, interestRate: 5.8, currency: 'VND', startDate: DateTime(2026, 2, 10), maturityDate: DateTime(2026, 8, 10)),
  ];

  final List<Loan> _loans = [
    Loan(id: 'loan-001', companyId: 'cmp-air-01', loanContractNumber: 'LN-AIR-2025-01', bankName: 'Vietcombank', principalAmount: 800000000000, outstandingBalance: 650000000000, interestRate: 7.2, currency: 'VND', maturityDate: DateTime(2028, 12, 31)),
    Loan(id: 'loan-002', companyId: 'cmp-realestate-01', loanContractNumber: 'LN-RE-2025-09', bankName: 'VietinBank', principalAmount: 500000000000, outstandingBalance: 420000000000, interestRate: 7.8, currency: 'VND', maturityDate: DateTime(2029, 6, 30)),
  ];

  final List<Overdraft> _overdrafts = [
    const Overdraft(id: 'od-001', companyId: 'cmp-air-01', bankName: 'Vietcombank', creditLimit: 200000000000, utilizedAmount: 120000000000, currency: 'VND'),
    const Overdraft(id: 'od-002', companyId: 'cmp-retail-01', bankName: 'MBBank', creditLimit: 100000000000, utilizedAmount: 30000000000, currency: 'VND'),
  ];

  late List<Transaction> _transactions;

  CorporateRepository() {
    _currentUser = _users.first;
    _initTransactions();
  }

  void _initTransactions() {
    _transactions = [
      Transaction(
        id: 'tx-001',
        referenceNumber: 'FT2610260001',
        companyId: 'cmp-hotels-01',
        verticalId: 'vtl-hotels',
        accountId: 'acc-002',
        amount: 1250000000,
        currency: 'VND',
        transactionType: 'Thanh toán nhà cung cấp',
        status: TransactionStatus.pendingApproval,
        date: DateTime.now().subtract(const Duration(hours: 2)),
        description: 'Thanh toán tiền thực phẩm khách sạn Q4',
        initiator: 'Trần Thị Mỹ',
        counterparty: 'Công ty Nông sản Sạch',
      ),
      Transaction(
        id: 'tx-002',
        referenceNumber: 'FT2610260002',
        companyId: 'cmp-hotels-02',
        verticalId: 'vtl-hotels',
        accountId: 'acc-003',
        amount: 850000000,
        currency: 'VND',
        transactionType: 'Chi trả lương',
        status: TransactionStatus.pendingApproval,
        date: DateTime.now().subtract(const Duration(hours: 4)),
        description: 'Chi trả lương nhân viên resort tháng 10',
        initiator: 'Trần Thị Mỹ',
        counterparty: 'Danh sách CBNV Resort',
      ),
      Transaction(
        id: 'tx-003',
        referenceNumber: 'FT2610260003',
        companyId: 'cmp-air-01',
        verticalId: 'vtl-air',
        accountId: 'acc-004',
        amount: 450000,
        currency: 'USD',
        transactionType: 'Thanh toán thuê tàu bay',
        status: TransactionStatus.pendingApproval,
        date: DateTime.now().subtract(const Duration(hours: 6)),
        description: 'Thanh toán định kỳ hợp đồng leasing A321',
        initiator: 'Nguyễn Văn Long',
        counterparty: 'AirCap Leasing Corp',
      ),
      Transaction(
        id: 'tx-004',
        referenceNumber: 'FT2610260004',
        companyId: 'cmp-parks-01',
        verticalId: 'vtl-parks',
        accountId: 'acc-001',
        amount: 3200000000,
        currency: 'VND',
        transactionType: 'Gửi tiết kiệm có kỳ hạn',
        status: TransactionStatus.completed,
        date: DateTime.now().subtract(const Duration(days: 1)),
        description: 'Mở hợp đồng tiền gửi 6 tháng Vietcombank',
        initiator: 'Hoàng Văn Thắng',
        counterparty: 'Vietcombank Ba Đình',
      ),
    ];
  }

  User get currentUser => _currentUser;
  List<User> get users => List.unmodifiable(_users);
  List<User> get availableUsers => List.unmodifiable(_users);
  List<Company> get companies => List.unmodifiable(_companies);
  List<Overdraft> get overdrafts => List.unmodifiable(_overdrafts);
  List<Transaction> get transactions => List.unmodifiable(_transactions);

  void switchUser(String userId) {
    final user = _users.firstWhere((u) => u.id == userId, orElse: () => _users.first);
    _currentUser = user;
    notifyListeners();
  }

  double convertToVnd(double amount, String currency) {
    if (currency == 'USD') {
      return amount * usdToVndRate;
    }
    return amount;
  }

  List<Vertical> getAccessibleVerticals([User? user]) {
    final u = user ?? _currentUser;
    if (u.isGroupWide) return _verticals;
    return _verticals.where((v) => u.assignedVerticalIds.contains(v.id)).toList();
  }

  List<Company> getAccessibleCompanies([User? user]) {
    final u = user ?? _currentUser;
    if (u.isGroupWide) return _companies;
    return _companies.where((c) => u.assignedCompanyIds.contains(c.id)).toList();
  }

  bool isCompanyAccessible(User user, String companyId) {
    if (user.isGroupWide) return true;
    return user.assignedCompanyIds.contains(companyId);
  }

  List<BankAccount> getAccessibleAccounts([User? user]) {
    final allowedCompanyIds = getAccessibleCompanies(user).map((c) => c.id).toSet();
    return _accounts.where((a) => allowedCompanyIds.contains(a.companyId)).toList();
  }

  List<Loan> getAccessibleLoans([User? user]) {
    final allowedCompanyIds = getAccessibleCompanies(user).map((c) => c.id).toSet();
    return _loans.where((l) => allowedCompanyIds.contains(l.companyId)).toList();
  }

  List<Transaction> getAccessibleTransactions([User? user]) {
    final allowedCompanyIds = getAccessibleCompanies(user).map((c) => c.id).toSet();
    return _transactions.where((t) => allowedCompanyIds.contains(t.companyId)).toList();
  }

  List<Transaction> getAccessiblePendingApprovals([User? user]) {
    return getAccessibleTransactions(user).where((t) => t.status == TransactionStatus.pendingApproval).toList();
  }

  Map<String, double> getCurrencyBreakdownForUser([User? user]) {
    final accounts = getAccessibleAccounts(user);
    final map = <String, double>{};
    for (var acc in accounts) {
      map[acc.currency] = (map[acc.currency] ?? 0) + acc.balance;
    }
    return map;
  }

  FinancialSummary calculateSummaryForUser(User user, {String? verticalId, String? companyId}) {
    if (companyId != null) {
      return getFinancialSummaryForCompany(companyId);
    }
    return getConsolidatedSummary();
  }

  List<Vertical> get accessibleVerticals {
    return getAccessibleVerticals(_currentUser);
  }

  List<Company> get accessibleCompanies {
    return getAccessibleCompanies(_currentUser);
  }

  List<BankAccount> get accessibleAccounts {
    return getAccessibleAccounts(_currentUser);
  }

  List<TermDeposit> get accessibleDeposits {
    final allowedCompanyIds = accessibleCompanies.map((c) => c.id).toSet();
    return _deposits.where((d) => allowedCompanyIds.contains(d.companyId)).toList();
  }

  List<Loan> get accessibleLoans {
    return getAccessibleLoans(_currentUser);
  }

  List<Overdraft> get accessibleOverdrafts {
    final allowedCompanyIds = accessibleCompanies.map((c) => c.id).toSet();
    return _overdrafts.where((o) => allowedCompanyIds.contains(o.companyId)).toList();
  }

  List<Transaction> get accessibleTransactions {
    return getAccessibleTransactions(_currentUser);
  }

  List<Transaction> get pendingApprovals {
    return getAccessiblePendingApprovals(_currentUser);
  }

  FinancialSummary getFinancialSummaryForCompany(String companyId) {
    double cash = 0;
    for (var acc in _accounts.where((a) => a.companyId == companyId)) {
      cash += acc.currency == 'USD' ? acc.balance * usdToVndRate : acc.balance;
    }

    double deposits = 0;
    for (var dep in _deposits.where((d) => d.companyId == companyId)) {
      deposits += dep.currency == 'USD' ? dep.principalAmount * usdToVndRate : dep.principalAmount;
    }

    double loans = 0;
    for (var loan in _loans.where((l) => l.companyId == companyId)) {
      loans += loan.currency == 'USD' ? loan.outstandingBalance * usdToVndRate : loan.outstandingBalance;
    }

    double utilOd = 0;
    double availOd = 0;
    for (var od in _overdrafts.where((o) => o.companyId == companyId)) {
      final util = od.currency == 'USD' ? od.utilizedAmount * usdToVndRate : od.utilizedAmount;
      final avail = od.currency == 'USD' ? od.availableLimit * usdToVndRate : od.availableLimit;
      utilOd += util;
      availOd += avail;
    }

    final pending = _transactions.where((t) => t.companyId == companyId && t.status == TransactionStatus.pendingApproval).toList();
    double pendingAmt = 0;
    for (var p in pending) {
      pendingAmt += p.currency == 'USD' ? p.amount * usdToVndRate : p.amount;
    }

    return FinancialSummary(
      totalCash: cash,
      totalDeposits: deposits,
      totalLoans: loans,
      totalUtilizedOverdraft: utilOd,
      totalAvailableOverdraft: availOd,
      pendingApprovalsCount: pending.length,
      pendingApprovalsAmount: pendingAmt,
      currency: 'USD',
    );
  }

  FinancialSummary getConsolidatedSummary() {
    double cash = 0;
    double deposits = 0;
    double loans = 0;
    double utilOd = 0;
    double availOd = 0;

    for (var comp in accessibleCompanies) {
      final s = getFinancialSummaryForCompany(comp.id);
      cash += s.totalCash;
      deposits += s.totalDeposits;
      loans += s.totalLoans;
      utilOd += s.totalUtilizedOverdraft;
      availOd += s.totalAvailableOverdraft;
    }

    final pending = pendingApprovals;
    double pendingAmt = 0;
    for (var p in pending) {
      pendingAmt += p.currency == 'USD' ? p.amount * usdToVndRate : p.amount;
    }

    return FinancialSummary(
      totalCash: cash,
      totalDeposits: deposits,
      totalLoans: loans,
      totalUtilizedOverdraft: utilOd,
      totalAvailableOverdraft: availOd,
      pendingApprovalsCount: pending.length,
      pendingApprovalsAmount: pendingAmt,
      currency: 'USD',
    );
  }

  bool approveTransaction(String transactionId, [User? user, String? reason]) {
    final u = user ?? _currentUser;
    final index = _transactions.indexWhere((t) => t.id == transactionId);
    if (index == -1) return false;

    final tx = _transactions[index];
    if (tx.initiator == u.name) {
      return false; // Maker-checker restriction
    }

    _transactions[index] = tx.copyWith(status: TransactionStatus.approved);
    notifyListeners();
    return true;
  }

  bool rejectTransaction(String transactionId, [User? user, String? reason]) {
    final index = _transactions.indexWhere((t) => t.id == transactionId);
    if (index == -1) return false;

    final tx = _transactions[index];
    _transactions[index] = tx.copyWith(
      status: TransactionStatus.rejected,
      rejectionReason: reason ?? 'Rejected',
    );
    notifyListeners();
    return true;
  }
}
