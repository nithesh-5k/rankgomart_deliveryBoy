class DeliveryBoyModel {
  DeliveryBoyModel({
    this.deliveryboyId,
    this.deliveryboyName,
    this.deliveryboyUserName,
    this.deliveryboyImage,
  });

  String deliveryboyId;
  String deliveryboyName;
  String deliveryboyUserName;
  String deliveryboyImage;

  factory DeliveryBoyModel.fromJson(Map<String, dynamic> json) {
    return DeliveryBoyModel(
      deliveryboyId: json["deliveryboyId"],
      deliveryboyName: json["deliveryboyName"],
      deliveryboyUserName: json["deliveryboyUserName"],
      deliveryboyImage: json["deliveryboyImagePath"] + json["deliveryboyImage"],
    );
  }
}
