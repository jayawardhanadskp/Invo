part of 'whatsapp_bloc.dart';

@immutable
sealed class WhatsappState {}

final class WhatsappInitial extends WhatsappState {}

final class SendMessageSucess extends WhatsappState {}
final class SendMessageError extends WhatsappState {
  final String error;

  SendMessageError({required this.error});
}
