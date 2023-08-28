# Netflix-clone

## 🎯 About
**Code-base 기반의 (Programmatically) UIKit Framework를 이용한 Netflix clone App 입니다.**

<br>

## 🚀 Technologies
- Swift (version 5.8.1)
- Xcode (version 14.3.1)
- UIKit Framework
- Core Data Framework
- TMDB API
- YouTube Data API
- RxSwift, RxCocoa (version 6.5.0)
- SnapKit (version 5.6.0)
- Alamofire

<br>

## ✅ Requirements
```
# Clone this project

$ git clone -b develop_CocoaPods https://github.com/jphong1005/Netflix-clone.git
```

> ⚠️ Target은 `iOS 15.0+`이며, 다크모드 환경에서 앱을 이용해주세요.

`API_KEY 및 ACCESS_TOKEN 등 민감한 정보는 별도의 .xcconfig파일로 분리시켰으나 .gitignore 파일에 저장해두었기에 따로 올리지는 않습니다.`

1. 터미널에서 위의 명령어를 입력하여 프로젝트를 다운받습니다.
2. `Podfile`을 확인 후, 터미널에서 ```$ pod install``` 명령어를 입력해 pod 파일들을 설치합니다.
3. 제일 안쪽, Netflix-clone 폴더로 이동하여 `.xcconfig` 파일을 넣어주세요. <br>
↪ `.xcconfig` 파일은 wlsvy1005@gmail.com 으로 요청해주세요 😇
4. CocoaPods를 이용한 이 프로젝트는 `.xcworkspace` 파일을 열어 실행시킵니다.

<br>

- `main`: Swift Concurrency 사용 버전
- `develop_Combine`: Combine Framework 사용 버전
- `develop_CocoaPods`: Cocoa Pods 사용 버전 (-> RxSwift, SnapKit, Alamofire)

<br>

## 📱 Results
|<img src="https://github.com/jphong1005/Netflix-clone/assets/52193695/08d271a5-615d-495f-b1ad-c886e798aeb0"></img>|<img src="https://github.com/jphong1005/Netflix-clone/assets/52193695/15988b37-1fef-4bfa-a1b7-e2d7f608376a"></img>|<img src="https://github.com/jphong1005/Netflix-clone/assets/52193695/d2174568-2c74-42d2-acde-ccfee7f0f167"></img>|<img src="https://github.com/jphong1005/Netflix-clone/assets/52193695/5df79263-50db-4c47-a943-682c2204513a"></img>|<img src="https://github.com/jphong1005/Netflix-clone/assets/52193695/625a5aa5-ea14-48c2-ace0-79e124fdc9cd"></img>|
|:---:|:---:|:---:|:---:|:---:|
|`Home`|`Preview`|`Upcoming`|`Search`|`Downloads`|
