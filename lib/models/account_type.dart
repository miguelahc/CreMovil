enum AccountType {
  PD,
  MD,
  GD,
}

extension ParseToString on AccountType {
  String toShortString() {
    return this.toString().split('.').last;
  }
}
