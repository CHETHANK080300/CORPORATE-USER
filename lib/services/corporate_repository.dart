import 'package:flutter/foundation.dart';
import '../models/models.dart';

class CorporateRepository extends ChangeNotifier {
  static const double usdToVndRate = 25400.0;

  final List<User> _users = [
    const User(
      id: 'usr-001',
      name: 'Minh Nguyễn',
      title: 'Giám đốc Nguồn vốn Group',
      role: UserRole.groupTreasuryManager,
      assignedCompanyIds: [],
      assignedVerticalIds: [],
      email: 'minh.nguyen@vietnamcorp.vn',
      phone: '0903 123 456',
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
      title: 'Kiểm toán viên Độc lập',
      role: UserRole.corporateViewerAuditor,
      assignedCompanyIds: [],
      assignedVerticalIds: [],
      email: 'huong.nguyen@auditfirm.vn',
      phone: '0933 445 566',
    ),
  ];

  final List<Vertical> _verticals = const [
    Vertical(
      id: 'vtl-parks',
      code: 'PARKS',
      nameVi: 'Vui chơi & Giải trí',
      nameEn: 'Parks & Entertainment',
      iconName: 'attractions',
    ),
    Vertical(
      id: 'vtl-hotels',
      code: 'HOTELS',
      nameVi: 'Khách sạn & Dịch vụ nghỉ dưỡng',
      nameEn: 'Hotels & Hospitality',
      iconName: 'hotel',
    ),
    Vertical(
      id: 'vtl-air',
      code: 'AIR',
      nameVi: 'Hàng không & Dịch vụ hàng không',
      nameEn: 'Aviation & Air Services',
      iconName: 'flight',
    ),
    Vertical(
      id: 'vtl-realestate',
      code: 'REALESTATE',
      nameVi: 'Bất động sản & Quản lý tài sản',
      nameEn: 'Real Estate & Property Management',
      iconName: 'domain',
    ),
    Vertical(
      id: 'vtl-retail',
      code: 'RETAIL',
      nameVi: 'Bán lẻ & Dịch vụ tiêu dùng',
      nameEn: 'Retail & Consumer Services',
      iconName: 'shopping_bag',
    ),
  ];

  final List<Company> _companies = const [
    Company(
      id: 'cmp-parks-01',
      code: 'VIETPARK',
      nameVi: 'Công ty Cổ phần Công viên Việt',
      nameEn: 'Viet Park Corporation',
      verticalId: 'vtl-parks',
      taxCode: '0101234567',
      address: 'Đường Hạ Long, Phường Bãi Cháy, TP. Hạ Long, Quảng Ninh',
    ),
    Company(
      id: 'cmp-parks-02',
      code: 'SUNPARK',
      nameVi: 'Công ty TNHH Giải trí Mặt Trời',
      nameEn: 'Sun World Entertainment Co., Ltd.',
      verticalId: 'vtl-parks',
      taxCode: '0309876543',
      address: 'Hòa Phú, Hòa Vang, TP. Đà Nẵng',
    ),
    Company(
      id: 'cmp-hotels-01',
      code: 'VIETHOTEL',
      nameVi: 'Công ty TNHH Khách sạn Việt Nam',
      nameEn: 'Vietnam Hotels Co., Ltd.',
      verticalId: 'vtl-hotels',
      taxCode: '0102345678',
      address: 'Phố Trần Hưng Đạo, Quận Hoàn Kiếm, TP. Hà Nội',
    ),
    Company(
      id: 'cmp-hotels-02',
      code: 'LOTUSHOTEL',
      nameVi: 'Công ty Cổ phần Khu nghỉ dưỡng Sen Việt',
      nameEn: 'Lotus Resort & Spa JSC',
      verticalId: 'vtl-hotels',
      taxCode: '0308765432',
      address: 'Phường Hàm Tiến, TP. Phan Thiết, Bình Thuận',
    ),
    Company(
      id: 'cmp-air-01',
      code: 'LOTUSAIR',
      nameVi: 'Công ty Cổ phần Hàng không Việt',
      nameEn: 'Viet Air Joint Stock Company',
      verticalId: 'vtl-air',
      taxCode: '0103456789',
      address: 'Đường Nguyễn Văn Cừ, Quận Long Biên, TP. Hà Nội',
    ),
    Company(
      id: 'cmp-air-02',
      code: 'AIRSERVICES',
      nameVi: 'Công ty TNHH Dịch vụ Mặt đất Hàng không',
      nameEn: 'Aviation Ground Services Ltd.',
      verticalId: 'vtl-air',
      taxCode: '0307654321',
      address: 'Sân bay Tân Sơn Nhất, Quận Tân Bình, TP. Hồ Chí Minh',
    ),
    Company(
      id: 'cmp-re-01',
      code: 'VIETREAL',
      nameVi: 'Công ty TNHH Bất động sản Việt',
      nameEn: 'Viet Real Estate Co., Ltd.',
      verticalId: 'vtl-realestate',
      taxCode: '0104567890',
      address: 'Đường Lê Duẩn, Quận 1, TP. Hồ Chí Minh',
    ),
    Company(
      id: 'cmp-retail-01',
      code: 'VIETRETAIL',
      nameVi: 'Công ty Cổ phần Bán lẻ Việt',
      nameEn: 'Viet Retail Corporation',
      verticalId: 'vtl-retail',
      taxCode: '0105678901',
      address: 'Phố Hai Bà Trưng, Quận Hoàn Kiếm, TP. Hà Nội',
    ),
  ];

