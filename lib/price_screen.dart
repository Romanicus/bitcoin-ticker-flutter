import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedItem = 'USD';

  @override
  void initState() {
    super.initState();
    updateExchangeDataOnStart(selectedItem);
    print('initState finished');
  }

  void updateExchangeDataOnStart(String currency) async {
    await CoinData.updateExchangeData();
  }

  Future<void> updateExchangeRate(String currency) async {
    setState(() {
      selectedItem = currency;
    });
  }

  DropdownButton androidDropdown() {
    List<DropdownMenuItem<String>> dropDownItemsList = [];
    currenciesList.forEach(
      (element) => dropDownItemsList.add(DropdownMenuItem(child: Text(element), value: element)),
    );

    return DropdownButton(
      value: selectedItem,
      items: dropDownItemsList,
      onChanged: (value) {
        updateExchangeRate(value);
      },
    );
  }

  CupertinoPicker iOsPicker() {
    List<Widget> itemsList = [];
    currenciesList.forEach(
      (element) => itemsList.add(Text(element)),
    );

    return CupertinoPicker(
      itemExtent: 32,
      onSelectedItemChanged: (selectedIndex) {
        updateExchangeRate(currenciesList[selectedIndex]);
      },
      children: itemsList,
    );
  }

  Padding makeCard(String currency, Coins coins) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $currency = ${CoinData.getCoinExchangeRateFor(coins, selectedItem)?.toStringAsFixed(2)} $selectedItem',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              makeCard('BTC', Coins.BTC),
              makeCard('ETH', Coins.ETH),
              makeCard('LTC', Coins.LTC),
            ],
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOsPicker() : iOsPicker(),
          ),
        ],
      ),
    );
  }
}
