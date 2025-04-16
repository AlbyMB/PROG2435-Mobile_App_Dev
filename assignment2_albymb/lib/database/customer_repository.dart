import 'package:assignment2_albymb/database/db_helper.dart';
import '../customerclasses.dart';

class CustomerRepository {
  final DBHelper _dbHelper = DBHelper.dbHelper;

  // Retrieve all customers
  Future<List<Customer>> getAllCustomers() async {
    final List<Customer>? customers = await _dbHelper.getCustomers();
    return customers ?? [];
  }

  // Insert a customer
  Future<int> insertCustomer(Customer customer) async {
    return await _dbHelper.insertCustomer(customer);
  }

  // Update a customer
  Future<int> updateCustomer(Customer customer, int id) async {
    return await _dbHelper.updateCustomer(customer, id);
  }

  // Delete a customer
  Future<int> deleteCustomer(int id) async {
    return await _dbHelper.deleteCustomer(id);
  }
}