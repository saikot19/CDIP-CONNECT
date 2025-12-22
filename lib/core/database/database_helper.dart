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
      version: 3, // Incremented version for new schema
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
          total_deposit REAL,
          total_withdraw REAL,
          net_saving_amount REAL,
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
          FOREIGN KEY (savings_id) REFERENCES savings(savings_id)
        )
      ''');
      
      await db.execute('''
          CREATE TABLE IF NOT EXISTS marketing_banners (
            id TEXT PRIMARY KEY,
            image_url TEXT NOT NULL,
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
  
  Future<void> _upgradeTables(sqflite.Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
          CREATE TABLE IF NOT EXISTS marketing_banners (
            id TEXT PRIMARY KEY,
            image_url TEXT NOT NULL,
            title TEXT
          )
          ''');
    }
    if (oldVersion < 3) {
       await db.execute('DROP TABLE IF EXISTS loan_transactions');
       await db.execute('DROP TABLE IF EXISTS savings_transactions');
       await _createTables(db, newVersion);
    }
  }

  Future<void> saveLoginResponse(Map<String, dynamic> response) async {
    final db = await database;
    final jsonString = jsonEncode(response);

    print('💾 Saving complete login response...');

    try {
      await db.delete('login_response');
      await db.insert('login_response', {
        'response_json': jsonString,
        'updated_at': DateTime.now().toIso8601String(),
      });

      if (response['dashboard_summery'] != null) {
        await _saveDashboardSummary(response['dashboard_summery']);
      }

      if (response['loan_transaction'] != null) {
        await _saveLoanTransactions(response['loan_transaction']);
      }

      if (response['savingTransaction'] != null) {
        await _saveSavingTransactions(response['savingTransaction']);
      }
      
      if (response['marketing_bannar'] != null) {
        await _saveMarketingBanners(response['marketing_bannar']);
      }

      print('✅ Complete login response saved');
    } catch (e) {
      print('❌ Error saving login response: $e');
    }
  }

  Future<void> _saveDashboardSummary(Map<String, dynamic> summary) async {
    final db = await database;
    try {
      await db.delete('dashboard_summary');
      await db.insert('dashboard_summary', summary);
      print('✅ Dashboard summary saved');
    } catch (e) {
      print('❌ Error saving dashboard summary: $e');
    }
  }

  Future<void> _saveLoanTransactions(List<dynamic> transactions) async {
    final db = await database;
    try {
      await db.delete('loan_transactions');
      for (var loan in transactions) {
         if(loan['transactions'] is List) {
            for(var txn in loan['transactions']) {
                 await db.insert('loan_transactions', {
                    'loan_id': loan['loan_id'],
                    'transaction_date': txn['transaction_date'],
                    'transaction_amount': txn['transaction_amount'],
                    'transaction_principal_amount': txn['transaction_principal_amount'],
                    'transaction_interest_amount': txn['transaction_interest_amount'],
                });
            }
         }
      }
      print('✅ Loan transactions saved');
    } catch (e) {
      print('❌ Error saving loan transactions: $e');
    }
  }

  Future<void> _saveSavingTransactions(Map<String, dynamic> savingTxn) async {
    final db = await database;
    try {
      await db.delete('savings_transactions');
      if(savingTxn['transactions'] is List) {
        for (var txn in savingTxn['transactions']) {
          await db.insert('savings_transactions', {
             'savings_id': 'all_savings', // Since there is no savings_id in the response
             'transaction_date': txn['transaction_date'],
             'deposit_amount': txn['deposit_amount'],
             'withdrawal_amount': txn['withdrawal_amount'],
             'balance': txn['balance'],
          });
        }
      }
      print('✅ Savings transactions saved');
    } catch (e) {
      print('❌ Error saving savings transactions: $e');
    }
  }

  Future<void> _saveMarketingBanners(List<dynamic> banners) async {
    final db = await database;
    try {
      await db.delete('marketing_banners'); // Clear old banners
      for (var bannerData in banners) {
        final banner = MarketingBanner.fromJson(bannerData);
        await db.insert(
          'marketing_banners',
          {
            'id': banner.id,
            'image_url': banner.image,
            'title': banner.title,
          },
          conflictAlgorithm: sqflite.ConflictAlgorithm.replace,
        );
      }
      print('✅ Marketing banners saved');
    } catch (e) {
      print('❌ Error saving marketing banners: $e');
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

  Future<Map<String, dynamic>?> getLoginResponse() async {
    final db = await database;

    try {
      final result = await db.query('login_response', limit: 1);

      if (result.isNotEmpty) {
        final jsonString = result.first['response_json'] as String;
        final data = jsonDecode(jsonString);
        print('✅ Login response retrieved from DB');
        return data;
      }
      print('⚠️ No login response found in DB');
      return null;
    } catch (e) {
      print('❌ Error getting login response: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getLoginSummary() async {
    final db = await database;

    try {
      final result = await db.query('login_response', limit: 1);

      if (result.isNotEmpty) {
        final jsonString = result.first['response_json'] as String;
        final data = jsonDecode(jsonString);

        final loanTxn = data['loan_transaction'] as Map<String, dynamic>? ?? {};
        final savingTxn =
            data['savingTransaction'] as Map<String, dynamic>? ?? {};

        return {
          'total_outstanding_after_transaction':
              loanTxn['total_outstanding_after_transaction'] ?? '0',
          'total_transaction_amount':
              loanTxn['total_transaction_amount'] ?? '0',
          'final_balance': savingTxn['final_balance'] ?? '0',
        };
      }

      print('⚠️ No login summary found');
      return null;
    } catch (e) {
      print('❌ Error getting login summary: $e');
      return null;
    }
  }

  Future<List<MarketingBanner>> getMarketingBanners() async {
    final db = await database;
    try {
      final result = await db.query('marketing_banners');
      final banners = result.map((row) {
        return MarketingBanner(
          id: row['id'] as String,
          image: row['image_url'] as String,
          title: row['title'] as String,
        );
      }).toList();
      print('✅ Retrieved ${banners.length} banners from DB');
      return banners;
    } catch (e) {
      print('❌ Error getting marketing banners: $e');
      return [];
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

      final loans = result
          .map((row) => UserLoan(
                loanId: row['loan_id'] as String? ?? '',
                customizedLoanNo: row['customized_loan_no'] as String? ?? '',
                loanProductName: row['loan_product_name'] as String? ?? '',
                disburseDate: row['disburse_date'] as String? ?? '',
                lastScheduleDate: row['last_schedule_date'] as String? ?? '',
                loanAmount: row['loan_amount'] as double? ?? 0,
                totalPayableAmount: row['total_payable_amount'] as double? ?? 0,
                totalRecoveredAmount:
                    row['total_recovered_amount'] as double? ?? 0,
                outstandingAmount: row['outstanding_amount'] as double? ?? 0,
                isOverdue: (row['is_overdue'] as int?) == 1,
                overdueAmount: row['overdue_amount'] as double? ?? 0,
              ))
          .toList();

      print('✅ Retrieved ${loans.length} loans from DB');
      return loans;
    } catch (e) {
      print('❌ Error getting loans: $e');
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

      final savings = result
          .map((row) => UserSaving(
                savingsId: row['savings_id'] as String? ?? '',
                code: row['code'] as String? ?? '',
                productName: row['product_name'] as String?,
                openingDate: row['opening_date'] as String? ?? '',
                totalDeposit: row['total_deposit'] as double? ?? 0,
                totalWithdraw: row['total_withdraw'] as double? ?? 0,
                netSavingAmount: row['net_saving_amount'] as double? ?? 0,
              ))
          .toList();

      print('✅ Retrieved ${savings.length} savings from DB');
      return savings;
    } catch (e) {
      print('❌ Error getting savings: $e');
      return [];
    }
  }

  Future<List<Map<String,dynamic>>> getLoanTransactions({String? loanId}) async {
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

  Future<List<Map<String,dynamic>>> getSavingTransactions({String? savingsId}) async {
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
