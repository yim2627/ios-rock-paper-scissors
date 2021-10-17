## 묵찌빠 프로젝트 저장소

## 🤝 Ground Rule

**팀원**</br>

@horeng2 (호랭이) @yim2627 (Jiseong)

**시간**</br>

- 끝나는 시간 : ~ 오후 10시
- 쉬는 날 : 화, 토, 일


## ⏰  타임라인 ('21.10.11 ~ '21.10.)
**2021.10.11 Mon**

- 팀 그라운드 룰 지정
- 프로젝트 요구사항 파악 및 이해
- FlowChart 작성
- Step 1 기능 구현
- Step 1 PR

**2021.10.12 Tue**

- README.md 수정	

**2021.10.13 Wed**

- Step 1  Refactor

**2021.10.14 Thu**

- Step 1 Refactor
- Step 2 기능 구현
- Step 2 커밋 수정
- Step 2 PR 제출

**2021.10.15 Fri**

- Step 2 Refactor
- Step 1, 2 네이밍 검토후 수정


## 🌊 Step 0 - FlowChart
![Flowchart](https://user-images.githubusercontent.com/87305744/136777385-07e4805c-e2fd-4aca-b8c8-f5be9f45cfdd.png)

## 🐯 Step 1 - 가위, 바위, 보 게임 구현
- ```selectUserChoice``` 함수
    - 메뉴 출력 및 메뉴 선택을 입력 기능 구현
- ```checkVaildInput``` 함수
    - 입력값 검증 기능 구현
- ```generatedChoiceOfComputer``` 연산 프로퍼티
    - 컴퓨터 임의의 패 생성 기능 구현
- ```decideGameResult``` 함수
    - 승부 결과 판정 구현
- ```enum Result```
    - 승부 결과 case를 열거형으로 선언
  

## 🕹 Step 1 구현 결과

#### 가위바위보를 졌을 경우
![mukchipa1](https://user-images.githubusercontent.com/70251136/136902464-03327a4b-b726-4da6-baf3-1d0af0049885.gif)

#### 가위바위보를 비기거나 이겼을 경우
![mukchipa2](https://user-images.githubusercontent.com/70251136/136902457-4119a0e4-4cb2-4d36-90a9-6ce89fcd8156.gif)

## 🔍 Step 1 고민과 해결

```swift
func selectUserChoice() {
    print("가위(1), 바위(2), 보(3)! <종료 : 0>", terminator: " : ")
    
    guard let inputUserChoice = readLine() else {
        print("\n"+Message.systemError.rawValue)
        return
    }
    
    if let userChoice = Int(inputUserChoice) {
        checkValidInput(userChoice: userChoice)
    } else {
        print(Message.wrongInput.rawValue)
        selectUserChoice()
    }
}
```

- ```if let userChoice = Int(inputUserChoice) {} else {}```

  - ```let userChoice = Int(inputUserChoice)```처럼 형변환을 할 경우 Optional 타입이 되기때문에 ```Optioanl Binding```과정이 필요하였습니다.

  - ```guard```를 이용한 ```Optioanl Binding```을 사용하려 했지만,  두개의 조건이 필요했기에 "nil이 들어오면?" 이란 조건만 있는 ```guard```보다 ```if```를 이용하여 ```Optioanl Binding```을 하는 것이 맞다고 생각하여 수정하였습니다.
  
  - nil이 들어온 경우, 입력값을 다시 받는 기능을 재귀를 이용해 구현하였습니다.
  
  - nil이 아닌 정상값이 들어온 경우, ```checkValidInput()```을 이용해 입력값의 유효성을 검증하였습니다.

## 👨‍🏭 Step 1 refactor

###  함수 세분화
- ```receiveUserInput```
  - 사용자의 입력을 받는 기능이 ```selectUserChoice```에 있어, 단일책임원칙을 고수하기위해 기능 분리
- 에러 출력 기능 분리 - ```printErrorMessage```
  - ```do-catch```문에 하드코딩을 피하려, 별도로 함수 분리
- 게임 결과 출력 기능 분리
  - ```printGameResult```
 
### 네이밍 수정
- 전달 인자 Label 추가 
   - 함수 내외부에서 파라미터 구분이 모호해 전치사 Label 추가
  
### 열거형 추가
- 가위바위보 선택지를 열거형으로 선언	

- ```swift
private enum Choice: Int {
        case scissors = 1
        case rock = 2
        case paper = 3
        case exit = 0
    }
```

- 게임 결과를 열거형으로 선언
  -  ```CustomStringConvertible```을 채택하여  ```description``` 프로퍼티를 통해 출력 형식 지정

  ```swift
  enum Result: CustomStringConvertible {
    case win
    case draw
    case lose
    case exit
    
    var description: String {
        switch self {
        case .win : return "이겼습니다!"
        case .draw : return "비겼습니다!"
        case .lose : return "졌습니다!"
        case .exit : return "게임 종료"
        }
    }
}
```


## 🎯 Step 2 - 묵찌빠 게임 구현

- ```MukChiPaGame ``` 구조체 추가
- ```Player``` 열거형 추가
- 지역변수 ```turn``` 추가 
- ```RockPaperScissorsGame``` 구조체와 ```MukChiPaGame``` 구조체의 상호작용을 위해 ```RockPaperScissorsGame```에 ```MukChiPaGame``` 인스턴스 생성
- 출력 함수 기능 분리
  - ```printVictoryMessage```
  - ```printErrorMessage```
  - ```printGameTurn```

## 🤔 Step 2 고민과 해결

- 가위바위보와 묵찌빠가 로직은 비슷하지만 로직에 사용되는 값은 다른 기능들이 많은데, 이부분을 어떻게 구현할지 고민했습니다.

   - 가위바위보 구조체와 묵찌빠 구조체를 선언하여 같은 기능을 하지만 상세내용(입력값 검증 등)은 다른(가위바위보 or 묵찌빠) 함수들이 동일한 함수명을 사용할 수 있도록 구현했습니다.
 
```swift
RockPaperScissorsGame.checkValidInput

MukChiPaGame.checkValidInput
```

- 묵찌빠 도중 바뀌는 턴을 어떻게 주고 받을지 고민했습니다.

 - ```turn```이라는 변수를 선언하여 매 턴마다 turn의 값을 변경해주는 방식으로 해결했습니다.

 - 구조체 내에서 선언된 ```turn```의 값을 구조체 내 함수에서 수정할 수 있도록 mutating 함수로 선언했습니다.

- 열거형을 정의하면서 CustomStringConvertible 프로토콜을 사용하는 방식에 대해서 고민했습니다.
  - description은 열거형의 값이 사용될 때 지정해놓은 형식대로 표현하도록 커스터마이징 해주는 역할

  - 따라서 별도로 호출해주지 않아도 return값이 출력이 되는 것 같다.

#### initialize

```turn``` 변수를 선언한 뒤 초기화 하는 방법을 고민해봤는데 해결하지 못했습니다. 변수 선언 시 아무 값도 할당하지 않았더니,  MukChiPaGame의 인스턴스를 생성하는 과정에서 에러가 생겨서 임시로 "사용자"를 선언해놓았습니다.

[에러내용]

'MukChiPaGame' initializer is inaccessible due to 'private' protection level

Missing argument for parameter 'turn' in call, Insert 'turn: <#Player#>'

하지만 아무한테도 턴이 있지 않는 상태에 default를 "사용자"로 선언해놓는 것은 옳지않다고 생각하여, ```Player``` 열거형에 ```nobody```라는 케이스를 추가하여initializer를 통해 default를 변경해주었습니다.

```swift
init() {
   turn = Player.nobody
}
```
## 🙇‍♀️ 프로젝트를 진행하며 배운 점

#### CustomStringConvertible

열거형을 CustomStringConvertible로 선언하고, Player타입의 변수를 선언하여 출력하는 아래의 코드를 작성하다가 궁금한 점이 생겼습니다.

```swift
enum Player: CustomStringConvertible {
    var description: String {
        switch self {
        case .computer : return "컴퓨터"
        case .user : return "사용자"
      }
    }
    case computer
    case user
}
```
```swift
var printPlayer: Player = Player.user

print(printPlayer)
print(printPlayer.description)
```
두 코드의 결과가 "사용자"로 동일하게 출력되는 것을 확인했는데, description을 사용하지 않고 출력해도 상관없는지, 또 그렇다면 description은 단순하게 선언 시에만 사용되는 변수인지 궁금했습니다.

공식문서를 살펴보니 ```description``` 이라는 변수를 통해 String으로 초기화 + print 기능이 ```description``` 프로퍼티를 통해 구현되는 것을 확인했습니다. 

그럼에도 불구하고
> "Accessing a type’s description property directly or using CustomStringConvertible as a generic constraint is discouraged." 

라고 적혀있는걸 보면 description으로 직접적으로 접근해서 사용하는건 바람직하지 않다는 것을 알게되었습니다.

#### 재귀함수의 장단점
**[장점]**

- 코드가 간단해진다. (가독성이 좋아진다.)
- 구현과정이 간결하다.
- 자기 자신만을 반복적으로 호출하는 것이기때문에 변수 사용(생성)을 줄여, 예상치 못한 에러를 줄일 수 있다.

**[단점]**

- 재귀함수는 스택을 사용하는데, 반복문은 무한히 돌아도 에러가 나지않는 반면, 재귀함수는 스택에 자기 자신을 무한히 쌓게 되면 결국 Stack overflow가 발생하여 프로그램이 종료된다.
- 반복문보다 속도가 느리다.

**반복문보다 속도가 느린 이유**

- 재귀함수의 경우 함수가 호출될 때 스택을 구성하고 종료될 때 스택을 해제하는 과정에서 반복문보다 오버헤드를 반복문에 비해 더 소모하기때문에 속도가 느리다.

#### 연산 프로퍼티와 저장 프로퍼티의 차이

저장프로퍼티는 객체의 값을 저장하고 있는 기본적인 프로퍼티로, var와 let이 있으며 생성 시 자동으로 초기화됩니다. 

연산프로퍼티는 특정 연산을 통해 필요(호출)시 연산을 통해 값을 리턴합니다. 또한 연산프로퍼티를 위한 저장 프로퍼티가 필요하며, 연산프로퍼티 자체로는 실제 값을 가지고 있는 것은 아닙니다. 

연산프로퍼티는 코드가 간결해지고 직관적이라는 장점이 있습니다.


#### mutating 함수 동작 구조

구조체의 특정 메소드에서 프로퍼티의 값을 변경해야 한다면 mutating 키워드를 사용하는데, mutating 메소드로 내부 프로퍼티의 값을 변경하면 프로퍼티만 변경되는 것이 아니라 프로퍼티가 변경된 완전히 새로운 인스턴스를 만들어 기존 인스턴스를 대체합니다. 따라서 구조체가 상수로 선언되어 있다면 mutating 메소드를 호출할 수 없습니다.

# 🎮 Step 2 구현 결과

### 🏅 사용자승리
![Hnet-image](https://user-images.githubusercontent.com/70251136/137608691-f7aff846-dd5b-4b75-bd47-13001736df74.gif)

### 🤼 컴퓨터 승리 및 잘못된 입력으로 인한 Turn change
![Hnet-image-2](https://user-images.githubusercontent.com/70251136/137608683-92c86cd2-83ca-420b-ba18-28ae72782abd.gif)
  


     