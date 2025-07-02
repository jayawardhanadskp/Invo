part of 'whatsapp_bloc.dart';

@immutable
sealed class WhatsappEvent {}

class SendMessage extends WhatsappEvent {
  final String name;
  final String amount;
  final String phone;
  final String since;

  SendMessage({
    required this.name,
    required this.amount,
    required this.phone,
    required this.since,
  });
}
