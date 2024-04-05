import 'package:flutter/material.dart';

Drawer setOrderBookDrawer(
    double width,
    double height,
    var market,
    var coinPriceChannel,
    var OrderBookChannel,
    Function setCoin,
    var getPricese,
    var getOrderBook) {
  return Drawer(
    width: width * 0.6,
    child: ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: market.length,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Column(
            children: [
              Container(
                height: height * 0.13,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.orange.withOpacity(0.8),
                        Theme.of(context).primaryColor.withOpacity(0.6)
                      ],
                    ),
                    borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(30))),
                child: Center(
                  child: Text(
                    '${market[index].code.split("-")[0]} Market',
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Container(
                height: height * 0.06,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 1,
                      color: Theme.of(context).disabledColor,
                    ),
                  ),
                ),
                child: ListTile(
                  onTap: () {
                    coinPriceChannel.sink.close();
                    OrderBookChannel.sink.close();
                    setCoin(market[index]);
                    getPricese();
                    getOrderBook(); // 변경: 새로운 코인으로 업데이트
                    Navigator.pop(context); // 변경: Drawer 닫기
                  },
                  titleTextStyle:
                      const TextStyle(fontSize: 15, color: Colors.black),
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          "${market[index].koreanName}(${market[index].code.split("-")[1]}/${market[index].code.split("-")[0]})",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }
        return Container(
          height: height * 0.06,
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      width: 1, color: Theme.of(context).disabledColor))),
          child: ListTile(
              onTap: () {
                coinPriceChannel.sink.close();
                OrderBookChannel.sink.close();
                setCoin(market[index]); // 변경: 새로운 코인으로 업데이트
                getPricese();
                getOrderBook();
                Navigator.pop(context); // 변경: Drawer 닫기
              },
              titleTextStyle:
                  const TextStyle(fontSize: 15, color: Colors.black),
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                      child: Text(
                          "${market[index].koreanName}(${market[index].code.split("-")[1]}/${market[index].code.split("-")[0]})")),
                ],
              )),
        );
      },
    ),
  );
}
