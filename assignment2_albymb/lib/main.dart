import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'customerclasses.dart';
import 'database/customer_repository.dart';
import 'package:sqflite/sqflite.dart';

enum Customers { individual, family, organizedGroup }

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: "Trip Cost Calculator",home: ListScreen());
  }
}

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  List<Customer> _customers = [];
  double totalPrice = 0.0;

  @override
  void initState(){
    super.initState();
    _loadCustomers();
  }

  void _loadCustomers() async {
    final customers = await CustomerRepository().getAllCustomers();
    int totalPrice = 0;
    for (var customer in customers) {
      totalPrice += customer.priceOfTrip.toInt();
    }
    setState(() {
      _customers = customers;
      this.totalPrice = totalPrice.toDouble();
    });
  }

  void _deleteCustomer(int id) async {
    await CustomerRepository().deleteCustomer(id);
    _loadCustomers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Trips"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total price for today: ${totalPrice.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return MyReactiveForm();
        }),
      );
            if (result == true) {
        _loadCustomers();
      }
          },
                child: Text('Add Trip'),
              ),
            ),
            SizedBox(height: 10),

            Expanded(
            child: ListView.builder(
              itemCount: _customers.length,
              itemBuilder: (context, index) {
                final customer = _customers[index];
                String customerType;
                if (customer is Individual) {
                  customerType = "Individual";
                } else if (customer is Family) {
                  customerType = "Family";
                } else if (customer is OrganizedGroup) {
                  customerType = "Organized Group";
                }
                else {
                  customerType = "Unknown";
                }
                return ListTile(
                  title: Text(customerType + "Trip"),
                  subtitle: Text(customer.priceOfTrip.toString()),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min, // Ensures the row takes only the space it needs
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyReactiveForm(customer: customer),
                            ),
                          );
                          if (result == true) {
                            _loadCustomers(); // Refresh the list after editing
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('Delete Trip'),
                              content: const Text(
                                  'Are you sure you want to delete this Trip?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    _deleteCustomer(customer.id!);
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  )
                );
              },
            ),
          ),
        ],
      )
    ),
    );
  }
}

//Entry Screen
class MyReactiveForm extends StatefulWidget {
  const MyReactiveForm({super.key, this.customer});
  final Customer? customer;

  @override
  State<StatefulWidget> createState() => MyReactiveFormState();
}

class MyReactiveFormState extends State<MyReactiveForm> {
  //Variables to set from form
  String destination = "";
  String contactPhone = "";
  String email = "";
  double priceOfTrip = 0.0;
  String travelInsuranceNumber = "";
  String insuranceName = "";
  String remainingFamilyNumber = "";
  String organizingHardware = "";
  int customerType = -1;
  List<Customer> cList = [];
  double totalPrice = 0.0;
  String customerListMsg = "";

  final form = FormGroup({
    'type': FormControl<int>(validators: [
      Validators.required,
    ]),
    'price': FormControl<double>(validators: [
      Validators.required,
      Validators.min(0.0),
      Validators.max(10000.0),
    ]),
    'contactphone': FormControl<String>(
        validators: [Validators.required, MinLengthValidator(4)]),
    'destination': FormControl<String>(
        validators: [Validators.required, MinLengthValidator(4)]),
    'email': FormControl<String>(
        validators: [Validators.required, MinLengthValidator(2), Validators.email]),
    'travelInsuranceNumber': FormControl<String>(),
    'insuranceName': FormControl<String>(),
    'remainingFamilyNumber': FormControl<String>(),
    'organizingHardware': FormControl<String>(),
  });


