import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'AUD';

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value ?? '';
          getData();
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }

    return CupertinoPicker(
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        print(selectedIndex);
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
          getData();
        });
      },
      children: pickerItems,
    );
  }

  Widget getPicker() {
    if (Platform.isIOS) {
      return iOSPicker();
    } else if (Platform.isAndroid) {
      return androidDropdown();
    } else {
      return Text('No se puede seleccionar la moneda');
    }
  }

  String bitcoinValue = '?';
  String ethereumValue = '?';
  String litecoinValue = '?';

  void getData() async {
    try {
      CoinData coinData = CoinData();
      Map<String, double> cryptoPrices =
      await coinData.getCoinData(selectedCurrency, ['BTC', 'ETH', 'LTC']);

      setState(() {
        bitcoinValue = cryptoPrices['BTC']?.toStringAsFixed(0) ?? '?';
        ethereumValue = cryptoPrices['ETH']?.toStringAsFixed(0) ?? '?';
        litecoinValue = cryptoPrices['LTC']?.toStringAsFixed(0) ?? '?';
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      getData();
    });
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
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CryptoCard(
                  cryptoName: 'BTC',
                  cryptoValue: bitcoinValue,
                  selectedCurrency: selectedCurrency,
                ),
                SizedBox(height: 16.0),
                CryptoCard(
                  cryptoName: 'ETH',
                  cryptoValue: ethereumValue,
                  selectedCurrency: selectedCurrency,
                ),
                SizedBox(height: 16.0),
                CryptoCard(
                  cryptoName: 'LTC',
                  cryptoValue: litecoinValue,
                  selectedCurrency: selectedCurrency,
                ),
              ],
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: getPicker(),
          ),
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  final String cryptoName;
  final String cryptoValue;
  final String selectedCurrency;

  CryptoCard({required this.cryptoName, required this.cryptoValue, required this.selectedCurrency});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.lightBlueAccent,
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 80.0),
        child: Text(
          '1 $cryptoName = $cryptoValue $selectedCurrency ',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