  final List<BankAccount> _accounts = const [
    BankAccount(
      id: 'acc-p01',
      companyId: 'cmp-parks-01',
      accountNumber: '1100 2233 4455',
      bankName: 'Vietcombank - CN Quảng Ninh',
      bankCode: 'VCB',
      accountType: 'Tài khoản Thanh toán Chính',
      balance: 450000000000,
      ledgerBalance: 452000000000,
      currency: 'VND',
    ),
    BankAccount(
      id: 'acc-p02',
      companyId: 'cmp-parks-02',
      accountNumber: '2200 3344 5566',
      bankName: 'VietinBank - CN Đà Nẵng',
      bankCode: 'CTG',
      accountType: 'Tài khoản Thu hộ Bán vé',
      balance: 180000000000,
      ledgerBalance: 180000000000,
      currency: 'VND',
    ),
    BankAccount(
      id: 'acc-h01',
      companyId: 'cmp-hotels-01',
      accountNumber: '3300 4455 6677',
      bankName: 'BIDV - CN Hà Nội',
      bankCode: 'BIDV',
      accountType: 'Tài khoản Tập trung Doanh thu',
      balance: 320000000000,
      ledgerBalance: 320000000000,
      currency: 'VND',
    ),
    BankAccount(
      id: 'acc-h02',
      companyId: 'cmp-hotels-01',
      accountNumber: '0081 0001 9988',
      bankName: 'Vietcombank - CN Sở Giao Dịch',
      bankCode: 'VCB',
      accountType: 'Tài khoản Ngoại tệ USD',
      balance: 2500000,
      ledgerBalance: 2500000,
      currency: 'USD',
    ),
    BankAccount(
      id: 'acc-h03',
      companyId: 'cmp-hotels-02',
      accountNumber: '4400 5566 7788',
      bankName: 'Techcombank - CN Phan Thiết',
      bankCode: 'TCB',
      accountType: 'Tài khoản Vận hành',
      balance: 125000000000,
      ledgerBalance: 125000000000,
      currency: 'VND',
    ),
    BankAccount(
      id: 'acc-a01',
      companyId: 'cmp-air-01',
      accountNumber: '5500 6677 8899',
      bankName: 'Vietcombank - CN Tân Bình',
      bankCode: 'VCB',
      accountType: 'Tài khoản Bán vé & Thanh toán',
      balance: 150000000000,
      ledgerBalance: 155000000000,
      currency: 'VND',
    ),
    BankAccount(
      id: 'acc-a02',
      companyId: 'cmp-air-01',
      accountNumber: '0071 0002 8877',
      bankName: 'MBBank - CN TP.HCM',
      bankCode: 'MB',
      accountType: 'Tài khoản Nhiên liệu USD',
      balance: 4000000,
      ledgerBalance: 4000000,
      currency: 'USD',
    ),
    BankAccount(
      id: 'acc-a03',
      companyId: 'cmp-air-02',
      accountNumber: '6600 7788 9900',
      bankName: 'Agribank - CN Tân Sơn Nhất',
      bankCode: 'VBA',
      accountType: 'Tài khoản Thu phí Phục vụ',
      balance: 85000000000,
      ledgerBalance: 85000000000,
      currency: 'VND',
    ),
    BankAccount(
      id: 'acc-r01',
      companyId: 'cmp-re-01',
      accountNumber: '7700 8899 0011',
      bankName: 'VPBank - CN Sài Gòn',
      bankCode: 'VPB',
      accountType: 'Tài khoản Dự án BĐS',
      balance: 210000000000,
      ledgerBalance: 210000000000,
      currency: 'VND',
    ),
    BankAccount(
      id: 'acc-rt01',
      companyId: 'cmp-retail-01',
      accountNumber: '8800 9900 1122',
      bankName: 'ACB - CN Hoàn Kiếm',
      bankCode: 'ACB',
      accountType: 'Tài khoản Chuỗi Cửa hàng',
      balance: 195000000000,
      ledgerBalance: 195000000000,
      currency: 'VND',
    ),
  ];

