# CurrencyConverter

환율 정보를 조회하고 계산할 수 있는 iOS 앱

## 주요 기능

- 실시간 환율 정보 조회
- 환율 계산기
- 즐겨찾기 기능 (Core Data 저장)
- 환율 변동 추이 표시 (0.01 이상 변동시)
- 앱 상태 복원 (마지막 화면 기억)
- 검색 기능

## 기술 스택

- UIKit (Programmatic UI)
- Core Data
- Observation Framework
- Async/Await
- SnapKit

## 아키텍처

MVVM + Coordinator 패턴으로 구성

```
CurrencyConverter/
├── App/
│   ├── Coordinator/           # 화면 전환 로직
│   │   ├── Coordinator.swift
│   │   ├── AppCoordinator.swift
│   │   └── ExchangeRateCoordinator.swift
│   ├── Sources/
│   │   ├── AppDelegate.swift
│   │   └── SceneDelegate.swift
│   └── Resources/
│
├── Features/                  # UI Layer
│   ├── ExchangeRate/
│   │   ├── ExchangeRateViewController.swift
│   │   ├── ExchangeRateViewModel.swift
│   │   ├── Models/
│   │   │   └── ExchangeRateCellModel.swift
│   │   └── Components/
│   │       └── ExchangeRateCell.swift
│   └── Calculator/
│       ├── CalculatorViewController.swift
│       └── CalculatorViewModel.swift
│
├── Domain/                    # Business Logic
│   ├── Entities/
│   │   ├── ExchangeRate.swift
│   │   └── ExchangeRateList.swift
│   ├── ExchangeRate/
│   │   ├── FetchExchangeRateUseCase.swift
│   │   └── UpdateFavoriteUseCase.swift
│   ├── RepositoryProtocol/
│   │   └── ExchangeRateRepository.swift
│   └── Error/
│       └── FetchExchangeRateError.swift
│
├── Data/                      # Data Layer
│   ├── Repository/
│   │   └── DefaultExchangeRateRepository.swift
│   ├── DataSources/
│   │   ├── RemoteExchangeRateDataSource.swift
│   │   ├── LocalExchangeRateDataSource.swift
│   │   ├── AppStateDataSource.swift
│   │   └── CoreData/
│   │       ├── ExchangeRateEntity+CoreData...
│   │       ├── FavoriteEntity+CoreData...
│   │       └── AppStateEntity+CoreData...
│   └── DTO/
│       └── ExchangeRateResponseDTO.swift
│
├── NetworkService/
│   └── API.swift
│
└── Common/
    ├── Extensions/
    └── ViewModelProtocol/
```

## 동작 방식

### 환율 데이터 흐름

1. Remote API에서 환율 데이터 fetch
2. Core Data에 저장 (upsert 방식)
3. 이전 환율과 비교해서 변동 추이 계산
4. ViewModel이 UI용 모델로 변환
5. 즐겨찾기 항목은 상단 정렬

### 즐겨찾기

- FavoriteEntity에 별도 저장
- 토글시 즉시 Core Data 업데이트
- 애니메이션과 함께 정렬 (crossDissolve)

### 앱 상태 복원

- 백그라운드 진입시 현재 화면 저장
- 앱 재시작시 마지막 화면으로 복원
- 계산기 화면이었으면 해당 통화 화면으로 이동

### Coordinator 패턴

- SceneDelegate는 AppCoordinator만 생성
- 화면 전환, DI는 Coordinator가 담당
- Repository를 Coordinator에서 생성하고 ViewModel과 공유
- 데이터 없으면 자동으로 뒤로가기

## 트러블슈팅

### 1. Core Data 유니크 제약 충돌

**문제**: 즐겨찾기 버튼 클릭시 `NSCocoaErrorDomain Code=133021` 에러 발생
```
ExchangeRateEntity에 code 속성이 unique 제약이 걸려있는데
saveRates()에서 기존 데이터 확인 없이 새 엔티티 생성
```

