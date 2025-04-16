class Vehicle {
  String ownerName;
  String? licensePlate;
  String type;
  String make;
  double cost;

  Vehicle(this.ownerName, this.licensePlate, this.make, this.cost) : type = '';

  @override
  String toString() =>
      "made by $make brought by $ownerName with licensePlate ${(licensePlate != null) ? licensePlate : ''}\n Cost of repairs: \$${cost.toStringAsFixed(2)}";

  void changeOil() {
    print("Oil Changed");
  }

  void checkBreakes() {
    print("Brakes checked");
  }

  void additionalWork() {
    print("Shouldn't see this");
  }
}

class Car extends Vehicle {
  Car(super.ownerName, super.licensePlate, super.make, super.cost) {
    super.type = "Car";
  }
  @override
  void additionalWork() {
    print("Clean Interior");
  }

  @override
  String toString() => "Vehicle ${super.type} ${super.toString()}";
}

class Truck extends Vehicle {
  Truck(super.ownerName, super.licensePlate, super.make, super.cost) {
    super.type = "Truck";
  }
  @override
  void additionalWork() {
    print("Install trunk cover");
  }

  @override
  String toString() => "Vehicle ${super.type} ${super.toString()}";
}

class Tractor extends Vehicle {
  Tractor(super.ownerName, super.licensePlate, super.make, super.cost) {
    super.type = "Tractor";
  }
  @override
  void additionalWork() {
    print("Check PTO");
  }

  @override
  String toString() => "Vehicle ${super.type} ${super.toString()}";
}
