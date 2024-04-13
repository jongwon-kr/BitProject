import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:medicalapp/models/coin_candle_chart/day_candle.dart';
import 'package:medicalapp/models/coin_candle_chart/minute_candle.dart';
import 'package:medicalapp/models/coin_candle_chart/week_or_month_candle.dart';
import 'package:medicalapp/models/coin_info_model.dart';

class TradingController extends GetxController {
  late var minuteCandle = <MinuteCandle>[].obs; // 분봉
  late var dayCandle = <DayCandle>[].obs; // 일봉
  late var weekOrMonthCandle = <WeekOrMonthCandle>[].obs; // 주봉
  late var coinInfo;

  bool isOnTooltip = true;
  final ScrollController scrollController = ScrollController();
  final PageController pageController = PageController();
  late Timer _timer;
  late String selectcoin = "KRW-BTC";
  String selectMinute = "1분"; // 1,3,5,15,30,60,240
  var selectTime = "days";

  @override
  void onInit() {
    getCoinInfo(selectcoin);
    getCurrent200Candles();
    // 10초마다 데이터 업데이트
    _timer = Timer.periodic(const Duration(milliseconds: 200), (_) {
      getCurrentCandles(selectcoin);
    });
    super.onInit();
  }

  void hideTooltip() {
    isOnTooltip = false;
  }

  void resetChart() {
    minuteCandle.clear();
    dayCandle.clear();
    weekOrMonthCandle.clear();
  }

  void getCurrent200Candles() {
    if (selectTime.contains("minutes")) {
      getMinuteCandles(selectcoin);
    } else if (selectTime.contains("days")) {
      getDayCandles(selectcoin);
    } else {
      getWeekOrMonthCandles(selectcoin);
    }
    update();
  }

  void getCurrentCandles(String code) async {
    if (selectTime.contains("minutes")) {
      try {
        var response = await http.get(Uri.parse(
            "https://api.upbit.com/v1/candles/$selectTime/${selectMinute.substring(0, selectMinute.length - 1)}?market=$code&count=1"));
        if (response.statusCode == 200) {
          List<MinuteCandle> candles = minuteCandleFromJson(response.body);
          if (minuteCandle.first.candleDateTimeKst ==
              candles.first.candleDateTimeKst) {
            minuteCandle.first.openingPrice = candles.first.openingPrice;
            minuteCandle.first.tradePrice = candles.first.tradePrice;
            minuteCandle.first.highPrice = candles.first.highPrice;
            minuteCandle.first.lowPrice = candles.first.lowPrice;
          } else {
            minuteCandle.removeLast();
            minuteCandle.insert(0, candles.first);
          }
        }
      } catch (error) {}
      update();
    } else if (selectTime.contains("days")) {
      try {
        var response = await http.get(Uri.parse(
            "https://api.upbit.com/v1/candles/$selectTime?market=$code&count=1"));
        if (response.statusCode == 200) {
          List<DayCandle> candles = dayCandleFromJson(response.body);
          if (minuteCandle.first.candleDateTimeKst ==
              candles.first.candleDateTimeKst) {
            dayCandle.first.openingPrice = candles.first.openingPrice;
            dayCandle.first.tradePrice = candles.first.tradePrice;
            dayCandle.first.highPrice = candles.first.highPrice;
            dayCandle.first.lowPrice = candles.first.lowPrice;
          } else {
            dayCandle.removeLast();
            dayCandle.insert(0, candles.first);
          }
        }
      } catch (error) {}
    } else if (selectTime.contains("weeks") || selectTime.contains("months")) {
      try {
        var response = await http.get(Uri.parse(
            "https://api.upbit.com/v1/candles/$selectTime?market=$code&count=1"));
        if (response.statusCode == 200) {
          List<WeekOrMonthCandle> candles =
              weekOrMonthCandleFromJson(response.body);
          if (minuteCandle.first.candleDateTimeKst ==
              candles.first.candleDateTimeKst) {
            weekOrMonthCandle.first.openingPrice = candles.first.openingPrice;
            weekOrMonthCandle.first.tradePrice = candles.first.tradePrice;
            weekOrMonthCandle.first.highPrice = candles.first.highPrice;
            weekOrMonthCandle.first.lowPrice = candles.first.lowPrice;
          } else {
            weekOrMonthCandle.removeLast();
            weekOrMonthCandle.insert(0, candles.first);
          }
        }
      } catch (error) {}
    }
  }

