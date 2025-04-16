import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import '../customerclasses.dart';

class DBHelper {
  databaseFactory = databaseFactoryFfiWeb;
  static final DBHelper dbHelper = DBHelper._secretDBConstructor();
  static Database? _database;

  DBHelper._secretDBConstructor();

  Future<Database?> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'customer_database.db');
    return openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  void _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE customers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT,
        destination TEXT,
        contactPhone TEXT,
        contactEmail TEXT,
        priceOfTrip REAL,
        travelInsuranceNumber TEXT, 
        insuranceName TEXT,
        remainingFamilyNumber TEXT,
        organizingHardware TEXT
      )
    ''');
  }

  Future<int> insertCustomer(Customer customer) async {
    final db = await database;

    // Map the customer object to a database row
    final Map<String, dynamic> row = {
      'id': customer.id,
      'type': customer is Individual
          ? 'individual'
          : customer is Family
              ? 'family'
              : 'organizedGroup',
      'destination': customer.destination,
      'contactPhone': customer.contactPhone,
      'contactEmail': customer.contactEmail,
      'priceOfTrip': customer.priceOfTrip,
      'travelInsuranceNumber': customer is Individual ? customer.travelInsuranceNumber : null,
      'insuranceName': customer is Family ? customer.insuranceName : null,
      'remainingFamilyNumber': customer is Family ? customer.remainingFamilyNumber : null,
      'organizingHardware': customer is OrganizedGroup ? customer.organizingHardware : null,
    };

    return db!.insert('customers', row);
  }

  Future<List<Customer>?> getCustomers() async {
    final db = await database;
    final List<Map<String, dynamic>> rows = await db!.query('customers');

    // Map the rows to Customer objects
    return rows.map((row) {
      final type = row['type'] as String;
      if (type == 'individual') {
        return Individual(
          id: row['id'],
          destination: row['destination'],
          contactPhone: row['contactPhone'],
          contactEmail: row['contactEmail'],
          priceOfTrip: row['priceOfTrip'],
          travelInsuranceNumber: row['travelInsuranceNumber'],
          );
          } else if (type == 'family') {
          return Family(
            id: row['id'],
            destination: row['destination'],
            contactPhone: row['contactPhone'],
            contactEmail: row['contactEmail'],
            priceOfTrip: row['priceOfTrip'],
            insuranceName: row['insuranceName'],
            remainingFamilyNumber: row['remainingFamilyNumber'],
          );
          } else if (type == 'organizedGroup') {
        return OrganizedGroup(
          id: row['id'],
          destination: row['destination'],
          contactPhone: row['contactPhone'],
          contactEmail: row['contactEmail'],
          priceOfTrip: row['priceOfTrip'],
          organizingHardware: row['organizingHardware'],
        );
      } else {
        throw Exception('Unknown customer type: $type');
      }
    }).toList();
  }

  Future<int> updateCustomer(Customer customer, int id) async {
    final db = await database;

    // Map the customer object to a database row
    final Map<String, dynamic> row = {
      'type': customer is Individual
          ? 'individual'
          : customer is Family
              ? 'family'
              : 'organizedGroup',
      'destination': customer.destination,
      'contactPhone': customer.contactPhone,
      'contactEmail': customer.contactEmail,
      'priceOfTrip': customer.priceOfTrip,
      'travelInsuranceNumber': customer is Individual ? customer.travelInsuranceNumber : null,
      'insuranceName': customer is Family ? customer.insuranceName : null,
      'remainingFamilyNumber': customer is Family ? customer.remainingFamilyNumber : null,
      'organizingHardware': customer is OrganizedGroup ? customer.organizingHardware : null,
    };

    return db!.update('customers', row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteCustomer(int id) async {
    final db = await database;
    return db!.delete('customers', where: 'id = ?', whereArgs: [id]);
  }
}