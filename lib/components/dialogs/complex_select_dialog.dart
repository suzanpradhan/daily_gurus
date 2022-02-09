import 'package:dailygurus/constants.dart';
import 'package:dailygurus/models/complex.dart';
import 'package:dailygurus/providers/auth_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void showComplexSelectDialog(
    BuildContext context, Function setSelectedComplex) {
  showDialog(
    context: context,
    builder: (BuildContext context) => ComplexSelectDialog(
      setSelectedComplex: setSelectedComplex,
    ),
  );
}

class ComplexSelectDialog extends StatelessWidget {
  final Function setSelectedComplex;
  ComplexSelectDialog({@required this.setSelectedComplex});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 16.0,
              ),
              child: Text(
                'Select Apartment',
                style: kProximaStyle.copyWith(
                  color: kColorBlack,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              height: 500.0,
              child: FutureBuilder(
                future: Provider.of<AuthProvider>(context).fetchComplexes(),
                builder: (context, snap) {
                  if (!snap.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  // TODO: List Renderflex overflow.
                  return ListView.builder(
                    itemCount: snap.data.length,
                    itemBuilder: (context, index) {
                      Complex complex = snap.data[index];
                      return ListTile(
                        title: Text(
                          complex.name ?? 'null',
                        ),
                        onTap: () {
                          setSelectedComplex(snap.data[index]);
                          Navigator.pop(context);
                        },
                      );
                    },
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FlatButton.icon(
                  onPressed: () {
                    Navigator.popAndPushNamed(context, '/register-complex');
                  },
                  icon: Icon(
                    Icons.add,
                    color: kColorBlack,
                  ),
                  label: Text(
                    'Add New Apartment',
                    style: kProximaStyle.copyWith(
                      color: kColorBlack,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
