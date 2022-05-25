part of 'payment_bloc.dart';
abstract class PaymentEvent extends Equatable{

  const PaymentEvent();

  @override
  List<Object?> get props => [];

}

class OnChangeTotalAmountEvent extends PaymentEvent {
  final double amount;
  const OnChangeTotalAmountEvent(this.amount);
}

class OnChangeInvoiceCountEvent extends PaymentEvent {
  final int count;
  const OnChangeInvoiceCountEvent(this.count);
}

class OnInitStatePaymentEvent extends PaymentEvent {
  const OnInitStatePaymentEvent();
}