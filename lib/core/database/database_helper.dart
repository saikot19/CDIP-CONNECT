import 'package:sqflite/sqflite.dart' hide Transaction;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../models/login_response_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      String path = join(dir.path, 'cdip_connect.db');
      print('📌 Database path: $path');

      final db = await openDatabase(
        path,
        version: 1,
        onCreate: _createTables,
      );
      print('✅ Database initialized successfully');
      return db;
    } catch (e) {
      print('❌ Error initializing database: $e');
      rethrow;
    }
  }

  Future<void> _createTables(Database db, int version) async {
    try {
      print('📌 Creating database tables...');

      // Loan Products Table
      await db.execute('''
        CREATE TABLE IF NOT EXISTS loan_products(
          id TEXT PRIMARY KEY,
          name TEXT,
          short_name TEXT,
          code TEXT,
          minimum_loan_amount TEXT,
          maximum_loan_amount TEXT,
          default_loan_amount TEXT,
          grace_period TEXT,
          number_of_installment TEXT,
          repayment_frequency TEXT,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
      ''');
      print('✅ loan_products table created');

      // Loan Transactions Table
      await db.execute('''
        CREATE TABLE IF NOT EXISTS loan_transactions(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          transaction_date TEXT,
          transaction_amount TEXT,
          outstanding_after_transaction TEXT,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
      ''');
      print('✅ loan_transactions table created');

      // Saving Transactions Table
      await db.execute('''
        CREATE TABLE IF NOT EXISTS saving_transactions(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          transaction_date TEXT,
          deposit_amount TEXT,
          withdrawal_amount TEXT,
          balance TEXT,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
      ''');
      print('✅ saving_transactions table created');

      // Login Summary Table
      await db.execute('''
        CREATE TABLE IF NOT EXISTS login_summary(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          app_version TEXT,
          access_token TEXT,
          total_payable_amount TEXT,
          total_transaction_amount TEXT,
          total_outstanding_after_transaction TEXT,
          total_deposit_amount TEXT,
          total_withdrawal_amount TEXT,
          final_balance TEXT,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
      ''');
      print('✅ login_summary table created');
    } catch (e) {
      print('❌ Error creating tables: $e');
      rethrow;
    }
  }

  // Insert Loan Products
  Future<void> insertLoanProducts(List<LoanProduct> products) async {
    try {
      final db = await database;
      await db.delete('loan_products');
      print('📌 Cleared loan_products table');

      for (var product in products) {
        await db.insert(
          'loan_products',
          {
            'id': product.id,
            'name': product.name,
            'short_name': product.shortName,
            'code': product.code,
            'minimum_loan_amount': product.minimumLoanAmount,
            'maximum_loan_amount': product.maximumLoanAmount,
            'default_loan_amount': product.defaultLoanAmount,
            'grace_period': product.gracePeriod,
            'number_of_installment': product.numberOfInstallment,
            'repayment_frequency': product.repaymentFrequency,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      print('✅ Inserted ${products.length} loan products');
    } catch (e) {
      print('❌ Error inserting loan products: $e');
      rethrow;
    }
  }

  // Get all Loan Products
  Future<List<LoanProduct>> getLoanProducts() async {
    try {
      final db = await database;
      final maps = await db.query('loan_products');
      print('✅ Retrieved ${maps.length} loan products from DB');
      return List.generate(maps.length, (i) {
        return LoanProduct(
          id: maps[i]['id'].toString(),
          name: maps[i]['name'].toString(),
          shortName: maps[i]['short_name'].toString(),
          code: maps[i]['code'].toString(),
          minimumLoanAmount: maps[i]['minimum_loan_amount'].toString(),
          maximumLoanAmount: maps[i]['maximum_loan_amount'].toString(),
          defaultLoanAmount: maps[i]['default_loan_amount'].toString(),
          gracePeriod: maps[i]['grace_period'].toString(),
          numberOfInstallment: maps[i]['number_of_installment'].toString(),
          repaymentFrequency: maps[i]['repayment_frequency'].toString(),
        );
      });
    } catch (e) {
      print('❌ Error getting loan products: $e');
      return [];
    }
  }

  // Insert Loan Transactions
  Future<void> insertLoanTransactions(List<Transaction> transactions) async {
    try {
      final db = await database;
      await db.delete('loan_transactions');
      print('📌 Cleared loan_transactions table');

      for (var transaction in transactions) {
        await db.insert(
          'loan_transactions',
          {
            'transaction_date': transaction.transactionDate,
            'transaction_amount': transaction.amount,
            'outstanding_after_transaction': transaction.outstanding,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      print('✅ Inserted ${transactions.length} loan transactions');
    } catch (e) {
      print('❌ Error inserting loan transactions: $e');
      rethrow;
    }
  }

  // Get all Loan Transactions
  Future<List<Transaction>> getLoanTransactions() async {
    try {
      final db = await database;
      final maps = await db.query('loan_transactions');
      print('✅ Retrieved ${maps.length} loan transactions from DB');
      return List.generate(maps.length, (i) {
        return Transaction(
          transactionDate: maps[i]['transaction_date'].toString(),
          amount: maps[i]['transaction_amount'].toString(),
          outstanding: maps[i]['outstanding_after_transaction'].toString(),
          type: 'loan',
        );
      });
    } catch (e) {
      print('❌ Error getting loan transactions: $e');
      return [];
    }
  }

  // Insert Saving Transactions
  Future<void> insertSavingTransactions(List<Transaction> transactions) async {
    try {
      final db = await database;
      await db.delete('saving_transactions');
      print('📌 Cleared saving_transactions table');

      for (var transaction in transactions) {
        await db.insert(
          'saving_transactions',
          {
            'transaction_date': transaction.transactionDate,
            'deposit_amount': transaction.amount,
            'withdrawal_amount': transaction.amount,
            'balance': transaction.outstanding,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      print('✅ Inserted ${transactions.length} saving transactions');
    } catch (e) {
      print('❌ Error inserting saving transactions: $e');
      rethrow;
    }
  }

  // Get all Saving Transactions
  Future<List<Transaction>> getSavingTransactions() async {
    try {
      final db = await database;
      final maps = await db.query('saving_transactions');
      print('✅ Retrieved ${maps.length} saving transactions from DB');
      return List.generate(maps.length, (i) {
        return Transaction(
          transactionDate: maps[i]['transaction_date'].toString(),
          amount: maps[i]['deposit_amount'].toString(),
          outstanding: maps[i]['balance'].toString(),
          type: 'saving',
        );
      });
    } catch (e) {
      print('❌ Error getting saving transactions: $e');
      return [];
    }
  }

  // Insert Login Summary
  Future<void> insertLoginSummary(LoginResponse response) async {
    try {
      final db = await database;
      await db.delete('login_summary');
      await db.insert(
        'login_summary',
        {
          'app_version': response.appVersion,
          'access_token': response.accessToken,
          'total_payable_amount': response.loanTransaction.totalPayableAmount,
          'total_transaction_amount':
              response.loanTransaction.totalTransactionAmount,
          'total_outstanding_after_transaction':
              response.loanTransaction.totalOutstandingAfterTransaction,
          'total_deposit_amount': response.savingTransaction.totalDepositAmount,
          'total_withdrawal_amount':
              response.savingTransaction.totalWithdrawalAmount,
          'final_balance': response.savingTransaction.finalBalance,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('✅ Login summary inserted');
    } catch (e) {
      print('❌ Error inserting login summary: $e');
      rethrow;
    }
  }

  // Get Login Summary
  Future<Map<String, dynamic>?> getLoginSummary() async {
    try {
      final db = await database;
      final maps = await db.query('login_summary', limit: 1);
      if (maps.isNotEmpty) {
        print('✅ Login summary retrieved');
        return maps.first;
      }
      print('⚠️ No login summary found');
      return null;
    } catch (e) {
      print('❌ Error getting login summary: $e');
      return null;
    }
  }

  // Clear all data
  Future<void> clearAllData() async {
    try {
      final db = await database;
      await db.delete('loan_products');
      await db.delete('loan_transactions');
      await db.delete('saving_transactions');
      await db.delete('login_summary');
      print('✅ All database tables cleared');
    } catch (e) {
      print('❌ Error clearing database: $e');
      rethrow;
    }
  }
}
