import 'package:bloc/bloc.dart';
import 'package:invo/repositories/whatsapp_message_repository.dart';
import 'package:meta/meta.dart';

part 'whatsapp_event.dart';
part 'whatsapp_state.dart';

class WhatsappBloc extends Bloc<WhatsappEvent, WhatsappState> {
  final WhatsappMessageRepository _whatsappMessageRepository;
  WhatsappBloc(this._whatsappMessageRepository) : super(WhatsappInitial()) {
    on<SendMessage>((event, emit) async {
      try {
        await _whatsappMessageRepository.sendWhatsAppMessage(
          event.phone,
          'Dear ${event.name}, your payment of ${event.amount} due on ${event.since} is still pending. Kindly complete it as soon as possible. Thank you.',
        );
        emit(SendMessageSucess());
      } catch (e) {
        print(e);
        emit(SendMessageError(error: e.toString()));
      }
    });
  }
}
