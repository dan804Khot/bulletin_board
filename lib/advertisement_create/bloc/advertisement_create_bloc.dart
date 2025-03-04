import 'package:flutter_bloc/flutter_bloc.dart';

part 'advertisement_create_state.dart';
part 'advertisement_create_events.dart';

class SubjectBloc extends Bloc<AdvertisementCreateEvents, AdvertisementCreateState> {
  SubjectBloc() : super(AdvertisementCreateInitial()) {
    on<AdvertisementCreateEvents>((event, emit) {
      // TODO: implement event handler
    });
  }
}