import 'dart:convert';
import 'package:http/http.dart' as http;

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

//Two api secrets in case of the 100 request limit is reached out.
const String _apiSecret = 'apiKey1';
const String _apiSecret2 = 'apiKey2';
const String _url = 'https://rest.coinapi.io/v1/exchangerate';
const String _getAllDataFor = 'https://rest.coinapi.io/v1/exchangerate';

class CoinData {
  static dynamic _BTCData = [];
  static dynamic _ETHData = [];
  static dynamic _LTCData = [];

  static Future<double> getCoinData(String currency) async {
    http.Response response = await http.get('$_url/BTC/$currency?apikey=$_apiSecret');

    if (response.statusCode == 401 || response.statusCode == 429) {
      http.Response response2 = await http.get('$_url/BTC/$currency?apikey=$_apiSecret2');
      return jsonDecode(response2.body)['rate'];
    }

    print('Response statuscode: ${response.statusCode}');
    return jsonDecode(response.body)['rate'];
  }

  static Future<void> updateExchangeData() async {
    cryptoList.forEach((element) async {
      Coins coins = Coins.BTC;

      if (element == 'ETH')
        coins = Coins.ETH;
      else if (element == 'LTC') coins = Coins.LTC;

      http.Response response = await http.get('$_getAllDataFor/$element?apikey=$_apiSecret');
      print('Response code is: ${response.statusCode}');
      if (response.statusCode == 401 || response.statusCode == 429) {
        http.Response response2 = await http.get('$_getAllDataFor/$element?apikey=$_apiSecret2');
        print('Response2 code is: ${response2.statusCode}');

        _mapValueToList(jsonDecode(response2.body), coins);
        return;
      }
      _mapValueToList(jsonDecode(response.body), coins);
    });
  }

  static void _mapValueToList(dynamic list, Coins coin) {
    switch (coin) {
      case Coins.BTC:
        _BTCData = list;
        break;
      case Coins.ETH:
        _ETHData = list;
        break;
      case Coins.LTC:
        _LTCData = list;
        break;
    }
  }

  static double getCoinExchangeRateFor(Coins coins, String currency) {
    dynamic listToHandle;
    double value;

    if (coins == Coins.ETH)
      listToHandle = _ETHData;
    else if (coins == Coins.BTC)
      listToHandle = _BTCData;
    else if (coins == Coins.LTC) listToHandle = _LTCData;
    listToHandle['rates'].forEach((element) {
      String currencyQuote = element['asset_id_quote'];
      if (currencyQuote == currency) {
        value = double.tryParse(element['rate'].toString());
        return;
      }
    });

    return value;
  }
}

enum Coins { BTC, ETH, LTC }
