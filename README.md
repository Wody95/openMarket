# OpenMarket READ.ME

# OpenMarket Project

Rest API를 이용해 서버와 통신하고 상품을 관리하는 어플리케이션입니다.
상품이라는 아이템에 대한 `목록 조회`, `상세 조회`, `등록`, `수정`, `삭제` 등의 기능을 구현했습니다.

# 목차

## 1. 프로젝트 개요

### 1-1. 프로젝트 관리

GitHub Issues를 통한 프로젝트의 목표와 각 커밋의 해당 목표 및 기능을 구분했습니다.

[Project Issues](https://github.com/Wody95/openMarket/issues)

### 1-2. MVC

신속하고 단순하게 코드를 구성하고자 프로젝트에 MVC 패턴을 적용했습니다.

`ViewController`가 크고 복잡해지는것을 막기 위해 `Custom View`와 `Model` 에 최대한 로직을 분리했습니다. 또한 뷰와 컨트롤러 그리고 모델 사이의 데이터 전달에 `delegate` 패턴을 활용했습니다.

### 1-3. 오토레이아웃 구성

프로젝트의 UI 구성은 코드를 통해 구현했으며 SnapKit을 이용해 오토레이아웃을 구성했습니다.

### 1-4. 기술스택

| 카테고리 | 기술 스택 |
| --- | --- |
| UI | UIKit
SnapKit |
| Network | URLSession |
| DataParsing | Encodabel / Decodable
JSONEncoder / JSONDecoder
multipart/form-data |
| Test | XCTest |

## 2. 기능

### 2-1. 목록 보기 모드 (구현 방식)

상품 목록을 보는 모드는 2가지를 지원합니다.  리스트 형식으로 보여주는 모드와 그리드 형식으로 보여주는 그리드 모드입니다.

앱 실행의 기본 보기 모드는 리스트 모드이며 각 모드 변경 시 스크롤은 최상단으로 이동합니다.

<img width="126" alt="리스트화면" src="https://user-images.githubusercontent.com/44163277/144872667-5ba71e2d-10b2-4f1c-aa50-8e80a23f6154.png"/> <img width="126" alt="그리드화면" src="https://user-images.githubusercontent.com/44163277/144872802-8291cee0-2840-4739-8f2e-1c7754d64b3c.png"/>   
![보기모드](https://user-images.githubusercontent.com/44163277/144873108-2d77ddba-cf1f-46ea-9cc4-d86ab89eb0bc.gif)


### 2-2. 목록 조회 (구현 방식)

앱이 실행되고 `ItemManager` 에 상품 목록 데이터가 없을 경우 서버에 요청하여 상품 목록 데이터를 가져오는 기능입니다. 상품 목록의 스크롤이 특정지점에 도달할 때 다음 페이지의 상품 목록 데이터를 비동기적으로 요청하여 끊김없는 스크롤을 구현했습니다. 
![리스트화면무한스크롤](https://user-images.githubusercontent.com/44163277/144873325-d15efc73-e2f4-496d-9936-a75c0a6e7246.gif)![그리드화면무한스크롤](https://user-images.githubusercontent.com/44163277/144873348-03b2ef73-1de6-42c8-921c-d9fc297b46a5.gif)

### 2-3. 상세 조회

상품 목록의 아이템을 클릭하면 상품에 대한 상세 정보를 나타내는 화면입니다.

전체적인 화면은 `UIScrollView`를 통해 나타내며 상품의 사진에 페이징 효과를 적용했습니다.

![상세화면보기](https://user-images.githubusercontent.com/44163277/144873477-10add5e5-b05b-481a-94f2-a7c46630105d.gif)


### 2-4. 등록

네이비게이션바의 우측 버튼을 통해 새로운 상품을 서버에 등록합니다.

![상품등록화면이동](https://user-images.githubusercontent.com/44163277/144873523-3a5cabd2-54b7-4e5d-89c2-68bd62e03191.gif) ![상품등록화면사진추가](https://user-images.githubusercontent.com/44163277/144873603-0bb7020b-4cd2-4163-ab8d-8341b0c075d0.gif) ![상품등록실행](https://user-images.githubusercontent.com/44163277/144873644-de7adf37-4d53-48fb-9024-7ef279fc8974.gif)

### 2-5. 수정

상품 상세 화면의 우측 상단에 Edit 버튼을 통해 상품을 수정할 수 있습니다.

이 때 사용되는 상품 수정 화면은 등록 화면을 재사용합니다.

상품 수정 후 표시되는 상세 화면에서 상품 목록으로 돌아갈 경우 상품 목록을 갱신합니다.

<img width="252" alt="상품수정화면버튼강조" src="https://user-images.githubusercontent.com/44163277/144873756-bb2d4ecb-2e90-4423-9b87-68b78db5d0df.png">![상품수정화면](https://user-images.githubusercontent.com/44163277/144873776-ce302452-e4d2-4f8b-ae9b-6d996ee86265.gif)


### 2-6. 삭제
상품을 삭제하는 기능입니다. 상품을 삭제한 후 상세 화면을 Pop하고 상품 목록으로 돌아가며 상품 목록을 갱신합니다.
![상품삭제](https://user-images.githubusercontent.com/44163277/144873815-5205698c-51fd-4ddc-9ee4-9a3b6bba5206.gif)

## 3. 설계

각 화면에 대한 시나리오를 설정하고, 구분하여 코드를 구성했습니다. 

MVC 패턴에 따라 `Model`, `View`, `Controller` 구현했으며 `ViewController`가 뚱뚱해지지 않도록 데이터의 흐름을 제외한 `View 로직`은 `View` 안에서 구현했습니다.

<img width="807" alt="스크린샷 2021-12-06 오후 6 32 13" src="https://user-images.githubusercontent.com/44163277/144873966-8f10cbd7-16f4-4613-bdf7-0423e6953e7a.png">

### 3-1. 상품 목록 조회 구현
<img width="810" alt="스크린샷 2021-12-06 오후 9 22 50" src="https://user-images.githubusercontent.com/44163277/144874020-0c84668c-ac5a-48f3-a597-45e7a2bfab59.png">

1. 앱이 처음 실행될 경우 컨트롤러와 모델, 뷰 모두 초기화가 진행되면서 `ItemListViewController`는 `ItemManager`를 이용해 서버에 상품 목록을 요청합니다. 이 때 `ItemManager`에 대한 `delegate` 초기화도 진행됩니다.
2. ItemManager는 컨트롤러의 요청에 따라 서버에 상품 목록을 요청하는데 이 때 작업은 비동기적으로 동작하므로 작업이 완료됐을 때 상품 목록 데이터를 적용할 수 있도록 `@escaping` 키워드를 사용해 데이터를 다룹니다.
3. 비동기작업을 통해 서버로부터 가져온 상품 목록 데이터를 `ItemManager`가 관리하며`ItemListViewController` 는 `Cell`을 만들 때`ItemCollectionView`에게 적용합니다. 이 때 상품 목록에 담겨져있는 상품의 텍스트 데이터와 이미지 데이터를 호출할 수 있는 url 텍스트 정보가 담겨져있습니다. 이를 통해 `ItemCollectionView`정보를 업데이트 합니다.

ItemListViewController(Controller)

```swift
private func setupItemManager() {
        itemManager.delegate = self
        itemManager.setupItemManager()
}
```

ItemManager(Model)

```swift
func readItems(completion: (() -> Void)? = nil) {
    guard let delegate = self.delegate else { return }

    urlsessionProvider.getItems(page: self.lastPage) { [weak self] result in
        switch result {
        case .success(let data):
            guard let decodeData = try? JSONDecoder().decode(getItems.self, from: data) else { return }
            
            self?.items += decodeData.items
            self?.lastPage += 1

            if decodeData.items.count >= 1 {
                for _ in 1...decodeData.items.count {
                    self?.thumbnailImages.append(nil)
                }
            }

            DispatchQueue.main.async {
                delegate.reloadCollectionView()
                completion?()
            }

        case .failure(let error):
            print(error)
        }
    }
}
```

URLSession을 통해 서버와 통신하여 그 결과에 따라 데이터를 처리합니다.

[상품 목록 구현에 대한 Issues](https://github.com/Wody95/openMarket/issues/3)

https://github.com/Wody95/openMarket/issues/4

- 무한 스크롤 구현
  ![무한 스크롤](https://user-images.githubusercontent.com/44163277/144874156-23be4827-7800-4adf-897f-906954c8b0b6.gif)
  
    
    ```swift
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (collectionView.contentOffset.y) > (collectionView.contentSize.height - collectionView.frame.size.height) {
    
            if fetchingMore {
                fetchingMore = false
    
                self.itemManager.readItems(completion: nil)
            }
        }
    }
    ```
    

ItemListViewController는 collectionView를 사용하면서 `CollectionViewDelegate Protocol`를 채택시켜주었다. 여기서 `CollectionViewDelegate`는 `ScrollViewDelegate`를 채택하므로 `scrollViewDidScroll()`메서드를 사용할 수 있습니다.

메서드는 if문을 통해 스크롤의 `contentOffset.y` 값을 체크하는데 비교하는 기준은 `collectionView`의 `contentSize.height`에 `frame.size.height`를 뺀 값입니다.

즉 스크롤의 위치가 컨텐츠사이즈의 제일 밑에 도달하는 경우와 `fetchingMore` 값을 대조해 새로운 목록이 필요할 경우 `ItemManager`에게 상품 목록을 요청하는 기능을 구현했습니다.

[무한 스크롤에 대해 고민했던 issues](https://github.com/Wody95/openMarket/issues/3#issuecomment-941071587)

### 3-2. 상품 상세 구현

![Untitled](OpenMarket%20READ%20ME%2074477020e28a4d8983e526315bd67fdc/Untitled%204.png)

1. `ItemListViewController`의 `Item Cell`을 클릭하면 `UICollectionViewDelegate`를 따라 `didSelectItem` 메서드가 실행됩니다. 이 때 메서드 안에서 `DetailItemViewController`가 생성되고 `Delegate`를 초기화합니다. 그리고 상품 목록의 id값을 기반으로 `ItemManager`를 통해 상세 정보를 서버에 요청한 후 네비게이션컨트롤러에 `DetailItemViewController`를 푸쉬합니다.
2. 서버로부터 상세 정보 데이터를 응답받으면 이 정보를 `DetailItemViewController` 에 업데이트합니다. 이 때 Text데이터 및 상품의 이미지 정보 또한 업데이트 되면서 UI정보가 바뀌기 때문에 비동기작업을 진행할 때 Main Thread에서 작업을 진행합니다.
3. 상세 이미지의 경우 `DetailItemManager`를 통해 별도로 처리했습니다. `ResponseItem`에 있는 images url 정보를 기반으로 이미지 갯수를 파악하고 그에 맞춰 반복문으로 이미지 다운로드를 실행하여 이미지 데이터를 관리합니다.

```swift
func downloadImages(completionHandler: @escaping () -> Void) {
    let lastIndex = images.count - 1
    var completionCount = 0

    for index in 0...lastIndex {
        let url = item.images[index]

        session.downloadImage(url: url) { [weak self] result in
            guard let self = self else { return }
            switch result {

            case .success(let data):
                let image = UIImage(data: data)
                self.images[index] = image
                completionCount += 1

                if completionCount == self.images.count {
                    completionHandler()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
```

[상세화면 issues](https://github.com/Wody95/openMarket/issues/6#issuecomment-975210762)

 

### 3-3. 상품 등록 구현

![Untitled](OpenMarket%20READ%20ME%2074477020e28a4d8983e526315bd67fdc/Untitled%205.png)

상품 등록화면의 핵심 기능은 클라이언트에서 입력한 데이터를 서버에 업로드하는 것입니다. API에 따르면 서버에 업로드 하는 데이터 양식은 `multipart/form-data` 형식을 따르고 있으며 이미지와 같이 텍스트 데이터를 `POST method`로 `request` 해야 합니다.

상품 등록 시 사용되는 텍스트 데이터는 UITextField에 입력된 text를 사용합니다. 그리고 이미지 데이터는 `PHPickerViewController`를 통해 갤러리에 있는 이미지 데이터를 다중 선택하여 사용합니다. 

이렇게 선택된 이미지들은 `RegistryItemContentsView`의 `imageCollectionView`에 Cell로 사용자에게 보여지고 데이터는 `imageManager`를 통해 따로 관리됩니다. 선택한 이미지를 나타내는 방법으로 CollectionView를 사용했기 때문에 선택한 이미지 갯수가 많아 뷰를 벗어났다면 스크롤을 통해 확인할 수 있습니다.

마지막으로 등록화면과 함께 상품 정보를 관리하는 패스워드 텍스트를 입력하고 request에 성공하면 등록한 상품이 상세화면으로 이동합니다.

### TextView의 PlaceHolder 구현

제품의 이름 및 가격, 수량 등등의 텍스트 정보는 대부분 UITextField로 구현하여 placeholder 기능을 사용할 수 있지만 제품 설명의 경우는 여러줄의 텍스트 데이터가 들어갈 수 있으므로 UITextView를 사용했습니다. 그래서 placeholder기능이 기본적으로 제공되지 않아 직접 구현했습니다.

```swift
func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.textColor == .lightGray {
        textView.text = nil
        textView.textColor = .black
    }
}

func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text.isEmpty {
        textView.text = "제품 설명"
        textView.textColor = .lightGray
    }
}
```

### 등록 완료까지의 사용자 경험 향상을 위한 인디케이터 활용

![Untitled](OpenMarket%20READ%20ME%2074477020e28a4d8983e526315bd67fdc/Untitled%206.png)

새로운 상품을 서버에 등록하기까지 요청은 딜레이가 있습니다. 그리고 그 시간은 충분히 기다릴 수 있을 정도로 짧더라도 언제 끝날지 예측하기 어렵습니다. 그래서 그 시간동안 앱이 멈춰있지 않고 동작하고 있다고 사용자에게 보여주는 방법으로 인디케이터를 활용했습니다.

```swift
func registryItem(item: [String:Any], images: [ImageFile]) {
    self.registryManager.registryItem(item: item,
                                      images: images) { [weak self] responseItem in
        sleep(2)

        DispatchQueue.main.async {
            self?.contentsView.indicator.stopAnimating()

            let detailItemViewController = DetailItemViewController()
            detailItemViewController.updateItem(item: responseItem)
            detailItemViewController.delegate = self?.delegate

            self?.navigationController?.pushViewController(detailItemViewController, animated: true)

            self?.delegate?.updataItems(completion: nil)
        }
    }
}
```

‣

### 3-4. 상품 수정 구현

![Untitled](OpenMarket%20READ%20ME%2074477020e28a4d8983e526315bd67fdc/Untitled%207.png)

상품 수정은 상품 등록과 사용자 경험이 유사하기 때문에 `RegistryItemViewController`를 활용했습니다. `DetailItemViewController`로부터 접근한 상품 수정 화면에는 상품 정보를 `RegistryItemViewController`의 View의 `TextField.text` 값을 적용하고 사용자가 수정하고 싶은 정보를 수정 후 서버에 Patch request를 보내는 것으로 적용했습니다.

RegistryItemViewController는 열거형 RegistryAndPatchMode 타입의 mode 프로퍼티를 통해 상품 등록 기능을 통한 접근인지 상품 수정 기능을 통한 접근인지 구분합니다. 만약 상품 수정을 통한 접근으로 화면이 구성되었다면 Edit Button이 실행될 때 editMode 메소드가 실행되어 매개변수로 받은 아이템에 따라 화면을 초기화합니다.

사용자는 원하는 정보를 수정하여 비밀번호를 입력하고 수정 요청을 보내면 서버의 응답을 받기까지 `UIActivityIndicatorView` 를 동작시켜 사용자경험을 향상시켰습니다. 그리고 정상적으로 수정된 정보가 반영되면 DetailItemViewController로 화면을 전환시켜 수정한 상품의 정보를 확인할 수 있습니다.

```swift
@objc func didTapRegistryItem() {
    guard var item = contentsView.createItem() else { return }
    let images = self.contentsView.imageManager.imageFiles()

    Alerts.shared.setupPasswordAlert(present: self) { password in
        item["password"] = password

        self.contentsView.indicator.startAnimating()

        switch self.mode {

        case .registry:
            self.registryItem(item: item, images: images)
        case .patch:
            self.patchItem(item: item, images: images)
        }
    }
}

func patchItem(item: [String: Any], images: [ImageFile]) {
    self.registryManager.patchItem(item: item, images: images) { [weak self] responseItem in
        sleep(2)

        DispatchQueue.main.async {
            self?.contentsView.indicator.stopAnimating()

            let detailItemViewController = DetailItemViewController()
            detailItemViewController.updateItem(item: responseItem)
            self?.navigationController?.pushViewController(detailItemViewController, animated: true)

            self?.delegate?.updataItems(completion: nil)
        }
    }
}
```

https://github.com/Wody95/openMarket/issues/7

### 3-5. 상품 삭제 구현

![Untitled](OpenMarket%20READ%20ME%2074477020e28a4d8983e526315bd67fdc/Untitled%208.png)

상품 삭제는 상품에 대한 DetailItemViewController에서 비밀번호 정보와 함께 서버로 Delete method로 request하면 됩니다.

상품이 정상적으로 삭제되었다면 삭제 완료에 대한 `Alert`을 표기한 후 확인을 누르면 `delegate`를 통해 상품 목록이 갱신된 `ItemListViewController`로 돌아오게 됩니다.

```swift
func updateItems(completion: @escaping () -> Void) {
    items = []
    thumbnailImages = []
    lastPage = 1

    readItems(completion: completion)
}
```

https://github.com/Wody95/openMarket/issues/7

## 4. 유닛테스트

### 유닛테스트를 왜 해야 하고 해보는 경험이 중요한가?

- 유닛 테스트는 빠르고 안정적으로 진행되어야 합니다. 실제 서버와 통신하게되면 단위 테스트의 속도가 느려질 뿐만 아니라 인터넷 연결에 의존하기 때문에 테스트를 신뢰할 수 없습니다.
- 실제 서버와 통신하면 의도치 않은 결과를 불러올 수 있습니다. 예를 들어 우리는 서버에 `Item` 을 등록하는 코드를 테스트하길 원합니다. 그런데 실제 서버에 코드를 호출하면 데이터가 실제로 등록되기 때문에 의도치 않은 결과를 불러올 수 있습니다.
- 이번 유닛테스트는 MVC 패턴을 사용하면서 ViewController와 연관된 타입의 테스트 진행이 어려웠지만 URLSession을 활용한 URLSessionProvider를 테스트하면서 네트워크와 무관한 네트워크 테스트를 진행해볼 수 있었고, 테스트가 가능하다는 MVVM 패턴에 대한 흥미가 생겼습니다.

![Untitled](OpenMarket%20READ%20ME%2074477020e28a4d8983e526315bd67fdc/Untitled%209.png)

URLSession의 `dataTask`는 네트워크 통신을 통해 서버의 데이터베이스에 `request`합니다. 그래서 네트워크와 무관한 URLSession 테스트를 위해서는 `dataTask`가 통신하는 과정을 가로채 `Mock` 을 반환해야 합니다. 그런데 꼭 dataTask의 통신과정을 가로챌 필요는 없습니다. URLSession의 dataTask를 `Mock` 으로 만들면 됩니다.

네트워크와 무관한 URLSession 유닛테스트의 핵심 키워드 중 하나는 protocol입니다. 프로토콜을 이용하여 URLSession의 dataTask를 가로챌 수 있기 때문입니다. 

```swift
protocol URLSessionProtocol {
    func dataTask(with request: URLRequest,
                      completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}
```

실제 URLSession에 URLSessionProtocol을 채택하여 dataTask를 새롭게 정의내릴 수 있게 됐습니다. 

```swift
class MockURLSessionDataTask: URLSessionDataTask {
    var resumeDidCall: () -> Void = {}

    override func resume() {
        resumeDidCall()
    }
}

class MockURLSession: URLSessionProtocol {
    var isRequestSuccess: Bool
    var sessionDataTask: MockURLSessionDataTask?
    var resultData: Data?
    var successResponse: HTTPURLResponse?
    var failureResponse: HTTPURLResponse?

    init(isRequestSuccess: Bool = true) {
        self.isRequestSuccess = isRequestSuccess
    }

    func dataTask(with request: URLRequest,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {

        let sessionDataTask = MockURLSessionDataTask()

        guard let resultData = self.resultData,
              let successResponse = self.successResponse,
              let failureResponse = self.failureResponse else { return sessionDataTask }

        if isRequestSuccess {
            sessionDataTask.resumeDidCall = { completionHandler(resultData, successResponse, nil)
            }
        } else {
            sessionDataTask.resumeDidCall = { completionHandler(nil, failureResponse, nil)
            }
        }

        self.sessionDataTask = sessionDataTask
        return sessionDataTask
    }
}
```

직접 만든 dataTask는 URLSessionProvider가 dataTask를 이용해 서버와 통신할 때 응답받는 `data` , `response`, `error` 등의 정보를 커스텀할 수 있어 네트워크와 무관한 테스트를 진행할 수 있게 만들어줍니다.

## 5. 트러블 슈팅

프로젝트를 진행하면서 놓치거나 생각처럼 구현되지 않는 부분, 에러가 발생하는 부분이 있었습니다.

이러한 상황은 언제나 다시 발생할 수 있고 시간이 지나면서 기억에서 잊혀져 똑같은 실수를 할 수 있습니다. 그렇기 때문에 기억보다 기록의 힘을 믿고 같은 상황이 발생하더라도 빠르게 대처할 수 있도록 남겨놓은 트러블 슈팅 기록입니다.

[CollectionView의 Cell Layout이 꼬이는 증상](https://github.com/Wody95/openMarket/issues/3#issuecomment-941071587)

[Cell Title Layout 길이 초과하는 현상](https://github.com/Wody95/openMarket/issues/4#issuecomment-945232627)

[썸네일 이미지를 비동기처리화 하여 사용자 경험을 향상시키기](https://github.com/Wody95/openMarket/issues/4#issuecomment-982324836)

[ScrollView와 CollectionView의 스크롤 겹침으로 인한 CollectionView 비활성화 문제](https://github.com/Wody95/openMarket/issues/5#issuecomment-946293172)

[Button의 터치 이벤트가 동작하지 않는다면?](https://github.com/Wody95/openMarket/issues/5#issuecomment-950121401)

[상품의 상세화면으로 이동했는데 상세 이미지가 표시되지 않거나 누락된다면?](https://github.com/Wody95/openMarket/issues/6#issuecomment-981599256)