  final List<TermDeposit> _deposits = [
    TermDeposit(
      id: 'dep-01',
      companyId: 'cmp-parks-01',
      depositNumber: 'HDGT-2026-001',
      bankName: 'Vietcombank',
      principalAmount: 200000000000,
      interestRate: 6.2,
      currency: 'VND',
      startDate: DateTime(2026, 1, 15),
      maturityDate: DateTime(2026, 7, 15),
    ),
    TermDeposit(
      id: 'dep-02',
      companyId: 'cmp-hotels-01',
      depositNumber: 'HDGT-2026-008',
      bankName: 'BIDV',
      principalAmount: 150000000000,
      interestRate: 6.5,
      currency: 'VND',
      startDate: DateTime(2026, 2, 1),
      maturityDate: DateTime(2026, 8, 1),
    ),
    TermDeposit(
      id: 'dep-03',
      companyId: 'cmp-retail-01',
      depositNumber: 'HDGT-2026-012',
      bankName: 'ACB',
      principalAmount: 80000000000,
      interestRate: 5.8,
      currency: 'VND',
      startDate: DateTime(2026, 3, 10),
      maturityDate: DateTime(2026, 6, 10),
    ),
  ];

  final List<Loan> _loans = [
    Loan(
      id: 'loan-01',
      companyId: 'cmp-air-01',
      loanContractNumber: 'HDTD-2025-A350',
      bankName: 'Vietcombank',
      principalAmount: 1200000000000,
      outstandingBalance: 850000000000,
      interestRate: 8.5,
      currency: 'VND',
      maturityDate: DateTime(2028, 12, 31),
    ),
    Loan(
      id: 'loan-02',
      companyId: 'cmp-air-01',
      loanContractNumber: 'HDTD-2025-LEASING',
      bankName: 'MBBank',
      principalAmount: 500000000000,
      outstandingBalance: 320000000000,
      interestRate: 8.2,
      currency: 'VND',
      maturityDate: DateTime(2027, 6, 30),
    ),
    Loan(
      id: 'loan-03',
      companyId: 'cmp-re-01',
      loanContractNumber: 'HDTD-2025-PROJECT-X',
      bankName: 'VPBank',
      principalAmount: 600000000000,
      outstandingBalance: 400000000000,
      interestRate: 9.0,
      currency: 'VND',
      maturityDate: DateTime(2027, 10, 15),
    ),
  ];

