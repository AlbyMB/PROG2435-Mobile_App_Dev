import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'garage.dart';

enum Vehicles { car, truck, tractor }

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: MyReactiveForm());
  }
}

class MyReactiveForm extends StatefulWidget {
  const MyReactiveForm({super.key});

  @override
  State<StatefulWidget> createState() => MyReactiveFormState();
}

class MyReactiveFormState extends State<MyReactiveForm> {
  //Variables to set from form
  String vehicleOwner = "";
  String vehicleMake = "";
  String vehicleLicense = "";
  double repairPrice = 0.0;
  int vehicleType = -1;
  List<Vehicle> vList = [];
  String vehicleListMsg = "";

  final form = FormGroup({
    'type': FormControl<int>(validators: [
      Validators.required,
    ]),
    'price': FormControl<double>(validators: [
      Validators.required,
      Validators.min(0.0),
      Validators.max(1000.0),
    ]),
    'name': FormControl<String>(
        validators: [Validators.required, MinLengthValidator(4)]),
    'license': FormControl<String>(
        validators: [Validators.required, MinLengthValidator(4)]),
    'make': FormControl<String>(
        validators: [Validators.required, MinLengthValidator(2)])
  });
  //Set list Entry from Form
  setListEntry() {
    if (form.valid) {
      vehicleType = form.control('type').value;
      vehicleOwner = form.control('name').value ?? '';
      vehicleMake = form.control('make').value ?? '';
      vehicleLicense = form.control('license').value ?? '';
      repairPrice = form.control('price').value ?? 0.0;

      if (vehicleType == Vehicles.car.index) {
        vList.add(Car(vehicleOwner, vehicleLicense, vehicleMake, repairPrice));
      } else if (vehicleType == Vehicles.truck.index) {
        vList
            .add(Truck(vehicleOwner, vehicleLicense, vehicleMake, repairPrice));
      } else if (vehicleType == Vehicles.tractor.index) {
        vList.add(
            Tractor(vehicleOwner, vehicleLicense, vehicleMake, repairPrice));
      }
    }
  }

  //display List
  displayList() {
    setState(() {
      vehicleListMsg = "";
      for (Vehicle v in vList) {
        vehicleListMsg += "$v\n";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Reactive Form Example'),
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
                      key: const Key('VehicleType'),
                      formControlName: 'type',
                      hint: Text('Please select vehicle type'),
                      items: [
                        DropdownMenuItem(
                            value: Vehicles.car.index, child: Text('Car')),
                        DropdownMenuItem(
                            value: Vehicles.truck.index, child: Text('Truck')),
                        DropdownMenuItem(
                            value: Vehicles.tractor.index,
                            child: Text('Tractor'))
                      ]),
                  SizedBox(height: 8),
                  ReactiveTextField(
                    key: const Key('Name'),
                    formControlName: 'name',
                    decoration: InputDecoration(
                      labelText: 'Owner Name',
                    ),
                    textAlign: TextAlign.start,
                    style: TextStyle(backgroundColor: Colors.white),
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: 8),
                  ReactiveTextField(
                    key: const Key('Make'),
                    formControlName: 'make',
                    decoration: InputDecoration(
                      labelText: 'Vehicle Make',
                    ),
                    textAlign: TextAlign.start,
                    style: TextStyle(backgroundColor: Colors.white),
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: 8),
                  ReactiveTextField(
                      key: const Key('License'),
                      formControlName: 'license',
                      decoration: InputDecoration(
                        labelText: 'Licence Plate',
                      ),
                      textAlign: TextAlign.start,
                      style: TextStyle(backgroundColor: Colors.white),
                      keyboardType: TextInputType.text),
                  SizedBox(height: 8),
                  ReactiveTextField(
                    key: const Key('RepairPrice'),
                    formControlName: 'price',
                    decoration: InputDecoration(
                      labelText: 'Repair Price',
                    ),
                    textAlign: TextAlign.start,
                    style: TextStyle(backgroundColor: Colors.white),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FilledButton(
                          onPressed: setListEntry, child: Text('Register')),
                      SizedBox(width: 10),
                      FilledButton(
                          onPressed: displayList, child: Text('Display')),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(vehicleListMsg),
                ])))));
  }
}