**해결**: Upsert 패턴 적용
```swift
let fetchRequest: NSFetchRequest<ExchangeRateEntity> = ExchangeRateEntity.fetchRequest()
fetchRequest.predicate = NSPredicate(format: "code == %@", rate.code)

let existingEntity = try? self.context.fetch(fetchRequest).first
let entity = existingEntity ?? ExchangeRateEntity(context: self.context)
```

### 2. 즐겨찾기 UI 업데이트 안되는 문제

**문제**: 즐겨찾기 버튼 눌러도 하트 아이콘이 변경되지 않음

**원인**:
- `isFavorite` 값이 Core Data에 저장은 되지만 불러올 때 반영 안됨
- `loadRates()`에서 `ExchangeRateEntity`만 조회하고 `FavoriteEntity` 무시

**해결**: 데이터 로드시 즐겨찾기 정보 병합
```swift
let favorites = try await getFavorites()
let result = entities.map { entity in
    let exchangeRate = entity.toDomain()
    exchangeRate.isFavorite = favorites.contains(entity.code ?? "")
    return exchangeRate
}
```

### 3. 모든 셀이 동시에 업데이트되는 성능 이슈

**문제**: 즐겨찾기 버튼 한 번 누르면 수백개 셀이 전부 업데이트됨
```
로그: Cell updated: USD
      Cell updated: JPY
      Cell updated: EUR
      ... (수백줄)
```

**원인**: Cell에서 `withObservationTracking`으로 model 관찰했는데, model이 ViewModel에서 새로 생성되면서 모든 셀이 반응

**해결**: Cell 레벨 observation 제거, ViewController에서 `reloadData()`로 직접 업데이트

### 4. 애니메이션 버그

**문제**: 즐겨찾기시 정렬 순서가 이상하고 애니메이션이 깨짐

**시도1**: `moveRow(at:to:)` 사용
```swift
tableView.moveRow(at: oldIndexPath, to: newIndexPath)
```
→ 순서가 뒤죽박죽됨

**해결**: `UIView.transition` + `reloadData()` 사용
```swift
UIView.transition(with: tableView, duration: 0.3, options: .transitionCrossDissolve) {
    self.tableView.reloadData()
}
```

### 5. 환율 변동 표시 정렬 깨짐

**문제**: 변동 아이콘(🔼🔽) 있을 때와 없을 때 셀 정렬이 어긋남

**해결**: 고정 너비 적용
```swift
trendIndicatorLabel.snp.makeConstraints { make in
    make.width.equalTo(20) // 이모지 너비 고정
}
```

### 6. SceneDelegate 복잡도 증가

**문제**: 앱 상태 복원 로직이 SceneDelegate에 집중되면서 책임 과다
```swift
// SceneDelegate에서 직접 처리
let viewModel = ExchangeRateViewModel(...)
let viewController = ExchangeRateViewController(viewModel: viewModel)
if appState.lastScreen == .calculator {
    await viewModel.send(.pushToCalculator(...))
}
```

**시도1**: ViewModel에 네비게이션 state 추가
```swift
var shouldNavigateToCalculator: (currency: String, ...)?
```
→ ViewModel이 너무 많은 역할 담당

**해결**: Coordinator 패턴 도입
- `AppCoordinator`: 앱 전체 흐름 관리
- `ExchangeRateCoordinator`: 환율 리스트 ↔ 계산기 전환
- SceneDelegate는 Coordinator만 생성
- 네비게이션 로직은 Coordinator가 담당

### 7. ViewController에서 데이터 직접 접근

**문제**: Coordinator가 ViewController의 내부 구조에 의존
```swift
// Coordinator에서
guard let model = viewController.viewModel.state.allItems.first(...) else { ... }
```

**해결**: Coordinator가 Repository를 직접 가지고 데이터 조회
```swift
private let repository: ExchangeRateRepository

func pushToCalculator(currencyCode: String) async {
    // Repository에서 직접 조회
    guard let rates = try? await repository.fetchExchangeRates() ...
}
```
→ UseCase를 CalculatorViewModel에 주입해서 ViewModel이 직접 데이터 로드하도록 변경

## 빌드 및 실행

```bash
git clone [repo-url]
cd CurrencyConverter
open CurrencyConverter.xcodeproj
```

Xcode에서 실행 (iOS 18.5+)
