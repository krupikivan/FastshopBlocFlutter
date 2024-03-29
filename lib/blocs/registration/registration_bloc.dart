import 'dart:async';

import 'package:fastshop/bloc_helpers/bloc_event_state.dart';
import 'package:fastshop/blocs/registration/registration_event.dart';
import 'package:fastshop/blocs/registration/registration_state.dart';
import 'package:fastshop/user_repository/user_repository.dart';

class RegistrationBloc extends BlocEventStateBase<RegistrationEvent, RegistrationState> {


  RegistrationBloc()
      : super(
          initialState: RegistrationState.noAction(),
        );

  @override
  Stream<RegistrationState> eventHandler(RegistrationEvent event, RegistrationState currentState) async* {
    if (event.event == RegistrationEventType.working){
      yield RegistrationState.busy();

      //Al user repository como no esta logueado no lo necesitamos
      //Pero si lo necesito para llamar a la API
      UserRepository userRepository = new UserRepository();
      try{

        await userRepository.signup(
            username: event.username,
            email: event.email,
            password: event.password,
        );
      }catch (error) {
        yield RegistrationState.failure();
      }

      await Future.delayed(const Duration(seconds: 1));

      yield RegistrationState.success();
    }
  }
}