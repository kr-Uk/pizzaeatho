enum OrderStatus {
  received,
  cooking,
  done;

  static OrderStatus fromJson(String value) {
    switch (value.toUpperCase()) {
      case 'RECEIVED':
        return OrderStatus.received;
      case 'COOKING':
        return OrderStatus.cooking;
      case 'DONE':
        return OrderStatus.done;
      default:
        throw ArgumentError('Unknown OrderStatus: $value');
    }
  }

  String toJson() {
    switch (this) {
      case OrderStatus.received:
        return 'RECEIVED';
      case OrderStatus.cooking:
        return 'COOKING';
      case OrderStatus.done:
        return 'DONE';
    }
  }
}