  final List<Overdraft> _overdrafts = [
    const Overdraft(
      id: 'ovd-01',
      companyId: 'cmp-air-01',
      bankName: 'Vietcombank',
      creditLimit: 100000000000,
      utilizedAmount: 65000000000,
      currency: 'VND',
    ),
    const Overdraft(
      id: 'ovd-02',
      companyId: 'cmp-air-02',
      bankName: 'Agribank',
      creditLimit: 50000000000,
      utilizedAmount: 20000000000,
      currency: 'VND',
    ),
    const Overdraft(
      id: 'ovd-03',
      companyId: 'cmp-re-01',
      bankName: 'VPBank',
      creditLimit: 80000000000,
      utilizedAmount: 35000000000,
      currency: 'VND',
    ),
    const Overdraft(
      id: 'ovd-04',
      companyId: 'cmp-hotels-01',
      bankName: 'BIDV',
      creditLimit: 50000000000,
      utilizedAmount: 0,
      currency: 'VND',
    ),
    const Overdraft(
      id: 'ovd-05',
      companyId: 'cmp-parks-01',
      bankName: 'Vietcombank',
      creditLimit: 50000000000,
      utilizedAmount: 0,
      currency: 'VND',
    ),
  ];

  late List<Transaction> _transactions;

  CorporateRepository() {
    _initTransactions();
  }

  void _initTransactions() {
    _transactions = [
      Transaction(
        id: 'tx-001',
        referenceNumber: 'FT26048100293',
        companyId: 'cmp-hotels-01',
        verticalId: 'vtl-hotels',
        accountId: 'acc-h01',
        amount: 15400000000,
        currency: 'VND',
        transactionType: 'Thanh toán Nhà cung cấp',
        status: TransactionStatus.pendingApproval,
        date: DateTime(2026, 4, 25, 14, 30),
        description: 'Thanh toán chi phí cung ứng thực phẩm Tháng 4/2026',
        initiator: 'Trần Thị Mỹ',
        counterparty: 'Công ty CP Thực phẩm Sạch Việt',
      ),
      Transaction(
        id: 'tx-002',
        referenceNumber: 'FT26048100512',
        companyId: 'cmp-air-01',
        verticalId: 'vtl-air',
        accountId: 'acc-a02',
        amount: 850000,
        currency: 'USD',
        transactionType: 'Thanh toán Nhiên liệu Bay',
        status: TransactionStatus.pendingApproval,
        date: DateTime(2026, 4, 26, 09, 15),
        description: 'Thanh toán hợp đồng nhiên liệu Jet A-1 cho Shell Aviation',
        initiator: 'Nguyễn Văn Hải',
        counterparty: 'Shell Aviation Global Ltd',
      ),
      Transaction(
        id: 'tx-003',
        referenceNumber: 'FT26048100688',
        companyId: 'cmp-parks-01',
        verticalId: 'vtl-parks',
        accountId: 'acc-p01',
        amount: 28500000000,
        currency: 'VND',
        transactionType: 'Thanh toán Thiết bị Trò chơi',
        status: TransactionStatus.pendingApproval,
        date: DateTime(2026, 4, 26, 11, 00),
        description: 'Đặt cọc Đợt 2 thiết bị Tàu hỏa cao tốc Hạ Long Park',
        initiator: 'Lê Văn Hoàng',
        counterparty: 'Vekoma Rides Manufacturing B.V.',
      ),
      Transaction(
        id: 'tx-004',
        referenceNumber: 'FT26048100741',
        companyId: 'cmp-re-01',
        verticalId: 'vtl-realestate',
        accountId: 'acc-r01',
        amount: 42000000000,
        currency: 'VND',
        transactionType: 'Chi trả Thuế đất & Hạ tầng',
        status: TransactionStatus.pendingApproval,
        date: DateTime(2026, 4, 26, 13, 45),
        description: 'Nộp tiền sử dụng đất Dự án KĐT Lê Duẩn Kỳ 1/2026',
        initiator: 'Phạm Minh Tuấn',
        counterparty: 'Kho bạc Nhà nước TP.HCM',
      ),
      Transaction(
        id: 'tx-005',
        referenceNumber: 'FT26048100890',
        companyId: 'cmp-hotels-02',
        verticalId: 'vtl-hotels',
        accountId: 'acc-h03',
        amount: 6800000000,
        currency: 'VND',
        transactionType: 'Thanh toán Lương & Chi phí VH',
        status: TransactionStatus.pendingApproval,
        date: DateTime(2026, 4, 26, 15, 20),
        description: 'Chi trả lương cán bộ nhân viên Khu nghỉ dưỡng Sen Việt',
        initiator: 'Trần Thị Mỹ',
        counterparty: 'Tài khoản Lương NV Lotus Resort',
      ),
      Transaction(
        id: 'tx-006',
        referenceNumber: 'FT26047100111',
        companyId: 'cmp-hotels-01',
        verticalId: 'vtl-hotels',
        accountId: 'acc-h01',
        amount: 8200000000,
        currency: 'VND',
        transactionType: 'Thanh toán NCC Điện Nước',
        status: TransactionStatus.approved,
        date: DateTime(2026, 4, 24, 10, 00),
        description: 'Thanh toán tiền điện chiếu sáng & điều hòa tháng 3',
        initiator: 'Trần Thị Mỹ',
        counterparty: 'Tổng công ty Điện lực TP. Hà Nội',
      ),
      Transaction(
        id: 'tx-007',
        referenceNumber: 'FT26047100332',
        companyId: 'cmp-retail-01',
        verticalId: 'vtl-retail',
        accountId: 'acc-rt01',
        amount: 19500000000,
        currency: 'VND',
        transactionType: 'Thanh toán Hàng hóa Bán lẻ',
        status: TransactionStatus.approved,
        date: DateTime(2026, 4, 23, 16, 10),
        description: 'Thanh toán lô hàng điện máy đợt 4/2026',
        initiator: 'Đỗ Thị Quyên',
        counterparty: 'Samsung Electronics Vietnam',
      ),
    ];
  }

