// /e:/project/capstone/project/planto/lib/repository/map_address_model.dart

class AddressElement {
  final List<String> types;
  final String longName;
  final String shortName;
  final String code;

  AddressElement({
    required this.types,
    required this.longName,
    required this.shortName,
    required this.code,
  });

  factory AddressElement.fromJson(Map<String, dynamic> json) {
    return AddressElement(
      types: List<String>.from(json['types']),
      longName: json['longName'],
      shortName: json['shortName'],
      code: json['code'],
    );
  }
}

class Address {
  final String roadAddress;
  final String jibunAddress;
  final String englishAddress;
  final List<AddressElement> addressElements;
  final String x;
  final String y;
  final double distance;

  Address({
    required this.roadAddress,
    required this.jibunAddress,
    required this.englishAddress,
    required this.addressElements,
    required this.x,
    required this.y,
    required this.distance,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    var addressElementsFromJson = json['addressElements'] as List;
    List<AddressElement> addressElementsList = addressElementsFromJson.map((i) => AddressElement.fromJson(i)).toList();

    return Address(
      roadAddress: json['roadAddress'],
      jibunAddress: json['jibunAddress'],
      englishAddress: json['englishAddress'],
      addressElements: addressElementsList,
      x: json['x'],
      y: json['y'],
      distance: json['distance'],
    );
  }
}

class MapAddressResponse {
  final String status;
  final int totalCount;
  final int page;
  final int count;
  final List<Address> addresses;
  final String errorMessage;

  MapAddressResponse({
    required this.status,
    required this.totalCount,
    required this.page,
    required this.count,
    required this.addresses,
    required this.errorMessage,
  });

  factory MapAddressResponse.fromJson(Map<String, dynamic> json) {
    var addressesFromJson = json['addresses'] as List;
    List<Address> addressesList = addressesFromJson.map((i) => Address.fromJson(i)).toList();

    return MapAddressResponse(
      status: json['status'],
      totalCount: json['meta']['totalCount'],
      page: json['meta']['page'],
      count: json['meta']['count'],
      addresses: addressesList,
      errorMessage: json['errorMessage'],
    );
  }
}