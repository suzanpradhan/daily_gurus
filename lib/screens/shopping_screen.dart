import 'package:badges/badges.dart';
import 'package:dailygurus/components/fonts/custom_icons_icons.dart';
import 'package:dailygurus/components/tabs/my_cart_tab.dart';
import 'package:dailygurus/components/tabs/notifications_tab.dart';
import 'package:dailygurus/components/tabs/offers_tab.dart';
import 'package:dailygurus/components/tabs/products_list_tab.dart';
import 'package:dailygurus/constants.dart';
import 'package:dailygurus/constants/route_constants.dart';
import 'package:dailygurus/models/auth.dart';
import 'package:dailygurus/providers/shopping_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShoppingScreen extends StatefulWidget {
  @override
  _ShoppingScreenState createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen> {
  String _name, _email;
  bool _loginStatus;
  int _currentIndex = 0;
  final List<Widget> _children = [
    ProductsListTab(),
    OffersTab(),
    NotificationsTab(),
    MyCartTab(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void getCartInfo() async {
    bool result = await Provider.of<ShoppingProvider>(context, listen: false)
        .fetchCartInfo();
    setState(() {});
  }

  void getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final loginStatus = prefs.getBool('login_status') ?? false;
    final id = prefs.getInt('id').toString();
    final name = prefs.getString('name') ?? "";
    final email = prefs.getString('email') ?? "Not Signed In";
    final phone = prefs.getString('phone');
    setState(() {
      _loginStatus = loginStatus;
      _name = name;
      _email = email;
    });
  }

  void logout() async {
    print("Logout");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('login_status');
    prefs.remove('id');
    prefs.remove('name');
    prefs.remove('email');
    prefs.remove('phone');
    setState(() {
      this._loginStatus = false;
      this._name = "";
      this._email = "Not Signed In";
    });
  }

  @override
  void initState() {
    super.initState();
    getUserData();
    getCartInfo();
  }

  @override
  Widget build(BuildContext context) {
    final ShoppingProvider shoppingProvider =
        Provider.of<ShoppingProvider>(context);
    return Scaffold(
      backgroundColor: kColorWhite,
      appBar: AppBar(
        backgroundColor: kColorLightGreen,
        title: Container(
          decoration: BoxDecoration(
            color: kColorGreen,
            borderRadius: BorderRadius.circular(
              50.0,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search',
                      border: InputBorder.none,
                      hintStyle: kProximaStyle.copyWith(
                        color: kColorWhite,
                        fontSize: 16.0,
                      ),
                      isDense: true,
                    ),
                    style: kProximaStyle.copyWith(
                      color: kColorWhite,
                    ),
                    cursorColor: kColorWhite,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: this._loginStatus == true
              ? <Widget>[
                  DrawerHeader(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            '$_name',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          '$_email',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                    ),
                  ),
                  ListTile(
                    title: Text('Home'),
                    leading: Icon(CustomIcons.home),
                    onTap: () {
                      setState(() {
                        _currentIndex = 0;
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text('My Orders'),
                    leading: Icon(CustomIcons.shopping_cart),
                    onTap: () {
                      Navigator.pushNamed(context, ORDERS_ROUTE);
                    },
                  ),
                  ListTile(
                    title: Text('My Wallet'),
                    leading: Icon(CustomIcons.wallet),
                    onTap: () {
                      //Navigator.pushNamed(context, ORDERS_ROUTE);
                    },
                  ),
                  ListTile(
                    title: Text('Offers'),
                    leading: Icon(CustomIcons.sale),
                    onTap: () {
                      setState(() {
                        _currentIndex = 1;
                      });
                      Navigator.pop(context);
                      //Navigator.pushNamed(context, ORDERS_ROUTE);
                    },
                  ),
                  ListTile(
                    title: Text('Notifications'),
                    leading: Icon(CustomIcons.alarm),
                    onTap: () {
                      setState(() {
                        _currentIndex = 2;
                      });
                      Navigator.pop(context);
                      //Navigator.pushNamed(context, ORDERS_ROUTE);
                    },
                  ),
                  ListTile(
                    title: Text('Contact Us'),
                    leading: Icon(Icons.contacts),
                    onTap: () {
                      //Navigator.pushNamed(context, ORDERS_ROUTE);
                    },
                  ),
                  ListTile(
                    title: Text('Logout'),
                    leading: Icon(CustomIcons.logout),
                    onTap: () {
                      Navigator.pop(context);
                      logout();
                    },
                  ),
                ]
              : <Widget>[
                  ListTile(
                    title: Text('Sign In'),
                    leading: Icon(Icons.person),
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        LOGIN_ROUTE,
                        arguments: AuthArguments(
                          rootRoute: SHOPPING_ROUTE,
                        ),
                      );
                    },
                  ),
                  ListTile(
                    title: Text('Register'),
                    leading: Icon(Icons.person_add),
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        REGISTER_ROUTE,
                        arguments: AuthArguments(
                          rootRoute: SHOPPING_ROUTE,
                        ),
                      );
                    },
                  ),
                ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(CustomIcons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(CustomIcons.sale),
            title: Text('My Offers'),
          ),
          BottomNavigationBarItem(
            icon: Icon(CustomIcons.alarm),
            title: Text('Notifications'),
          ),
          BottomNavigationBarItem(
            icon: Badge(
              badgeContent: Text(
                '${shoppingProvider.productsInCart.length}',
                style: TextStyle(
                  color: kColorWhite,
                ),
              ),
              child: Icon(
                Icons.shopping_cart,
              ),
              badgeColor: kColorGreen,
              showBadge:
                  shoppingProvider.productsInCart.length == 0 ? false : true,
              animationType: BadgeAnimationType.fade,
              animationDuration: const Duration(milliseconds: 300),
            ),
            title: Text('My Cart'),
          ),
        ],
      ),
      body: _children[_currentIndex],
    );
  }
}
