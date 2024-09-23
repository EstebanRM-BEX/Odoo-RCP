class NewProductrequest {

  String name;
  String defaultCode;
  String barcode;
  String detailedType;
  double listPrice;

  NewProductrequest({
    required this.name,
    required this.defaultCode,
    required this.barcode,
    required this.detailedType,
    required this.listPrice,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'default_code': defaultCode,
      'barcode': barcode,
      'detailed_type': detailedType,
      'list_price': listPrice,
    };
  }
}
