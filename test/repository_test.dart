import 'package:flutter_test/flutter_test.dart';
import 'package:corporate_banking_dashboard/models/models.dart';
import 'package:corporate_banking_dashboard/services/corporate_repository.dart';

void main() {
  group('CorporateRepository Tests', () {
    late CorporateRepository repo;

    setUp(() {
      repo = CorporateRepository();
    });

    test('Group Treasury Manager sees all verticals and companies', () {
      final minh = repo.users.firstWhere((u) => u.name == 'Minh Nguyễn');
      final companies = repo.getAccessibleCompanies(minh);
      expect(companies.length, equals(repo.companies.length));
    });

    test('Hotels Accountant only sees Hotels companies and accounts', () {
      final myTran = repo.users.firstWhere((u) => u.name == 'Trần Thị Mỹ');
      final companies = repo.getAccessibleCompanies(myTran);
      expect(companies.every((c) => c.verticalId == 'vtl-hotels'), isTrue);

      final accounts = repo.getAccessibleAccounts(myTran);
      expect(accounts.every((a) => a.companyId.startsWith('cmp-hotels')), isTrue);
    });

    test('Net Liquidity formula calculation is accurate', () {
      final minh = repo.users.firstWhere((u) => u.name == 'Minh Nguyễn');
      final summary = repo.calculateSummaryForUser(minh);

      final expectedNetLiquidity = summary.totalCash +
          summary.totalDeposits -
          summary.totalLoans -
          summary.totalUtilizedOverdraft;

      expect(summary.netLiquidity, equals(expectedNetLiquidity));
    });

    test('Maker-checker rule prevents initiator from approving their own transaction', () {
      final myTran = repo.users.firstWhere((u) => u.name == 'Trần Thị Mỹ');
      final approver = repo.users.firstWhere((u) => u.name == 'Phạm Văn Đức');

      final resultSelfApprove = repo.approveTransaction('tx-001', myTran);
      expect(resultSelfApprove, isFalse);

      final resultApprover = repo.approveTransaction('tx-001', approver);
      expect(resultApprover, isTrue);

      final tx = repo.transactions.firstWhere((t) => t.id == 'tx-001');
      expect(tx.status, equals(TransactionStatus.approved));
    });
  });
}