  @override
  void initState() {
    super.initState();

    // Pre-fill the form if a customer is provided
    if (widget.customer != null) {
      final customer = widget.customer!;
      form.control('type').value = customer is Individual
          ? Customers.individual.index
          : customer is Family
              ? Customers.family.index
              : Customers.organizedGroup.index;
      setState(() {
                          customerType = form.control('type').value ?? -1;
                        });
      form.control('destination').value = customer.destination;
      form.control('contactphone').value = customer.contactPhone;
      form.control('email').value = customer.contactEmail;
      form.control('price').value = customer.priceOfTrip;

      if (customer is Individual) {
        form.control('travelInsuranceNumber').value = customer.travelInsuranceNumber;
      } else if (customer is Family) {
        form.control('insuranceName').value = customer.insuranceName;
        form.control('remainingFamilyNumber').value = customer.remainingFamilyNumber;
      } else if (customer is OrganizedGroup) {
        form.control('organizingHardware').value = customer.organizingHardware;
      }
    }
  }
  //Set list Entry from Form
  setListEntry() async {
    if (form.valid) {
      customerType = form.control('type').value;
      destination = form.control('destination').value ?? '';
      contactPhone = form.control('contactphone').value ?? '';
      email = form.control('email').value ?? '';
      priceOfTrip = form.control('price').value ?? 0.0;
      travelInsuranceNumber = form.control('travelInsuranceNumber').value ?? '';
      insuranceName = form.control('insuranceName').value ?? '';
      remainingFamilyNumber = form.control('remainingFamilyNumber').value ?? '';
      organizingHardware = form.control('organizingHardware').value ?? '';
      totalPrice += priceOfTrip;

      if(widget.customer != null) {
        if (customerType == Customers.individual.index) {
          await CustomerRepository().updateCustomer(
              Individual(
                destination: destination,
                contactPhone: contactPhone,
                contactEmail: email,
                priceOfTrip: priceOfTrip,
                travelInsuranceNumber: travelInsuranceNumber), widget.customer!.id!);
        } else if (customerType == Customers.family.index) {
          await CustomerRepository().updateCustomer(
              Family(
                destination: destination,
                contactPhone: contactPhone,
                contactEmail: email,
                priceOfTrip: priceOfTrip,
                insuranceName: insuranceName,
                remainingFamilyNumber: remainingFamilyNumber), widget.customer!.id!);
        } else if (customerType == Customers.organizedGroup.index) {
          await CustomerRepository().updateCustomer(
              OrganizedGroup(
                destination: destination,
                contactPhone: contactPhone,
                contactEmail: email,
                priceOfTrip: priceOfTrip,
                organizingHardware: organizingHardware), widget.customer!.id!);
        }
      } else {
        if (customerType == Customers.individual.index) {
          await CustomerRepository().insertCustomer(
              Individual(
                destination: destination,
                contactPhone: contactPhone,
                contactEmail: email,
                priceOfTrip: priceOfTrip,
                travelInsuranceNumber: travelInsuranceNumber));
        } else if (customerType == Customers.family.index) {
          await CustomerRepository().insertCustomer(
              Family(
                destination: destination,
                contactPhone: contactPhone,
                contactEmail: email,
                priceOfTrip: priceOfTrip,
                insuranceName: insuranceName,
                remainingFamilyNumber: remainingFamilyNumber));
        } else if (customerType == Customers.organizedGroup.index) {
          await CustomerRepository().insertCustomer(
              OrganizedGroup(
                destination: destination,
                contactPhone: contactPhone,
                contactEmail: email,
                priceOfTrip: priceOfTrip,
                organizingHardware: organizingHardware));
        }
      }
      Navigator.pop(context, true);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Trip Cost Calculator'),
        ),
        body: ReactiveForm(
            formGroup: form,
            child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 24,
                ),
                child: SingleChildScrollView(
                    child: Column(children: <Widget>[
                  ReactiveDropdownField(
                      key: const Key('CustomerType'),
                      onChanged: (control) {
                        setState(() {
                          customerType = control.value ?? -1;
                        });
                  },
                      formControlName: 'type',
                      hint: Text('Please select customer type'),
                      items: [
                        DropdownMenuItem(
                            value: Customers.individual.index, child: Text('Individual')),
                        DropdownMenuItem(
                            value: Customers.family.index, child: Text('Family')),
                        DropdownMenuItem(
                            value: Customers.organizedGroup.index,
                            child: Text('Organized Group')),
                      ]),
                  SizedBox(height: 8),
                  ReactiveTextField(
                    key: const Key('Destination'),
                    formControlName: 'destination',
                    decoration: InputDecoration(
                      labelText: 'Destination',
                    ),
                    textAlign: TextAlign.start,
                    style: TextStyle(backgroundColor: Colors.white),
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: 8),
                  ReactiveTextField(
                    key: const Key('ContactPhone'),
                    formControlName: 'contactphone',
                    decoration: InputDecoration(
                      labelText: 'Contact Phone',
                    ),
                    textAlign: TextAlign.start,
                    style: TextStyle(backgroundColor: Colors.white),
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: 8),
                  ReactiveTextField(
                      key: const Key('Email'),
                      formControlName: 'email',
                      decoration: InputDecoration(
                        labelText: 'Email',
                      ),
                      textAlign: TextAlign.start,
                      style: TextStyle(backgroundColor: Colors.white),
                      keyboardType: TextInputType.text),
                  SizedBox(height: 8),
                  ReactiveTextField(
                    key: const Key('PriceOfTrip'),
                    formControlName: 'price',
                    decoration: InputDecoration(
                      labelText: 'Price of Trip',
                    ),
                    textAlign: TextAlign.start,
                    style: TextStyle(backgroundColor: Colors.white),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 8),
                  if (customerType == Customers.individual.index) 
                    ReactiveTextField(
                      key: const Key('TravelInsuranceNumber'),
                      formControlName: 'travelInsuranceNumber',
                      decoration: InputDecoration(
                        labelText: 'Travel Insurance Number',
                      ),
                      textAlign: TextAlign.start,
                      style: TextStyle(backgroundColor: Colors.white),
                      keyboardType: TextInputType.text,
                    )
                  else if (customerType == Customers.family.index) 
                    Column(
                      children: [
                        ReactiveTextField(
                          key: const Key('InsuranceName'),
                          formControlName: 'insuranceName',
                          decoration: InputDecoration(
                            labelText: 'Insurance Name',
                          ),
                          textAlign: TextAlign.start,
                          style: TextStyle(backgroundColor: Colors.white),
                          keyboardType: TextInputType.text,
                        ), 
                        ReactiveTextField(
                          key: const Key('RemainingFamilyNumber'),
                          formControlName: 'remainingFamilyNumber',
                          decoration: InputDecoration(
                            labelText: 'Remaining Family Number',
                          ),
                          textAlign: TextAlign.start,
                          style: TextStyle(backgroundColor: Colors.white),
                          keyboardType: TextInputType.text,
                        )
                      ],
                    )
                  else if (customerType == Customers.organizedGroup.index) 
                    ReactiveTextField(
                      key: const Key('OrganizingHardware'),
                      formControlName: 'organizingHardware',
                      decoration: InputDecoration(
                        labelText: 'Organizing Hardware',
                      ),
                      textAlign: TextAlign.start,
                      style: TextStyle(backgroundColor: Colors.white),
                      keyboardType: TextInputType.text,
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FilledButton(
                          onPressed: setListEntry, child: Text(widget.customer == null ? 'Register' : 'Update')),
                      SizedBox(width: 10),
                      FilledButton(
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                          child: Text('Cancel')),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(customerListMsg),
                ])))));
  }
}
