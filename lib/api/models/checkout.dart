class TotalOrderData {
  TotalOrderData({
    this.id,
    this.hasDeliveryOffer,
    this.hasCouponOffer,
    this.price,
    this.offerPrice,
    this.couponNet,
    this.deliveryCost,
    this.taxFees,
    this.totalPrice,
    this.paymentMethod,
    this.status,
    this.note,
    this.reason,
    this.pendingAt,
    this.signedAt,
    this.processedAt,
    this.shippedAt,
    this.askToPay,
    this.branch,
    this.address,
    this.coupon,
  });

  int id;
  String hasDeliveryOffer;
  String hasCouponOffer;
  String price;
  String offerPrice;
  String couponNet;
  String deliveryCost;
  int taxFees;
  String totalPrice;
  dynamic paymentMethod;
  String status;
  dynamic note;
  dynamic reason;
  dynamic pendingAt;
  dynamic signedAt;
  dynamic processedAt;
  dynamic shippedAt;
  int askToPay;
  Branch branch;
  dynamic address;
  dynamic coupon;

  factory TotalOrderData.fromJson(Map<String, dynamic> json) => TotalOrderData(
        id: json["id"],
        hasDeliveryOffer: json["has_delivery_offer"],
        hasCouponOffer: json["has_coupon_offer"],
        price: json["price"],
        offerPrice: json["offer_price"],
        couponNet: json["coupon_net"],
        deliveryCost: json["delivery_cost"],
        taxFees: json["tax_fees"],
        totalPrice: json["total_price"],
        paymentMethod: json["payment_method"],
        status: json["status"],
        note: json["note"],
        reason: json["reason"],
        pendingAt: json["pending_at"],
        signedAt: json["signed_at"],
        processedAt: json["processed_at"],
        shippedAt: json["shipped_at"],
        askToPay: json["ask_to_pay"],
        branch: Branch.fromJson(json["branch"]),
        address: json["address"],
        coupon: json["coupon"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "has_delivery_offer": hasDeliveryOffer,
        "has_coupon_offer": hasCouponOffer,
        "price": price,
        "offer_price": offerPrice,
        "coupon_net": couponNet,
        "delivery_cost": deliveryCost,
        "tax_fees": taxFees,
        "total_price": totalPrice,
        "payment_method": paymentMethod,
        "status": status,
        "note": note,
        "reason": reason,
        "pending_at": pendingAt,
        "signed_at": signedAt,
        "processed_at": processedAt,
        "shipped_at": shippedAt,
        "ask_to_pay": askToPay,
        "branch": branch.toJson(),
        "address": address,
        "coupon": coupon,
      };
}

class Branch {
  Branch({
    this.id,
    this.maximumDeliveryTime,
    this.trans,
    this.address,
  });

  int id;
  String maximumDeliveryTime;
  BranchTrans trans;
  Address address;

  factory Branch.fromJson(Map<String, dynamic> json) => Branch(
        id: json["id"],
        maximumDeliveryTime: json["maximum_delivery_time"],
        trans: BranchTrans.fromJson(json["trans"]),
        address: Address.fromJson(json["address"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "maximum_delivery_time": maximumDeliveryTime,
        "trans": trans.toJson(),
        "address": address.toJson(),
      };
}

class Address {
  Address({
    this.id,
    this.title,
    this.latitude,
    this.longitude,
  });

  int id;
  String title;
  String latitude;
  String longitude;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json["id"],
        title: json["title"],
        latitude: json["latitude"],
        longitude: json["longitude"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "latitude": latitude,
        "longitude": longitude,
      };
}

class BranchTrans {
  BranchTrans({
    this.title,
  });

  String title;

  factory BranchTrans.fromJson(Map<String, dynamic> json) => BranchTrans(
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
      };
}