  //'https://api.upbit.com/v1/candles/minutes/1?market=KRW-BTC&count=1' minuts/요청 분(1,3,5,15,10,30,60,240) market=코인코드, coont = candle개수
  void getMinuteCandles(String code) async {
    try {
      if (minuteCandle.isEmpty) {
        var response = await http.get(Uri.parse(
            "https://api.upbit.com/v1/candles/$selectTime/${selectMinute.substring(0, selectMinute.length - 1)}?market=$code&count=50"));
        if (response.statusCode == 200) {
          List<MinuteCandle> candles = minuteCandleFromJson(response.body);
          for (var candle in candles) {
            minuteCandle.add(candle);
          }
        }
      } else {
        var response = await http.get(Uri.parse(
            "https://api.upbit.com/v1/candles/$selectTime/${selectMinute.substring(0, selectMinute.length - 1)}?market=$code&to=${minuteCandle.last.candleDateTimeUtc}&count=50"));
        if (response.statusCode == 200) {
          List<MinuteCandle> candles = minuteCandleFromJson(response.body);
          for (var candle in candles) {
            minuteCandle.add(candle);
          }
        }
      }
    } catch (error) {}
    update();
  }

  //'https://api.upbit.com/v1/candles/days?market=%20KRW-BTC&count=1&convertingPriceUnit=KRW' market=코인코드, coont = candle개수, &convertingPriceUnit=KRW 생력가능 입력하면 원화 환산 가격 반환
  void getDayCandles(String code) async {
    try {
      if (dayCandle.isEmpty) {
        var response = await http.get(Uri.parse(
            "https://api.upbit.com/v1/candles/$selectTime?market=$code&count=50"));
        if (response.statusCode == 200) {
          List<DayCandle> candles = dayCandleFromJson(response.body);
          for (var candle in candles) {
            dayCandle.add(candle);
          }
        }
      } else {
        var response = await http.get(Uri.parse(
            "https://api.upbit.com/v1/candles/$selectTime?market=$code&to=${dayCandle.last.candleDateTimeUtc}&count=50"));
        if (response.statusCode == 200) {
          List<DayCandle> candles = dayCandleFromJson(response.body);
          for (var candle in candles) {
            dayCandle.add(candle);
          }
        }
      }
    } catch (error) {}
    for (var day in dayCandle) {
      print(day.tradePrice);
    }
    update();
    // get day candles
  }

  //'https://api.upbit.com/v1/candles/weeks?market=KRW-BTC&count=1' market=코인코드, coont = candle개수
  //'https://api.upbit.com/v1/candles/months?market=KRW-BTC&count=1' market=코인코드, coont = candle개수
  void getWeekOrMonthCandles(String code) async {
    try {
      if (weekOrMonthCandle.isEmpty) {
        var response = await http.get(Uri.parse(
            "https://api.upbit.com/v1/candles/$selectTime?market=$code&count=50"));
        if (response.statusCode == 200) {
          List<WeekOrMonthCandle> candles =
              weekOrMonthCandleFromJson(response.body);
          for (var candle in candles) {
            weekOrMonthCandle.add(candle);
            print(candle.highPrice);
          }
        }
      } else {
        var response = await http.get(Uri.parse(
            "https://api.upbit.com/v1/candles/$selectTime?market=$code&to=${weekOrMonthCandle.last.candleDateTimeUtc}&count=50"));
        if (response.statusCode == 200) {
          List<WeekOrMonthCandle> candles =
              weekOrMonthCandleFromJson(response.body);
          for (var candle in candles) {
            weekOrMonthCandle.add(candle);
          }
        }
      }
    } catch (error) {}
    update();
    // get week or Month candles
  }

  void getCoinInfo(String code) async {
    coinInfo = null;
    var response = await http
        .get(Uri.parse("http://222.119.233.177:5000/coin-info/$code"));
    if (response.statusCode == 200) {
      Future.delayed(const Duration(seconds: 2));
      CoinInfo coinInfo = coinInfoFromJson(utf8.decode(response.bodyBytes));
      this.coinInfo = coinInfo;
    } else {
      print("실패");
    }
  }
}
