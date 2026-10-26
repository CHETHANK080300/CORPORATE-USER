enum UserRole {
  groupTreasuryManager,
  corporateGroupFinanceManager,
  companyAccountantHotels,
  corporateApprover,
  corporateViewerAuditor,
}

extension UserRoleExtension on UserRole {
  String get displayNameVi {
    switch (this) {
      case UserRole.groupTreasuryManager:
        return 'Quản lý Nguồn vốn Tập đoàn';
      case UserRole.corporateGroupFinanceManager:
        return 'Giám đốc Tài chính Tập đoàn';
      case UserRole.companyAccountantHotels:
        return 'Kế toán trưởng - Khách sạn';
      case UserRole.corporateApprover:
        return 'Cấp Phê duyệt Tập đoàn';
      case UserRole.corporateViewerAuditor:
        return 'Kiểm toán & Xem báo cáo';
    }
  }

  String get displayNameEn {
    switch (this) {
      case UserRole.groupTreasuryManager:
        return 'Group Treasury Manager';
      case UserRole.corporateGroupFinanceManager:
        return 'Corporate Group Finance Manager';
      case UserRole.companyAccountantHotels:
        return 'Company Accountant – Hotels';
      case UserRole.corporateApprover:
        return 'Corporate Approver';
      case UserRole.corporateViewerAuditor:
        return 'Corporate Viewer / Auditor';
    }
  }
}

class User {
  final String id;
  final String name;
  final String title;
  final UserRole role;
  final List<String> assignedCompanyIds;
  final List<String> assignedVerticalIds;
  final String email;
  final String phone;

  const User({
    required this.id,
    required this.name,
    required this.title,
    required this.role,
    required this.assignedCompanyIds,
    required this.assignedVerticalIds,
    required this.email,
    required this.phone,
  });

  bool get isGroupWide =>
      role == UserRole.groupTreasuryManager ||
      role == UserRole.corporateGroupFinanceManager ||
      role == UserRole.corporateApprover ||
      role == UserRole.corporateViewerAuditor;
}

class Vertical {
  final String id;
  final String code;
  final String nameVi;
  final String nameEn;
  final String iconName;

  const Vertical({
    required this.id,
    required this.code,
    required this.nameVi,
    required this.nameEn,
    required this.iconName,
  });
}

class Company {
  final String id;
  final String code;
  final String nameVi;
  final String nameEn;
  final String verticalId;
  final String taxCode;
  final String address;

  const Company({
    required this.id,
    required this.code,
    required this.nameVi,
    required this.nameEn,
    required this.verticalId,
    required this.taxCode,
    required this.address,
  });
}

class BankAccount {
  final String id;
  final String companyId;
  final String accountNumber;
  final String bankName;
  final String bankCode;
  final String accountType;
  final double balance;
  final double ledgerBalance;
  final String currency;
  final String status;

  const BankAccount({
    required this.id,
    required this.companyId,
    required this.accountNumber,
    required this.bankName,
    required this.bankCode,
    required this.accountType,
    required this.balance,
    required this.ledgerBalance,
    required this.currency,
    this.status = 'Hoạt động',
  });
}

class TermDeposit {
  final String id;
  final String companyId;
  final String depositNumber;
  final String bankName;
  final double principalAmount;
  final double interestRate;
  final String currency;
  final DateTime startDate;
  final DateTime maturityDate;
  final String status;

  const TermDeposit({
    required this.id,
    required this.companyId,
    required this.depositNumber,
    required this.bankName,
    required this.principalAmount,
    required this.interestRate,
    required this.currency,
    required this.startDate,
    required this.maturityDate,
    this.status = 'Đang gửi',
  });
}

class Loan {
  final String id;
  final String companyId;
  final String loanContractNumber;
  final String bankName;
  final double principalAmount;
  final double outstandingBalance;
  final double interestRate;
  final String currency;
  final DateTime maturityDate;
  final String status;

  const Loan({
    required this.id,
    required this.companyId,
    required this.loanContractNumber,
    required this.bankName,
    required this.principalAmount,
    required this.outstandingBalance,
    required this.interestRate,
    required this.currency,
    required this.maturityDate,
    this.status = 'Đang vay',
  });
}

class Overdraft {
  final String id;
  final String companyId;
  final String bankName;
  final double creditLimit;
  final double utilizedAmount;
  final String currency;

  const Overdraft({
    required this.id,
    required this.companyId,
    required this.bankName,
    required this.creditLimit,
    required this.utilizedAmount,
    required this.currency,
  });

  double get availableLimit => creditLimit - utilizedAmount;
}

enum TransactionStatus {
  pendingApproval,
  approved,
  rejected,
  completed,
}

class Transaction {
  final String id;
  final String referenceNumber;
  final String companyId;
  final String verticalId;
  final String accountId;
  final double amount;
  final String currency;
  final String transactionType;
  final TransactionStatus status;
  final DateTime date;
  final String description;
  final String initiator;
  final String counterparty;
  final String? rejectionReason;

  const Transaction({
    required this.id,
    required this.referenceNumber,
    required this.companyId,
    required this.verticalId,
    required this.accountId,
    required this.amount,
    required this.currency,
    required this.transactionType,
    required this.status,
    required this.date,
    required this.description,
    required this.initiator,
    required this.counterparty,
    this.rejectionReason,
  });

  Transaction copyWith({
    TransactionStatus? status,
    String? rejectionReason,
  }) {
    return Transaction(
      id: id,
      referenceNumber: referenceNumber,
      companyId: companyId,
      verticalId: verticalId,
      accountId: accountId,
      amount: amount,
      currency: currency,
      transactionType: transactionType,
      status: status ?? this.status,
      date: date,
      description: description,
      initiator: initiator,
      counterparty: counterparty,
      rejectionReason: rejectionReason ?? this.rejectionReason,
    );
  }
}

class FinancialSummary {
  final double totalCash;
  final double totalDeposits;
  final double totalLoans;
  final double totalUtilizedOverdraft;
  final double totalAvailableOverdraft;
  final int pendingApprovalsCount;
  final double pendingApprovalsAmount;
  final String currency;

  const FinancialSummary({
    required this.totalCash,
    required this.totalDeposits,
    required this.totalLoans,
    required this.totalUtilizedOverdraft,
    required this.totalAvailableOverdraft,
    required this.pendingApprovalsCount,
    required this.pendingApprovalsAmount,
    this.currency = 'VND',
  });

  double get netLiquidity =>
      totalCash + totalDeposits - totalLoans - totalUtilizedOverdraft;
}
