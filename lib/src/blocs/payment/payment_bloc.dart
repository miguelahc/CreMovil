import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'payment_state.dart';

part 'payment_event.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  PaymentBloc() : super(const PaymentState()) {
    on<OnChangeTotalAmountEvent>(
      (event, emit) => emit(state.copyWith(totalAmount: event.amount)),
    );
    on<OnChangeInvoiceCountEvent>(
      (event, emit) => emit(state.copyWith(invoiceCount: event.count)),
    );
    on<OnInitStatePaymentEvent>((event, emit) =>
        emit(state.copyWith(invoiceCount: 0, totalAmount: 0.0)));
  }
}
