# BerryQuest: 나무 열매 원정대

- 포켓몬 친구들을 치료하기 위해 현재 나의 위치에서 최단 거리를 탐색해서 나무 열매를 전달하자!

## 개발 환경

- 개발 언어: Swift
- 개발 환경: SwiftUI, Combine, MVVM
    - 최소: 16.6
    - 기종 호환
- 라이브러리: KakaoMapSDK ios_v2

## 주요 기능

- `메인 화면`
    - 사용자의 현재 위치와 포켓몬들의 위치를 한 눈에 파악할 수 있다.
    - 다친 포켓몬 친구들 모두에게 가기 위한 최단 경로를 확인할 수 있다.
    - 사용자의 현재 위치는 실시간 업데이트되어서 지도에 반영된다.
- `치료할 포켓몬 화면`
    - 바텀 시트에서 list목록으로 확인할 수 있다.
    - 메인 화면에서 경로 탐색을 하면 가장 방문할 순서대로 포켓몬들이 정렬된다.
    - 포켓몬을 선택하면 상세 정보를 확인할 수 있다.
- `상세 정보`
    - 포켓몬들의 이미지, 이름, 위치, 병명, 열매 정보를 확인할 수 있다.

### 화면
|내 위치와 포켓몬 위치 마커|줌 확대시 포케몬 마커|최단 경로 탐색 폴리라인|
|------|---|---|
|![image](https://github.com/user-attachments/assets/0031c57a-deda-43b1-9016-edfefebf050b)|![image](https://github.com/user-attachments/assets/1a790bb8-46dd-471f-990b-feb748c98519)|![image](https://github.com/user-attachments/assets/e83c57ed-2d44-48ff-8053-7628395adf10)|

|바텀 시트|상세 화면|위치 변경시|
|------|---|---|
|![image](https://github.com/user-attachments/assets/c67644be-68e8-4776-9cb0-e86595df27f5)|![image](https://github.com/user-attachments/assets/cf49c9ef-f2f8-4005-80d5-b49485842202)|![image](https://github.com/user-attachments/assets/cde79be4-f522-426b-a324-63fc49e3c985)


<br/>

## 주요 기술 스택
- **네트워크 통신 모델의 추상화 및 SOLID 원칙 준수**
    - RawDataFetchable는 Data 타입을, DecodableDataFetchable는 디코딩된 데이터를 가져오는 역할을 수행하고, PokemonNetworkManager는 두 네트워크 서비스를 관리하여 데이터를 가져오는 기능을 제공합니다. `각 클래스가 하나의 책임만을 갖고있도록 역할을 분리하였고, 각 클래스가 필요한 메서드만 구현`하기 때문에 SRP와 ISP를 준수하고 있습니다.
    - 새로운 데이터를 가져오는 방식이 필요한 경우 프로토콜을 채택한 새로운 서비스를 구현해서 사용할 수 있기 때문에 PokemonNetworkManager에서 `기존 코드의 수정 없이 새로운 서비스를 확장할 수 있어서 확장에는 열려있고, 수정에는 닫혀있는 구조`로 OCP를 준수하고 있습니다.
    - 프로토콜을 기반으로 의존성 주입을 하고 있기 때문에 RawDataFetchable또는 DecodableDataFetchable을 채택한 클래스는 어떤 것이든 PokemonNetworkManager에서 사용할 수 있기 때문에 `기존의 기능이 깨지지 않고, 하위 타입으로 대체할 수 있는 구조`를 설계하여 LSP를 준수하고 있습니다.
    - PokemonNetworkManager는 구현체인 DataNetworkService와 DecodableNetworkService가 아닌 추상화된 인터페이스 RawDataFetchable, DecodableDataFetchable에 의존하고 있기 때문에 `높은 수준의 모듈이 낮은 수준의 모듈에 의존하지 않도록` 설계해서 DIP 를 준수하고 있습니다.
- **Router Pattern과 Custom HTTPRequestable 프로토콜 활용**
    - 네트워크 설계시에 Router Pattern을 사용한 이유로는
        - API 엔드포인트를 Router로 관리하여, 여러 개의 API 주소를 하나의 구조체에서 효율적으로 관리할 수 있습니다.
    - Custom HTTPRequestable 프로토콜을 사용한 이유로는
        - `동적인 경로`, `버전`, `쿼리 파라미터`, `포트 번호` 등을 제어할 수 있어 복잡한 서버 환경에서도 유연하게 대응하기 위해서 Custom HTTPRequestable을 직접 구현하여서 사용하였습니다.
- **SwiftUI + Combine + MVVM 아키텍처**
    - SwiftUI와 Combine을 함께 사용하면 선언적 UI와 반응형 프로그래밍의 장점을 결합하여 효율적인 데이터 처리와 동기화된 UI 업데이트가 가능해져서 코드의 간결성, 성능 최적화, 유지보수성을 높일 수 있습니다.
    - MVVM에서 데이터의 바인딩
        - View가 ViewModel의 데이터를 구독하고, ViewModel의 데이터가 변경되면 자동으로 View가 업데이트 되는 MVVM의 구조는 SwiftUI에서의 `@ObservedObject`, `@StateObject` 및 Combine의 `@Published` 프로퍼티와 잘 결합되기 때문에 MVVM의 구조를 사용하였습니다.
- **서버의 통신 모델(DTO)과 앱 내 데이터 모델(Model) 분리**
    - 서버의 DTO와 앱 내에서 사용하는 Model을 분리함으로써, 서버의 데이터 구조가 변경되더라도 앱 내 Model은 그대로 유지할 수 있고, 앱 내부의 비즈니스 로직이나 UI 로직이 불필요하게 변경되는 것을 방지할 수 있습니다.
- **NavigationLazyView를 사용하여 초기 뷰 로드 최적화**
    - NavigationLazyView를 사용해서 init 시점에 불필요한 메모리 소비를 줄이고 뷰를 사용하는 시점에 rendering을 해서 앱의 성능을 향상시킬 수 있습니다.

## 트러블 슈팅
![image](https://github.com/user-attachments/assets/155380b3-f7b2-4ce4-89ed-540d07b2e0c0)

- 내장 sheet의 .presentationDetents를 사용해서 바텀시트를 구현하였으나, 정작 뒷 화면의 MapView에서 버벅임 현상이 발견됨.
    - View 계층을 보았을 때 dimming view가 뒤의 MapView와의 상호작용을 방해하고 있음을 확인함.
        - `dimming view`: sheet나 다른 모달 방식으로 화면에 표시될 때, 배경에 나타나는 반투명한 뷰, 기본적으로 상호작용을 차단하는 역할을 하며, 뒤에 있는 다른 UI 요소와의 상호작용을 방해할 수 있음
        - `interactiveDismissDisabled()` 메스드를 사용해서 뒤의 MapView와 상호작용을 허용하더라도, 터치와 제스처 인식이 `dimming` 뷰에 우선적으로 처리되기 때문에 `MapView`나 다른 UI 요소의 제스처 인식기가 작동하지 않을 수 있다.
    
    → **`GeometryReader`**와 **`DragGesture`**를 이용하여 Custom Bottom Sheet를 구현하여, View의 `ZStack`에 MapView와 BottomSheetView를 배치하는 것으로 문제를 해결하였다.
    
