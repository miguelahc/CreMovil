part of 'payment_bloc.dart';
class PaymentState extends Equatable{

  final double totalAmount;
  final int invoiceCount;

  const PaymentState({
    this.totalAmount = 0,
    this.invoiceCount = 0
  });

  PaymentState copyWith({
    double? totalAmount,
    int? invoiceCount
  }) => PaymentState(
    totalAmount: totalAmount ?? this.totalAmount,
    invoiceCount: invoiceCount ?? this.invoiceCount
  );

  @override
  List<Object?> get props => [totalAmount, invoiceCount];

}