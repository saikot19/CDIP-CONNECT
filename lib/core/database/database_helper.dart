import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:path/path.dart';
import 'dart:convert';
import '../models/login_response_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static sqflite.Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<sqflite.Database> get database async {
    if (_database != null) return _database!;
    _database = await _initializeDatabase();
    return _database!;
  }

  Future<sqflite.Database> _initializeDatabase() async {
    final dbPath = await sqflite.getDatabasesPath();
    final path = join(dbPath, 'cdip_connect.db');

    print('📁 Database path: $path');

    return await sqflite.openDatabase(
      path,
      version: 8, // Incremented version for schema change
      onCreate: _createTables,
      onUpgrade: _upgradeTables,
    );
  }

  Future<void> _createTables(sqflite.Database db, int version) async {
    print('📊 Creating database tables...');

    try {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS login_response (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          response_json TEXT NOT NULL,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
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
          loan_amount REAL,
          total_payable_amount REAL,
          total_recovered_amount REAL,
          outstanding_amount REAL,
          is_overdue INTEGER,
          overdue_amount REAL,
          is_open INTEGER DEFAULT 0,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
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
          total_deposit REAL,
          total_withdraw REAL,
          net_saving_amount REAL,
          is_open INTEGER DEFAULT 0,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
      ''');

      await db.execute('''
        CREATE TABLE IF NOT EXISTS loan_transactions (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          loan_id TEXT NOT NULL,
          transaction_date TEXT,
          transaction_amount REAL,
          transaction_principal_amount REAL,
          transaction_interest_amount REAL,
          FOREIGN KEY (loan_id) REFERENCES loans(loan_id)
        )
      ''');

      await db.execute('''
        CREATE TABLE IF NOT EXISTS savings_transactions (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          savings_id TEXT NOT NULL,
          transaction_date TEXT,
          deposit_amount REAL,
          withdrawal_amount REAL,
          balance REAL,
          flag TEXT,
          FOREIGN KEY (savings_id) REFERENCES savings(savings_id)
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
          loan_count INTEGER,
          loan_outstanding REAL,
          savings_count INTEGER,
          savings_outstanding REAL,
          due_loan_count INTEGER,
          due_loan_amount REAL
        )
      ''');

      print('✅ Tables created successfully');
    } catch (e) {
      print('❌ Error creating tables: $e');
    }
  }
  
  Future<void> _upgradeTables(
      sqflite.Database db, int oldVersion, int newVersion) async {
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
      await _createTables(db, newVersion);
    }
    if (oldVersion < 4) {
      await db
          .execute('ALTER TABLE loans ADD COLUMN is_open INTEGER DEFAULT 0');
    }
    if (oldVersion < 5) {
      // This was a duplicate, do nothing.
    }
    if (oldVersion < 6) {
      await db
          .execute('ALTER TABLE savings ADD COLUMN is_open INTEGER DEFAULT 0');
      await db.execute('ALTER TABLE savings ADD COLUMN closing_date TEXT');
      await db.execute('ALTER TABLE savings_transactions ADD COLUMN flag TEXT');
    }
    if (oldVersion < 7) {
       // This was a duplicate, do nothing.
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
  }

  Future<void> saveLoginResponse(LoginResponse response) async {
    final db = await database;
    final jsonString = jsonEncode(response.toJson());

    print('💾 Saving complete login response...');

    try {
      await db.delete('login_response');
      await db.insert('login_response', {
        'response_json': jsonString,
        'updated_at': DateTime.now().toIso8601String(),
      });

      await _saveDashboardSummary(response.dashboardSummary);
      await _saveLoansAndTransactions(
          response.loanTransactions, response.userData.id);
      await _saveSavingsAndTransactions(
          response.savingAccounts, response.userData.id);
      await _saveMarketingBanners(response.marketingBanners);

      print('✅ Complete login response saved');
    } catch (e) {
      print('❌ Error saving login response: $e');
    }
  }

  Future<void> _saveDashboardSummary(DashboardSummary summary) async {
    final db = await database;
    try {
      await db.delete('dashboard_summary');
      await db.insert('dashboard_summary', summary.toJson());
      print('✅ Dashboard summary saved');
    } catch (e) {
      print('❌ Error saving dashboard summary: $e');
    }
  }

  Future<void> _saveLoansAndTransactions(
      List<LoanTransaction> loanTransactions, String memberId) async {
    final db = await database;
    try {
      await db.delete('loans', where: 'member_id = ?', whereArgs: [memberId]);
      await db.delete('loan_transactions');

      for (var loan in loanTransactions) {
        await db.insert(
          'loans',
          {
            'loan_id': loan.loanId,
            'member_id': memberId,
            'customized_loan_no': loan.customizedLoanNo,
            'loan_product_name': loan.productName,
            'disburse_date': loan.disburseDate,
            'last_schedule_date': loan.loanFullyPaidDate,
            'loan_amount': loan.totalPayableAmount,
            'total_payable_amount': loan.totalPayableAmount,
            'total_recovered_amount': loan.totalTransactionAmount,
            'outstanding_amount': loan.totalOutstandingAfterTransaction,
            'is_overdue': (loan.totalOverdueTransactionAmount) > 0 ? 1 : 0,
            'overdue_amount': loan.totalOverdueTransactionAmount,
            'is_open': loan.isOpen == '1' ? 1 : 0,
          },
          conflictAlgorithm: sqflite.ConflictAlgorithm.replace,
        );

        for (var txn in loan.transactions) {
          await db.insert('loan_transactions', {
            'loan_id': loan.loanId,
            'transaction_date': txn.transactionDate,
            'transaction_amount': txn.transactionAmount,
            'transaction_principal_amount': txn.transactionPrincipalAmount,
            'transaction_interest_amount': txn.transactionInterestAmount,
          });
        }
      }
      print('✅ Loans and transactions saved');
    } catch (e) {
      print('❌ Error saving loans and transactions: $e');
    }
  }

  Future<void> _saveSavingsAndTransactions(
      List<SavingAccount> savingAccounts, String memberId) async {
    final db = await database;
    try {
      await db.delete('savings', where: 'member_id = ?', whereArgs: [memberId]);
      await db.delete('savings_transactions');

      for (var account in savingAccounts) {
        await db.insert(
          'savings',
          {
            'savings_id': account.savingId,
            'member_id': memberId,
            'code': account.customizedSavingNo,
            'product_name': account.productName,
            'opening_date': account.openingDate,
            'closing_date': account.closingDate,
            'total_deposit': account.totalDeposit,
            'total_withdraw': account.totalWithdraw,
            'net_saving_amount': account.currentBalance,
            'is_open': account.isOpen,
          },
          conflictAlgorithm: sqflite.ConflictAlgorithm.replace,
        );

        for (var txn in account.transactions) {
          await db.insert('savings_transactions', {
            'savings_id': account.savingId,
            'transaction_date': txn.transactionDate,
            'deposit_amount': txn.depositAmount,
            'withdrawal_amount': txn.withdrawAmount,
            'balance': txn.balanceAfterTx,
            'flag': txn.flag,
          });
        }
      }
      print('✅ Savings and transactions saved');
    } catch (e) {
      print('❌ Error saving savings and transactions: $e');
    }
  }

  Future<void> _saveMarketingBanners(List<MarketingBanner> banners) async {
    final db = await database;
    try {
      await db.delete('marketing_banners'); // Clear old banners
      for (var banner in banners) {
        await db.insert(
          'marketing_banners',
          banner.toJson(),
          conflictAlgorithm: sqflite.ConflictAlgorithm.replace,
        );
      }
      print('✅ Marketing banners saved');
    } catch (e) {
      print('❌ Error saving marketing banners: $e');
    }
  }

  Future<List<MarketingBanner>> getMarketingBanners() async {
    final db = await database;
    try {
      final result = await db.query('marketing_banners');
      if (result.isNotEmpty) {
        print('✅ Retrieved ${result.length} marketing banners');
        return result
            .map((row) => MarketingBanner.fromJson(row))
            .toList();
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
        final data = jsonDecode(jsonString);
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
      );

      return result
          .map((row) => UserLoan(
                loanId: row['loan_id'] as String,
                customizedLoanNo: row['customized_loan_no'] as String,
                loanProductName: row['loan_product_name'] as String,
                disburseDate: row['disburse_date'] as String,
                lastScheduleDate: row['last_schedule_date'] as String,
                loanAmount: (row['loan_amount'] as num).toDouble(),
                totalPayableAmount:
                    (row['total_payable_amount'] as num).toDouble(),
                totalRecoveredAmount:
                    (row['total_recovered_amount'] as num).toDouble(),
                outstandingAmount:
                    (row['outstanding_amount'] as num).toDouble(),
                isOverdue: (row['is_overdue'] as int) == 1,
                overdueAmount: (row['overdue_amount'] as num).toDouble(),
                isOpen: (row['is_open'] as int) == 1,
              ))
          .toList();
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
      );

      return result
          .map((row) => UserSaving(
                savingsId: row['savings_id'] as String,
                code: row['code'] as String,
                productName: row['product_name'] as String?,
                openingDate: row['opening_date'] as String,
                closingDate: row['closing_date'] as String?,
                totalDeposit: (row['total_deposit'] as num).toDouble(),
                totalWithdraw: (row['total_withdraw'] as num).toDouble(),
                netSavingAmount: (row['net_saving_amount'] as num).toDouble(),
                isOpen: (row['is_open'] as int) == 1,
              ))
          .toList();
    } catch (e) {
      print('❌ Error getting savings from DB: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getLoanTransactions(
      {String? loanId}) async {
    final db = await database;

    try {
      final List<Map<String, dynamic>> result;

      if (loanId != null) {
        result = await db.query(
          'loan_transactions',
          where: 'loan_id = ?',
          whereArgs: [loanId],
        );
      } else {
        result = await db.query('loan_transactions');
      }
      print('✅ Retrieved ${result.length} loan transactions');
      return result;
    } catch (e) {
      print('❌ Error getting loan transactions: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getSavingTransactions(
      {String? savingsId}) async {
    final db = await database;

    try {
      final List<Map<String, dynamic>> result;

      if (savingsId != null) {
        result = await db.query(
          'savings_transactions',
          where: 'savings_id = ?',
          whereArgs: [savingsId],
        );
      } else {
        result = await db.query('savings_transactions');
      }

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
      await db.delete('login_response');
      await db.delete('loan_transactions');
      await db.delete('savings_transactions');
      await db.delete('loans');
      await db.delete('savings');
      await db.delete('marketing_banners'); // Clear banners too
      await db.delete('dashboard_summary');
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
