class Customer{
  int? id;
  String destination;
  String contactPhone;
  String contactEmail;
  double priceOfTrip;

  Customer({this.id, required this.destination, required this.contactPhone, required this.contactEmail, required this.priceOfTrip});

  @override
  String toString() {
    return "to $destination for \$${priceOfTrip.toStringAsFixed(2)}. Email: $contactEmail";
  }


  void arrangements(){
    bookTravel();
    arrangeTransportToAirport();
  }

  void bookTravel(){
    print("Travel booked to $destination for $priceOfTrip");
  }

  void arrangeTransportToAirport(){
    print("Transport to airport arranged for $contactEmail");
  }
  
}

class Individual extends Customer{
  String travelInsuranceNumber;

  Individual({super.id, required super.destination, required super.contactPhone, required super.contactEmail, required super.priceOfTrip, required this.travelInsuranceNumber});

  @override
  String toString() {
    return "Trip booked for Individual ${super.toString()}. Insurance No. $travelInsuranceNumber";
  }

  @override
  void arrangements(){
    super.arrangements();
    notifyWork();
  }

  void notifyWork(){
    print("Notifying work of travel plans for $contactEmail");
  }
}

class Family extends Customer{
  String insuranceName;
  String remainingFamilyNumber;

  Family({super.id, required super.destination, required super.contactPhone, required super.contactEmail, required super.priceOfTrip, required this.insuranceName, required this.remainingFamilyNumber});

  @override
  String toString() {
    return "Trip booked for Family ${super.toString()}. Remaining family member: $remainingFamilyNumber";
  }

  @override
  void arrangements(){
    super.arrangements();
    remainingMember();
  }

  void remainingMember(){
    print("Remaining family member: $remainingFamilyNumber");
  }
}

class OrganizedGroup extends Customer{
  String organizingHardware;

  OrganizedGroup({super.id, required super.destination, required super.contactPhone, required super.contactEmail, required super.priceOfTrip, required this.organizingHardware});
  
  @override
  String toString() {
    return "Trip booked for group  ${super.toString()}. Organizing hardware: $organizingHardware";
  }

  @override
  void arrangements(){
    super.arrangements();
    notifyDestinationCompany();
  }

  void notifyDestinationCompany(){
    print("Notified destination company of group travel plans for $contactEmail");
  }
}