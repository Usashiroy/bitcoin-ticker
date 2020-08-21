import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'cryptocard.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency='USD';


  DropdownButton<String> androidDropdown(){
    List<DropdownMenuItem<String>> dropdownItem=[];
    for(String currency in currenciesList){
      var newItem=DropdownMenuItem(
        child:Text(currency,),
        value:currency,
      );
      dropdownItem.add(newItem);
    }
    return DropdownButton(
      value: selectedCurrency,
      items: dropdownItem,
      onChanged: (value){
        setState(() {
          selectedCurrency=value;
          getData();
        },);
     },
    );
  }


  CupertinoPicker iOSPicker(){
    List<Text> picker=[];
    for(String currency in currenciesList){
     picker.add(Text(currency));
    }
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue ,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex){
        print(selectedIndex+1);
        setState(() {
          selectedCurrency=currenciesList[selectedIndex];
          getData();
        });
      },
      children: picker,
    );
  }


  Map<String,String> coinValue={};
  bool isWaiting = false;
  void getData()async{
    isWaiting=true;
    try{
      var data= await CoinData().getCoinData(selectedCurrency);
      isWaiting=false;
      setState(() {
        coinValue=data;
      });
    }catch(e){
      print(e);
    }
  }


  Column makeCard(){
    List<CryptoCard> cryptoCard=[];
    for(String crypto in cryptoList){
      cryptoCard.add(
        CryptoCard(
          value: isWaiting? '?' : coinValue[crypto],
          selectedCurrency: selectedCurrency,
          cryptoCurrency: crypto,
        ),
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: cryptoCard,
    );
  }


  @override
  void initState() {
    super.initState();
    getData();
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
          makeCard(),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS? iOSPicker():androidDropdown(),
          ),
        ],
      ),
    );
  }
}
