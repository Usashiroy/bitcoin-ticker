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

const apiKey = '62BAAFEE-7BCE-4993-BD1C-38AB20441EDA';
const coinApiUrl = 'https://rest.coinapi.io/v1/exchangerate';

class CoinData {
   Future<Map> getCoinData(String selectedCurrency)async{
     Map<String,String> cryptoPrice = {};
     for(String crypto in cryptoList){
       String url='$coinApiUrl/$crypto/$selectedCurrency?apikey=$apiKey';

       http.Response response= await http.get(url);

       if(response.statusCode==200){
         var decodedData = jsonDecode(response.body);
         double lastData = decodedData['rate'];
         cryptoPrice[crypto] = lastData.toStringAsFixed(0);
       }else{
         print(response.statusCode);
       }
     }
     return cryptoPrice;
   }
}