  List<User> get users => List.unmodifiable(_users);
  List<Vertical> get verticals => List.unmodifiable(_verticals);
  List<Company> get companies => List.unmodifiable(_companies);
  List<BankAccount> get accounts => List.unmodifiable(_accounts);
  List<TermDeposit> get deposits => List.unmodifiable(_deposits);
  List<Loan> get loans => List.unmodifiable(_loans);
  List<Overdraft> get overdrafts => List.unmodifiable(_overdrafts);
  List<Transaction> get transactions => List.unmodifiable(_transactions);

  bool isCompanyAccessible(User user, String companyId) {
    if (user.isGroupWide) return true;
    return user.assignedCompanyIds.contains(companyId);
  }

  bool isVerticalAccessible(User user, String verticalId) {
    if (user.isGroupWide) return true;
    return user.assignedVerticalIds.contains(verticalId);
  }

  List<Company> getAccessibleCompanies(User user) {
    if (user.isGroupWide) return _companies;
    return _companies
        .where((c) => user.assignedCompanyIds.contains(c.id))
        .toList();
  }

  List<Vertical> getAccessibleVerticals(User user) {
    if (user.isGroupWide) return _verticals;
    return _verticals
        .where((v) => user.assignedVerticalIds.contains(v.id))
        .toList();
  }

  List<BankAccount> getAccessibleAccounts(User user) {
    final accessibleCompanies = getAccessibleCompanies(user).map((c) => c.id).toSet();
    return _accounts.where((a) => accessibleCompanies.contains(a.companyId)).toList();
  }

  List<Loan> getAccessibleLoans(User user) {
    final accessibleCompanies = getAccessibleCompanies(user).map((c) => c.id).toSet();
    return _loans.where((l) => accessibleCompanies.contains(l.companyId)).toList();
  }

  List<Transaction> getAccessibleTransactions(User user) {
    final accessibleCompanies = getAccessibleCompanies(user).map((c) => c.id).toSet();
    return _transactions.where((t) => accessibleCompanies.contains(t.companyId)).toList();
  }

