# KeepIt-iOS
![Untitled3](https://github.com/KeepIt-App/KeepIt-iOS/assets/11778058/6541fad3-bf7e-4626-ac14-267d0f2a63e8)

# 📌 Topic

- 똑똑한 온라인 쇼핑 리마인더
- 저장해둔 아이템에 대한 푸시알림 제공
- 쇼핑몰 상세 페이지 링크 복사 시 품목 정보 추가 기능 제공

# 🤔 Summary

간혹 구매하기로 했던 물품을 까먹어 골치 아팠던 적이 많았는데, 이를 방지하기 위해 물품을 등록해두면 주기적으로 푸시 알림을 제공하여 사용자가 물품 구매를 잊지 않도록 도와주는 서비스입니다. 만약 쇼핑몰 링크를 복사해둔 채 앱을 키게 되면, 자동으로 물품을 인식하여 등록 페이지로 안내해주어 편의성을 강조했습니다.

# 🌟 Key Function

- **구매할 물품**의 이름, 이미지, 가격, 메모, 중요도 등을 입력하여 **앱에 등록**
- 사용자가 등록해둔 물품을 최신순, 중요도순, 가격순으로 정렬하여 보여줌
- 사용자가 등록해둔 **물품 키워드 검색** 기능 제공

# 🛠 Tech Stack

`Swift` , `ViewModel` , `CoreData` , `Combine` , `CombineCocoa` , `OpenGraph`, `Differ` 

# ⚙️ Architecture

- `MVVM`

# 🧑🏻‍💻 Part

- **개인 프로젝트(개발)**

# 📝 Learned

- **MVVM 패턴**을 처음으로 도입해보며, **패턴에 대한 이해**를 높일 수 있었음.
- `Combine` 을 사용하여 **ViewController의 의존도를 낮추는 작업**을 진행해보았고, 그 과정 속에서 **ViewModel의 역할** 또한 배울 수 있었음.
- 비동기 작업을 그냥 `DispatchQueue` 만 사용하면 다 되는줄 알아서 막 넣는 바람에 여러 동작들이 꼬여 딜레이가 생겼었지만, 각 **목적에 따라 비동기 처리** 구현하여 이 문제를 극복함.
- SearchBar의 검색 텀을 `debounce` 로 처리해보면서 `Combine` 의 오퍼레이터들을 사용해볼 수 있었음.

# 📷 Screenshot
  ![무제 6 001](https://github.com/KeepIt-App/KeepIt-iOS/assets/11778058/b6a13899-9dec-4e15-9979-28d67d861743)
