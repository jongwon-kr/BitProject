# 가상화폐 시세 확인 및 트레이딩 정보 확인 서비스

### 프로젝트 기간
2023.11 ~ 2024.1 - 2024.03 ~ 2024.04

### 개발 인원
개인프로젝트

### 사용언어 및 개발환경
Java, Dart, Springboot, Flutter, VsCode, intellij, Github

### 프로젝트 목적
거래소의 Api 및 각종 정보들을 바탕으로 거래소의 기능들을 구현하며 Springboot API서버 구현 및 사용 경험과 Flutter의 다양한 상태관리 라이브러리를 이용하여 실시간 데이터를 처리하고 가공해서 사용자에게 보여주는 경험을 통해 데이터 사용의 실력 향상

### 주요 구현 내용
- 거래소 API를 이용해 마켓별 코인 리스트를 불러와 모델에 저장하고 각 코인의 시세, 차트, 호가등의 데이터를 WebSocket으로 연결하여 실시간 데이터 스트림 구축
- 거래소에서 제공하지 않는 코인 정보를 Springboot 환경에서 RestAPI를 구현하고 Flutter와 연동
- 실시간 데이터들을 Flutter의 Getx라이브러리를 통해 상태관리를 하며 KRW, BTC, USDT 마켓 구현과 각 코인별 호가창, 차트, 시세, 코인정보 구현

### 느낀점 및 문제 해결
- 거래소의 API를 이용하며 데이터에 대해 밀리초단위로 업데이트가 필요할 경우 Websocket으로 채널을 생성하여 구현하거나 마켓 코인 리스트 정보처럼 지속적인 데이터의 변화가 필요없을 경우 RestAPI를 통해 호출하며 각 데이터마다 사용해야하는 기술들을 배움.
- Springboot를 통해 제공되지 않은 데이터를 직접 API로 구현을 해보며 API의 형태, 통신이 되는 원리와 같은 지식을 얻었다.
- 코인 정보에 대한 API는 제공되지 않았었고 Spring서버로 코인정보 API를 호출하면 Java로 셀레니움을 활용해 동적웹크롤링을 하여 Json형태로 코인정보 데이터를 전송해주는 API를 개발하였다.
- 초기 상태관리를 setState로만 진행하다가 관리를 하고 있는 데이터가 너무 많아져서 Getx 라이브러리로 상태관리를 하도록 리팩토링 하였다. 컨트롤러를 통해 Rx데이터를 관리하고 값이 변하는 메소드가 발생하면 update를 통해 컨트롤러를 사용중인 클래스에 전달하게 구현하였다.
- 마켓에 있는 코인리스트가 대략 400개 정도 되었는데 400개 정도의 코인에 데이터를 실시간으로 반영하려다보니 성능이 안좋아지고 앱에 버벅임이 발생했다. 이때 사용자의 입장에서 굉장히 불편했기 때문에 사용자의 돋작이 있을경우 WebSocket 채널을 잠시 닫아서 사용환경에 최적화를 시켰다.

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
#### 주요 사용 기술
1) Getx : GetX/Obx상태 관리, controller)
2) http : RestAPI 호출(Springboot에서 구현한 코인 정보 API 서비스를 호출, 캔들 차트 API데이터를 호출)
3) WebSocketChannel : 구독형 WebSockerAPI 호출(호가창, 시세 데이터를 구독하여 받아옴)
4) SfCartesianChart : 캔들 차트를 구현하기 위해 사용함
<img src="https://github.com/jongwon-kr/BitProject/assets/76871947/bb403436-8742-4be8-8657-a034062859bb" width="200" height="400">
<img src="https://github.com/jongwon-kr/BitProject/assets/76871947/8a759b62-daee-4f75-8c8b-34da6c3d9394" width="200" height="400">
<img src="https://github.com/jongwon-kr/BitProject/assets/76871947/71ff33e0-0003-4e7c-8e9e-f95b2f07778e" width="200" height="400">
<img src="https://github.com/jongwon-kr/BitProject/assets/76871947/e659831b-e898-4e25-8e83-368e174a4758" width="200" height="400">

## END


