import 'dart:convert';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'package:cdip_connect/shared/models/login_response_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static sqflite.Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static const String _dbName = 'cdip_connect.db';
  static const int _dbVersion = 9;

  Future<sqflite.Database> get database async {
    if (_database != null) return _database!;
    _database = await _initializeDatabase();
    return _database!;
  }

  Future<sqflite.Database> _initializeDatabase() async {
    final dbPath = await sqflite.getDatabasesPath();
    final path = join(dbPath, _dbName);

    print('📁 Database path: $path');

    return sqflite.openDatabase(
      path,
      version: _dbVersion,
      onConfigure: _onConfigure,
      onCreate: _createTables,
      onUpgrade: _upgradeTables,
    );
  }

  Future<void> _onConfigure(sqflite.Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _createTables(sqflite.Database db, int version) async {
    print('📊 Creating database tables...');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS login_response (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        response_json TEXT NOT NULL,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        updated_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS loans (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        loan_id TEXT UNIQUE NOT NULL,
        member_id TEXT NOT NULL,
        customized_loan_no TEXT,
        loan_product_name TEXT,
        disburse_date TEXT,
        last_schedule_date TEXT,
        loan_amount REAL DEFAULT 0,
        total_payable_amount REAL DEFAULT 0,
        total_recovered_amount REAL DEFAULT 0,
        outstanding_amount REAL DEFAULT 0,
        is_overdue INTEGER DEFAULT 0,
        overdue_amount REAL DEFAULT 0,
        is_open INTEGER DEFAULT 0,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS savings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        savings_id TEXT UNIQUE NOT NULL,
        member_id TEXT NOT NULL,
        code TEXT,
        product_name TEXT,
        opening_date TEXT,
        closing_date TEXT,
        total_deposit REAL DEFAULT 0,
        total_withdraw REAL DEFAULT 0,
        net_saving_amount REAL DEFAULT 0,
        is_open INTEGER DEFAULT 0,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS loan_transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        loan_id TEXT NOT NULL,
        transaction_date TEXT,
        transaction_amount REAL DEFAULT 0,
        transaction_principal_amount REAL DEFAULT 0,
        transaction_interest_amount REAL DEFAULT 0,
        FOREIGN KEY (loan_id) REFERENCES loans(loan_id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS savings_transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        savings_id TEXT NOT NULL,
        transaction_date TEXT,
        deposit_amount REAL DEFAULT 0,
        withdrawal_amount REAL DEFAULT 0,
        balance REAL DEFAULT 0,
        flag TEXT,
        FOREIGN KEY (savings_id) REFERENCES savings(savings_id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS marketing_banners (
        id TEXT PRIMARY KEY,
        image TEXT NOT NULL,
        title TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS dashboard_summary (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        loan_count INTEGER DEFAULT 0,
        loan_outstanding REAL DEFAULT 0,
        savings_count INTEGER DEFAULT 0,
        savings_outstanding REAL DEFAULT 0,
        due_loan_count INTEGER DEFAULT 0,
        due_loan_amount REAL DEFAULT 0
      )
    ''');

    await _createIndexes(db);

    print('✅ Tables created successfully');
  }

  Future<void> _createIndexes(sqflite.Database db) async {
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_loans_member_id ON loans(member_id)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_savings_member_id ON savings(member_id)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_loan_transactions_loan_id ON loan_transactions(loan_id)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_savings_transactions_savings_id ON savings_transactions(savings_id)',
    );
  }

  Future<void> _upgradeTables(
    sqflite.Database db,
    int oldVersion,
    int newVersion,
  ) async {
    print('🔄 Upgrading database from v$oldVersion to v$newVersion');

    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS marketing_banners (
          id TEXT PRIMARY KEY,
          image TEXT NOT NULL,
          title TEXT
        )
      ''');
    }

    if (oldVersion < 3) {
      await db.execute('DROP TABLE IF EXISTS loan_transactions');
      await db.execute('DROP TABLE IF EXISTS savings_transactions');

      await db.execute('''
        CREATE TABLE IF NOT EXISTS loan_transactions (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          loan_id TEXT NOT NULL,
          transaction_date TEXT,
          transaction_amount REAL DEFAULT 0,
          transaction_principal_amount REAL DEFAULT 0,
          transaction_interest_amount REAL DEFAULT 0,
          FOREIGN KEY (loan_id) REFERENCES loans(loan_id) ON DELETE CASCADE
        )
      ''');

      await db.execute('''
        CREATE TABLE IF NOT EXISTS savings_transactions (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          savings_id TEXT NOT NULL,
          transaction_date TEXT,
          deposit_amount REAL DEFAULT 0,
          withdrawal_amount REAL DEFAULT 0,
          balance REAL DEFAULT 0,
          flag TEXT,
          FOREIGN KEY (savings_id) REFERENCES savings(savings_id) ON DELETE CASCADE
        )
      ''');
    }

    if (oldVersion < 4) {
      await _safeAddColumn(
        db,
        'loans',
        'ALTER TABLE loans ADD COLUMN is_open INTEGER DEFAULT 0',
      );
    }

    if (oldVersion < 6) {
      await _safeAddColumn(
        db,
        'savings',
        'ALTER TABLE savings ADD COLUMN is_open INTEGER DEFAULT 0',
      );
      await _safeAddColumn(
        db,
        'savings',
        'ALTER TABLE savings ADD COLUMN closing_date TEXT',
      );
      await _safeAddColumn(
        db,
        'savings_transactions',
        'ALTER TABLE savings_transactions ADD COLUMN flag TEXT',
      );
    }

    if (oldVersion < 8) {
      await db.execute('DROP TABLE IF EXISTS marketing_banners');
      await db.execute('''
        CREATE TABLE IF NOT EXISTS marketing_banners (
          id TEXT PRIMARY KEY,
          image TEXT NOT NULL,
          title TEXT
        )
      ''');
    }

    if (oldVersion < 9) {
      await _createIndexes(db);
    }

    print('✅ Database upgrade complete');
  }

  Future<void> _safeAddColumn(
    sqflite.Database db,
    String tableName,
    String alterSql,
  ) async {
    try {
      await db.execute(alterSql);
    } catch (_) {
      // Ignore duplicate column errors safely.
    }
  }

  Future<void> saveLoginResponse(LoginResponse response) async {
    final db = await database;
    final jsonString = jsonEncode(response.toJson());

    print('💾 Saving complete login response...');

    try {
      await db.transaction((txn) async {
        await txn.delete('login_response');
        await txn.insert('login_response', {
          'response_json': jsonString,
          'updated_at': DateTime.now().toIso8601String(),
        });

        await _saveDashboardSummary(txn, response.dashboardSummary);
        await _saveLoansAndTransactions(
          txn,
          response.loanTransactions,
          response.userData.id,
        );
        await _saveSavingsAndTransactions(
          txn,
          response.savingAccounts,
          response.userData.id,
        );
        await _saveMarketingBanners(txn, response.marketingBanners);
      });

      print('✅ Complete login response saved');
    } catch (e) {
      print('❌ Error saving login response: $e');
      rethrow;
    }
  }

  Future<void> _saveDashboardSummary(
    sqflite.DatabaseExecutor db,
    DashboardSummary summary,
  ) async {
    await db.delete('dashboard_summary');
    await db.insert('dashboard_summary', summary.toJson());
    print('✅ Dashboard summary saved');
  }

  Future<void> _saveLoansAndTransactions(
    sqflite.DatabaseExecutor db,
    List<LoanTransaction> loanTransactions,
    String memberId,
  ) async {
    final existingLoanRows = await db.query(
      'loans',
      columns: ['loan_id'],
      where: 'member_id = ?',
      whereArgs: [memberId],
    );

    final existingLoanIds = existingLoanRows
        .map((e) => e['loan_id']?.toString())
        .whereType<String>()
        .toList();

    for (final loanId in existingLoanIds) {
      await db.delete(
        'loan_transactions',
        where: 'loan_id = ?',
        whereArgs: [loanId],
      );
    }

    await db.delete('loans', where: 'member_id = ?', whereArgs: [memberId]);

    final uniqueLoans = <String, LoanTransaction>{};
    for (final loan in loanTransactions) {
      uniqueLoans[loan.loanId] = loan;
    }

    final batch = db.batch();

    for (final loan in uniqueLoans.values) {
      batch.insert(
        'loans',
        {
          'loan_id': loan.loanId,
          'member_id': memberId,
          'customized_loan_no': loan.customizedLoanNo,
          'loan_product_name': loan.productName,
          'disburse_date': loan.disburseDate,
          'last_schedule_date': loan.loanFullyPaidDate,
          'loan_amount': loan.totalPayableAmount.toDouble(),
          'total_payable_amount': loan.totalPayableAmount.toDouble(),
          'total_recovered_amount': loan.totalTransactionAmount.toDouble(),
          'outstanding_amount':
              loan.totalOutstandingAfterTransaction.toDouble(),
          'is_overdue': loan.totalOverdueTransactionAmount > 0 ? 1 : 0,
          'overdue_amount': loan.totalOverdueTransactionAmount.toDouble(),
          'is_open': loan.isOpen == '1' ? 1 : 0,
        },
        conflictAlgorithm: sqflite.ConflictAlgorithm.replace,
      );

      for (final txn in loan.transactions) {
        batch.insert(
          'loan_transactions',
          {
            'loan_id': loan.loanId,
            'transaction_date': txn.transactionDate,
            'transaction_amount': txn.transactionAmount.toDouble(),
            'transaction_principal_amount':
                txn.transactionPrincipalAmount.toDouble(),
            'transaction_interest_amount':
                txn.transactionInterestAmount.toDouble(),
          },
          conflictAlgorithm: sqflite.ConflictAlgorithm.replace,
        );
      }
    }

    await batch.commit(noResult: true);
    print('✅ Loans and transactions saved');
  }

  Future<void> _saveSavingsAndTransactions(
    sqflite.DatabaseExecutor db,
    List<SavingAccount> savingAccounts,
    String memberId,
  ) async {
    final existingSavingRows = await db.query(
      'savings',
      columns: ['savings_id'],
      where: 'member_id = ?',
      whereArgs: [memberId],
    );

    final existingSavingIds = existingSavingRows
        .map((e) => e['savings_id']?.toString())
        .whereType<String>()
        .toList();

    for (final savingsId in existingSavingIds) {
      await db.delete(
        'savings_transactions',
        where: 'savings_id = ?',
        whereArgs: [savingsId],
      );
    }

    await db.delete('savings', where: 'member_id = ?', whereArgs: [memberId]);

    final uniqueSavings = <String, SavingAccount>{};
    for (final account in savingAccounts) {
      uniqueSavings[account.savingId] = account;
    }

    final batch = db.batch();

    for (final account in uniqueSavings.values) {
      batch.insert(
        'savings',
        {
          'savings_id': account.savingId,
          'member_id': memberId,
          'code': account.customizedSavingNo,
          'product_name': account.productName,
          'opening_date': account.openingDate,
          'closing_date': account.closingDate,
          'total_deposit': account.totalDeposit.toDouble(),
          'total_withdraw': account.totalWithdraw.toDouble(),
          'net_saving_amount': account.currentBalance.toDouble(),
          'is_open': account.isOpen,
        },
        conflictAlgorithm: sqflite.ConflictAlgorithm.replace,
      );

      for (final txn in account.transactions) {
        batch.insert(
          'savings_transactions',
          {
            'savings_id': account.savingId,
            'transaction_date': txn.transactionDate,
            'deposit_amount': txn.depositAmount.toDouble(),
            // Keep current UI-compatible column name:
            'withdrawal_amount': txn.withdrawAmount.toDouble(),
            // Keep current UI-compatible column name:
            'balance': txn.balanceAfterTx.toDouble(),
            'flag': txn.flag,
          },
          conflictAlgorithm: sqflite.ConflictAlgorithm.replace,
        );
      }
    }

    await batch.commit(noResult: true);
    print('✅ Savings and transactions saved');
  }

  Future<void> _saveMarketingBanners(
    sqflite.DatabaseExecutor db,
    List<MarketingBanner> banners,
  ) async {
    await db.delete('marketing_banners');

    final batch = db.batch();
    for (final banner in banners) {
      batch.insert(
        'marketing_banners',
        banner.toJson(),
        conflictAlgorithm: sqflite.ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);

    print('✅ Marketing banners saved');
  }

  Future<List<MarketingBanner>> getMarketingBanners() async {
    final db = await database;
    try {
      final result = await db.query('marketing_banners');
      if (result.isNotEmpty) {
        print('✅ Retrieved ${result.length} marketing banners');
        return result.map((row) => MarketingBanner.fromJson(row)).toList();
      }
      print('⚠️ No marketing banners found in DB');
      return [];
    } catch (e) {
      print('❌ Error getting marketing banners: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> getDashboardSummary() async {
    final db = await database;
    try {
      final result = await db.query('dashboard_summary', limit: 1);
      if (result.isNotEmpty) {
        print('✅ Dashboard summary retrieved from DB');
        return result.first;
      }
      print('⚠️ No dashboard summary found in DB');
      return null;
    } catch (e) {
      print('❌ Error getting dashboard summary: $e');
      return null;
    }
  }

  Future<LoginResponse?> getLoginResponse() async {
    final db = await database;
    try {
      final result = await db.query('login_response', limit: 1);
      if (result.isNotEmpty) {
        final jsonString = result.first['response_json'] as String;
        final data = jsonDecode(jsonString) as Map<String, dynamic>;
        print('✅ Login response retrieved from DB');
        return LoginResponse.fromJson(data);
      }
      print('⚠️ No login response found in DB');
      return null;
    } catch (e) {
      print('❌ Error getting login response: $e');
      return null;
    }
  }

  Future<List<UserLoan>> getAllLoans(String memberId) async {
    final db = await database;
    try {
      final result = await db.query(
        'loans',
        where: 'member_id = ?',
        whereArgs: [memberId],
        orderBy: 'created_at DESC, id DESC',
      );

      return result.map((row) {
        return UserLoan(
          loanId: row['loan_id']?.toString() ?? '',
          customizedLoanNo: row['customized_loan_no']?.toString() ?? '',
          loanProductName: row['loan_product_name']?.toString() ?? '',
          disburseDate: row['disburse_date']?.toString() ?? '',
          lastScheduleDate: row['last_schedule_date']?.toString() ?? '',
          loanAmount: (row['loan_amount'] as num?)?.toDouble() ?? 0.0,
          totalPayableAmount:
              (row['total_payable_amount'] as num?)?.toDouble() ?? 0.0,
          totalRecoveredAmount:
              (row['total_recovered_amount'] as num?)?.toDouble() ?? 0.0,
          outstandingAmount:
              (row['outstanding_amount'] as num?)?.toDouble() ?? 0.0,
          isOverdue: (row['is_overdue'] as int? ?? 0) == 1,
          overdueAmount: (row['overdue_amount'] as num?)?.toDouble() ?? 0.0,
          isOpen: (row['is_open'] as int? ?? 0) == 1,
        );
      }).toList();
    } catch (e) {
      print('❌ Error getting loans from DB: $e');
      return [];
    }
  }

  Future<List<UserSaving>> getAllSavings(String memberId) async {
    final db = await database;
    try {
      final result = await db.query(
        'savings',
        where: 'member_id = ?',
        whereArgs: [memberId],
        orderBy: 'created_at DESC, id DESC',
      );

      return result.map((row) {
        return UserSaving(
          savingsId: row['savings_id']?.toString() ?? '',
          code: row['code']?.toString() ?? '',
          productName: row['product_name']?.toString(),
          openingDate: row['opening_date']?.toString() ?? '',
          closingDate: row['closing_date']?.toString(),
          totalDeposit: (row['total_deposit'] as num?)?.toDouble() ?? 0.0,
          totalWithdraw: (row['total_withdraw'] as num?)?.toDouble() ?? 0.0,
          netSavingAmount:
              (row['net_saving_amount'] as num?)?.toDouble() ?? 0.0,
          isOpen: (row['is_open'] as int? ?? 0) == 1,
        );
      }).toList();
    } catch (e) {
      print('❌ Error getting savings from DB: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getLoanTransactions(
      {String? loanId}) async {
    final db = await database;
    try {
      final result = loanId != null
          ? await db.query(
              'loan_transactions',
              where: 'loan_id = ?',
              whereArgs: [loanId],
              orderBy: 'transaction_date ASC, id ASC',
            )
          : await db.query(
              'loan_transactions',
              orderBy: 'transaction_date ASC, id ASC',
            );

      print('✅ Retrieved ${result.length} loan transactions');
      return result;
    } catch (e) {
      print('❌ Error getting loan transactions: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getSavingTransactions({
    String? savingsId,
  }) async {
    final db = await database;
    try {
      final result = savingsId != null
          ? await db.query(
              'savings_transactions',
              where: 'savings_id = ?',
              whereArgs: [savingsId],
              orderBy: 'transaction_date ASC, id ASC',
            )
          : await db.query(
              'savings_transactions',
              orderBy: 'transaction_date ASC, id ASC',
            );

      print('✅ Retrieved ${result.length} saving transactions');
      return result;
    } catch (e) {
      print('❌ Error getting saving transactions: $e');
      return [];
    }
  }

  Future<void> clearAllData() async {
    final db = await database;

    try {
      await db.transaction((txn) async {
        await txn.delete('login_response');
        await txn.delete('loan_transactions');
        await txn.delete('savings_transactions');
        await txn.delete('loans');
        await txn.delete('savings');
        await txn.delete('marketing_banners');
        await txn.delete('dashboard_summary');
      });

      print('✅ All data cleared from database');
    } catch (e) {
      print('❌ Error clearing data: $e');
    }
  }

  Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
      print('✅ Database closed');
    }
  }
}
