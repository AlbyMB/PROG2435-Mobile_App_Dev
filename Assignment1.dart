import 'dart:io';

class Customer{
  String destination;
  String contactPhone;
  String contactName;
  double priceOfTrip;

  Customer(this.destination, this.contactPhone, this.contactName, this.priceOfTrip);

  void Arrangements(){
    BookTravel();
    ArrangeTransportToAirport();
  }

  void BookTravel(){
    print("Travel booked to $destination for $priceOfTrip");
  }

  void ArrangeTransportToAirport(){
    print("Transport to airport arranged for $contactName");
  }
  
}

class Individual extends Customer{
  String travelInsuranceNumber;

  Individual(String destination, String contactPhone, String contactName, double priceOfTrip, this.travelInsuranceNumber) : super(destination, contactPhone, contactName, priceOfTrip);

  void Arrangements(){
    super.Arrangements();
    NotifyWork();
  }

  void NotifyWork(){
    print("Notifying work of travel plans for $contactName");
  }
}

class Family extends Customer{
  String insuranceName;
  String remainingFamilyNumber;

  Family(String destination, String contactPhone, String contactName, double priceOfTrip, this.insuranceName, this.remainingFamilyNumber) : super(destination, contactPhone, contactName, priceOfTrip);

  void Arrangements(){
    super.Arrangements();
    RemainingMember();
  }

  void RemainingMember(){
    print("Remaining family member: $remainingFamilyNumber");
  }
}

class OrganizedGroup extends Customer{
  String organizingHardware;

  OrganizedGroup(String destination, String contactPhone, String contactName, double priceOfTrip, this.organizingHardware) : super(destination, contactPhone, contactName, priceOfTrip);

  void Arrangements(){
    super.Arrangements();
    NotifyDestinationCompany();
  }

  void NotifyDestinationCompany(){
    print("Notified destination company of group travel plans for $contactName");
  }
}

void main(){
  List<Customer> customers = [];

  double totalPrice = 0;
  bool exit = false;

  while(!exit){
    print("Enter customer type: \n 1. Individual \n 2. Family \n 3. Organized Group \n 4. Exit");
    String choice = stdin.readLineSync()!;

    switch(choice){
      case '1':
        print("Enter destination: ");
        String destination = stdin.readLineSync()!;
        print("Enter contact phone: ");
        String contactPhone = stdin.readLineSync()!;
        print("Enter contact name: ");
        String contactName = stdin.readLineSync()!;
        print("Enter price of trip: ");
        double priceOfTrip = double.parse(stdin.readLineSync()!);
        print("Enter travel insurance policy number: ");
        String travelInsuranceNumber = stdin.readLineSync()!;
        customers.add(Individual(destination, contactPhone, contactName, priceOfTrip, travelInsuranceNumber));
        totalPrice += priceOfTrip;
        break;

      case '2':
        print("Enter destination: ");
        String destination = stdin.readLineSync()!;
        print("Enter contact phone: ");
        String contactPhone = stdin.readLineSync()!;
        print("Enter contact name: ");
        String contactName = stdin.readLineSync()!;
        print("Enter price of trip: ");
        double priceOfTrip = double.parse(stdin.readLineSync()!);
        print("Enter insurance name: ");
        String insuranceName = stdin.readLineSync()!;
        print("Enter remaining family members: ");
        String remainingFamilyNumber = stdin.readLineSync()!;
        customers.add(Family(destination, contactPhone, contactName, priceOfTrip, insuranceName, remainingFamilyNumber));
        totalPrice += priceOfTrip;
        break;

      case '3':
        print("Enter destination: ");
        String destination = stdin.readLineSync()!;
        print("Enter contact phone: ");
        String contactPhone = stdin.readLineSync()!;
        print("Enter contact name: ");
        String contactName = stdin.readLineSync()!;
        print("Enter price of trip: ");
        double priceOfTrip = double.parse(stdin.readLineSync()!);
        print("Enter organizing hardware: ");
        String organizingHardware = stdin.readLineSync()!;
        customers.add(OrganizedGroup(destination, contactPhone, contactName, priceOfTrip, organizingHardware));
        totalPrice += priceOfTrip;
        break;

      case '4':
        for(Customer customer in customers){
          customer.Arrangements();
        }
        print("Total price of all trips:\$$totalPrice");
        exit = true;
        break;

      default:
        print("Invalid choice");
    }
  }


}