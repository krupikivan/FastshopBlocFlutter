import 'package:fastshop/bloc_helpers/bloc_provider.dart';
import 'package:fastshop/blocs/authentication/authentication_bloc.dart';
import 'package:fastshop/blocs/cart/cart_boc.dart';
import 'package:fastshop/blocs/shopping/shopping_bloc.dart';
import 'package:fastshop/pages/cart_page.dart';
import 'package:fastshop/pages/decision_page.dart';
import 'package:fastshop/pages/initialization_page.dart';
import 'package:fastshop/pages/registration_page.dart';
import 'package:flutter/material.dart';
import 'package:user_repository/user_repository.dart';

class Application extends StatelessWidget {

  final UserRepository userRepository;

  Application({Key key, @required this.userRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthenticationBloc>(
      bloc: AuthenticationBloc(userRepository: userRepository),
      child: BlocProvider<ShoppingBloc>(
        bloc: ShoppingBloc(),
        child: BlocProvider<CartBloc>(
          bloc: CartBloc(),
          child: MaterialApp(
            title: 'FastShop',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            routes: 
            {
              '/decision': (BuildContext context) => DecisionPage(userRepository: userRepository,),
              '/register': (BuildContext context) => RegistrationPage(),
              '/shoppingBasket': (BuildContext context) => BlocCartPage(),
            },
            home: InitializationPage(),
          ),
        ),
      ),
    );
  }
}
