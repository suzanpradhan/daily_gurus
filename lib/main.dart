import 'package:dailygurus/constants.dart';
import 'package:dailygurus/constants/route_constants.dart';
import 'package:dailygurus/providers/auth_provider.dart';
import 'package:dailygurus/providers/orders_provider.dart';
import 'package:dailygurus/providers/products_provider.dart';
import 'package:dailygurus/providers/shopping_provider.dart';
import 'package:dailygurus/screens/add_address_screen.dart';
import 'package:dailygurus/screens/checkout_screen.dart';
import 'package:dailygurus/screens/landing_screen.dart';
import 'package:dailygurus/screens/login_screen.dart';
import 'package:dailygurus/screens/order_details_screen.dart';
import 'package:dailygurus/screens/orders_screen.dart';
import 'package:dailygurus/screens/otp_verification_screen.dart';
import 'package:dailygurus/screens/payment_screen.dart';
import 'package:dailygurus/screens/register_complex_screen.dart';
import 'package:dailygurus/screens/register_screen.dart';
import 'package:dailygurus/screens/shopping_screen.dart';
import 'package:dailygurus/screens/splash_screen.dart';
import 'package:dailygurus/screens/user_details_test.dart';
import 'package:dailygurus/screens/welcome_screen.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  //TODO: Replace GOOGLE-SERVICES.JSON with original

  //ONLY ENABLE IN DEV MODE
  //Crashlytics.instance.enableInDevMode = true;

  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>.value(
          value: AuthProvider(),
        ),
        ChangeNotifierProvider<ProductsProvider>.value(
          value: ProductsProvider(),
        ),
        ChangeNotifierProvider<ShoppingProvider>.value(
          value: ShoppingProvider(),
        ),
        ChangeNotifierProvider<OrdersProvider>.value(
          value: OrdersProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          accentColor: kColorGreen,
        ),
        initialRoute: SPLASH_ROUTE,
        routes: {
          SPLASH_ROUTE: (context) => SplashScreen(),
          LANDING_ROUTE: (context) => LandingScreen(),
          WELCOME_ROUTE: (context) => WelcomeScreen(),
          LOGIN_ROUTE: (context) => LoginScreen(),
          REGISTER_ROUTE: (context) => RegisterScreen(),
          REGISTER_COMPLEX_ROUTE: (context) => RegisterComplexScreen(),
          OTP_VERIFY_ROUTE: (context) => OTPVerificationScreen(),
          USER_DETAILS_TEST_ROUTE: (context) => UserDetailsTestScreen(),
          SHOPPING_ROUTE: (context) => ShoppingScreen(),
          CHECKOUT_ROUTE: (context) => CheckoutScreen(),
          PAYMENT_ROUTE: (context) => PaymentScreen(),
          ADD_ADDRESS_ROUTE: (context) => AddAddressScreen(),
          ORDERS_ROUTE: (context) => OrdersScreen(),
          ORDER_DETAILS_ROUTE: (context) => OrderDetailsScreen(),
        },
      ),
    );
  }
}
