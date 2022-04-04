enum AccountType {
  PD,
  MD,
  GD,
}

extension ParseToString on AccountType {
  String toShortString() {
    return toString().split('.').last;
  }
}
