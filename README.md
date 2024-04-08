# 가상화폐 시세 확인 서비스
## 프로젝트 설명
업비트 API를 활용하여 비트코인, 이더리움 등의 가상화폐들의 마켓 데이터들을 실시간으로 확인하고 호가창, 차트데이터, 시세, 코인정보등을 확인할 수 있게 거래소 어플을 구현하였다. 추후 가상화폐 신규 정보, 사용자 자산확인 등의 서비스를 추가할 예정.


## 서비스 내용
- KRW 원화 시세 확인
- BTC 마켓 시세 확인
- USDT 마켓 시세 확인
- 모든 마켓 검색기능
- 화폐 실시간 호가 확인
- 화폐 실시간 차트 확인
- 화폐 실시간 시세 확인
- 코인 정보 확인

## 프로젝트 인원
- 개인 프로젝트

## 프로젝트 기간
2023.11 ~ 2024.1 - 2024.03 ~ 2024.04

## 개발 환경 및 언어
- Springboot
- Java
- Flutter
- Dart
- Upbit API
- MySQL
- AWS EC2(Rest Api)
- Visual Studio Code
- Intellij
- Docket

## 구현 영상(마켓)
[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/aw1K01BxLdc/0.jpg)](https://www.youtube.com/watch?v=aw1K01BxLdc)

## 구현 영상(트레이딩)
[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/J9DgC26hk6M/0.jpg)](https://www.youtube.com/watch?v=J9DgC26hk6M)

## 구현 영상(RestAPI 호출)
#### Springboot환경에서 RestAPI 서버를 구축하여 셀레니움을 통해 업비트 코인 정보를 크롤링하여 api를 호출받고 정보들을 json데이터로 반환해줌
#### API 구현 Github 링크 : https://github.com/jongwon-kr/coinProjectSpring
[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/pbG5uMikTBQ/0.jpg)](https://www.youtube.com/watch?v=pbG5uMikTBQ)

## 서비스 개발 요약 및 이미지
## Market
#### 주요 사용 기술
1) Getx : GetX/Obx상태 관리, GetBuilder반응 상태 관리, controller)
2) http : RestAPI 호출(코인 마켓의 코인 리스트 데이터 받아옴)
3) WebSocketChannel : 구독형 WebSockerAPI 호출(코인 마켓에 있는 데이터들을 채널을 통해 받아옴)
<img src="https://github.com/jongwon-kr/BitProject/assets/76871947/60593c97-c90d-43bf-991c-db1d3df43b6e" width="200" height="400">
<img src="https://github.com/jongwon-kr/BitProject/assets/76871947/fadf09b9-5849-4f3b-ae60-071416083045" width="200" height="400">
<img src="https://github.com/jongwon-kr/BitProject/assets/76871947/5348c453-295f-461b-a6e4-d4eb5b7e63a4" width="200" height="400">

## Trading
1) Getx : GetX/Obx상태 관리, controller)
2) http : RestAPI 호출(Springboot에서 구현한 코인 정보 API 서비스를 호출, 캔들 차트 API데이터를 호출)
3) WebSocketChannel : 구독형 WebSockerAPI 호출(호가창, 시세 데이터를 구독하여 받아옴)
4) SfCartesianChart : 캔들 차트를 구현하기 위해 사용함
<img src="https://github.com/jongwon-kr/BitProject/assets/76871947/bb403436-8742-4be8-8657-a034062859bb" width="200" height="400">
<img src="https://github.com/jongwon-kr/BitProject/assets/76871947/8a759b62-daee-4f75-8c8b-34da6c3d9394" width="200" height="400">
<img src="https://github.com/jongwon-kr/BitProject/assets/76871947/71ff33e0-0003-4e7c-8e9e-f95b2f07778e" width="200" height="400">
<img src="https://github.com/jongwon-kr/BitProject/assets/76871947/e659831b-e898-4e25-8e83-368e174a4758" width="200" height="400">

## END