  List<Transaction> getAccessiblePendingApprovals(User user) {
    return getAccessibleTransactions(user)
        .where((t) => t.status == TransactionStatus.pendingApproval)
        .toList();
  }

  double convertToVnd(double amount, String currency) {
    if (currency == 'USD') {
      return amount * usdToVndRate;
    }
    return amount;
  }

  FinancialSummary calculateSummaryForUser(User user, {String? companyId, String? verticalId}) {
    final accessibleCompanies = getAccessibleCompanies(user);
    var filteredCompanies = accessibleCompanies;

    if (companyId != null) {
      filteredCompanies = filteredCompanies.where((c) => c.id == companyId).toList();
    } else if (verticalId != null) {
      filteredCompanies = filteredCompanies.where((c) => c.verticalId == verticalId).toList();
    }

    final companyIdSet = filteredCompanies.map((c) => c.id).toSet();

    double totalCashVnd = 0;
    for (final acc in _accounts.where((a) => companyIdSet.contains(a.companyId))) {
      totalCashVnd += convertToVnd(acc.balance, acc.currency);
    }

    double totalDepositsVnd = 0;
    for (final dep in _deposits.where((d) => companyIdSet.contains(d.companyId))) {
      totalDepositsVnd += convertToVnd(dep.principalAmount, dep.currency);
    }

    double totalLoansVnd = 0;
    for (final loan in _loans.where((l) => companyIdSet.contains(l.companyId))) {
      totalLoansVnd += convertToVnd(loan.outstandingBalance, loan.currency);
    }

    double totalUtilizedOverdraftVnd = 0;
    double totalAvailableOverdraftVnd = 0;
    for (final ovd in _overdrafts.where((o) => companyIdSet.contains(o.companyId))) {
      totalUtilizedOverdraftVnd += convertToVnd(ovd.utilizedAmount, ovd.currency);
      totalAvailableOverdraftVnd += convertToVnd(ovd.availableLimit, ovd.currency);
    }

    final pendingTxList = _transactions.where(
      (t) => companyIdSet.contains(t.companyId) && t.status == TransactionStatus.pendingApproval,
    );
    int pendingCount = pendingTxList.length;
    double pendingAmountVnd = 0;
    for (final tx in pendingTxList) {
      pendingAmountVnd += convertToVnd(tx.amount, tx.currency);
    }

    return FinancialSummary(
      totalCash: totalCashVnd,
      totalDeposits: totalDepositsVnd,
      totalLoans: totalLoansVnd,
      totalUtilizedOverdraft: totalUtilizedOverdraftVnd,
      totalAvailableOverdraft: totalAvailableOverdraftVnd,
      pendingApprovalsCount: pendingCount,
      pendingApprovalsAmount: pendingAmountVnd,
    );
  }

  Map<String, Map<String, double>> getCurrencyBreakdownForUser(User user) {
    final accessibleCompanies = getAccessibleCompanies(user).map((c) => c.id).toSet();

    double vndCash = 0;
    double usdCash = 0;

    for (final acc in _accounts.where((a) => accessibleCompanies.contains(a.companyId))) {
      if (acc.currency == 'USD') {
        usdCash += acc.balance;
      } else {
        vndCash += acc.balance;
      }
    }

    return {
      'VND': {'cash': vndCash},
      'USD': {'cash': usdCash, 'convertedVnd': usdCash * usdToVndRate},
    };
  }

  bool approveTransaction(String transactionId, User user) {
    final index = _transactions.indexWhere((t) => t.id == transactionId);
    if (index == -1) return false;

    final tx = _transactions[index];
    if (tx.initiator == user.name) {
      return false;
    }

    _transactions[index] = tx.copyWith(status: TransactionStatus.approved);
    notifyListeners();
    return true;
  }

  bool rejectTransaction(String transactionId, User user, String reason) {
    final index = _transactions.indexWhere((t) => t.id == transactionId);
    if (index == -1) return false;

    final tx = _transactions[index];
    _transactions[index] = tx.copyWith(
      status: TransactionStatus.rejected,
      rejectionReason: reason,
    );
    notifyListeners();
    return true;
  }
}
