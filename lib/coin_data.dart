import 'package:http/http.dart' as http;
import 'dart:convert';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];
const String url = 'https://rest.coinapi.io/v1/exchangerate';
const String apiKey = '54D182FB-AC82-4350-A755-6741B3BD84FC';

class CoinData {
  Future<Map<String, double>> getCoinData(String selectedCurrency, List<String> cryptoList) async {
    Map<String, double> cryptoPrices = {};

    for (String crypto in cryptoList) {
      http.Response response = await http.get(Uri.parse('$url/$crypto/$selectedCurrency?apikey=$apiKey'));

      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
        var price = decodedData['rate'];
        cryptoPrices[crypto] = price.toDouble();
      } else {
        print('Problem with the get response for $crypto: ${response.statusCode}');
        throw 'Problem with the get response';
      }
    }

    return cryptoPrices;
  }
}